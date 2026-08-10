import 'dart:convert';
import 'dart:io';

import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/entities/vehicle_part.dart';
import 'package:mobile/domain/repositories/fuel_log_repository.dart';
import 'package:mobile/domain/repositories/maintenance_interval_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_part_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_repository.dart';
import 'package:mobile/domain/repositories/vehicle_document_repository.dart';
import 'package:mobile/domain/repositories/vehicle_part_repository.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';
import 'package:path_provider/path_provider.dart';

class ExportData {
  final int version;
  final DateTime exportedAt;
  final List<Vehicle> vehicles;
  final List<FuelLog> fuelLogs;
  final List<MaintenanceLog> maintenanceLogs;
  final List<MaintenanceInterval> maintenanceIntervals;
  final List<VehicleDocument> vehicleDocuments;
  final List<VehiclePart> vehicleParts;
  final List<MaintenanceLogPart> maintenanceLogParts;

  ExportData({
    required this.version,
    required this.exportedAt,
    required this.vehicles,
    required this.fuelLogs,
    required this.maintenanceLogs,
    required this.maintenanceIntervals,
    required this.vehicleDocuments,
    this.vehicleParts = const [],
    this.maintenanceLogParts = const [],
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'exportedAt': exportedAt.toIso8601String(),
        'vehicles': vehicles.map((v) => v.toJson()).toList(),
        'fuelLogs': fuelLogs.map((l) => l.toJson()).toList(),
        'maintenanceLogs': maintenanceLogs.map((l) => l.toJson()).toList(),
        'maintenanceIntervals':
            maintenanceIntervals.map((i) => i.toJson()).toList(),
        'vehicleDocuments':
            vehicleDocuments.map((d) => d.toJson()).toList(),
        'vehicleParts': vehicleParts.map((p) => p.toJson()).toList(),
        'maintenanceLogParts':
            maintenanceLogParts.map((p) => p.toJson()).toList(),
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
        vehicleDocuments: (json['vehicleDocuments'] as List?)
                ?.map((d) => VehicleDocument.fromJson(d))
                .toList() ??
            [],
        vehicleParts: (json['vehicleParts'] as List?)
                ?.map((p) => VehiclePart.fromJson(p))
                .toList() ??
            [],
        maintenanceLogParts: (json['maintenanceLogParts'] as List?)
                ?.map((p) => MaintenanceLogPart.fromJson(p))
                .toList() ??
            [],
      );
}

class ExportService {
  final VehicleRepository _vehicleRepo;
  final FuelLogRepository _fuelLogRepo;
  final MaintenanceLogRepository _maintenanceLogRepo;
  final MaintenanceIntervalRepository _intervalRepo;
  final VehicleDocumentRepository _documentRepo;
  final MaintenanceLogPartRepository _logPartRepo;
  final VehiclePartRepository _vehiclePartRepo;

  ExportService(
    this._vehicleRepo,
    this._fuelLogRepo,
    this._maintenanceLogRepo,
    this._intervalRepo,
    this._documentRepo,
    this._logPartRepo,
    this._vehiclePartRepo,
  );

  Future<String> exportVehicles(Set<String> vehicleIds) async {
    final allVehicles = await _vehicleRepo.getVehicles();
    final selected =
        allVehicles.where((v) => vehicleIds.contains(v.id)).toList();

    final fuelLogs = <FuelLog>[];
    final maintenanceLogs = <MaintenanceLog>[];
    final intervals = <MaintenanceInterval>[];
    final documents = <VehicleDocument>[];
    final logParts = <MaintenanceLogPart>[];

    for (final v in selected) {
      fuelLogs.addAll(await _fuelLogRepo.getByVehicle(v.id));
      maintenanceLogs.addAll(await _maintenanceLogRepo.getByVehicle(v.id));
      intervals.addAll(await _intervalRepo.getByVehicle(v.id));
      final docs = await _documentRepo.getByVehicle(v.id);
      for (final doc in docs) {
        try {
          final file = File(doc.filePath);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            documents.add(doc.copyWith(
                fileDataBase64: base64Encode(bytes)));
          } else {
            documents.add(doc);
          }
        } catch (_) {
          documents.add(doc);
        }
      }
      for (final log in maintenanceLogs.where((l) => l.vehicleId == v.id)) {
        logParts.addAll(await _logPartRepo.getByLog(log.id));
      }
    }

    final allLogPartIds = logParts.map((p) => p.partId).toSet();
    final vehicleParts = (await _vehiclePartRepo.getAll())
        .where((p) => allLogPartIds.contains(p.id))
        .toList();

    final data = ExportData(
      version: 2,
      exportedAt: DateTime.now(),
      vehicles: selected,
      fuelLogs: fuelLogs,
      maintenanceLogs: maintenanceLogs,
      maintenanceIntervals: intervals,
      vehicleDocuments: documents,
      vehicleParts: vehicleParts,
      maintenanceLogParts: logParts,
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

    for (final doc in data.vehicleDocuments) {
      var saved = doc;
      if (doc.fileDataBase64 != null) {
        try {
          final bytes = base64Decode(doc.fileDataBase64!);
          final dir = await getApplicationDocumentsDirectory();
          final newPath =
              '${dir.path}/documents/${doc.id}_${doc.fileName}';
          await File(newPath).parent.create(recursive: true);
          await File(newPath).writeAsBytes(bytes);
          saved = doc.copyWith(
            filePath: newPath,
            fileDataBase64: null,
          );
        } catch (_) {}
      }
      await _documentRepo.save(saved);
    }

    for (final part in data.vehicleParts) {
      await _vehiclePartRepo.save(part);
    }

    final partsByLog = <String, List<MaintenanceLogPart>>{};
    for (final part in data.maintenanceLogParts) {
      partsByLog.putIfAbsent(part.logId, () => []).add(part);
    }
    for (final entry in partsByLog.entries) {
      await _logPartRepo.replaceForLog(entry.key, entry.value);
    }
  }

  static ExportData? preview(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final version = map['version'];
      if (version != 1 && version != 2) return null;
      return ExportData.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
