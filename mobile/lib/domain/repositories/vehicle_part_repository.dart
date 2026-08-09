import '../entities/vehicle_part.dart';

abstract class VehiclePartRepository {
  Future<List<VehiclePart>> getAll();
  Future<VehiclePart?> getById(String id);
  Future<void> save(VehiclePart part);
  Future<void> delete(String id);
}
