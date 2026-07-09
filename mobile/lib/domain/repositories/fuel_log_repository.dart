import '../entities/fuel_log.dart';

abstract class FuelLogRepository {
  Future<FuelLog?> getById(String id);
  Future<List<FuelLog>> getByVehicle(String vehicleId);
  Future<void> save(FuelLog log);
  Future<void> delete(String id);
}