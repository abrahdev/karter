import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupMetadata {
  final String fileName;
  final String fileId;
  final int sizeBytes;
  final DateTime createdAt;

  BackupMetadata({
    required this.fileName,
    required this.fileId,
    required this.sizeBytes,
    required this.createdAt,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) =>
      BackupMetadata(
        fileName: json['fileName'] as String,
        fileId: json['fileId'] as String,
        sizeBytes: json['sizeBytes'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fileId': fileId,
        'sizeBytes': sizeBytes,
        'createdAt': createdAt.toIso8601String(),
      };
}

class BackupService {
  static const _prefsKey = 'karter_backup_metadata';
  static const _secKey = 'karter_backup_key';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Uint8List> createEncryptedBackup() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbBytes = await File('${dir.path}/karter.db').readAsBytes();
    final key = await _getOrCreateKey();
    final encrypted = await _encrypt(dbBytes, key);

    return encrypted;
  }

  Future<String> restoreFromEncrypted(Uint8List encrypted) async {
    final dir = await getApplicationDocumentsDirectory();
    final backupPath = '${dir.path}/karter_backup_restore.db';

    final key = await _getOrCreateKey();
    final decrypted = _decrypt(encrypted, key);

    await File(backupPath).writeAsBytes(decrypted);
    return backupPath;
  }

  Future<void> replaceDb(String restoredDbPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/karter.db';

    await File(dbPath).delete();
    await File(restoredDbPath).rename(dbPath);
  }

  Future<String> formatFileSize(int bytes) async {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> saveLocalMetadata(BackupMetadata meta) async {
    final prefs = await SharedPreferences.getInstance();
    final existingJson = prefs.getString(_prefsKey);
    final list = existingJson != null
        ? (jsonDecode(existingJson) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    list.add(meta.toJson());
    await prefs.setString(_prefsKey, jsonEncode(list));
  }

  Future<List<BackupMetadata>> getLocalBackups() async {
    final prefs = await SharedPreferences.getInstance();
    final existingJson = prefs.getString(_prefsKey);
    if (existingJson == null) return [];
    final list = (jsonDecode(existingJson) as List).cast<Map<String, dynamic>>();
    return list.map((e) => BackupMetadata.fromJson(e)).toList();
  }

  Future<String> _getOrCreateKey() async {
    final existing = await _secureStorage.read(key: _secKey);
    if (existing != null) return existing;

    final key = enc.Key.fromSecureRandom(32).base64;
    await _secureStorage.write(key: _secKey, value: key);
    return key;
  }

  Future<Uint8List> _encrypt(Uint8List data, String keyBase64) async {
    final key = enc.Key.fromBase64(keyBase64);
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));

    final encrypted = encrypter.encryptBytes(data.toList(), iv: iv);

    final combined = Uint8List.fromList([
      ...iv.bytes,
      ...encrypted.bytes,
    ]);
    return combined;
  }

  Uint8List _decrypt(Uint8List combined, String keyBase64) {
    final key = enc.Key.fromBase64(keyBase64);
    final iv = enc.IV(Uint8List.fromList(combined.sublist(0, 16)));
    final ciphertext = combined.sublist(16);

    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final decrypted = encrypter.decryptBytes(
      enc.Encrypted(Uint8List.fromList(ciphertext)),
      iv: iv,
    );

    return Uint8List.fromList(decrypted);
  }
}
