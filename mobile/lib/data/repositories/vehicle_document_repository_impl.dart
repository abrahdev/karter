import 'package:drift/drift.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/enums/document_type.dart';
import 'package:mobile/domain/repositories/vehicle_document_repository.dart';

class VehicleDocumentRepositoryImpl implements VehicleDocumentRepository {
  final AppDatabase _db;

  VehicleDocumentRepositoryImpl(this._db);

  VehicleDocument _toEntity(VehicleDocumentEntry entry) {
    return VehicleDocument(
      id: entry.id,
      vehicleId: entry.vehicleId,
      type: DocumentType.values.firstWhere(
        (e) => e.name == entry.type,
        orElse: () => DocumentType.other,
      ),
      name: entry.name,
      fileName: entry.fileName,
      filePath: entry.filePath,
      mimeType: entry.mimeType,
      fileSize: entry.fileSize,
      notes: entry.notes,
      expiryDate: entry.expiryDate,
      createdAt: entry.createdAt,
    );
  }

  VehicleDocumentsCompanion _toEntry(VehicleDocument doc) {
    return VehicleDocumentsCompanion.insert(
      id: doc.id,
      vehicleId: doc.vehicleId,
      type: doc.type.name,
      name: doc.name,
      fileName: doc.fileName,
      filePath: doc.filePath,
      mimeType: Value(doc.mimeType),
      fileSize: Value(doc.fileSize),
      notes: Value(doc.notes),
      expiryDate: Value(doc.expiryDate),
      createdAt: doc.createdAt,
    );
  }

  @override
  Future<List<VehicleDocument>> getByVehicle(String vehicleId) async {
    final entries = await (_db.select(_db.vehicleDocuments)
        ..where((t) => t.vehicleId.equals(vehicleId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> save(VehicleDocument document) async {
    await _db.into(_db.vehicleDocuments).insertOnConflictUpdate(
      _toEntry(document),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.vehicleDocuments)
        ..where((t) => t.id.equals(id))).go();
  }
}
