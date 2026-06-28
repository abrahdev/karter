import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class VehicleDetailPage extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final intervalsAsync = ref.watch(maintenanceIntervalsProvider(vehicleId));
    final theme = Theme.of(context);

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Vehículo')),
            body: const Center(child: Text('Vehículo no encontrado')),
          );
        }

        final distance = vehicle.currentOdometer.distance;
        final isKm =
            vehicle.currentOdometer.unit == DistanceUnit.kilometers;
        final distanceKm = isKm ? distance : distance * 1.60934;

        return Scaffold(
          appBar: AppBar(
            title: Text(vehicle.displayName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    context.push('/vehicle/$vehicleId/edit'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            switch (vehicle.type) {
                              VehicleType.combustion =>
                                Icons.local_gas_station,
                              VehicleType.electric => Icons.electric_car,
                              VehicleType.motorcycle => Icons.motorcycle,
                            },
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vehicle.displayName,
                                    style: theme.textTheme.headlineSmall),
                                if (vehicle.alias != null &&
                                    vehicle.alias!.isNotEmpty)
                                  Text(
                                    '${vehicle.brand} ${vehicle.model} ${vehicle.year}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _infoRow(Icons.badge, 'Placa', vehicle.plate.value),
                      _infoRow(Icons.qr_code, 'VIN', vehicle.vin.code),
                      _infoRow(Icons.directions_car,
                          'Marca / Modelo',
                          '${vehicle.brand} ${vehicle.model}'),
                      _infoRow(Icons.calendar_today,
                          'Año', vehicle.year.toString()),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.speed),
                  title: Text(
                    '${distance.toStringAsFixed(0)} ${isKm ? 'km' : 'mi'}',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: const Text('Odómetro'),
                  trailing: FilledButton.tonal(
                    onPressed: () =>
                        _updateOdometer(context, vehicle.id, ref),
                    child: const Text('Actualizar'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Acciones', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_gas_station),
                      title: const Text('Cargas de combustible'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push('/vehicle/$vehicleId/fuel'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: const Text('Historial de mantenimiento'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push('/vehicle/$vehicleId/maintenance'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.tune),
                      title: const Text('Configurar intervalos'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push('/vehicle/$vehicleId/maintenance/settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('Mantenimiento',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              intervalsAsync.when(
                data: (intervals) {
                  final enabled = intervals.where((i) => i.isEnabled);
                  if (enabled.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Todos los intervalos están desactivados.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: enabled.map((interval) {
                      final effectiveKm = interval.lastResetKm > 0
                          ? distanceKm - interval.lastResetKm
                          : distanceKm;
                      final elapsed = effectiveKm % interval.kmInterval;
                      final remaining = interval.kmInterval - elapsed;
                      final isDue = elapsed / interval.kmInterval > 0.9;

                      return Card(
                        color: isDue
                            ? theme.colorScheme.errorContainer
                            : null,
                        child: ListTile(
                          leading: Icon(
                            Icons.build_circle_outlined,
                            color: isDue
                                ? theme.colorScheme.onErrorContainer
                                : null,
                          ),
                          title: Text(
                            interval.label,
                            style: TextStyle(
                              fontWeight: isDue
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            isDue
                                ? 'Vencido — realizá el servicio'
                                : 'Próximo en ${remaining.toStringAsFixed(0)} km',
                          ),
                          trailing: TextButton(
                            onPressed: () => context.push(
                              '/vehicle/$vehicleId/maintenance/new',
                              extra: {
                                'description': interval.label,
                                'intervalId': interval.id,
                              },
                            ),
                            child: const Text('Registrar'),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context
                    .push('/vehicle/$vehicleId/maintenance/new'),
                icon: const Icon(Icons.add),
                label: const Text('Registrar servicio'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _updateOdometer(
      BuildContext context, String vehicleId, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Actualizar odómetro'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Nuevo valor',
            hintText: '0',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final value = double.tryParse(controller.text.trim());
              if (value == null || value < 0) return;
              final repo = ref.read(vehicleRepositoryProvider);
              final vehicle = await repo.getById(vehicleId);
              if (vehicle != null) {
                final updated = vehicle.copyWith(
                  currentOdometer: vehicle.currentOdometer.add(
                    value - vehicle.currentOdometer.distance,
                  ),
                );
                await repo.save(updated);
                ref.invalidate(vehicleProvider(vehicleId));
                ref.invalidate(vehicleListProvider);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
