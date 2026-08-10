import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

class CatalogService {
  CatalogService({
    Directory? documentsDirectory,
    String bundleAssetName = 'assets/catalog/karter-catalog.db',
    String fileName = 'karter-catalog.db',
  })  : _documentsDirectory = documentsDirectory,
        _bundleAssetName = bundleAssetName,
        _fileName = fileName;

  static const releaseUrl =
      'https://github.com/abrahdev/karter/releases/download/catalog/karter-catalog.db';

  static const catalogDbFileName = 'karter-catalog.db';
  static const defaultBranch = 'main';

  static final _githubPathRegExp = RegExp(
    r'^https?://github\.com/([^/]+)/([^/]+)/(blob|raw)/([^/]+)/(.+)$',
  );
  static final _githubBarePathRegExp = RegExp(
    r'^https?://github\.com/([^/]+)/([^/]+)/(.+)$',
  );

  static String catalogDbUrl(String repoUrl) {
    final base = repoUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (base.endsWith(catalogDbFileName)) return base;
    return '$base/$catalogDbFileName';
  }

  static String resolveRawBaseUrl(String repoUrl) {
    final base = repoUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final blob = _githubPathRegExp.firstMatch(base);
    if (blob != null) {
      return 'https://raw.githubusercontent.com/${blob.group(1)}/'
          '${blob.group(2)}/${blob.group(4)}/${blob.group(5)}';
    }
    final bare = _githubBarePathRegExp.firstMatch(base);
    if (bare != null) {
      return 'https://raw.githubusercontent.com/${bare.group(1)}/'
          '${bare.group(2)}/$defaultBranch/${bare.group(3)}';
    }
    return base;
  }

  final Directory? _documentsDirectory;
  final String _bundleAssetName;
  final String _fileName;

  Database? _db;
  File? _file;

