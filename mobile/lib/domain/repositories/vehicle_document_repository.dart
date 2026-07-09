import 'package:mobile/domain/entities/vehicle_document.dart';

abstract class VehicleDocumentRepository {
  Future<VehicleDocument?> getById(String id);
  Future<List<VehicleDocument>> getByVehicle(String vehicleId);
  Future<void> save(VehicleDocument document);
  Future<void> delete(String id);
}
