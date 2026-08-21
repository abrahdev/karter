import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/data/repositories/vehicle_repository_impl.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/repositories/vehicle_repository.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/l10n/app_localizations_en.dart';
import 'package:mobile/l10n/app_localizations_es.dart';
import 'package:mobile/l10n/app_localizations_et.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const _odometerChannel = 1000;
const _maintenanceChannel = 2000;

Future<void> initBackgroundTasks() async {
  await Workmanager().initialize(
    callbackDispatcher,
  );
  await Workmanager().registerPeriodicTask(
    'karter-reminder-check',
    'odometerMaintenanceCheck',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.notRequired,
      requiresBatteryNotLow: false,
    ),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final service = NotificationService();
    await service.init();

    final db = AppDatabase();
    try {
      final VehicleRepository repo = VehicleRepositoryImpl(db);
      final vehicles = await repo.getVehicles();

      final l = await _loadLocalizations();

      for (final v in vehicles) {
        try {
          await _checkOdometerReminder(service, v, l);
          await _checkMaintenanceReminder(service, v, l);
        } catch (_) {}
      }
    } finally {
      await db.close();
    }
    return true;
  });
}

Future<AppLocalizations> _loadLocalizations() async {
  final prefs = await SharedPreferences.getInstance();
  final locale = prefs.getString('locale') ?? 'en';
  switch (locale) {
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
    default:
      return AppLocalizationsEn();
  }
}

int _notificationId(int channel, String vehicleId) {
  return channel + (vehicleId.hashCode & 0x7FFFFFFF) % 1000;
}

Future<void> _checkOdometerReminder(
    NotificationService service, Vehicle v, AppLocalizations l) async {
  final freq = v.odometerReminderFreqDays;
  if (freq == null || freq <= 0) return;

  final lastNotified = v.odometerReminderLastNotified;
  if (lastNotified != null &&
      DateTime.now().difference(lastNotified).inDays < freq) {
    return;
  }

  await service.showNotification(
    id: _notificationId(_odometerChannel, v.id),
    title: l.notificationOdometerTitle,
    body: l.notificationOdometerBody(v.alias ?? v.brand, freq),
    payload: 'odometer:${v.id}',
  );
}

Future<void> _checkMaintenanceReminder(
    NotificationService service, Vehicle v, AppLocalizations l) async {
  if (!v.maintenanceReminderEnabled) return;

  final snoozedUntil = v.maintenanceReminderSnoozedUntil;
  if (snoozedUntil != null && DateTime.now().isBefore(snoozedUntil)) return;

  await service.showNotification(
    id: _notificationId(_maintenanceChannel, v.id),
    title: l.notificationMaintenanceTitle,
    body: l.notificationMaintenanceBody(v.alias ?? v.brand),
    payload: 'maintenance:${v.id}',
  );
}
