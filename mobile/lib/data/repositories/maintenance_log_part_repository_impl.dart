import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/repositories/maintenance_log_part_repository.dart';

class MaintenanceLogPartRepositoryImpl
    implements MaintenanceLogPartRepository {
  final AppDatabase _db;

  MaintenanceLogPartRepositoryImpl(this._db);

  @override
  Future<List<MaintenanceLogPart>> getByLog(String logId) async {
    final entries = await (_db.select(_db.maintenanceLogParts)
          ..where((t) => t.logId.equals(logId)))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<List<MaintenanceLogPart>> getByPartId(String partId) async {
    final entries = await (_db.select(_db.maintenanceLogParts)
          ..where((t) => t.partId.equals(partId)))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> replaceForLog(
    String logId,
    List<MaintenanceLogPart> parts,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.maintenanceLogParts)
            ..where((t) => t.logId.equals(logId)))
          .go();
      for (final part in parts) {
        await _db.into(_db.maintenanceLogParts).insert(
              MaintenanceLogPartsCompanion(
                id: drift.Value(part.id),
                logId: drift.Value(logId),
                partId: drift.Value(part.partId),
                name: drift.Value(part.name),
                quantity: drift.Value(_qtyToString(part.quantity)),
                unit: drift.Value(part.unit),
                oemNumber: drift.Value(part.oemNumber),
                description: drift.Value(part.description),
                links: drift.Value(
                    part.links.isEmpty ? null : jsonEncode(part.links)),
              ),
            );
      }
    });
  }

  @override
  Future<void> deleteByLog(String logId) async {
    await (_db.delete(_db.maintenanceLogParts)
          ..where((t) => t.logId.equals(logId)))
        .go();
  }

  @override
  Future<void> deleteByPartId(String partId) async {
    await (_db.delete(_db.maintenanceLogParts)
          ..where((t) => t.partId.equals(partId)))
        .go();
  }

  MaintenanceLogPart _toEntity(MaintenanceLogPartEntry entry) {
    return MaintenanceLogPart(
      id: entry.id,
      logId: entry.logId,
      partId: entry.partId,
      name: entry.name,
      quantity: double.tryParse(entry.quantity ?? '1') ?? 1,
      unit: entry.unit,
      oemNumber: entry.oemNumber,
      description: entry.description,
      links: _decodeLinks(entry.links),
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
