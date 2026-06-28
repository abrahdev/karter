import '../entities/maintenance_interval.dart';

abstract class MaintenanceIntervalRepository {
  Future<List<MaintenanceInterval>> getByVehicle(String vehicleId);
  Future<void> save(MaintenanceInterval interval);
  Future<void> delete(String id);
  Future<void> resetInterval(String id, double currentKm);
}
