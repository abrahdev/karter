import '../entities/fuel_log.dart';

abstract class FuelLogRepository {
  Future<List<FuelLog>> getByVehicle(String vehicleId);
  Future<void> save(FuelLog log);
  Future<void> delete(String id);
}