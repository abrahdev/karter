import '../entities/spare_part.dart';

abstract class SparePartRepository {
  Future<List<SparePart>> getAll();
  Future<SparePart?> getById(String id);
  Future<void> save(SparePart part);
  Future<void> delete(String id);
}