import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/fuel_log_repository_impl.dart';
import 'package:mobile/data/repositories/maintenance_interval_repository_impl.dart';
import 'package:mobile/data/repositories/maintenance_log_repository_impl.dart';
import 'package:mobile/data/repositories/vehicle_document_repository_impl.dart';
import 'package:mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:mobile/data/services/export_service.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/data/services/pdf_export_service.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/repositories/fuel_log_repository.dart';
import 'package:mobile/domain/repositories/maintenance_interval_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_repository.dart';
import 'package:mobile/domain/repositories/vehicle_document_repository.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(ref.watch(appDatabaseProvider));
});

final fuelLogRepositoryProvider = Provider<FuelLogRepository>((ref) {
  return FuelLogRepositoryImpl(ref.watch(appDatabaseProvider));
});

final maintenanceLogRepositoryProvider = Provider<MaintenanceLogRepository>(
  (ref) => MaintenanceLogRepositoryImpl(ref.watch(appDatabaseProvider)),
);

final maintenanceIntervalRepositoryProvider =
    Provider<MaintenanceIntervalRepository>((ref) {
  return MaintenanceIntervalRepositoryImpl(ref.watch(appDatabaseProvider));
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

final fuelLogsProvider =
    FutureProvider.family<List<FuelLog>, String>((ref, vehicleId) async {
  final repo = ref.watch(fuelLogRepositoryProvider);
  return repo.getByVehicle(vehicleId);
});

final maintenanceLogsProvider =
    FutureProvider.family<List<MaintenanceLog>, String>(
  (ref, vehicleId) async {
    final repo = ref.watch(maintenanceLogRepositoryProvider);
    return repo.getByVehicle(vehicleId);
  },
);

final maintenanceIntervalsProvider =
    FutureProvider.family<List<MaintenanceInterval>, String>(
  (ref, vehicleId) async {
    final repo = ref.watch(maintenanceIntervalRepositoryProvider);
    return repo.getByVehicle(vehicleId);
  },
);

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    ref.watch(vehicleRepositoryProvider),
    ref.watch(fuelLogRepositoryProvider),
    ref.watch(maintenanceLogRepositoryProvider),
    ref.watch(maintenanceIntervalRepositoryProvider),
    ref.watch(vehicleDocumentRepositoryProvider),
  );
});

final templateResolverProvider = Provider<TemplateResolver>((ref) {
  return TemplateResolver();
});

final templateIndexProvider = FutureProvider<TemplateIndex>((ref) async {
  final resolver = ref.watch(templateResolverProvider);
  return resolver.loadIndex();
});

final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return PdfExportService();
});

final vehicleDocumentRepositoryProvider =
    Provider<VehicleDocumentRepository>((ref) {
  return VehicleDocumentRepositoryImpl(ref.watch(appDatabaseProvider));
});

final vehicleDocumentsProvider =
    FutureProvider.family<List<VehicleDocument>, String>(
  (ref, vehicleId) async {
    final repo = ref.watch(vehicleDocumentRepositoryProvider);
    return repo.getByVehicle(vehicleId);
  },
);

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final pendingNotificationActionProvider =
    StateProvider<String?>((ref) => null);
