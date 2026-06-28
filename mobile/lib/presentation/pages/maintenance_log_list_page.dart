import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class MaintenanceLogListPage extends ConsumerWidget {
  final String vehicleId;

  const MaintenanceLogListPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(maintenanceLogsProvider(vehicleId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimiento')),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.build,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('Sin servicios registrados',
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
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Icon(Icons.build,
                        color: theme.colorScheme.onSecondaryContainer),
                  ),
                  title: Text(log.description),
                  subtitle: Text(dateStr),
                  trailing: log.odometerAtService > 0
                      ? Text(
                          '${log.odometerAtService.toStringAsFixed(0)} km',
                          style: theme.textTheme.bodySmall)
                      : null,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/vehicle/$vehicleId/maintenance/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
