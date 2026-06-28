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
}