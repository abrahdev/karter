import 'package:drift/drift.dart' as drift;
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/utils/path_codec.dart' as path_codec;
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/repositories/fuel_log_repository.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/volume.dart';

class FuelLogRepositoryImpl implements FuelLogRepository {
  final AppDatabase _db;

  FuelLogRepositoryImpl(this._db);

  @override
  Future<FuelLog?> getById(String id) async {
    final entry = await (_db.select(_db.fuelLogs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<List<FuelLog>> getByVehicle(String vehicleId) async {
    final entries = await (_db.select(_db.fuelLogs)
          ..where((t) => t.vehicleId.equals(vehicleId))
          ..orderBy([(t) => drift.OrderingTerm.desc(t.date)]))
        .get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<void> save(FuelLog log) async {
    await _db.into(_db.fuelLogs).insertOnConflictUpdate(_toEntry(log));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.fuelLogs)..where((t) => t.id.equals(id))).go();
  }

  FuelLog _toEntity(FuelLogEntry entry) {
    return FuelLog(
      id: entry.id,
      vehicleId: entry.vehicleId,
      date: entry.date,
      isSynced: entry.isSynced,
      fueledVolume: Volume(
        entry.volumeAmount,
        VolumeUnit.values.firstWhere((u) => u.name == entry.volumeUnit),
      ),
      odometerAtFueling: Odometer(
        entry.odometerDistance,
        DistanceUnit.values.firstWhere((u) => u.name == entry.odometerUnit),
      ),
      pricePerUnit: entry.pricePerUnit,
      isFullTank: entry.isFullTank,
      photoPaths: path_codec.decodePaths(entry.photoPaths),
    );
  }

  FuelLogsCompanion _toEntry(FuelLog log) {
    return FuelLogsCompanion(
      id: drift.Value(log.id),
      vehicleId: drift.Value(log.vehicleId),
      date: drift.Value(log.date),
      isSynced: drift.Value(log.isSynced),
      volumeAmount: drift.Value(log.fueledVolume.amount),
      volumeUnit: drift.Value(log.fueledVolume.unit.name),
      odometerDistance: drift.Value(log.odometerAtFueling.distance),
      odometerUnit: drift.Value(log.odometerAtFueling.unit.name),
      isFullTank: drift.Value(log.isFullTank),
      pricePerUnit: drift.Value(log.pricePerUnit),
      photoPaths: drift.Value(path_codec.encodePaths(log.photoPaths)),
    );
  }

}
