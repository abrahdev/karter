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
}
