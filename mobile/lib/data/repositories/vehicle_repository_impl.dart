import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:drift/drift.dart' as drift;

class VehicleRepositoryImpl implements VehicleRepository {
  final AppDatabase _db;

  VehicleRepositoryImpl(this._db);

  @override
  Future<List<Vehicle>> getVehicles() async {
    final entries = await _db.select(_db.vehicles).get();
    return entries.map(_toEntity).toList();
  }

  @override
  Future<Vehicle?> getById(String id) async {
    final entry = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return entry != null ? _toEntity(entry) : null;
  }

  @override
  Future<void> save(Vehicle vehicle) async {
    await _db.into(_db.vehicles).insertOnConflictUpdate(
          _toEntry(vehicle),
        );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.vehicles)..where((t) => t.id.equals(id))).go();
  }

  Vehicle _toEntity(VehicleEntry entry) {
    return Vehicle(
      id: entry.id,
      name: entry.name,
      brand: entry.brand,
      model: entry.model,
      year: entry.year,
      createdAt: entry.createdAt,
      isSynced: entry.isSynced,
      plate: Plate(entry.plate),
      vin: Vin(entry.vin),
      currentOdometer: Odometer(
        entry.odometerDistance,
        DistanceUnit.values.firstWhere((u) => u.name == entry.odometerUnit),
      ),
    );
  }

  VehiclesCompanion _toEntry(Vehicle vehicle) {
    return VehiclesCompanion(
      id: drift.Value(vehicle.id),
      name: drift.Value(vehicle.name),
      brand: drift.Value(vehicle.brand),
      model: drift.Value(vehicle.model),
      year: drift.Value(vehicle.year),
      plate: drift.Value(vehicle.plate.value),
      vin: drift.Value(vehicle.vin.code),
      odometerDistance: drift.Value(vehicle.currentOdometer.distance),
      odometerUnit: drift.Value(vehicle.currentOdometer.unit.name),
      createdAt: drift.Value(vehicle.createdAt),
      isSynced: drift.Value(vehicle.isSynced),
    );
  }
}
