import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/widgets/add_maintenance_interval_modal.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';

class MaintenanceSettingsPage extends ConsumerWidget {
  final String vehicleId;

  const MaintenanceSettingsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervalsAsync = ref.watch(maintenanceIntervalsProvider(vehicleId));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.maintenanceSettingsTitle)),
      body: intervalsAsync.when(
        data: (intervals) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Text(
              l.maintenanceSettingsInstruction,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...intervals.map((interval) => _IntervalTile(
                  interval: interval,
                  onToggle: (enabled) {
                    final repo =
                        ref.read(maintenanceIntervalRepositoryProvider);
                    repo.save(interval.copyWith(isEnabled: enabled));
                    ref.invalidate(
                        maintenanceIntervalsProvider(vehicleId));
                  },
                  onTap: () => showEditIntervalModal(
                    context,
                    vehicleId: vehicleId,
                    interval: interval,
                    onSaved: () => ref.invalidate(
                        maintenanceIntervalsProvider(vehicleId)),
                  ),
                )),
          ],
        ),
        loading: () => const Center(
            child: M3LoadingIndicator(
                contained: true, size: 36, containerSize: 72)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddCustomIntervalModal(
          context,
          vehicleId: vehicleId,
          onSaved: () =>
              ref.invalidate(maintenanceIntervalsProvider(vehicleId)),
        ),
        tooltip: l.add,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IntervalTile extends StatelessWidget {
  final MaintenanceInterval interval;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const _IntervalTile({
    required this.interval,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    final parts = <String>[l.intervalSubtitleKm(_formatKm(interval.kmInterval, l))];
    if (interval.monthsInterval != null) {
      parts.add(l.intervalSubtitleMonths(interval.monthsInterval.toString()));
    }
    final subtitle = parts.join(' / ');

    return Card(
      child: KarterSwitchListTile(
        title: Text(
          localizedLabel(l.localeName, interval.i18nKey, interval.label),
          style: TextStyle(
            color: interval.isEnabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            if (interval.parts.isNotEmpty) ...[
              const SizedBox(height: 4),
              IntervalPartsView(parts: interval.parts),
            ],
          ],
        ),
        value: interval.isEnabled,
        onChanged: onToggle,
        onTap: onTap,
      ),
    );
  }

  String _formatKm(int km, AppLocalizations l) {
    if (km >= 1000) return l.formattedKmK((km ~/ 1000).toString());
    return l.formattedKm(km.toString());
  }
}
