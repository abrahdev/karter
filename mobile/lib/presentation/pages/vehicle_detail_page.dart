import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class _MaintenanceInterval {
  final String label;
  final IconData icon;
  final int kmInterval;

  const _MaintenanceInterval({
    required this.label,
    required this.icon,
    required this.kmInterval,
  });
}

const _intervals = [
  _MaintenanceInterval(
      label: 'Cambio de aceite',
      icon: Icons.oil_barrel,
      kmInterval: 10000),
  _MaintenanceInterval(
      label: 'Filtro de aceite',
      icon: Icons.filter_alt,
      kmInterval: 10000),
  _MaintenanceInterval(
      label: 'Filtro de aire',
      icon: Icons.air,
      kmInterval: 20000),
  _MaintenanceInterval(
      label: 'Pastillas de freno',
      icon: Icons.disc_full,
      kmInterval: 30000),
  _MaintenanceInterval(
      label: 'Neumáticos', icon: Icons.circle, kmInterval: 50000),
];

class VehicleDetailPage extends ConsumerWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
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
            title: Text(vehicle.name),
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
                      Text(vehicle.name,
                          style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      _infoRow(Icons.badge, 'Placa', vehicle.plate.value),
                      _infoRow(Icons.qr_code, 'VIN', vehicle.vin.code),
                      _infoRow(Icons.directions_car,
                          'Marca / Modelo',
                          '${vehicle.brand} ${vehicle.model}'),
                      _infoRow(Icons.calendar_today,
                          'Año', vehicle.year.toString()),
                      _infoRow(
                        Icons.speed,
                        'Odómetro',
                        '${distance.toStringAsFixed(0)} ${isKm ? 'km' : 'mi'}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Mantenimiento',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._intervals.map((interval) {
                final elapsed = distanceKm % interval.kmInterval;
                final remaining = interval.kmInterval - elapsed;
                final isDue = elapsed / interval.kmInterval > 0.9;

                return Card(
                  color: isDue
                      ? theme.colorScheme.errorContainer
                      : null,
                  child: ListTile(
                    leading: Icon(interval.icon),
                    title: Text(interval.label),
                    subtitle: Text(
                      isDue
                          ? 'Vencido — hacélo pronto'
                          : 'Próximo en ${remaining.toStringAsFixed(0)} km',
                    ),
                    trailing: Text(
                      'cada ${_formatKm(interval.kmInterval)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                );
              }),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatKm(int km) {
    if (km >= 1000) return '${km ~/ 1000}k km';
    return '$km km';
  }
}
