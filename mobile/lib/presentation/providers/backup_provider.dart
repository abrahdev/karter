import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/backup_service.dart';
import 'package:mobile/data/services/google_drive_auth_service.dart';
import 'package:mobile/data/services/google_drive_service.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupState {
  final bool loading;
  final bool signedIn;
  final String? email;
  final String? lastBackupAt;
  final List<DriveBackupMetadata> driveBackups;
  final String? error;
  final bool backingUp;
  final bool restoring;
  final int maxBackups;

  const BackupState({
    this.loading = false,
    this.signedIn = false,
    this.email,
    this.lastBackupAt,
    this.driveBackups = const [],
    this.error,
    this.backingUp = false,
    this.restoring = false,
    this.maxBackups = 10,
  });

  BackupState copyWith({
    bool? loading,
    bool? signedIn,
    String? email,
    String? lastBackupAt,
    List<DriveBackupMetadata>? driveBackups,
    String? error,
    bool? backingUp,
    bool? restoring,
    int? maxBackups,
  }) {
    return BackupState(
      loading: loading ?? this.loading,
      signedIn: signedIn ?? this.signedIn,
      email: email ?? this.email,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      driveBackups: driveBackups ?? this.driveBackups,
      error: error,
      backingUp: backingUp ?? this.backingUp,
      restoring: restoring ?? this.restoring,
      maxBackups: maxBackups ?? this.maxBackups,
    );
  }
}

class BackupNotifier extends Notifier<BackupState> {
  final GoogleDriveAuthService _auth = GoogleDriveAuthService();
  final BackupService _backup = BackupService();
  static const _maxBackupsKey = 'karter_max_backups';

  @override
  BackupState build() {
    _init();
    return const BackupState();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMax = prefs.getInt(_maxBackupsKey) ?? 10;

    await _auth.signInSilently();
    if (_auth.isSignedIn) {
      state = BackupState(signedIn: true, email: _auth.email, maxBackups: savedMax);
      await _loadLastBackup();
      await listBackups();
    } else {
      state = BackupState(maxBackups: savedMax);
    }
  }

  Future<void> signIn() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _auth.signIn();
      state = state.copyWith(
        loading: false,
        signedIn: _auth.isSignedIn,
        email: _auth.email,
      );
      if (_auth.isSignedIn) {
        await _loadLastBackup();
        await listBackups();
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _auth.signOut();
      state = BackupState(maxBackups: state.maxBackups);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> setMaxBackups(int value) async {
    final clamped = value.clamp(1, 50);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxBackupsKey, clamped);
    state = state.copyWith(maxBackups: clamped);
  }

  Future<void> backupNow() async {
    final client = _auth.client;
    if (client == null) {
      state = state.copyWith(backingUp: false, error: 'Not signed in. Please sign in again.');
      return;
    }
    state = state.copyWith(backingUp: true, error: null);
    try {
      final drive = GoogleDriveService(client);

      final backups = await drive.listBackups();
      if (backups.length >= state.maxBackups) {
        final toDelete = backups.sublist(state.maxBackups - 1);
        for (final b in toDelete) {
          await drive.deleteBackup(b.id);
        }
      }

      final now = DateTime.now();
      final filename = 'karter_${now.year}${_pad(now.month)}${_pad(now.day)}_${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}.db.aes';

      final encrypted = await _backup.createEncryptedBackup();
      final fileId = await drive.uploadBackup(filename, encrypted);

      await _backup.saveLocalMetadata(BackupMetadata(
        fileName: filename,
        fileId: fileId,
        sizeBytes: encrypted.length,
        createdAt: now,
      ));

      state = state.copyWith(
        backingUp: false,
        lastBackupAt: now.toIso8601String(),
      );

      await listBackups();
    } catch (e) {
      state = state.copyWith(backingUp: false, error: e.toString());
    }
  }

  Future<void> listBackups() async {
    if (!_auth.isSignedIn) return;
    final client = _auth.client;
    if (client == null) {
      state = state.copyWith(error: 'Not signed in. Please sign in again.');
      return;
    }
    try {
      final drive = GoogleDriveService(client);
      final backups = await drive.listBackups();
      state = state.copyWith(driveBackups: backups);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteBackup(String fileId) async {
    final client = _auth.client;
    if (client == null) {
      state = state.copyWith(loading: false, error: 'Not signed in. Please sign in again.');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    try {
      final drive = GoogleDriveService(client);
      await drive.deleteBackup(fileId);
      state = state.copyWith(
        loading: false,
        driveBackups: state.driveBackups.where((b) => b.id != fileId).toList(),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> restoreBackup(String fileId) async {
    final client = _auth.client;
    if (client == null) {
      state = state.copyWith(restoring: false, error: 'Not signed in. Please sign in again.');
      return;
    }
    state = state.copyWith(restoring: true, error: null);
    try {
      final drive = GoogleDriveService(client);
      final encrypted = await drive.downloadBackup(fileId);
      final restoredPath = await _backup.restoreFromEncrypted(encrypted);
      await _backup.replaceDb(restoredPath);
      ref.invalidate(appDatabaseProvider);
      state = state.copyWith(restoring: false);
      await listBackups();
    } catch (e) {
      state = state.copyWith(restoring: false, error: e.toString());
    }
  }

  Future<void> _loadLastBackup() async {
    final backups = await _backup.getLocalBackups();
    if (backups.isNotEmpty) {
      state = state.copyWith(
        lastBackupAt: backups.first.createdAt.toIso8601String(),
      );
    }
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

final backupProvider = NotifierProvider<BackupNotifier, BackupState>(
  BackupNotifier.new,
);
