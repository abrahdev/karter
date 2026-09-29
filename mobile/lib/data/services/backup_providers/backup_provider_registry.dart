import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:mobile/data/services/backup_providers/google_drive_provider.dart';
import 'package:mobile/data/services/backup_providers/webdav_provider.dart';

class BackupProviderRegistry {
  static BackupProvider create(BackupProviderType type) {
    return switch (type) {
      BackupProviderType.googleDrive => GoogleDriveProvider(),
      BackupProviderType.webDav => WebDavProvider(),
    };
  }
}