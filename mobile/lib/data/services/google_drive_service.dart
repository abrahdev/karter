import 'dart:typed_data';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class DriveBackupMetadata {
  final String id;
  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;

  DriveBackupMetadata({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
  });
}

class GoogleDriveService {
  static const _folderName = 'KarterBackups';

  final drive.DriveApi _api;

  GoogleDriveService(http.Client client) : _api = drive.DriveApi(client);

  Future<String> _ensureFolder() async {
    final existing = await _api.files.list(
      q: "name = '$_folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      spaces: 'drive',
    );

    if (existing.files != null && existing.files!.isNotEmpty) {
      return existing.files!.first.id!;
    }

    final folder = await _api.files.create(
      drive.File()
        ..name = _folderName
        ..mimeType = 'application/vnd.google-apps.folder',
    );
    return folder.id!;
  }

  Future<String> uploadBackup(String filename, Uint8List data) async {
    final folderId = await _ensureFolder();

    final file = drive.File()
      ..name = filename
      ..parents = [folderId];

    final uploaded = await _api.files.create(
      file,
      uploadMedia: drive.Media(
        Stream.fromIterable([data]),
        data.length,
      ),
    );
    return uploaded.id!;
  }

  Future<List<DriveBackupMetadata>> listBackups() async {
    final folderId = await _ensureFolder();

    final response = await _api.files.list(
      q: "'$folderId' in parents and trashed = false",
      orderBy: 'createdTime desc',
      spaces: 'drive',
      pageSize: 50,
      $fields: 'nextPageToken,files(id,name,size,createdTime)',
    );

    final files = response.files;
    if (files == null || files.isEmpty) return [];

    return files
        .where((f) => f.id != null && f.name != null)
        .map((f) => DriveBackupMetadata(
              id: f.id!,
              name: f.name!,
              sizeBytes: int.tryParse(f.size ?? '0') ?? 0,
              modifiedAt: f.createdTime != null
                  ? f.createdTime!.toLocal()
                  : DateTime.now(),
            ))
        .toList();
  }

  Future<Uint8List> downloadBackup(String fileId) async {
    final response = await _api.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia);
    if (response is drive.Media) {
      final bytes = <int>[];
      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
      }
      return Uint8List.fromList(bytes);
    }
    throw Exception('Failed to download backup');
  }

  Future<void> deleteBackup(String fileId) async {
    await _api.files.delete(fileId);
  }
}
