import 'dart:typed_data';

enum BackupProviderType { googleDrive, webDav }

BackupProviderType backupProviderTypeFromName(String name) =>
    BackupProviderType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => BackupProviderType.googleDrive,
    );

class RemoteBackup {
  final String id;
  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;

  const RemoteBackup({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
  });
}

abstract class BackupProvider {
  bool get isConnected;

  String get displayName;

  Future<void> restoreSession();

  Future<void> connect();

  Future<void> disconnect();

  Future<List<RemoteBackup>> listBackups();

  Future<void> uploadBackup(String filename, Uint8List data);

  Future<Uint8List> downloadBackup(String id);

  Future<void> deleteBackup(String id);
}

class BackupProviderException implements Exception {
  final String message;

  const BackupProviderException(this.message);

  @override
  String toString() => message;
}