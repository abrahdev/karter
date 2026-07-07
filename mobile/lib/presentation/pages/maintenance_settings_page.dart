import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';

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
          padding: const EdgeInsets.all(16),
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
                  onEdit: () => _editInterval(context, interval, ref),
                  onDelete: interval.isCustom
                      ? () {
                          final repo = ref
                              .read(maintenanceIntervalRepositoryProvider);
                          repo.delete(interval.id);
                          ref.invalidate(
                              maintenanceIntervalsProvider(vehicleId));
                        }
                      : null,
                )),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCustomInterval(context, ref),
        tooltip: l.add,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editInterval(BuildContext context, MaintenanceInterval interval,
      WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final kmCtrl =
        TextEditingController(text: interval.kmInterval.toString());
    final monthsCtrl = interval.monthsInterval != null
        ? TextEditingController(text: interval.monthsInterval.toString())
        : TextEditingController();
    final descCtrl =
        TextEditingController(text: interval.description ?? '');
    var hasMonths = interval.monthsInterval != null;

    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  localizedLabel(l, interval.i18nKey, interval.label),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: kmCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.unitKm,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(l.timeMonths),
                  value: hasMonths,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => hasMonths = v),
                ),
                if (hasMonths) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: monthsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.months,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  minLines: 2,
                  decoration: InputDecoration(
                    labelText: l.description,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final km = int.tryParse(kmCtrl.text.trim());
                          final months = hasMonths && monthsCtrl.text.trim().isNotEmpty
                              ? int.tryParse(monthsCtrl.text.trim())
                              : null;
                          if (km != null && km > 0) {
                            final repo = ref.read(maintenanceIntervalRepositoryProvider);
                            repo.save(interval.copyWith(
                              kmInterval: km,
                              monthsInterval: months,
                              description: descCtrl.text.trim().isEmpty
                                  ? null
                                  : descCtrl.text.trim(),
                            ));
                            ref.invalidate(maintenanceIntervalsProvider(vehicleId));
                          }
                          Navigator.pop(ctx);
                        },
                        child: Text(l.saveChanges),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addCustomInterval(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final nameCtrl = TextEditingController();
    final kmCtrl = TextEditingController();
    final monthsCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    var hasMonths = false;

    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l.newInterval, style: theme.textTheme.titleLarge),
                const SizedBox(height: 20),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: l.name,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: kmCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.unitKm,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(l.timeMonths),
                  value: hasMonths,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => hasMonths = v),
                ),
                if (hasMonths) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: monthsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l.months,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  minLines: 2,
                  decoration: InputDecoration(
                    labelText: l.description,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l.cancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final km = int.tryParse(kmCtrl.text.trim());
                          final months = hasMonths && monthsCtrl.text.trim().isNotEmpty
                              ? int.tryParse(monthsCtrl.text.trim())
                              : null;
                          if (name.isNotEmpty && km != null && km > 0) {
                            final interval = MaintenanceInterval(
                              id: uuid.v4(),
                              vehicleId: vehicleId,
                              label: name,
                              kmInterval: km,
                              monthsInterval: months,
                              description: descCtrl.text.trim().isEmpty
                                  ? null
                                  : descCtrl.text.trim(),
                              isCustom: true,
                            );
                            final repo = ref.read(maintenanceIntervalRepositoryProvider);
                            repo.save(interval);
                            ref.invalidate(maintenanceIntervalsProvider(vehicleId));
                          }
                          Navigator.pop(ctx);
                        },
                        child: Text(l.add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntervalTile extends StatelessWidget {
  final MaintenanceInterval interval;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _IntervalTile({
    required this.interval,
    required this.onToggle,
    required this.onEdit,
    this.onDelete,
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
      child: ListTile(
        title: Text(
          localizedLabel(l, interval.i18nKey, interval.label),
          style: TextStyle(
            color: interval.isEnabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          final desc = localizedDesc(
              l, interval.descI18nKey, interval.description ?? '');
          if (desc.isNotEmpty) {
            _showDescription(context, l);
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: l.edit,
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                tooltip: l.delete,
              ),
            Switch(
              value: interval.isEnabled,
              onChanged: onToggle,
            ),
          ],
        ),
      ),
    );
  }

  void _showDescription(BuildContext context, AppLocalizations l) {
    final label =
        localizedLabel(l, interval.i18nKey, interval.label);
    final text = localizedDesc(
            l, interval.descI18nKey, interval.description ?? '');
    final theme = Theme.of(context);
    karterShowModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(label, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(text, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatKm(int km, AppLocalizations l) {
    if (km >= 1000) return l.formattedKmK((km ~/ 1000).toString());
    return l.formattedKm(km.toString());
  }
}
