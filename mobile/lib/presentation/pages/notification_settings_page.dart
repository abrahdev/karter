import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class NotificationSettingsPage extends ConsumerWidget {
  final String vehicleId;

  const NotificationSettingsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.notificationSettingsTitle)),
            body: Center(child: Text(l.vehicleNotFound)),
          );
        }
        return _SettingsView(
          vehicle: vehicle,
          vehicleId: vehicleId,
          l: l,
          theme: theme,
          ref: ref,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text(l.homeError(e))),
      ),
    );
  }
}

class _SettingsView extends StatelessWidget {
  final Vehicle vehicle;
  final String vehicleId;
  final AppLocalizations l;
  final ThemeData theme;
  final WidgetRef ref;

  const _SettingsView({
    required this.vehicle,
    required this.vehicleId,
    required this.l,
    required this.theme,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final vehicleLabel = vehicle.alias ?? '${vehicle.brand} ${vehicle.model}';

    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicleLabel,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(l.notificationSettingsSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l.notificationOdometerSection,
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _buildFreqSelector(context),
          const SizedBox(height: 24),
          Text(l.notificationMaintenanceSection,
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          _buildMaintenanceToggle(context),
          const SizedBox(height: 16),
          if (vehicle.maintenanceReminderSnoozedUntil != null &&
              vehicle.maintenanceReminderSnoozedUntil!.isAfter(DateTime.now()))
            _buildSnoozeBanner(context),
        ],
      ),
    );
  }

  Widget _buildFreqSelector(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: vehicle.odometerReminderFreqDays,
      decoration: InputDecoration(
        labelText: l.notificationFreqLabel,
        border: const OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: null, child: Text('Off')),
        DropdownMenuItem(value: 7, child: Text('Cada 7 días (Semanal)')),
        DropdownMenuItem(value: 15, child: Text('Cada 15 días (Quincenal)')),
        DropdownMenuItem(value: 30, child: Text('Cada 30 días (Mensual)')),
      ],
      onChanged: (value) async {
        final now = DateTime.now();
        final updated = vehicle.copyWith(
          odometerReminderFreqDays: value,
          odometerReminderLastNotified:
              value != null ? now : null,
        );
        final repo = ref.read(vehicleRepositoryProvider);
        await repo.save(updated);
        ref.invalidate(vehicleProvider(vehicleId));
      },
    );
  }

  Widget _buildMaintenanceToggle(BuildContext context) {
    return SwitchListTile(
      title: Text(l.notificationMaintenanceToggle),
      subtitle: Text(l.notificationMaintenanceToggleSubtitle),
      value: vehicle.maintenanceReminderEnabled,
      onChanged: (enabled) async {
        final updated = vehicle.copyWith(
          maintenanceReminderEnabled: enabled,
          maintenanceReminderSnoozedUntil:
              enabled ? null : vehicle.maintenanceReminderSnoozedUntil,
        );
        final repo = ref.read(vehicleRepositoryProvider);
        await repo.save(updated);
        ref.invalidate(vehicleProvider(vehicleId));
      },
    );
  }

  Widget _buildSnoozeBanner(BuildContext context) {
    final remaining = vehicle.maintenanceReminderSnoozedUntil!
        .difference(DateTime.now())
        .inDays;
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.notificationSnoozedBanner(remaining),
                style: theme.textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () async {
                final updated = vehicle.copyWith(
                  maintenanceReminderSnoozedUntil: null,
                );
                final repo = ref.read(vehicleRepositoryProvider);
                await repo.save(updated);
                ref.invalidate(vehicleProvider(vehicleId));
              },
              child: Text(l.notificationSnoozeCancel),
            ),
          ],
        ),
      ),
    );
  }
}
