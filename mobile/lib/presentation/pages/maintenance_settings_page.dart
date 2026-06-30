import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class MaintenanceSettingsPage extends ConsumerWidget {
  final String vehicleId;

  const MaintenanceSettingsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervalsAsync = ref.watch(maintenanceIntervalsProvider(vehicleId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Intervalos de mantenimiento')),
      body: intervalsAsync.when(
        data: (intervals) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Activa o desactiva los ítems según las necesidades de tu vehículo. '
              'Los intervalos personalizados se pueden eliminar.',
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
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editInterval(BuildContext context, MaintenanceInterval interval,
      WidgetRef ref) {
    final kmCtrl =
        TextEditingController(text: interval.kmInterval.toString());
    final monthsCtrl = interval.monthsInterval != null
        ? TextEditingController(text: interval.monthsInterval.toString())
        : TextEditingController();
    final descCtrl =
        TextEditingController(text: interval.description ?? '');
    var hasMonths = interval.monthsInterval != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(interval.label),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'km'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Tiempo (meses)'),
                value: hasMonths,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) =>
                    setDialogState(() => hasMonths = v),
              ),
              if (hasMonths) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: monthsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'meses'),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                minLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final km = int.tryParse(kmCtrl.text.trim());
                final months = hasMonths && monthsCtrl.text.trim().isNotEmpty
                    ? int.tryParse(monthsCtrl.text.trim())
                    : null;
                if (km != null && km > 0) {
                  final repo =
                      ref.read(maintenanceIntervalRepositoryProvider);
                  repo.save(interval.copyWith(
                    kmInterval: km,
                    monthsInterval: months,
                    description: descCtrl.text.trim().isEmpty
                        ? null
                        : descCtrl.text.trim(),
                  ));
                  ref.invalidate(
                      maintenanceIntervalsProvider(vehicleId));
                }
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _addCustomInterval(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final kmCtrl = TextEditingController();
    final monthsCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    var hasMonths = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Nuevo intervalo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'km'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Tiempo (meses)'),
                value: hasMonths,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) =>
                    setDialogState(() => hasMonths = v),
              ),
              if (hasMonths) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: monthsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'meses'),
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                minLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancelar')),
            FilledButton(
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
                  final repo =
                      ref.read(maintenanceIntervalRepositoryProvider);
                  repo.save(interval);
                  ref.invalidate(
                      maintenanceIntervalsProvider(vehicleId));
                }
                Navigator.pop(ctx);
              },
              child: const Text('Agregar'),
            ),
          ],
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

    final parts = <String>['cada ${_formatKm(interval.kmInterval)}'];
    if (interval.monthsInterval != null) {
      parts.add('${interval.monthsInterval} meses');
    }
    final subtitle = parts.join(' / ');

    return Card(
      child: ListTile(
        title: Text(
          interval.label,
          style: TextStyle(
            color: interval.isEnabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              if (interval.description != null &&
                  interval.description!.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () => _showDescription(context),
                  tooltip: 'Información',
                ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Editar',
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                tooltip: 'Eliminar',
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

  void _showDescription(BuildContext context) {
    final text = interval.description ??
        'Sin descripción disponible. Pulsa "Editar" para añadir una.';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(interval.label),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  String _formatKm(int km) {
    if (km >= 1000) return '${km ~/ 1000}k km';
    return '$km km';
  }
}
