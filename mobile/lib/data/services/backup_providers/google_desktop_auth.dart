import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart' as gauth_io;
import 'package:googleapis_auth/googleapis_auth.dart' as gauth;
import 'package:http/http.dart' as http;
import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _kClientId = String.fromEnvironment('GOOGLE_DESKTOP_CLIENT_ID');
const _kClientSecret = String.fromEnvironment('GOOGLE_DESKTOP_CLIENT_SECRET');
const _kCredsKey = 'karter_google_desktop_creds';

class GoogleDesktopAuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  gauth.AuthClient? _client;

  bool get isSignedIn => _client != null;

  bool get isConfigured => _kClientId.isNotEmpty && _kClientSecret.isNotEmpty;

  String? get email => null;

  http.Client? get client => _client;

  Future<void> signIn() async {
    if (!isConfigured) {
      throw const BackupProviderException(
        'Google Drive desktop is not configured. '
        'Build with --dart-define=GOOGLE_DESKTOP_CLIENT_ID and '
        '--dart-define=GOOGLE_DESKTOP_CLIENT_SECRET.',
      );
    }
    final clientId = gauth.ClientId(_kClientId, _kClientSecret);
    _client = await gauth_io.clientViaUserConsent(
      clientId,
      [drive.DriveApi.driveFileScope],
      (url) async {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      },
    );
    await _persist();
  }

  Future<void> restoreSession() async {
    if (!isConfigured) return;
    final credsJson = await _storage.read(key: _kCredsKey);
    if (credsJson == null) return;
    try {
      final creds = gauth.AccessCredentials.fromJson(
        jsonDecode(credsJson) as Map<String, dynamic>,
      );
      _client = gauth_io.autoRefreshingClient(
        gauth.ClientId(_kClientId, _kClientSecret),
        creds,
        http.Client(),
      );
    } catch (_) {
      await _storage.delete(key: _kCredsKey);
    }
  }

  Future<void> signOut() async {
    _client?.close();
    _client = null;
    await _storage.delete(key: _kCredsKey);
  }

  Future<void> _persist() async {
    final creds = _client?.credentials;
    if (creds == null) return;
    await _storage.write(
      key: _kCredsKey,
      value: jsonEncode(creds.toJson()),
    );
  }
}