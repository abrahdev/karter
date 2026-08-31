import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/fuel_log_repository_impl.dart';
import 'package:mobile/data/repositories/maintenance_interval_repository_impl.dart';
import 'package:mobile/data/repositories/maintenance_log_part_repository_impl.dart';
import 'package:mobile/data/repositories/maintenance_log_repository_impl.dart';
import 'package:mobile/data/repositories/vehicle_document_repository_impl.dart';
import 'package:mobile/data/repositories/vehicle_part_repository_impl.dart';
import 'package:mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:mobile/data/services/export_service.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/data/services/pdf_export_service.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/services/catalog_repository.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/entities/vehicle_part.dart';
import 'package:mobile/domain/repositories/fuel_log_repository.dart';
import 'package:mobile/domain/repositories/maintenance_interval_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_part_repository.dart';
import 'package:mobile/domain/repositories/maintenance_log_repository.dart';
import 'package:mobile/domain/repositories/vehicle_document_repository.dart';
import 'package:mobile/domain/repositories/vehicle_part_repository.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
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

final vehiclePartRepositoryProvider = Provider<VehiclePartRepository>((ref) {
  return VehiclePartRepositoryImpl(ref.watch(appDatabaseProvider));
});

final maintenanceLogPartRepositoryProvider =
    Provider<MaintenanceLogPartRepository>((ref) {
  return MaintenanceLogPartRepositoryImpl(ref.watch(appDatabaseProvider));
});

final vehiclePartsProvider = FutureProvider<List<VehiclePart>>((ref) async {
  final repo = ref.watch(vehiclePartRepositoryProvider);
  return repo.getAll();
});

final maintenanceLogPartsProvider =
    FutureProvider.family<List<MaintenanceLogPart>, String>(
  (ref, logId) async {
    final repo = ref.watch(maintenanceLogPartRepositoryProvider);
    return repo.getByLog(logId);
  },
);

final maintenanceLogPartsByPartProvider =
    FutureProvider.family<List<MaintenanceLogPart>, String>(
  (ref, partId) async {
    final repo = ref.watch(maintenanceLogPartRepositoryProvider);
    return repo.getByPartId(partId);
  },
);

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
    ref.watch(appDatabaseProvider),
    ref.watch(vehicleRepositoryProvider),
    ref.watch(fuelLogRepositoryProvider),
    ref.watch(maintenanceLogRepositoryProvider),
    ref.watch(maintenanceIntervalRepositoryProvider),
    ref.watch(vehicleDocumentRepositoryProvider),
    ref.watch(maintenanceLogPartRepositoryProvider),
    ref.watch(vehiclePartRepositoryProvider),
  );
});

final catalogServiceProvider = Provider<CatalogService>((ref) {
  final service = CatalogService();
  ref.onDispose(service.dispose);
  return service;
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(ref.watch(catalogServiceProvider));
});

final templateIndexProvider = FutureProvider<TemplateIndex>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.loadIndex();
});

final templateResolverProvider = Provider<TemplateResolver>((ref) {
  return TemplateResolver();
});

/// Resolved raw base URL of the configured online template repo (same value
/// as the "Repo URL" in More). Null when the template source is disabled.
final onlineTemplateBaseUrlProvider = FutureProvider<String?>((ref) async {
  final config = ref.watch(templateSourceProvider);
  if (!config.enabled) return null;
  final url = config.version.isEmpty || !config.repoUrl.contains('<tag>')
      ? config.repoUrl
      : config.repoUrl.replaceAll('<tag>', config.version);
  return CatalogService.resolveBaseUrl(
    url,
    timeout: const Duration(seconds: 10),
  );
});

/// Template index (with extends) fetched as JSON from the online template
/// repo, used by the template creator.
final onlineTemplateIndexProvider = FutureProvider<TemplateIndex>((ref) async {
  final baseUrl = await ref.watch(onlineTemplateBaseUrlProvider.future);
  final resolver = ref.watch(templateResolverProvider);
  return resolver.loadIndex(baseUrl: baseUrl);
});

final templateResolutionProvider =
    FutureProvider.family<TemplateResolution?, String>((ref, vehicleId) async {
  final vehicle = await ref.watch(vehicleProvider(vehicleId).future);
  if (vehicle == null) return null;
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.findBestMatch(
    make: vehicle.brand,
    model: vehicle.model,
    year: vehicle.year,
  );
});

final templateByIdProvider =
    FutureProvider.family<TemplateResolution?, String>((ref, vehicleId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.resolveTemplate(vehicleId);
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

class _PendingNotificationActionNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? value) => state = value;
}

final pendingNotificationActionProvider =
    NotifierProvider<_PendingNotificationActionNotifier, String?>(
  _PendingNotificationActionNotifier.new,
);
