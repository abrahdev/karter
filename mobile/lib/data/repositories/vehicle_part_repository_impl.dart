import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/vehicle_part.dart';
import 'package:mobile/domain/repositories/vehicle_part_repository.dart';

class VehiclePartRepositoryImpl implements VehiclePartRepository {
  final AppDatabase _db;

  VehiclePartRepositoryImpl(this._db);

  @override
  Future<List<VehiclePart>> getAll() async {
    final entries = await (_db.select(_db.vehicleParts)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.name)]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<VehiclePart?> getById(String id) async {
    final entry = await (_db.select(_db.vehicleParts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<void> save(VehiclePart part) async {
    await _db.into(_db.vehicleParts).insertOnConflictUpdate(_toEntry(part));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.vehicleParts)..where((t) => t.id.equals(id))).go();
  }

  VehiclePart _toEntity(VehiclePartEntry entry) {
    return VehiclePart(
      id: entry.id,
      name: entry.name,
      partId: entry.partId,
      quantity: double.tryParse(entry.quantity ?? '1') ?? 1,
      unit: entry.unit,
      oemNumber: entry.oemNumber,
      description: entry.description,
      links: _decodeLinks(entry.links),
      createdAt: entry.createdAt,
    );
  }

  VehiclePartsCompanion _toEntry(VehiclePart part) {
    return VehiclePartsCompanion(
      id: drift.Value(part.id),
      name: drift.Value(part.name),
      partId: drift.Value(part.partId),
      quantity: drift.Value(_qtyToString(part.quantity)),
      unit: drift.Value(part.unit),
      oemNumber: drift.Value(part.oemNumber),
      description: drift.Value(part.description),
      links: drift.Value(part.links.isEmpty ? null : jsonEncode(part.links)),
      createdAt: drift.Value(part.createdAt),
    );
  }

  String? _qtyToString(double qty) {
    if (qty == qty.roundToDouble()) return qty.round().toString();
    return qty.toString();
  }

  List<String> _decodeLinks(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } catch (_) {
      return [];
    }
  }
}
