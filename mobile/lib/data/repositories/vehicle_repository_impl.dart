import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/seed_intervals.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
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
  Future<void> save(Vehicle vehicle, {List<MaintenanceInterval>? intervals, bool replaceNonCustom = false}) async {
    final existing = await (_db.select(_db.vehicles)
          ..where((t) => t.id.equals(vehicle.id)))
        .getSingleOrNull();
    final isNew = existing == null;

    await _db.into(_db.vehicles).insertOnConflictUpdate(
          _toEntry(vehicle),
        );

    if (isNew) {
      final seedIntervals =
          intervals ?? defaultIntervalsFor(vehicle.type, vehicle.id);
      for (final interval in seedIntervals) {
        await _db.into(_db.maintenanceIntervals).insert(
              _intervalToCompanion(interval),
            );
      }
    } else if (intervals != null && replaceNonCustom) {
      final toDelete = await (_db.select(_db.maintenanceIntervals)
            ..where((t) => t.vehicleId.equals(vehicle.id))
            ..where((t) => t.isCustom.equals(false)))
          .get();
      for (final entry in toDelete) {
        await (_db.delete(_db.maintenanceIntervals)
              ..where((t) => t.id.equals(entry.id)))
            .go();
      }
      for (final interval in intervals) {
        await _db.into(_db.maintenanceIntervals).insert(
              _intervalToCompanion(interval),
            );
      }
    } else if (intervals != null) {
      final existingList = await (_db.select(_db.maintenanceIntervals)
            ..where((t) => t.vehicleId.equals(vehicle.id)))
          .get();
      final existingByKey = <String, MaintenanceIntervalEntry>{};
      for (final entry in existingList) {
        if (entry.i18nKey != null) {
          existingByKey[entry.i18nKey!] = entry;
        }
      }
      for (final interval in intervals) {
        if (interval.i18nKey != null && existingByKey.containsKey(interval.i18nKey)) {
          final existing = existingByKey[interval.i18nKey!]!;
          if (!existing.isCustom) {
            await (_db.update(_db.maintenanceIntervals)
                  ..where((t) => t.id.equals(existing.id)))
                .write(_intervalToCompanion(interval).copyWith(
                  id: drift.Value(existing.id),
                  vehicleId: drift.Value(existing.vehicleId),
                  lastResetKm: drift.Value(existing.lastResetKm),
                  lastResetDate: drift.Value(existing.lastResetDate),
                  isEnabled: drift.Value(existing.isEnabled),
                ));
          }
        } else {
          await _db.into(_db.maintenanceIntervals).insert(
                _intervalToCompanion(interval),
              );
        }
      }
    }
  }

  MaintenanceIntervalsCompanion _intervalToCompanion(MaintenanceInterval interval) {
    return MaintenanceIntervalsCompanion(
      id: drift.Value(interval.id),
      vehicleId: drift.Value(interval.vehicleId),
      label: drift.Value(interval.label),
      kmInterval: drift.Value(interval.kmInterval),
      monthsInterval: drift.Value(interval.monthsInterval),
      description: drift.Value(interval.description),
      i18nKey: drift.Value(interval.i18nKey),
      lastResetKm: drift.Value(interval.lastResetKm),
      lastResetDate: drift.Value(interval.lastResetDate),
      isEnabled: drift.Value(interval.isEnabled),
      isCustom: drift.Value(interval.isCustom),
    );
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.vehicles)..where((t) => t.id.equals(id))).go();
  }

  Vehicle _toEntity(VehicleEntry entry) {
    return Vehicle(
      id: entry.id,
      brand: entry.brand,
      model: entry.model,
      year: entry.year,
      alias: entry.alias,
      createdAt: entry.createdAt,
      isSynced: entry.isSynced,
      plate: entry.plate != null ? Plate(entry.plate!) : null,
      vin: entry.vin != null ? Vin(entry.vin!) : null,
      currentOdometer: Odometer(
        entry.odometerDistance,
        DistanceUnit.values.firstWhere((u) => u.name == entry.odometerUnit),
      ),
      type: VehicleType.values.firstWhere((t) => t.name == entry.type),
      fuelVolumeUnit:
          VolumeUnit.values.firstWhere((u) => u.name == entry.fuelVolumeUnit),
      currency: entry.currency,
      odometerReminderFreqDays: entry.odometerReminderFreqDays,
      odometerReminderLastNotified: entry.odometerReminderLastNotified,
      maintenanceReminderEnabled: entry.maintenanceReminderEnabled,
      maintenanceReminderSnoozedUntil: entry.maintenanceReminderSnoozedUntil,
    );
  }

  VehiclesCompanion _toEntry(Vehicle vehicle) {
    return VehiclesCompanion(
      id: drift.Value(vehicle.id),
      name: drift.Value(''),
      brand: drift.Value(vehicle.brand),
      model: drift.Value(vehicle.model),
      year: drift.Value(vehicle.year),
      alias: drift.Value(vehicle.alias),
      plate: drift.Value(vehicle.plate?.value),
      vin: drift.Value(vehicle.vin?.code),
      odometerDistance: drift.Value(vehicle.currentOdometer.distance),
      odometerUnit: drift.Value(vehicle.currentOdometer.unit.name),
      createdAt: drift.Value(vehicle.createdAt),
      isSynced: drift.Value(vehicle.isSynced),
      type: drift.Value(vehicle.type.name),
      fuelVolumeUnit: drift.Value(vehicle.fuelVolumeUnit.name),
      currency: drift.Value(vehicle.currency),
      odometerReminderFreqDays: drift.Value(vehicle.odometerReminderFreqDays),
      odometerReminderLastNotified:
          drift.Value(vehicle.odometerReminderLastNotified),
      maintenanceReminderEnabled:
          drift.Value(vehicle.maintenanceReminderEnabled),
      maintenanceReminderSnoozedUntil:
          drift.Value(vehicle.maintenanceReminderSnoozedUntil),
    );
  }
}
