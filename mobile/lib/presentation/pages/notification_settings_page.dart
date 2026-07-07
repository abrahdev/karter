import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class NotificationSettingsPage extends ConsumerWidget {
  final String vehicleId;

  const NotificationSettingsPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(vehicleProvider(vehicleId));
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return vehicleAsync.when(
      data: (vehicle) {
        if (vehicle == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.notificationSettingsTitle)),
            body: Center(child: Text(l.vehicleNotFound)),
          );
        }
        return _SettingsView(
          vehicle: vehicle,
          vehicleId: vehicleId,
          l: l,
          theme: theme,
          ref: ref,
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text(l.homeError(e))),
      ),
    );
  }
}

class _SettingsView extends StatefulWidget {
  final Vehicle vehicle;
  final String vehicleId;
  final AppLocalizations l;
  final ThemeData theme;
  final WidgetRef ref;

  const _SettingsView({
    required this.vehicle,
    required this.vehicleId,
    required this.l,
    required this.theme,
    required this.ref,
  });

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  late double _sliderValue;

  bool get _isCustom =>
      widget.vehicle.odometerReminderFreqDays != null &&
      widget.vehicle.odometerReminderFreqDays != 7 &&
      widget.vehicle.odometerReminderFreqDays != 30;

  @override
  void initState() {
    super.initState();
    _sliderValue =
        (widget.vehicle.odometerReminderFreqDays ?? 14).toDouble().clamp(1, 90);
  }

  int? _selectedSegment() {
    final freq = widget.vehicle.odometerReminderFreqDays;
    if (freq == null) return null;
    if (freq == 7) return 7;
    if (freq == 30) return 30;
    return null;
  }

  String get _vehicleLabel =>
      widget.vehicle.alias ?? '${widget.vehicle.brand} ${widget.vehicle.model}';

  Future<void> _saveFreq(int? days) async {
    final now = DateTime.now();
    final updated = widget.vehicle.copyWith(
      odometerReminderFreqDays: days,
      odometerReminderLastNotified: days != null ? now : null,
    );
    final repo = widget.ref.read(vehicleRepositoryProvider);
    await repo.save(updated);
    widget.ref.invalidate(vehicleProvider(widget.vehicleId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.l.notificationSettingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_vehicleLabel,
                      style: widget.theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(widget.l.notificationSettingsSubtitle,
                      style: widget.theme.textTheme.bodySmall?.copyWith(
                        color: widget.theme.colorScheme.onSurfaceVariant,
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(widget.l.notificationOdometerSection,
              style: widget.theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          _buildFreqSelector(),
          const SizedBox(height: 24),
          Text(widget.l.notificationMaintenanceSection,
              style: widget.theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          _buildMaintenanceToggle(),
          const SizedBox(height: 16),
          if (widget.vehicle.maintenanceReminderSnoozedUntil != null &&
              widget.vehicle.maintenanceReminderSnoozedUntil!
                  .isAfter(DateTime.now()))
            _buildSnoozeBanner(),
        ],
      ),
    );
  }

  Widget _buildFreqSelector() {
    final selected = _selectedSegment();
    final l = widget.l;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<int?>(
          segments: const [
            ButtonSegment(value: 7, label: Text('7 días')),
            ButtonSegment(value: 30, label: Text('30 días')),
            ButtonSegment(value: null, label: Text('Personalizado')),
          ],
          selected: {selected},
          onSelectionChanged: (selectedSet) {
            final value = selectedSet.first;
            if (value != null) {
              _saveFreq(value);
            } else {
              setState(() {
                _sliderValue = (widget.vehicle.odometerReminderFreqDays ?? 14)
                    .toDouble()
                    .clamp(1, 90);
              });
              _saveFreq(_sliderValue.round());
            }
          },
        ),
        if (_isCustom || selected == null && _sliderValue > 0) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Text('1', style: widget.theme.textTheme.bodySmall),
              Expanded(
                child: Slider(
                  value: _sliderValue,
                  min: 1,
                  max: 90,
                  divisions: 89,
                  label: '${_sliderValue.round()} días',
                  onChanged: (v) {
                    setState(() => _sliderValue = v);
                  },
                  onChangeEnd: (v) {
                    _saveFreq(v.round());
                  },
                ),
              ),
              Text('90', style: widget.theme.textTheme.bodySmall),
              const SizedBox(width: 16),
            ],
          ),
          Center(
            child: Text(
              l.notificationFreqDays(_sliderValue.round()),
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.theme.colorScheme.primary,
              ),
            ),
          ),
        ],
        if (selected == null && !_isCustom)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              l.notificationFreqOff,
              style: widget.theme.textTheme.bodySmall?.copyWith(
                color: widget.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMaintenanceToggle() {
    final l = widget.l;
    final vehicle = widget.vehicle;

    return Column(
      children: [
        SwitchListTile(
          title: Text(l.notificationMaintenanceToggle),
          subtitle: Text(l.notificationMaintenanceToggleSubtitle),
          value: vehicle.maintenanceReminderEnabled,
          contentPadding: EdgeInsets.zero,
          onChanged: (enabled) async {
            final updated = vehicle.copyWith(
              maintenanceReminderEnabled: enabled,
              maintenanceReminderSnoozedUntil:
                  enabled ? null : vehicle.maintenanceReminderSnoozedUntil,
            );
            final repo = widget.ref.read(vehicleRepositoryProvider);
            await repo.save(updated);
            widget.ref.invalidate(vehicleProvider(widget.vehicleId));
          },
        ),
        if (vehicle.maintenanceReminderEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton.icon(
              icon: const Icon(Icons.notifications_off_outlined, size: 18),
              label: Text(l.notificationSnoozeAction),
              onPressed: () async {
                final updated = vehicle.copyWith(
                  maintenanceReminderSnoozedUntil:
                      DateTime.now().add(const Duration(days: 7)),
                );
                final repo = widget.ref.read(vehicleRepositoryProvider);
                await repo.save(updated);
                widget.ref.invalidate(vehicleProvider(widget.vehicleId));
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSnoozeBanner() {
    final remaining = widget.vehicle.maintenanceReminderSnoozedUntil!
        .difference(DateTime.now())
        .inDays;
    return Card(
      color: widget.theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.l.notificationSnoozedBanner(remaining),
                style: widget.theme.textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () async {
                final updated = widget.vehicle.copyWith(
                  maintenanceReminderSnoozedUntil: null,
                );
                final repo = widget.ref.read(vehicleRepositoryProvider);
                await repo.save(updated);
                widget.ref.invalidate(vehicleProvider(widget.vehicleId));
              },
              child: Text(widget.l.notificationSnoozeCancel),
            ),
          ],
        ),
      ),
    );
  }
}
