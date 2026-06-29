import 'replaced_part.dart';

class MaintenanceLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String description;
  final double odometerAtService;
  final bool isSynced;
  final String? resetIntervalId;
  final double? restoreResetKm;
  final DateTime? restoreResetDate;

  final List<ReplacedPart> replacedParts;

  MaintenanceLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.isSynced,
    this.odometerAtService = 0,
    this.resetIntervalId,
    this.restoreResetKm,
    this.restoreResetDate,
    this.replacedParts = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date.toIso8601String(),
        'description': description,
        'odometerAtService': odometerAtService,
        'isSynced': isSynced,
        'resetIntervalId': resetIntervalId,
        'restoreResetKm': restoreResetKm,
        'restoreResetDate': restoreResetDate?.toIso8601String(),
      };

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) =>
      MaintenanceLog(
        id: json['id'],
        vehicleId: json['vehicleId'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        odometerAtService: (json['odometerAtService'] as num?)?.toDouble() ?? 0,
        isSynced: json['isSynced'],
        resetIntervalId: json['resetIntervalId'],
        restoreResetKm: (json['restoreResetKm'] as num?)?.toDouble(),
        restoreResetDate: json['restoreResetDate'] != null
            ? DateTime.parse(json['restoreResetDate'])
            : null,
      );
}