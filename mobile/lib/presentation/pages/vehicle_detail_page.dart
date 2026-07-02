import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/odometer_dialog.dart';

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
                      if (vehicle.plate != null)
                        _infoRow(Icons.badge, 'Placa', vehicle.plate!.value),
                      if (vehicle.vin != null)
                        _infoRow(Icons.qr_code, 'VIN', vehicle.vin!.code),
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
              Text('Proximo Mantenimiento',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              intervalsAsync.when(
                data: (intervals) {
                  final enabled = intervals
                      .where((i) => i.isEnabled)
                      .toList();

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

                  final intervalData = enabled
                      .map((i) => _IntervalData.compute(i, distanceKm))
                      .toList()
                    ..sort((a, b) {
                      if (a.isDue != b.isDue) return a.isDue ? -1 : 1;
                      if (a.isApproaching != b.isApproaching) {
                        return a.isApproaching ? -1 : 1;
                      }
                      return b.sortKey.compareTo(a.sortKey);
                    });

                  return Column(
                    children: intervalData.map((data) {
                      final interval = data.interval;
                      Color? cardColor;
                      Color? accentColor;
                      if (data.isDue) {
                        cardColor = theme.colorScheme.errorContainer;
                        accentColor =
                            theme.colorScheme.onErrorContainer;
                      } else if (data.isApproaching) {
                        cardColor = Colors.amber.withValues(alpha: 0.25);
                        accentColor = Colors.amber.shade800;
                      }

                      return Card(
                        color: cardColor,
                        child: ListTile(
                          leading: Icon(
                            Icons.build_circle_outlined,
                            color: accentColor,
                          ),
                          title: Text(
                            interval.label,
                            style: TextStyle(
                              fontWeight: data.isDue
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                          subtitle: Text(data.subtitle),
                          onTap: interval.description != null &&
                                  interval.description!.isNotEmpty
                              ? () => _showDescription(
                                  context, interval)
                              : null,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () => context.push(
                                  '/vehicle/$vehicleId/maintenance/new',
                                  extra: {
                                    'description': interval.label,
                                    'intervalId': interval.id,
                                  },
                                ),
                                child: Text(
                                  'Registrar',
                                  style: accentColor != null
                                      ? TextStyle(color: accentColor)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                    child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
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

  void _showDescription(
      BuildContext context, dynamic interval) {
    final text = interval.description ??
        'Sin descripción disponible. Ve a Ajustes de mantenimiento para añadir una.';
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

  void _updateOdometer(
      BuildContext context, String vehicleId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => OdometerDialog(
        current: ref.read(vehicleProvider(vehicleId)).valueOrNull
                ?.currentOdometer ??
            Odometer(0, DistanceUnit.kilometers),
        onSave: (double newDistance) async {
          final repo = ref.read(vehicleRepositoryProvider);
          final vehicle = await repo.getById(vehicleId);
          if (vehicle != null) {
            final updated = vehicle.copyWith(
              currentOdometer: vehicle.currentOdometer.add(
                newDistance - vehicle.currentOdometer.distance,
              ),
            );
            await repo.save(updated);
            ref.invalidate(vehicleProvider(vehicleId));
            ref.invalidate(vehicleListProvider);
          }
        },
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

class _IntervalData {
  final MaintenanceInterval interval;
  final double kmRemaining;
  final double? monthsRemaining;
  final bool isDue;
  final bool isApproaching;
  final String subtitle;
  final double sortKey;

  _IntervalData._({
    required this.interval,
    required this.kmRemaining,
    required this.monthsRemaining,
    required this.isDue,
    required this.isApproaching,
    required this.subtitle,
    required this.sortKey,
  });

  static _IntervalData compute(MaintenanceInterval interval, double distanceKm) {
    final kmSinceReset = interval.lastResetKm > 0 && distanceKm >= interval.lastResetKm
        ? distanceKm - interval.lastResetKm
        : distanceKm;
    final kmRemaining = interval.kmInterval - kmSinceReset;
    final isKmDue = kmSinceReset >= interval.kmInterval;

    double? monthsRemaining;
    bool isMonthsDue = false;
    if (interval.monthsInterval != null) {
      if (interval.lastResetDate != null) {
        final monthsSinceReset =
            DateTime.now().difference(interval.lastResetDate!).inDays / 30.44;
        monthsRemaining = interval.monthsInterval! - monthsSinceReset;
        isMonthsDue = monthsSinceReset >= interval.monthsInterval!;
      } else {
        monthsRemaining = interval.monthsInterval!.toDouble();
      }
    }

    final isDue = isKmDue || isMonthsDue;
    final isApproaching = !isDue &&
        ((kmRemaining > 0 && kmRemaining <= 100) ||
            (monthsRemaining != null && monthsRemaining > 0 && monthsRemaining <= 1));

    String subtitle;
    if (isDue) {
      subtitle = 'Vencido — realizá el servicio';
    } else {
      final parts = <String>[];
      if (interval.kmInterval < 999999) {
        final kmShow = kmRemaining > 0 ? kmRemaining.toStringAsFixed(0) : '0';
        parts.add('$kmShow km');
      }
      if (monthsRemaining != null) {
        parts.add('${monthsRemaining.round()} meses');
      }
      subtitle = 'Próximo en ${parts.join(' / ')}';
    }

    final kmProgress = interval.kmInterval < 999999 && kmSinceReset > 0
        ? kmSinceReset / interval.kmInterval
        : 0.0;
    final timeProgress = interval.monthsInterval != null && interval.lastResetDate != null
        ? DateTime.now().difference(interval.lastResetDate!).inDays /
            30.44 /
            interval.monthsInterval!
        : 0.0;
    final sortKey = kmProgress > timeProgress ? kmProgress : timeProgress;

    return _IntervalData._(
      interval: interval,
      kmRemaining: kmRemaining,
      monthsRemaining: monthsRemaining,
      isDue: isDue,
      isApproaching: isApproaching,
      subtitle: subtitle,
      sortKey: sortKey,
    );
  }
}
