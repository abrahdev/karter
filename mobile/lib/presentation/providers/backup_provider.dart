import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:mobile/data/services/backup_providers/backup_provider_registry.dart';
import 'package:mobile/data/services/backup_providers/webdav_provider.dart';
import 'package:mobile/data/services/backup_service.dart';
import 'package:mobile/data/services/background_service.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupState {
  final bool loading;
  final BackupProviderType providerType;
  final bool connected;
  final String? account;
  final String? lastBackupAt;
  final List<RemoteBackup> backups;
  final String? error;
  final bool backingUp;
  final bool restoring;
  final int maxBackups;
  final bool autoBackupEnabled;
  final int autoBackupHours;
  final String? webDavUrl;
  final String? webDavUser;

  const BackupState({
    this.loading = false,
    this.providerType = BackupProviderType.googleDrive,
    this.connected = false,
    this.account,
    this.lastBackupAt,
    this.backups = const [],
    this.error,
    this.backingUp = false,
    this.restoring = false,
    this.maxBackups = 10,
    this.autoBackupEnabled = false,
    this.autoBackupHours = 24,
    this.webDavUrl,
    this.webDavUser,
  });

  BackupState copyWith({
    bool? loading,
    BackupProviderType? providerType,
    bool? connected,
    String? account,
    String? lastBackupAt,
    List<RemoteBackup>? backups,
    String? error,
    bool? backingUp,
    bool? restoring,
    int? maxBackups,
    bool? autoBackupEnabled,
    int? autoBackupHours,
    String? webDavUrl,
    String? webDavUser,
  }) {
    return BackupState(
      loading: loading ?? this.loading,
      providerType: providerType ?? this.providerType,
      connected: connected ?? this.connected,
      account: account ?? this.account,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
      backups: backups ?? this.backups,
      error: error,
      backingUp: backingUp ?? this.backingUp,
      restoring: restoring ?? this.restoring,
      maxBackups: maxBackups ?? this.maxBackups,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      autoBackupHours: autoBackupHours ?? this.autoBackupHours,
      webDavUrl: webDavUrl ?? this.webDavUrl,
      webDavUser: webDavUser ?? this.webDavUser,
    );
  }
}

class BackupNotifier extends Notifier<BackupState> {
  final BackupService _backup = BackupService();

  BackupProvider? _provider;

  @override
  BackupState build() {
    _init();
    return const BackupState();
  }

  BackupProvider _activeProvider() {
    return _provider ??= BackupProviderRegistry.create(state.providerType);
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMax = prefs.getInt(kMaxBackupsKey) ?? 10;
    final savedType = backupProviderTypeFromName(
      prefs.getString(kBackupProviderKey) ?? '',
    );
    final autoEnabled = prefs.getBool(kAutoBackupEnabledKey) ?? false;
    final autoHours = prefs.getInt(kAutoBackupHoursKey) ?? 24;

    state = BackupState(
      providerType: savedType,
      maxBackups: savedMax,
      autoBackupEnabled: autoEnabled,
      autoBackupHours: autoHours,
    );
    await _restoreSession();
  }

  Future<void> _restoreSession() async {
    final provider = _activeProvider();
    try {
      await provider.restoreSession();
    } catch (_) {}

    if (provider.isConnected) {
      state = state.copyWith(
        connected: true,
        account: provider.displayName,
        error: null,
      );
      await _loadLastBackup();
      await listBackups();
    } else {
      state = state.copyWith(connected: false, account: null);
      if (state.providerType == BackupProviderType.webDav) {
        final config = await (provider as WebDavProvider).loadConfig();
        if (config != null && config.isValid) {
          state = state.copyWith(
            webDavUrl: config.url,
            webDavUser: config.user,
          );
        }
      }
    }
  }

