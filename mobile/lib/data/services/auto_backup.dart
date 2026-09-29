import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:mobile/data/services/backup_providers/backup_provider_registry.dart';
import 'package:mobile/data/services/backup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> runAutoBackup() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(kAutoBackupEnabledKey) ?? false)) return false;

    final type = backupProviderTypeFromName(
      prefs.getString(kBackupProviderKey) ?? '',
    );
    final provider = BackupProviderRegistry.create(type);
    await provider.restoreSession();
    if (!provider.isConnected) return false;

    final backup = BackupService();
    final encrypted = await backup.createEncryptedBackup();
    final now = DateTime.now();
    final filename = backupFilename(now);
    await provider.uploadBackup(filename, encrypted);

    final max = prefs.getInt(kMaxBackupsKey) ?? 10;
    final backups = await provider.listBackups();
    if (backups.length > max) {
      for (final b in backups.sublist(max)) {
        await provider.deleteBackup(b.id);
      }
    }

    await backup.saveLocalMetadata(
      BackupMetadata(
        fileName: filename,
        fileId: filename,
        sizeBytes: encrypted.length,
        createdAt: now,
      ),
    );
    return true;
  } catch (_) {
    return false;
  }
}