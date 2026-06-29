import 'dart:convert';

import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/repositories/fuel_log_repository.dart';
import 'package:mobile/domain/repositories/maintenance_interval_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_repository.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';

class ExportData {
  final int version;
  final DateTime exportedAt;
  final List<Vehicle> vehicles;
  final List<FuelLog> fuelLogs;
  final List<MaintenanceLog> maintenanceLogs;
  final List<MaintenanceInterval> maintenanceIntervals;

  ExportData({
    required this.version,
    required this.exportedAt,
    required this.vehicles,
    required this.fuelLogs,
    required this.maintenanceLogs,
    required this.maintenanceIntervals,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'exportedAt': exportedAt.toIso8601String(),
        'vehicles': vehicles.map((v) => v.toJson()).toList(),
        'fuelLogs': fuelLogs.map((l) => l.toJson()).toList(),
        'maintenanceLogs': maintenanceLogs.map((l) => l.toJson()).toList(),
        'maintenanceIntervals':
            maintenanceIntervals.map((i) => i.toJson()).toList(),
      };

  factory ExportData.fromJson(Map<String, dynamic> json) => ExportData(
        version: json['version'],
        exportedAt: DateTime.parse(json['exportedAt']),
        vehicles: (json['vehicles'] as List)
            .map((v) => Vehicle.fromJson(v))
            .toList(),
        fuelLogs: (json['fuelLogs'] as List)
            .map((l) => FuelLog.fromJson(l))
            .toList(),
        maintenanceLogs: (json['maintenanceLogs'] as List)
            .map((l) => MaintenanceLog.fromJson(l))
            .toList(),
        maintenanceIntervals: (json['maintenanceIntervals'] as List)
            .map((i) => MaintenanceInterval.fromJson(i))
            .toList(),
      );
}

class ExportService {
  final VehicleRepository _vehicleRepo;
  final FuelLogRepository _fuelLogRepo;
  final MaintenanceLogRepository _maintenanceLogRepo;
  final MaintenanceIntervalRepository _intervalRepo;

  ExportService(
    this._vehicleRepo,
    this._fuelLogRepo,
    this._maintenanceLogRepo,
    this._intervalRepo,
  );

  Future<String> exportVehicles(Set<String> vehicleIds) async {
    final allVehicles = await _vehicleRepo.getVehicles();
    final selected = allVehicles.where((v) => vehicleIds.contains(v.id)).toList();

    final fuelLogs = <FuelLog>[];
    final maintenanceLogs = <MaintenanceLog>[];
    final intervals = <MaintenanceInterval>[];

    for (final v in selected) {
      fuelLogs.addAll(await _fuelLogRepo.getByVehicle(v.id));
      maintenanceLogs.addAll(await _maintenanceLogRepo.getByVehicle(v.id));
      intervals.addAll(await _intervalRepo.getByVehicle(v.id));
    }

    final data = ExportData(
      version: 1,
      exportedAt: DateTime.now(),
      vehicles: selected,
      fuelLogs: fuelLogs,
      maintenanceLogs: maintenanceLogs,
      maintenanceIntervals: intervals,
    );

    return const JsonEncoder.withIndent('  ').convert(data.toJson());
  }

  Future<void> importJson(String json) async {
    final map = jsonDecode(json) as Map<String, dynamic>;
    final data = ExportData.fromJson(map);

    for (final vehicle in data.vehicles) {
      await _vehicleRepo.save(vehicle);
    }

    for (final log in data.fuelLogs) {
      await _fuelLogRepo.save(log);
    }

    for (final log in data.maintenanceLogs) {
      await _maintenanceLogRepo.save(log);
    }

    for (final interval in data.maintenanceIntervals) {
      await _intervalRepo.save(interval);
    }
  }

  static ExportData? preview(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      if (map['version'] != 1) return null;
      return ExportData.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
