import '../entities/maintenance_interval.dart';
import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle?> getById(String id);
  Future<void> save(Vehicle vehicle, {List<MaintenanceInterval>? intervals, bool replaceNonCustom = false});
  Future<void> delete(String id);
}