import '../entities/maintenance_log.dart';

abstract class MaintenanceLogRepository {
  Future<List<MaintenanceLog>> getByVehicle(String vehicleId);
  Future<void> save(MaintenanceLog log);
  Future<void> delete(String id);
}