  Future<void> setProvider(BackupProviderType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kBackupProviderKey, type.name);
    _provider = null;
    state = state.copyWith(
      providerType: type,
      connected: false,
      account: null,
      backups: const [],
      error: null,
    );
    await _restoreSession();
  }

  Future<void> connectGoogle() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final provider = _activeProvider();
      await provider.connect();
      if (provider.isConnected) {
        state = state.copyWith(
          loading: false,
          connected: true,
          account: provider.displayName,
          error: null,
        );
        await _loadLastBackup();
        await listBackups();
      } else {
        state = state.copyWith(loading: false, connected: false);
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> connectWebDav(WebDavConfig config) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final provider = _activeProvider() as WebDavProvider;
      await provider.testConnection(config);
      await provider.saveConfig(config);
      await provider.connect();
      state = state.copyWith(
        loading: false,
        connected: true,
        account: provider.displayName,
        webDavUrl: config.url.trim(),
        webDavUser: config.user.trim(),
        error: null,
      );
      await _loadLastBackup();
      await listBackups();
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> disconnect() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _activeProvider().disconnect();
      state = BackupState(
        providerType: state.providerType,
        maxBackups: state.maxBackups,
        autoBackupEnabled: state.autoBackupEnabled,
        autoBackupHours: state.autoBackupHours,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> setMaxBackups(int value) async {
    final clamped = value.clamp(1, 50);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kMaxBackupsKey, clamped);
    state = state.copyWith(maxBackups: clamped);
  }

  Future<void> setAutoBackup(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kAutoBackupEnabledKey, enabled);
    state = state.copyWith(autoBackupEnabled: enabled);
    if (enabled) {
      await _scheduleAutoBackup();
    } else {
      try {
        await cancelAutoBackup();
      } catch (_) {}
    }
  }

  Future<void> setAutoBackupHours(int hours) async {
    final clamped = hours.clamp(6, 24 * 7);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kAutoBackupHoursKey, clamped);
    state = state.copyWith(autoBackupHours: clamped);
    if (state.autoBackupEnabled) {
      await _scheduleAutoBackup();
    }
  }

  Future<void> _scheduleAutoBackup() async {
    try {
      await scheduleAutoBackup(frequencyHours: state.autoBackupHours);
    } catch (_) {}
  }

  Future<void> backupNow() async {
    final provider = _activeProvider();
    if (!provider.isConnected) {
      state = state.copyWith(
        backingUp: false,
        error: 'Not connected. Please connect first.',
      );
      return;
    }
    state = state.copyWith(backingUp: true, error: null);
    try {
      final backups = await provider.listBackups();
      if (backups.length >= state.maxBackups) {
        final toDelete = backups.sublist(state.maxBackups - 1);
        for (final b in toDelete) {
          await provider.deleteBackup(b.id);
        }
      }

      final now = DateTime.now();
      final filename = backupFilename(now);

      final encrypted = await _backup.createEncryptedBackup();
      await provider.uploadBackup(filename, encrypted);

      await _backup.saveLocalMetadata(BackupMetadata(
        fileName: filename,
        fileId: filename,
        sizeBytes: encrypted.length,
        createdAt: now,
      ));

      state = state.copyWith(
        backingUp: false,
        lastBackupAt: now.toIso8601String(),
        error: null,
      );

      await listBackups();
    } catch (e) {
      state = state.copyWith(backingUp: false, error: e.toString());
    }
  }

  Future<void> listBackups() async {
    final provider = _activeProvider();
    if (!provider.isConnected) return;
    try {
      final backups = await provider.listBackups();
      state = state.copyWith(backups: backups, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteBackup(String fileId) async {
    final provider = _activeProvider();
    if (!provider.isConnected) {
      state = state.copyWith(loading: false, error: 'Not connected.');
      return;
    }
    state = state.copyWith(loading: true, error: null);
    try {
      await provider.deleteBackup(fileId);
      state = state.copyWith(
        loading: false,
        backups: state.backups.where((b) => b.id != fileId).toList(),
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> restoreBackup(String fileId) async {
    final provider = _activeProvider();
    if (!provider.isConnected) {
      state = state.copyWith(restoring: false, error: 'Not connected.');
      return;
    }
    state = state.copyWith(restoring: true, error: null);
    try {
      final encrypted = await provider.downloadBackup(fileId);
      final restoredPath = await _backup.restoreFromEncrypted(encrypted);
      await _backup.replaceDb(restoredPath);
      ref.invalidate(appDatabaseProvider);
      state = state.copyWith(restoring: false, error: null);
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
}

final backupProvider = NotifierProvider<BackupNotifier, BackupState>(
  BackupNotifier.new,
);