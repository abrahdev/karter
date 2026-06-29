import 'replaced_part.dart';

class MaintenanceLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String description;
  final double odometerAtService;
  final bool isSynced;

  final List<ReplacedPart> replacedParts;

  MaintenanceLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.isSynced,
    this.odometerAtService = 0,
    this.replacedParts = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date.toIso8601String(),
        'description': description,
        'odometerAtService': odometerAtService,
        'isSynced': isSynced,
      };

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) =>
      MaintenanceLog(
        id: json['id'],
        vehicleId: json['vehicleId'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        odometerAtService: (json['odometerAtService'] as num?)?.toDouble() ?? 0,
        isSynced: json['isSynced'],
      );
}