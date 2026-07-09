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
  final String? fileDataBase64;

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
    this.fileDataBase64,
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
    String? fileDataBase64,
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
      fileDataBase64: fileDataBase64 ?? this.fileDataBase64,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'type': type.name,
        'name': name,
        'fileName': fileName,
        'filePath': filePath,
        'mimeType': mimeType,
        'fileSize': fileSize,
        'notes': notes,
        'expiryDate': expiryDate?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        if (fileDataBase64 != null) 'fileData': fileDataBase64,
      };

  factory VehicleDocument.fromJson(Map<String, dynamic> json) =>
      VehicleDocument(
        id: json['id'],
        vehicleId: json['vehicleId'],
        type: DocumentType.values.byName(json['type']),
        name: json['name'],
        fileName: json['fileName'],
        filePath: json['filePath'],
        mimeType: json['mimeType'],
        fileSize: (json['fileSize'] as num?)?.toDouble(),
        notes: json['notes'],
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'])
            : null,
        createdAt: DateTime.parse(json['createdAt']),
        fileDataBase64: json['fileData'],
      );
}
