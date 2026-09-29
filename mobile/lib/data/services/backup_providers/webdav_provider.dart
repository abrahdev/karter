import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:webdav_client/webdav_client.dart' as dav;

class WebDavConfig {
  final String url;
  final String user;
  final String password;

  const WebDavConfig({
    required this.url,
    required this.user,
    required this.password,
  });

  bool get isValid =>
      url.trim().isNotEmpty && user.trim().isNotEmpty && password.isNotEmpty;
}

class WebDavProvider implements BackupProvider {
  static const _kUrl = 'karter_webdav_url';
  static const _kUser = 'karter_webdav_user';
  static const _kPassword = 'karter_webdav_password';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  dav.Client? _client;
  String? _url;

  @override
  bool get isConnected => _client != null;

  @override
  String get displayName => _url ?? '';

  Future<WebDavConfig?> loadConfig() async {
    final url = await _storage.read(key: _kUrl);
    final user = await _storage.read(key: _kUser);
    final password = await _storage.read(key: _kPassword);
    if (url == null || user == null || password == null) return null;
    return WebDavConfig(url: url, user: user, password: password);
  }

  Future<void> saveConfig(WebDavConfig config) async {
    await _storage.write(key: _kUrl, value: config.url.trim());
    await _storage.write(key: _kUser, value: config.user.trim());
    await _storage.write(key: _kPassword, value: config.password);
  }

  Future<void> clearConfig() async {
    await _storage.delete(key: _kUrl);
    await _storage.delete(key: _kUser);
    await _storage.delete(key: _kPassword);
  }

  Future<void> testConnection(WebDavConfig config) async {
    final client = _buildClient(config);
    try {
      await client.ping();
      await client.mkdirAll('/');
    } catch (e) {
      throw BackupProviderException('WebDAV connection failed: $e');
    }
  }

  @override
  Future<void> restoreSession() async {
    final config = await loadConfig();
    if (config == null || !config.isValid) return;
    _client = _buildClient(config);
    _url = config.url.trim();
    try {
      await _client!.mkdirAll('/');
    } catch (_) {
      _client = null;
    }
  }

  @override
  Future<void> connect() async {
    final config = await loadConfig();
    if (config == null || !config.isValid) {
      throw const BackupProviderException('WebDAV is not configured');
    }
    _client = _buildClient(config);
    _url = config.url.trim();
    await _client!.mkdirAll('/');
  }

  @override
  Future<void> disconnect() async {
    _client = null;
    _url = null;
    await clearConfig();
  }

  @override
  Future<List<RemoteBackup>> listBackups() async {
    final client = _requireClient();
    final files = await client.readDir('/');
    final result = <RemoteBackup>[];
    for (final f in files) {
      final name = f.name;
      if (name == null || name.isEmpty || f.isDir == true) continue;
      result.add(
        RemoteBackup(
          id: name,
          name: name,
          sizeBytes: f.size ?? 0,
          modifiedAt: f.mTime ?? f.cTime ?? DateTime.now(),
        ),
      );
    }
    result.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
    return result;
  }

  @override
  Future<void> uploadBackup(String filename, Uint8List data) async {
    final client = _requireClient();
    await client.write('/$filename', data);
  }

  @override
  Future<Uint8List> downloadBackup(String id) async {
    final client = _requireClient();
    final bytes = await client.read('/$id');
    return Uint8List.fromList(bytes);
  }

  @override
  Future<void> deleteBackup(String id) async {
    final client = _requireClient();
    await client.remove('/$id');
  }

  dav.Client _requireClient() {
    final client = _client;
    if (client == null) {
      throw const BackupProviderException('WebDAV is not connected');
    }
    return client;
  }

  dav.Client _buildClient(WebDavConfig config) {
    final client = dav.newClient(
      config.url.trim(),
      user: config.user.trim(),
      password: config.password,
    );
    client.setConnectTimeout(15000);
    client.setReceiveTimeout(15000);
    return client;
  }
}