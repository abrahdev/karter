import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:mobile/data/services/backup_providers/google_desktop_auth.dart';
import 'package:mobile/data/services/google_drive_auth_service.dart';
import 'package:mobile/data/services/google_drive_service.dart';

class GoogleDriveProvider implements BackupProvider {
  final GoogleDriveAuthService _mobileAuth = GoogleDriveAuthService();
  final GoogleDesktopAuthService _desktopAuth = GoogleDesktopAuthService();

  bool get _useDesktop => !kIsWeb && (Platform.isLinux || Platform.isWindows);

  @override
  bool get isConnected =>
      _useDesktop ? _desktopAuth.isSignedIn : _mobileAuth.isSignedIn;

  @override
  String get displayName {
    final email = _useDesktop ? _desktopAuth.email : _mobileAuth.email;
    if (email != null && email.isNotEmpty) return email;
    return 'Google Drive';
  }

  @override
  Future<void> restoreSession() async {
    if (_useDesktop) {
      await _desktopAuth.restoreSession();
    } else {
      await _mobileAuth.signInSilently();
    }
  }

  @override
  Future<void> connect() async {
    if (_useDesktop) {
      await _desktopAuth.signIn();
    } else {
      await _mobileAuth.signIn();
    }
  }

  @override
  Future<void> disconnect() async {
    if (_useDesktop) {
      await _desktopAuth.signOut();
    } else {
      await _mobileAuth.signOut();
    }
  }

  @override
  Future<List<RemoteBackup>> listBackups() async {
    final drive = _driveService();
    final files = await drive.listBackups();
    return files
        .map(
          (f) => RemoteBackup(
            id: f.id,
            name: f.name,
            sizeBytes: f.sizeBytes,
            modifiedAt: f.modifiedAt,
          ),
        )
        .toList();
  }

  @override
  Future<void> uploadBackup(String filename, Uint8List data) async {
    await _driveService().uploadBackup(filename, data);
  }

  @override
  Future<Uint8List> downloadBackup(String id) async {
    return _driveService().downloadBackup(id);
  }

  @override
  Future<void> deleteBackup(String id) async {
    await _driveService().deleteBackup(id);
  }

  http.Client? _client() {
    if (_useDesktop) return _desktopAuth.client;
    return _mobileAuth.client;
  }

  GoogleDriveService _driveService() {
    final client = _client();
    if (client == null) {
      throw const BackupProviderException('Google Drive is not connected');
    }
    return GoogleDriveService(client);
  }
}