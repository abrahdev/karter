import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(ref.watch(appDatabaseProvider));
});

final vehicleListProvider = FutureProvider<List<Vehicle>>((ref) async {
  final repo = ref.watch(vehicleRepositoryProvider);
  return repo.getVehicles();
});

final vehicleProvider = FutureProvider.family<Vehicle?, String>(
  (ref, id) async {
    final repo = ref.watch(vehicleRepositoryProvider);
    return repo.getById(id);
  },
);
