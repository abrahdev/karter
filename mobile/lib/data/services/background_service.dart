import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';
import 'package:workmanager/workmanager.dart';

const _odometerChannel = 1000;
const _maintenanceChannel = 2000;

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final service = NotificationService();
    await service.init();

    final db = AppDatabase();
    final VehicleRepository repo = VehicleRepositoryImpl(db);
    final vehicles = await repo.getVehicles();

    for (final v in vehicles) {
      await _checkOdometerReminder(service, v);
      await _checkMaintenanceReminder(service, v);
    }

    await db.close();
    return true;
  });
}

Future<void> _checkOdometerReminder(
    NotificationService service, Vehicle v) async {
  final freq = v.odometerReminderFreqDays;
  if (freq == null || freq <= 0) return;

  final lastNotified = v.odometerReminderLastNotified;
  if (lastNotified != null &&
      DateTime.now().difference(lastNotified).inDays < freq) {
    return;
  }

  await service.showNotification(
    id: _odometerChannel + v.id.hashCode,
    title: 'Actualiza el odómetro',
    body:
        '${v.alias ?? v.brand} — han pasado $freq días desde el último recordatorio.',
    payload: 'odometer:${v.id}',
  );
}

Future<void> _checkMaintenanceReminder(
    NotificationService service, Vehicle v) async {
  if (!v.maintenanceReminderEnabled) return;

  final snoozedUntil = v.maintenanceReminderSnoozedUntil;
  if (snoozedUntil != null && DateTime.now().isBefore(snoozedUntil)) return;

  await service.showNotification(
    id: _maintenanceChannel + v.id.hashCode,
    title: 'Mantenimiento pendiente',
    body:
        '${v.alias ?? v.brand} — revisa el estado de los intervalos de mantenimiento.',
    payload: 'maintenance:${v.id}',
  );
}
