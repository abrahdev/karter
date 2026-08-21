import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/notification_permission_modal.dart';
import 'package:mobile/presentation/widgets/notification_settings_modal.dart';

class NotificationListPage extends ConsumerStatefulWidget {
  const NotificationListPage({super.key});

  @override
  ConsumerState<NotificationListPage> createState() =>
      _NotificationListPageState();
}

class _NotificationListPageState extends ConsumerState<NotificationListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(notificationServiceProvider);
      notifier.areNotificationsEnabled().then((enabled) {
        if (!enabled && mounted) {
          showNotificationPermissionModal(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehicleListProvider);
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettingsTitle)),
      body: Column(
        children: [
          Expanded(
            child: vehiclesAsync.when(
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return Center(child: Text(l.notificationNoVehicles));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vehicles.length,
                  itemBuilder: (_, i) {
                    final v = vehicles[i];
                    final freq = v.odometerReminderFreqDays;
                    final maintOn = v.maintenanceReminderEnabled;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Icon(
                            switch (v.type) {
                              VehicleType.combustion => Icons.local_gas_station,
                              VehicleType.electric => Icons.electric_car,
                              VehicleType.motorcycle => Icons.motorcycle,
                            },
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(v.displayName),
                        subtitle: Text(
                          l.notificationVehicleSubtitle(
                            freq != null
                                ? l.notificationFreqValue(freq)
                                : l.notificationFreqOff,
                            maintOn
                                ? l.notificationMaintOn
                                : l.notificationMaintOff,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showNotificationSettingsModal(
                            context,
                            vehicleId: v.id,
                          );
                        },
                      ),
                    );
                  },
          );
        },
              loading: () => const Center(
                  child: M3LoadingIndicator(
                      contained: true, size: 36, containerSize: 72)),
              error: (e, _) => Center(child: Text(l.homeError(e))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilledButton.tonalIcon(
              onPressed: () async {
                final service = ref.read(notificationServiceProvider);
                await service.showNotification(
                  id: 99999,
                  title: l.testNotification,
                  body: l.testNotificationDesc,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.testNotificationSent)),
                  );
                }
              },
              icon: const Icon(Icons.notifications_active_outlined),
              label: Text(l.testNotification),
            ),
          ),
        ],
      ),
    );
  }
}
