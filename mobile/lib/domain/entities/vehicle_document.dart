import 'package:mobile/domain/enums/document_type.dart';

class VehicleDocument {
  final String id;
  final String vehicleId;
  final DocumentType type;
  final String name;
  final String fileName;
  final String filePath;
  final String? mimeType;
  final double? fileSize;
  final String? notes;
  final DateTime? expiryDate;
  final DateTime createdAt;

  const VehicleDocument({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.name,
    required this.fileName,
    required this.filePath,
    this.mimeType,
    this.fileSize,
    this.notes,
    this.expiryDate,
    required this.createdAt,
  });

  VehicleDocument copyWith({
    String? id,
    String? vehicleId,
    DocumentType? type,
    String? name,
    String? fileName,
    String? filePath,
    String? mimeType,
    double? fileSize,
    String? notes,
    DateTime? expiryDate,
    DateTime? createdAt,
  }) {
    return VehicleDocument(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      notes: notes ?? this.notes,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
