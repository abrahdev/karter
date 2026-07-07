import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (_, i) {
              final log = logs[i];
              final dateStr = DateFormat('dd/MM/yy').format(log.date);
              final volStr =
                  '${log.fueledVolume.amount.toStringAsFixed(1)} ${log.fueledVolume.unit == VolumeUnit.liters ? 'L' : 'gal'}';
              final odoStr =
                  '${log.odometerAtFueling.distance.toStringAsFixed(0)} ${log.odometerAtFueling.unit == DistanceUnit.kilometers ? 'km' : 'mi'}';

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
                          '\$${log.pricePerUnit!.toStringAsFixed(2)}/${log.fueledVolume.unit == VolumeUnit.liters ? 'L' : 'gal'}',
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
        loading: () => const Center(child: CircularProgressIndicator()),
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
