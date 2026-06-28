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
                  onEditKm: () => _editKm(context, interval, ref),
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

  void _editKm(BuildContext context, MaintenanceInterval interval,
      WidgetRef ref) {
    final controller =
        TextEditingController(text: interval.kmInterval.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${interval.label} — km'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'km'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              final km = int.tryParse(controller.text.trim());
              if (km != null && km > 0) {
                final repo = ref.read(maintenanceIntervalRepositoryProvider);
                repo.save(interval.copyWith(kmInterval: km));
                ref.invalidate(maintenanceIntervalsProvider(vehicleId));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _addCustomInterval(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final kmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
              if (name.isNotEmpty && km != null && km > 0) {
                final interval = MaintenanceInterval(
                  id: uuid.v4(),
                  vehicleId: vehicleId,
                  label: name,
                  kmInterval: km,
                  isCustom: true,
                );
                final repo =
                    ref.read(maintenanceIntervalRepositoryProvider);
                repo.save(interval);
                ref.invalidate(maintenanceIntervalsProvider(vehicleId));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class _IntervalTile extends StatelessWidget {
  final MaintenanceInterval interval;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEditKm;
  final VoidCallback? onDelete;

  const _IntervalTile({
    required this.interval,
    required this.onToggle,
    required this.onEditKm,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        title: Text(
          interval.label,
          style: TextStyle(
            color: interval.isEnabled ? null : theme.colorScheme.outline,
          ),
        ),
        subtitle: Text('cada ${_formatKm(interval.kmInterval)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEditKm,
              tooltip: 'Editar km',
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

  String _formatKm(int km) {
    if (km >= 1000) return '${km ~/ 1000}k km';
    return '$km km';
  }
}
