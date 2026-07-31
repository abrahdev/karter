import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/shake_to_odometer_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/widgets/add_document_modal.dart';
import 'package:mobile/presentation/widgets/add_fuel_log_modal.dart';
import 'package:mobile/presentation/widgets/add_maintenance_log_modal.dart';
import 'package:mobile/presentation/widgets/odometer_dialog.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:sensors_plus/sensors_plus.dart';

const _wideBreakpoint = 600.0;

class VehicleDetailPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  ConsumerState<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends ConsumerState<VehicleDetailPage> {
  bool _fabOpen = false;
  StreamSubscription<AccelerometerEvent>? _accelSub;
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);
  bool _shakeDebouncing = false;

  @override
  void initState() {
    super.initState();
    _startShakeListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final action = ref.read(pendingNotificationActionProvider);
      if (action != null) {
        ref.read(pendingNotificationActionProvider.notifier).set(null);
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

  @override
  void dispose() {
    _accelSub?.cancel();
    super.dispose();
  }

  void _startShakeListener() {
    const threshold = 30.0;
    _accelSub = accelerometerEventStream(samplingPeriod: const Duration(milliseconds: 200)).listen((event) {
      final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > threshold && !_shakeDebouncing) {
        final now = DateTime.now();
        if (now.difference(_lastShake).inSeconds >= 2) {
          _lastShake = now;
          _shakeDebouncing = true;
          if (mounted && ref.read(shakeToOdometerProvider)) {
            ref.read(hapticProvider.notifier).vibrate();
            _updateOdometer(context, widget.vehicleId, ref);
          }
          Future.delayed(const Duration(seconds: 2), () {
            _shakeDebouncing = false;
          });
        }
      }
    });
  }

  Future<void> _openOdometerFromNotification() async {
    final vehicle = await ref.read(vehicleProvider(widget.vehicleId).future);
    if (!mounted || vehicle == null) return;
    karterShowDialog(
      context: context,
      builder: (ctx) => OdometerDialog(
        current: vehicle.currentOdometer,
        onSave: (double newDistance) async {
          final repo = ref.read(vehicleRepositoryProvider);
          final updated = vehicle.copyWith(
            currentOdometer: vehicle.currentOdometer.add(
              newDistance - vehicle.currentOdometer.distance,
            ),
            odometerReminderLastNotified: DateTime.now(),
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

  void _updateOdometer(
      BuildContext context, String vehicleId, WidgetRef ref) {
    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => OdometerDialog(
        current: ref.read(vehicleProvider(vehicleId)).value
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
              odometerReminderLastNotified: DateTime.now(),
            );
            await repo.save(updated);
            ref.invalidate(vehicleProvider(vehicleId));
            ref.invalidate(vehicleListProvider);
          }
        },
      ),
    );
  }

  void _showDescription(
      BuildContext context, AppLocalizations l, dynamic interval) {
    final label = localizedLabel(
        l.localeName, interval.i18nKey, interval.label ?? '');
    final desc = localizedDesc(
        l.localeName, interval.descI18nKey, interval.description ?? '');
    final text = desc.isEmpty ? l.noDescriptionAvailable : desc;
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

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(vehicleProvider(widget.vehicleId));
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= _wideBreakpoint;

              if (isWide) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            SectionHeader(title: l.information),
                            _VehicleInfoCard(vehicle: vehicle, l: l),
                            const SizedBox(height: 8),
                            SectionHeader(title: l.odometer),
                            _OdometerCard(
                              vehicle: vehicle,
                              isKm: isKm,
                              l: l,
                              onUpdate: () => _updateOdometer(
                                  context, vehicle.id, ref),
                            ),
                            const SizedBox(height: 8),
                            SectionHeader(title: l.actions),
                            _ActionsCard(
                              vehicleId: widget.vehicleId,
                              l: l,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ListView(
                          children: [
                            SectionHeader(title: l.nextMaintenance),
                            _MaintenanceCard(
                              vehicleId: widget.vehicleId,
                              distanceKm: distanceKm,
                              l: l,
                              onShowDescription: _showDescription,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                children: [
                  _VehicleInfoCard(vehicle: vehicle, l: l),
                  const SizedBox(height: 8),
                  _OdometerCard(
                    vehicle: vehicle,
                    isKm: isKm,
                    l: l,
                    onUpdate: () =>
                        _updateOdometer(context, vehicle.id, ref),
                  ),
                  const SizedBox(height: 8),
                  SectionHeader(title: l.actions),
                  _ActionsCard(
                    vehicleId: widget.vehicleId,
                    l: l,
                  ),
                  SectionHeader(title: l.nextMaintenance),
                  _MaintenanceCard(
                    vehicleId: widget.vehicleId,
                    distanceKm: distanceKm,
                    l: l,
                    onShowDescription: _showDescription,
                  ),
                  const SizedBox(height: 24),
                ],
              );
            },
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _FabStaggeredEntry(
                index: 2,
                visible: _fabOpen,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.small(
                    heroTag: 'add_service',
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onPressed: () {
                      setState(() => _fabOpen = false);
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
              ),
              _FabStaggeredEntry(
                index: 1,
                visible: _fabOpen,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.small(
                    heroTag: 'add_fuel',
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onPressed: () {
                      setState(() => _fabOpen = false);
                      showAddFuelLogModal(
                        context,
                        vehicleId: widget.vehicleId,
                        onSaved: () {
                          ref.invalidate(
                              fuelLogsProvider(
                                  widget.vehicleId));
                        },
                      );
                    },
                    child: const Icon(Icons.local_gas_station),
                  ),
                ),
              ),
              _FabStaggeredEntry(
                index: 0,
                visible: _fabOpen,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.small(
                    heroTag: 'add_doc',
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onPressed: () {
                      setState(() => _fabOpen = false);
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
              ),
              FloatingActionButton(
                heroTag: 'main_fab',
                onPressed: () =>
                    setState(() => _fabOpen = !_fabOpen),
                child: AnimatedRotation(
                  turns: _fabOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.add),
                ),
              ),
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
}

class _VehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;
  final AppLocalizations l;

  const _VehicleInfoCard({required this.vehicle, required this.l});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vehicle.alias != null && vehicle.alias!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.person_outline, size: 20),
              title: Text(vehicle.alias!),
              subtitle: Text(
                '${vehicle.brand} ${vehicle.model} ${vehicle.year}',
              ),
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                if (vehicle.plate != null)
                  _infoLine(Icons.badge, l.plate, vehicle.plate!.value),
                if (vehicle.vin != null)
                  _infoLine(Icons.qr_code, l.vin, vehicle.vin!.code),
                _infoLine(Icons.directions_car, l.brandModel,
                    '${vehicle.brand} ${vehicle.model}'),
                _infoLine(Icons.calendar_today, l.year, vehicle.year.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OdometerCard extends StatelessWidget {
  final Vehicle vehicle;
  final bool isKm;
  final AppLocalizations l;
  final VoidCallback onUpdate;

  const _OdometerCard({
    required this.vehicle,
    required this.isKm,
    required this.l,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final distance = vehicle.currentOdometer.distance;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.speed),
            title: Text(
              '${distance.toStringAsFixed(0)} ${isKm ? l.unitKm : l.unitMi}',
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(l.odometer),
            trailing: FilledButton.tonal(
              onPressed: onUpdate,
              child: Text(l.update),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsCard extends StatelessWidget {
  final String vehicleId;
  final AppLocalizations l;

  const _ActionsCard({required this.vehicleId, required this.l});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.local_gas_station),
            title: Text(l.fuelLogs),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/vehicle/$vehicleId/fuel'),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: Text(l.maintenanceHistory),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/vehicle/$vehicleId/maintenance'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l.vehicleDocuments),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/vehicle/$vehicleId/documents'),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(l.dtcLookupTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/vehicle/$vehicleId/dtc'),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: Text(l.configureIntervals),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context
                .push('/vehicle/$vehicleId/maintenance/settings'),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends ConsumerWidget {
  final String vehicleId;
  final double distanceKm;
  final AppLocalizations l;
  final void Function(BuildContext, AppLocalizations, dynamic)
      onShowDescription;

  const _MaintenanceCard({
    required this.vehicleId,
    required this.distanceKm,
    required this.l,
    required this.onShowDescription,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(vehicleId));
    final theme = Theme.of(context);

    return intervalsAsync.when(
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
            .map((i) => _IntervalData.compute(i, distanceKm, l))
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

        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: intervalData.map((data) {
              final interval = data.interval;
              Color? accentColor;
              if (data.isDue) {
                accentColor = theme.colorScheme.onErrorContainer;
              } else if (data.isApproaching) {
                accentColor = Colors.amber.shade800;
              }

              return ListTile(
                leading: Icon(
                  Icons.build_circle_outlined,
                  color: accentColor,
                ),
                title: Text(
                  localizedLabel(l.localeName, interval.i18nKey,
                      interval.label),
                  style: TextStyle(
                    fontWeight:
                        data.isDue ? FontWeight.bold : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(data.subtitle),
                    if (data.lastResetInfo != null)
                      Text(
                        data.lastResetInfo!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                onTap: () => onShowDescription(
                    context, l, interval),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () =>
                          showAddMaintenanceLogModal(
                        context,
                        vehicleId: vehicleId,
                        initialDescription: localizedLabel(
                          l.localeName,
                          interval.i18nKey,
                          interval.label,
                        ),
                        initialIntervalId: interval.id,
                        onSaved: () {
                          ref.invalidate(
                              maintenanceLogsProvider(
                                  vehicleId));
                          ref.invalidate(
                              maintenanceIntervalsProvider(
                                  vehicleId));
                        },
                      ),
                      child: Text(
                        l.register,
                        style: accentColor != null
                            ? TextStyle(color: accentColor)
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

Widget _infoLine(IconData icon, String label, String value) {
  return Builder(
    builder: (context) {
      final onSurface =
          Theme.of(context).colorScheme.onSurfaceVariant;
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: onSurface),
            const SizedBox(width: 8),
            Flexible(
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: '$label: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  TextSpan(text: value),
                ]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _FabStaggeredEntry extends StatefulWidget {
  final int index;
  final bool visible;
  final Widget child;

  const _FabStaggeredEntry({
    required this.index,
    required this.visible,
    required this.child,
  });

  @override
  State<_FabStaggeredEntry> createState() => _FabStaggeredEntryState();
}

class _FabStaggeredEntryState extends State<_FabStaggeredEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Durations.medium4,
      vsync: this,
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl, curve: Easing.emphasizedDecelerate),
    );
    _scale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl, curve: Easing.emphasizedDecelerate),
    );
    if (widget.visible) _ctrl.value = 1;
  }

  @override
  void didUpdateWidget(_FabStaggeredEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _ctrl.duration = Durations.medium4;
        Future.delayed(
            Duration(milliseconds: 50 * widget.index), () {
          if (mounted) _ctrl.forward();
        });
      } else {
        _ctrl.duration = Durations.short4;
        Future.delayed(
            Duration(milliseconds: 50 * (2 - widget.index)),
            () {
          if (mounted) _ctrl.reverse();
        });
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fade,
            child: ScaleTransition(scale: _scale, child: child),
          );
        },
        child: widget.child,
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
  final String? lastResetInfo;
  final double sortKey;

  _IntervalData._({
    required this.interval,
    required this.kmRemaining,
    required this.monthsRemaining,
    required this.isDue,
    required this.isApproaching,
    required this.subtitle,
    required this.lastResetInfo,
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

    String? lastResetInfo;
    if (interval.lastResetDate != null) {
      final dateStr = DateFormat.yMd().format(interval.lastResetDate!);
      if (interval.lastResetKm > 0) {
        lastResetInfo =
            '${l.lastService}: $dateStr · ${interval.lastResetKm.toStringAsFixed(0)} ${l.km}';
      } else {
        lastResetInfo = '${l.lastService}: $dateStr';
      }
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
      lastResetInfo: lastResetInfo,
      sortKey: sortKey,
    );
  }
}
