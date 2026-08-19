import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/add_fuel_log_modal.dart';

class FuelLogListPage extends ConsumerWidget {
  final String vehicleId;

  const FuelLogListPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(fuelLogsProvider(vehicleId));
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.fuelListTitle)),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_gas_station,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l.fuelEmpty,
                      style: theme.textTheme.titleMedium),
                ],
              ),
            );
          }
          return vehicleAsync.when(
            data: (vehicle) {
              final currencySymbol = vehicle != null ? Vehicle.currencySymbol(vehicle.currency) : '\$';
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: logs.length,
                itemBuilder: (_, i) {
                  final log = logs[i];
                  final dateStr = DateFormat.yMd(l.localeName).format(log.date);
                  final volUnit = log.fueledVolume.unit == VolumeUnit.liters ? l.unitL : l.unitGal;
                  final volStr =
                      '${log.fueledVolume.amount.toStringAsFixed(1)} $volUnit';
                  final odoUnit = log.odometerAtFueling.unit == DistanceUnit.kilometers ? l.unitKm : l.unitMi;
                  final odoStr =
                      '${log.odometerAtFueling.distance.toStringAsFixed(0)} $odoUnit';

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.local_gas_station,
                            color: theme.colorScheme.onPrimaryContainer),
                      ),
                      title: Text(volStr),
                      subtitle: Text('$dateStr · $odoStr'),
                      trailing: log.pricePerUnit != null
                          ? Text(
                              '$currencySymbol${log.pricePerUnit!.toStringAsFixed(2)}/$volUnit',
                              style: theme.textTheme.bodySmall,
                            )
                          : null,
                      onTap: () => showEditFuelLogModal(
                        context,
                        vehicleId: vehicleId,
                        log: log,
                        onSaved: () {
                          ref.invalidate(fuelLogsProvider(vehicleId));
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(
                child: M3LoadingIndicator(
                    contained: true, size: 36, containerSize: 72)),
            error: (e, _) => Center(child: Text(l.homeError(e.toString()))),
          );
        },
        loading: () => const Center(
            child: M3LoadingIndicator(
                contained: true, size: 36, containerSize: 72)),
        error: (e, _) => Center(child: Text(l.homeError(e.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddFuelLogModal(
          context,
          vehicleId: vehicleId,
          onSaved: () {
            ref.invalidate(fuelLogsProvider(vehicleId));
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
