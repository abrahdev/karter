import 'package:drift/drift.dart' as drift;
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/repositories/maintenance_interval_repository.dart';

class MaintenanceIntervalRepositoryImpl
    implements MaintenanceIntervalRepository {
  final AppDatabase _db;

  MaintenanceIntervalRepositoryImpl(this._db);

  @override
  Future<List<MaintenanceInterval>> getByVehicle(String vehicleId) async {
    final entries = await (_db.select(_db.maintenanceIntervals)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.label)]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> save(MaintenanceInterval interval) async {
    await _db.into(_db.maintenanceIntervals).insertOnConflictUpdate(
          _toEntry(interval),
        );
  }

  @override
  Future<MaintenanceInterval?> getById(String id) async {
    final entry = await (_db.select(_db.maintenanceIntervals)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.maintenanceIntervals)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<void> resetInterval(String id, double currentKm) async {
    await (_db.update(_db.maintenanceIntervals)
          ..where((t) => t.id.equals(id)))
        .write(MaintenanceIntervalsCompanion(
          lastResetKm: drift.Value(currentKm),
          lastResetDate: drift.Value(DateTime.now()),
        ));
  }

  MaintenanceInterval _toEntity(MaintenanceIntervalEntry entry) {
    return MaintenanceInterval(
      id: entry.id,
      vehicleId: entry.vehicleId,
      label: entry.label,
      kmInterval: entry.kmInterval,
      monthsInterval: entry.monthsInterval,
      description: entry.description,
      lastResetKm: entry.lastResetKm,
      lastResetDate: entry.lastResetDate,
      isEnabled: entry.isEnabled,
      isCustom: entry.isCustom,
    );
  }

  MaintenanceIntervalsCompanion _toEntry(MaintenanceInterval interval) {
    return MaintenanceIntervalsCompanion(
      id: drift.Value(interval.id),
      vehicleId: drift.Value(interval.vehicleId),
      label: drift.Value(interval.label),
      kmInterval: drift.Value(interval.kmInterval),
      monthsInterval: drift.Value(interval.monthsInterval),
      description: drift.Value(interval.description),
      lastResetKm: drift.Value(interval.lastResetKm),
      lastResetDate: drift.Value(interval.lastResetDate),
      isEnabled: drift.Value(interval.isEnabled),
      isCustom: drift.Value(interval.isCustom),
    );
  }
}