  Future<File> catalogFile() async {
    final cached = _file;
    if (cached != null) return cached;
    final dir = _documentsDirectory ?? await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, _fileName));
    if (!await file.exists()) {
      final data = await rootBundle.load(_bundleAssetName);
      await file.create(recursive: true);
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }
    _file = file;
    return file;
  }

  Future<Database> database() async {
    final cached = _db;
    if (cached != null) return cached;
    final file = await catalogFile();
    final db = sqlite3.open(file.path, mode: OpenMode.readOnly);
    _db = db;
    return db;
  }

  Future<String?> catalogVersion() async {
    final db = await database();
    final rows =
        db.select("SELECT v FROM meta WHERE k = 'catalog_version'");
    if (rows.isEmpty) return null;
    return rows.single['v'] as String?;
  }

  Future<void> refreshFromRelease({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final file = await catalogFile();
    final resp = await http.get(Uri.parse(releaseUrl)).timeout(timeout);
    if (resp.statusCode != 200) {
      throw StateError('HTTP ${resp.statusCode} for $releaseUrl');
    }
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(resp.bodyBytes, flush: true);
    String? downloadedVersion;
    final check = sqlite3.open(tmp.path, mode: OpenMode.readOnly);
    try {
      final rows =
          check.select("SELECT v FROM meta WHERE k = 'catalog_version'");
      if (rows.isEmpty) {
        throw StateError('Downloaded catalog is missing catalog_version');
      }
      downloadedVersion = rows.single['v'] as String;
    } finally {
      check.close();
    }
    final currentVersion = await catalogVersion();
    if (downloadedVersion == currentVersion) {
      await tmp.delete();
      return;
    }
    _db = null;
    if (await file.exists()) await file.delete();
    await tmp.rename(file.path);
    _file = file;
  }

  void dispose() {
    _db?.close();
    _db = null;
  }

  Future<CatalogImportCheck> checkImport(
    String repoUrl, {
    http.Client? client,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final base = resolveRawBaseUrl(repoUrl);
    final ownClient = client == null;
    final c = client ?? http.Client();
    try {
      var translationsFound = 0;
      var translationsTotal = 0;
      for (final locale in const ['en', 'es', 'et']) {
        translationsTotal++;
        final resp = await _get(c, '$base/i18n/$locale.json', timeout);
        if (resp != null && resp.statusCode == 200) translationsFound++;
      }

      var indexOk = false;
      var templateCount = 0;
      final indexResp = await _get(c, '$base/index.json', timeout);
      if (indexResp != null && indexResp.statusCode == 200) {
        try {
          final data = jsonDecode(indexResp.body) as Map<String, dynamic>;
          templateCount =
              (data['templates'] as List<dynamic>? ?? const []).length;
          indexOk = true;
        } on Exception {
          indexOk = false;
        }
      }

      var dbRemoteFound = false;
      DateTime? dbRemoteModified;
      final dbUrl = catalogDbUrl(base);
      final dbResp = await _get(
        c,
        _resolveGithubUrl(dbUrl),
        timeout,
        headers: const {'Range': 'bytes=0-0'},
      );
      if (dbResp != null &&
          (dbResp.statusCode == 200 || dbResp.statusCode == 206)) {
        dbRemoteFound = true;
        final lastModified = dbResp.headers['last-modified'];
        if (lastModified != null) {
          try {
            dbRemoteModified = HttpDate.parse(lastModified);
          } on FormatException {
            dbRemoteModified = null;
          }
        }
        dbRemoteModified ??=
            await _githubPathModifiedAt(dbUrl, client: c, timeout: timeout);
      }

      var localDbOk = false;
      String? catalogVersion;
      var vehicles = 0;
      var maintenanceItems = 0;
      var parts = 0;
      var obdCodes = 0;
      try {
        final db = await database();
        final versionRows =
            db.select("SELECT v FROM meta WHERE k = 'catalog_version'");
        catalogVersion =
            versionRows.isEmpty ? null : versionRows.single['v'] as String?;
        vehicles = db
                .select("SELECT COUNT(*) FROM vehicles WHERE kind = 'vehicle'")
                .single
                .values
                .first as int;
        maintenanceItems = db
                .select('SELECT COUNT(*) FROM maintenance_items')
                .single
                .values
                .first as int;
        parts =
            db.select('SELECT COUNT(*) FROM parts').single.values.first as int;
        obdCodes =
            db.select('SELECT COUNT(*) FROM obd_codes').single.values.first as int;
        localDbOk = true;
      } on Exception {
        localDbOk = false;
      }

      return CatalogImportCheck(
        baseUrl: base,
        translationsOk: translationsFound == translationsTotal,
        translationsFound: translationsFound,
        translationsTotal: translationsTotal,
        indexOk: indexOk,
        templateCount: templateCount,
        dbRemoteFound: dbRemoteFound,
        dbRemoteModified: dbRemoteModified,
        localDbOk: localDbOk,
        catalogVersion: catalogVersion,
        vehicles: vehicles,
        maintenanceItems: maintenanceItems,
        parts: parts,
        obdCodes: obdCodes,
      );
    } finally {
      if (ownClient) c.close();
    }
  }

  Future<http.Response?> _get(
    http.Client client,
    String url,
    Duration timeout, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final resp = headers == null
          ? await client.get(uri).timeout(timeout)
          : await client.get(uri, headers: headers).timeout(timeout);
      return resp;
    } on Exception {
      return null;
    }
  }

  ({String owner, String repo, String ref, String path})? _parseGithub(
      String url) {
    final match = _githubPathRegExp.firstMatch(url);
    if (match != null) {
      return (
        owner: match.group(1)!,
        repo: match.group(2)!,
        ref: match.group(4)!,
        path: match.group(5)!,
      );
    }
    final bare = _githubBarePathRegExp.firstMatch(url);
    if (bare != null) {
      return (
        owner: bare.group(1)!,
        repo: bare.group(2)!,
        ref: defaultBranch,
        path: bare.group(3)!,
      );
    }
    return null;
  }

  String _resolveGithubUrl(String url) {
    final parsed = _parseGithub(url);
    if (parsed == null) return url;
    return 'https://raw.githubusercontent.com/${parsed.owner}/${parsed.repo}'
        '/${parsed.ref}/${parsed.path}';
  }

  Future<DateTime?> _githubPathModifiedAt(
    String url, {
    http.Client? client,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final parsed = _parseGithub(url);
    if (parsed == null) return null;
    final api = Uri.parse(
      'https://api.github.com/repos/${parsed.owner}/${parsed.repo}/commits',
    ).replace(queryParameters: {
      'path': parsed.path,
      'sha': parsed.ref,
      'per_page': '1',
    });
    final ownClient = client == null;
    final c = client ?? http.Client();
    try {
      final resp = await c
          .get(api, headers: const {'Accept': 'application/vnd.github+json'})
          .timeout(timeout);
      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body) as List<dynamic>;
      if (data.isEmpty) return null;
      final commit =
          (data.first as Map<String, dynamic>)['commit'] as Map<String, dynamic>;
      final committer = commit['committer'] as Map<String, dynamic>;
      final date = committer['date'] as String?;
      return date == null ? null : DateTime.tryParse(date);
    } on Exception {
      return null;
    } finally {
      if (ownClient) c.close();
    }
  }
}

class CatalogImportCheck {
  const CatalogImportCheck({
    required this.baseUrl,
    required this.translationsOk,
    required this.translationsFound,
    required this.translationsTotal,
    required this.indexOk,
    required this.templateCount,
    required this.dbRemoteFound,
    this.dbRemoteModified,
    required this.localDbOk,
    this.catalogVersion,
    required this.vehicles,
    required this.maintenanceItems,
    required this.parts,
    required this.obdCodes,
  });

  final String baseUrl;
  final bool translationsOk;
  final int translationsFound;
  final int translationsTotal;
  final bool indexOk;
  final int templateCount;
  final bool dbRemoteFound;
  final DateTime? dbRemoteModified;
  final bool localDbOk;
  final String? catalogVersion;
  final int vehicles;
  final int maintenanceItems;
  final int parts;
  final int obdCodes;
}
