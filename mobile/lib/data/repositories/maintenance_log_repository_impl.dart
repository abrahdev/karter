import 'package:drift/drift.dart' as drift;
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/repositories/maintenance_log_repository.dart';

class MaintenanceLogRepositoryImpl implements MaintenanceLogRepository {
  final AppDatabase _db;

  MaintenanceLogRepositoryImpl(this._db);

  @override
  Future<List<MaintenanceLog>> getByVehicle(String vehicleId) async {
    final entries = await (_db.select(_db.maintenanceLogs)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> save(MaintenanceLog log) async {
    await _db.into(_db.maintenanceLogs).insertOnConflictUpdate(
          _toEntry(log),
        );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.maintenanceLogs)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  MaintenanceLog _toEntity(MaintenanceLogEntry entry) {
    return MaintenanceLog(
      id: entry.id,
      vehicleId: entry.vehicleId,
      date: entry.date,
      description: entry.description,
      odometerAtService: entry.odometerAtService,
      isSynced: entry.isSynced,
    );
  }

  MaintenanceLogsCompanion _toEntry(MaintenanceLog log) {
    return MaintenanceLogsCompanion(
      id: drift.Value(log.id),
      vehicleId: drift.Value(log.vehicleId),
      date: drift.Value(log.date),
      description: drift.Value(log.description),
      odometerAtService: drift.Value(log.odometerAtService),
      isSynced: drift.Value(log.isSynced),
    );
  }
}
