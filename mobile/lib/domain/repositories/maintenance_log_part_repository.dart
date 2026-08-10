import '../entities/maintenance_log_part.dart';

abstract class MaintenanceLogPartRepository {
  Future<List<MaintenanceLogPart>> getByLog(String logId);
  Future<List<MaintenanceLogPart>> getByPartId(String partId);
  Future<void> replaceForLog(String logId, List<MaintenanceLogPart> parts);
  Future<void> deleteByLog(String logId);
  Future<void> deleteByPartId(String partId);
}
