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

  /// Fallback used when the rolling `catalog` release does not exist yet:
  /// the catalog committed on the default branch.
  static const fallbackCatalogUrl =
      'https://raw.githubusercontent.com/abrahdev/karter/main/templates/karter-catalog.db';

  static const catalogDbFileName = 'karter-catalog.db';
  static const onlineCatalogDbFileName = 'online-catalog.db';
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

  /// Parses `owner/repo` from a github.com or raw.githubusercontent.com URL.
  static (String, String)? parseOwnerRepo(String url) {
    final base = url.trim().replaceAll(RegExp(r'/+$'), '');
    final raw = RegExp(
      r'^https?://raw\.githubusercontent\.com/([^/]+)/([^/]+)/',
    ).firstMatch(base);
    if (raw != null) return (raw.group(1)!, raw.group(2)!);
    final blob = _githubPathRegExp.firstMatch(base);
    if (blob != null) return (blob.group(1)!, blob.group(2)!);
    final bare = _githubBarePathRegExp.firstMatch(base);
    if (bare != null) return (bare.group(1)!, bare.group(2)!);
    return null;
  }

  /// Latest release tag (`tag_name`) of a GitHub repository, or null when it
  /// cannot be resolved (offline, no releases, unknown repo, rate limit).
  static Future<String?> latestReleaseRef({
    required String owner,
    required String repo,
    http.Client? client,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final own = client == null;
    final c = client ?? http.Client();
    try {
      final resp = await c
          .get(
            Uri.parse('https://api.github.com/repos/$owner/$repo/releases/latest'),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(timeout);
      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return data['tag_name'] as String?;
    } catch (_) {
      return null;
    } finally {
      if (own) c.close();
    }
  }

  /// Version tags of a GitHub repository (empty when they cannot be listed).
  static Future<List<String>> listTags({
    required String owner,
    required String repo,
    http.Client? client,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final own = client == null;
    final c = client ?? http.Client();
    try {
      final resp = await c
          .get(
            Uri.parse(
              'https://api.github.com/repos/$owner/$repo/tags?per_page=100',
            ),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(timeout);
      if (resp.statusCode != 200) return const [];
      final list = jsonDecode(resp.body) as List<dynamic>;
      return list
          .map((e) => (e as Map<String, dynamic>)['name'] as String)
          .toList();
    } catch (_) {
      return const [];
    } finally {
      if (own) c.close();
    }
  }

  /// Resolves a template-source base URL.
  ///
  /// When the URL contains a `<tag>` placeholder, the latest release tag of the
  /// repository embedded in the URL is substituted (any GitHub repo is
  /// supported). If the tag cannot be resolved the URL is returned unchanged
  /// (Option B), so connection tests surface the failure instead of silently
  /// falling back to the development branch.
  static Future<String> resolveBaseUrl(
    String repoUrl, {
    http.Client? client,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final base = repoUrl.trim().replaceAll(RegExp(r'/+$'), '');
    if (base.contains('<tag>')) {
      final parsed = parseOwnerRepo(base);
      if (parsed == null) return base;
      final tag = await latestReleaseRef(
        owner: parsed.$1,
        repo: parsed.$2,
        client: client,
        timeout: timeout,
      );
      if (tag == null) return base;
      final github = _githubBarePathRegExp.firstMatch(base);
      if (github != null) {
        final rest = github.group(3)!;
        final slash = rest.indexOf('/');
        final path = slash == -1 ? rest : rest.substring(slash + 1);
        return 'https://raw.githubusercontent.com/${github.group(1)}/'
                '${github.group(2)}/$tag/$path'
            .replaceAll('<tag>', tag);
      }
      return base.replaceAll('<tag>', tag);
    }
    return resolveRawBaseUrl(base);
  }

  final Directory? _documentsDirectory;
  final String _bundleAssetName;
  final String _fileName;

  Database? _db;
  File? _file;

  Future<Directory> get documentsDirectory async =>
      _documentsDirectory ?? await getApplicationDocumentsDirectory();

  /// Path of the "online" catalog: the refreshed copy downloaded from the
  /// rolling GitHub release. Distinct from the immutable bundled catalog.
  Future<File> onlineCatalogFile() async {
    final dir = await documentsDirectory;
    return File(p.join(dir.path, onlineCatalogDbFileName));
  }

  /// Switches which catalog file is read by the app. Callers own lifecycle of
  /// the target file (imported local DBs, online copy, or the bundled copy).
  void useFile(String path) {
    _db?.close();
    _db = null;
    _file = File(path);
  }

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
    final online = await onlineCatalogFile();
    await online.parent.create(recursive: true);

    var resp = await http.get(Uri.parse(releaseUrl)).timeout(timeout);
    if (resp.statusCode != 200) {
      resp = await http.get(Uri.parse(fallbackCatalogUrl)).timeout(timeout);
    }
    if (resp.statusCode != 200) {
      throw StateError('HTTP ${resp.statusCode} for catalog download');
    }

    final tmp = File('${online.path}.tmp');
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

    String? currentVersion;
    if (await online.exists()) {
      final cur = sqlite3.open(online.path, mode: OpenMode.readOnly);
      try {
        final rows =
            cur.select("SELECT v FROM meta WHERE k = 'catalog_version'");
        if (rows.isNotEmpty) currentVersion = rows.single['v'] as String;
      } finally {
        cur.close();
      }
    }

    if (downloadedVersion == currentVersion) {
      await tmp.delete();
      return;
    }

    _db = null;
    if (await online.exists()) await online.delete();
    await tmp.rename(online.path);
    if (_file?.path == online.path) _file = online;
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
    final ownClient = client == null;
    final c = client ?? http.Client();
    final base = await resolveBaseUrl(repoUrl, client: c);
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
