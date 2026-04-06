import '../entities/vehicle.dart';

abstract class VehicleRepository {
  Future<List<Vehicle>> getVehicles();
  Future<Vehicle?> getById(String id);
  Future<void> save(Vehicle vehicle);
  Future<void> delete(String id);
}