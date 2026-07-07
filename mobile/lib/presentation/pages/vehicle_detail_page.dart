import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/widgets/add_document_modal.dart';
import 'package:mobile/presentation/widgets/add_fuel_log_modal.dart';
import 'package:mobile/presentation/widgets/add_maintenance_log_modal.dart';
import 'package:mobile/presentation/widgets/odometer_dialog.dart';

class VehicleDetailPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  ConsumerState<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends ConsumerState<VehicleDetailPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _fabCtrl;

  bool get _fabOpen => (_fabCtrl?.value ?? 0) > 0.5;

  @override
  void initState() {
    super.initState();
    _fabCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final action = ref.read(pendingNotificationActionProvider);
      if (action != null) {
        ref.read(pendingNotificationActionProvider.notifier).state = null;
        final parts = action.split(':');
        if (parts.length == 2 && parts[1] == widget.vehicleId) {
      if (parts[0] == 'odometer') {
        _openOdometerFromNotification();
      } else if (parts[0] == 'maintenance') {
        _openMaintenanceFromNotification();
      }
        }
      }
    });
  }

  Future<void> _openOdometerFromNotification() async {
    final vehicle = await ref.read(vehicleProvider(widget.vehicleId).future);
    if (!mounted || vehicle == null) return;
    showDialog(
      context: context,
      builder: (ctx) => OdometerDialog(
        current: vehicle.currentOdometer,
        onSave: (double newDistance) async {
          final repo = ref.read(vehicleRepositoryProvider);
          final updated = vehicle.copyWith(
            currentOdometer: vehicle.currentOdometer.add(
              newDistance - vehicle.currentOdometer.distance,
            ),
          );
          await repo.save(updated);
          if (ctx.mounted) Navigator.of(ctx).pop();
          ref.invalidate(vehicleProvider(widget.vehicleId));
        },
      ),
    );
  }

  void _openMaintenanceFromNotification() {
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l?.notificationMaintenanceToggle ?? ''),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(vehicleProvider(widget.vehicleId));
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(widget.vehicleId));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.vehicleDetailTitle)),
            body: Center(child: Text(l.vehicleNotFound)),
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
                    context.push('/vehicle/${widget.vehicleId}/edit'),
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
                      Hero(
                        tag: 'vehicle-avatar-${vehicle.id}',
                        child: Row(
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
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(vehicle.displayName,
                                      style: theme
                                          .textTheme.headlineSmall),
                                  if (vehicle.alias != null &&
                                      vehicle.alias!.isNotEmpty)
                                    Text(
                                      '${vehicle.brand} ${vehicle.model} ${vehicle.year}',
                                      style:
                                          theme.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (vehicle.plate != null)
                        _infoRow(
                            Icons.badge, l.plate, vehicle.plate!.value),
                      if (vehicle.vin != null)
                        _infoRow(
                            Icons.qr_code, l.vin, vehicle.vin!.code),
                      _infoRow(Icons.directions_car,
                          l.brandModel,
                          '${vehicle.brand} ${vehicle.model}'),
                      _infoRow(Icons.calendar_today,
                          l.year, vehicle.year.toString()),
                    ],
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.speed),
                  title: Text(
                    '${distance.toStringAsFixed(0)} ${isKm ? l.unitKm : l.unitMi}',
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(l.odometer),
                  trailing: FilledButton.tonal(
                    onPressed: () =>
                        _updateOdometer(context, vehicle.id, ref),
                    child: Text(l.update),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.actions, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.local_gas_station),
                      title: Text(l.fuelLogs),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          context.push('/vehicle/${widget.vehicleId}/fuel'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.build),
                      title: Text(l.maintenanceHistory),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push('/vehicle/${widget.vehicleId}/maintenance'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: Text(l.vehicleDocuments),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push('/vehicle/${widget.vehicleId}/documents'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.tune),
                      title: Text(l.configureIntervals),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context
                          .push('/vehicle/${widget.vehicleId}/maintenance/settings'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(l.nextMaintenance,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              intervalsAsync.when(
                data: (intervals) {
                  final enabled =
                      intervals.where((i) => i.isEnabled).toList();

                  if (enabled.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          l.allIntervalsDisabled,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }

                  final intervalData = enabled
                      .map((i) => _IntervalData.compute(
                          i, distanceKm, l))
                      .toList()
                    ..sort((a, b) {
                      if (a.isDue != b.isDue) {
                        return a.isDue ? -1 : 1;
                      }
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
                        cardColor =
                            theme.colorScheme.errorContainer;
                        accentColor =
                            theme.colorScheme.onErrorContainer;
                      } else if (data.isApproaching) {
                        cardColor =
                            Colors.amber.withValues(alpha: 0.25);
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
                            localizedLabel(l, interval.i18nKey,
                                interval.label),
                            style: TextStyle(
                              fontWeight: data.isDue
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                          subtitle: Text(data.subtitle),
                          onTap: () => _showDescription(
                              context, l, interval),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    showAddMaintenanceLogModal(
                                  context,
                                  vehicleId: widget.vehicleId,
                                  initialDescription:
                                      localizedLabel(
                                    l,
                                    interval.i18nKey,
                                    interval.label,
                                  ),
                                  initialIntervalId: interval.id,
                                  onSaved: () {
                                    ref.invalidate(
                                        maintenanceLogsProvider(
                                            widget.vehicleId));
                                    ref.invalidate(
                                        maintenanceIntervalsProvider(
                                            widget.vehicleId));
                                  },
                                ),
                                child: Text(
                                  l.register,
                                  style: accentColor != null
                                      ? TextStyle(
                                          color: accentColor)
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
            ],
          ),
          floatingActionButton: Builder(
            builder: (context) {
              if (_fabCtrl == null) {
                return FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.add),
                );
              }
              return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _animatedFabOption(
                0,
                FloatingActionButton.small(
                  heroTag: 'add_doc',
                  backgroundColor:
                      theme.colorScheme.secondaryContainer,
                  onPressed: () {
                    _fabCtrl?.reverse();
                    showAddDocumentModal(
                      context,
                      vehicleId: widget.vehicleId,
                      onSaved: () {
                        ref.invalidate(
                            vehicleDocumentsProvider(
                                widget.vehicleId));
                      },
                    );
                  },
                  child: const Icon(Icons.description),
                ),
              ),
              _animatedFabOption(
                1,
                FloatingActionButton.small(
                  heroTag: 'add_fuel',
                  backgroundColor:
                      theme.colorScheme.secondaryContainer,
                  onPressed: () {
                    _fabCtrl?.reverse();
                    showAddFuelLogModal(
                      context,
                      vehicleId: widget.vehicleId,
                      onSaved: () {
                        ref.invalidate(
                            fuelLogsProvider(widget.vehicleId));
                      },
                    );
                  },
                  child: const Icon(Icons.local_gas_station),
                ),
              ),
              _animatedFabOption(
                2,
                FloatingActionButton.small(
                  heroTag: 'add_service',
                  backgroundColor:
                      theme.colorScheme.secondaryContainer,
                  onPressed: () {
                    _fabCtrl?.reverse();
                    showAddMaintenanceLogModal(
                      context,
                      vehicleId: widget.vehicleId,
                      onSaved: () {
                        ref.invalidate(
                            maintenanceLogsProvider(
                                widget.vehicleId));
                        ref.invalidate(
                            maintenanceIntervalsProvider(
                                widget.vehicleId));
                      },
                    );
                  },
                  child: const Icon(Icons.build),
                ),
              ),
              FloatingActionButton(
                heroTag: 'main_fab',
                onPressed: () {
                  final ctrl = _fabCtrl;
                  if (ctrl == null) return;
                  if (ctrl.isDismissed) {
                    ctrl.forward();
                  } else {
                    ctrl.reverse();
                  }
                },
                child: AnimatedRotation(
                  turns: _fabOpen ? 0.375 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
            },
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
      BuildContext context, AppLocalizations l, dynamic interval) {
    final label = localizedLabel(
        l, interval.i18nKey, interval.label ?? '');
    final desc = localizedDesc(
        l, interval.descI18nKey, interval.description ?? '');
    final text = desc.isEmpty ? l.noDescriptionAvailable : desc;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(label),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.close),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fabCtrl?.dispose();
    super.dispose();
  }

  Widget _animatedFabOption(int index, Widget fab) {
    final ctrl = _fabCtrl;
    if (ctrl == null) return fab;
    final start = index * 0.15;
    final curve = CurvedAnimation(
      parent: ctrl,
      curve: Interval(start, start + 0.4, curve: Curves.easeOut),
    );
    return SizeTransition(
      sizeFactor: curve,
      child: FadeTransition(
        opacity: curve,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: fab,
        ),
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
              style:
                  const TextStyle(fontWeight: FontWeight.w500)),
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

  static _IntervalData compute(
      MaintenanceInterval interval, double distanceKm, AppLocalizations l) {
    final kmSinceReset = interval.lastResetKm > 0 &&
            distanceKm >= interval.lastResetKm
        ? distanceKm - interval.lastResetKm
        : distanceKm;
    final kmRemaining = interval.kmInterval - kmSinceReset;
    final isKmDue = kmSinceReset >= interval.kmInterval;

    double? monthsRemaining;
    bool isMonthsDue = false;
    if (interval.monthsInterval != null) {
      if (interval.lastResetDate != null) {
        final monthsSinceReset = DateTime.now()
                .difference(interval.lastResetDate!)
                .inDays /
            30.44;
        monthsRemaining =
            interval.monthsInterval! - monthsSinceReset;
        isMonthsDue =
            monthsSinceReset >= interval.monthsInterval!;
      } else {
        monthsRemaining = interval.monthsInterval!.toDouble();
      }
    }

    final isDue = isKmDue || isMonthsDue;
    final isApproaching = !isDue &&
        ((kmRemaining > 0 && kmRemaining <= 100) ||
            (monthsRemaining != null &&
                monthsRemaining > 0 &&
                monthsRemaining <= 1));

    String subtitle;
    if (isDue) {
      subtitle = l.overduePerformService;
    } else {
      final parts = <String>[];
      if (interval.kmInterval < 999999) {
        final kmShow =
            kmRemaining > 0 ? kmRemaining.toStringAsFixed(0) : '0';
        parts.add('$kmShow ${l.unitKm}');
      }
      if (monthsRemaining != null) {
        parts.add('${monthsRemaining.round()} ${l.months}');
      }
      subtitle = l.nextIn(parts.join(' / '));
    }

    final kmProgress = interval.kmInterval < 999999 && kmSinceReset > 0
        ? kmSinceReset / interval.kmInterval
        : 0.0;
    final timeProgress = interval.monthsInterval != null &&
            interval.lastResetDate != null
        ? DateTime.now().difference(interval.lastResetDate!).inDays /
            30.44 /
            interval.monthsInterval!
        : 0.0;
    final sortKey =
        kmProgress > timeProgress ? kmProgress : timeProgress;

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
