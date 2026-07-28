import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/backup_service.dart';
import 'package:mobile/data/services/google_drive_auth_service.dart';
import 'package:mobile/data/services/google_drive_service.dart';

class BackupState {
  final bool loading;
  final bool signedIn;
  final String? email;
  final String? lastBackupAt;
  final List<DriveBackupMetadata> driveBackups;
  final String? error;
  final bool backingUp;
  final bool restoring;

  const BackupState({
    this.loading = false,
    this.signedIn = false,
    this.email,
    this.lastBackupAt,
    this.driveBackups = const [],
    this.error,
    this.backingUp = false,
    this.restoring = false,
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
    );
  }
}

class BackupNotifier extends Notifier<BackupState> {
  final GoogleDriveAuthService _auth = GoogleDriveAuthService();
  final BackupService _backup = BackupService();

  @override
  BackupState build() {
    return const BackupState();
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
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _auth.signOut();
      state = const BackupState();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> backupNow() async {
    state = state.copyWith(backingUp: true, error: null);
    try {
      final now = DateTime.now();
      final filename = 'karter_${now.year}${_pad(now.month)}${_pad(now.day)}_${_pad(now.hour)}${_pad(now.minute)}${_pad(now.second)}.db.aes';

      final encrypted = await _backup.createEncryptedBackup();

      final drive = GoogleDriveService(_auth.client!);
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
    } catch (e) {
      state = state.copyWith(backingUp: false, error: e.toString());
    }
  }

  Future<void> listBackups() async {
    if (!_auth.isSignedIn) return;
    state = state.copyWith(loading: true, error: null);
    try {
      final drive = GoogleDriveService(_auth.client!);
      final backups = await drive.listBackups();
      state = state.copyWith(loading: false, driveBackups: backups);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> restoreBackup(String fileId) async {
    state = state.copyWith(restoring: true, error: null);
    try {
      final drive = GoogleDriveService(_auth.client!);
      final encrypted = await drive.downloadBackup(fileId);
      final restoredPath = await _backup.restoreFromEncrypted(encrypted);
      await _backup.replaceDb(restoredPath);
      state = state.copyWith(restoring: false);
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
