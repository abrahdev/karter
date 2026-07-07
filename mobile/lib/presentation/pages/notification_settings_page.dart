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
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettingsTitle)),
      body: NotificationSettingsContent(
        vehicleId: vehicleId,
        scrollController: null,
      ),
    );
  }
}

class NotificationSettingsContent extends ConsumerStatefulWidget {
  final String vehicleId;
  final ScrollController? scrollController;

  const NotificationSettingsContent({
    super.key,
    required this.vehicleId,
    this.scrollController,
  });

  @override
  ConsumerState<NotificationSettingsContent> createState() =>
      _NotificationSettingsContentState();
}

class _NotificationSettingsContentState
    extends ConsumerState<NotificationSettingsContent> {
  late double _sliderValue;

  Vehicle? get _vehicle =>
      ref.watch(vehicleProvider(widget.vehicleId)).valueOrNull;

  bool get _isCustom {
    final freq = _vehicle?.odometerReminderFreqDays;
    return freq != null && freq != 7 && freq != 30;
  }

  int? _selectedSegment() {
    final freq = _vehicle?.odometerReminderFreqDays;
    if (freq == null) return null;
    if (freq == 7) return 7;
    if (freq == 30) return 30;
    return null;
  }

  Future<void> _saveFreq(int? days) async {
    final vehicle = _vehicle;
    if (vehicle == null) return;
    final now = DateTime.now();
    final updated = vehicle.copyWith(
      odometerReminderFreqDays: days,
      odometerReminderLastNotified: days != null ? now : null,
    );
    final repo = ref.read(vehicleRepositoryProvider);
    await repo.save(updated);
    ref.invalidate(vehicleProvider(widget.vehicleId));
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _vehicle;
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    if (vehicle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.notificationOdometerSection,
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        _buildFreqSelector(theme, l),
        const SizedBox(height: 24),
        Text(l.notificationMaintenanceSection,
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 12),
        _buildMaintenanceToggle(vehicle, theme, l),
        const SizedBox(height: 16),
        if (vehicle.maintenanceReminderSnoozedUntil != null &&
            vehicle.maintenanceReminderSnoozedUntil!
                .isAfter(DateTime.now()))
          _buildSnoozeBanner(vehicle, theme, l),
      ],
    );
  }

  Widget _buildFreqSelector(ThemeData theme, AppLocalizations l) {
    final selected = _selectedSegment();
    final vehicle = _vehicle!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<int?>(
          segments: const [
            ButtonSegment(value: 7, label: Text('7 días')),
            ButtonSegment(value: 30, label: Text('30 días')),
            ButtonSegment(value: null, label: Text('Personalizado')),
          ],
          selected: selected != null ? {selected} : <int?>{},
          onSelectionChanged: (selectedSet) {
            final value = selectedSet.first;
            if (value == null) {
              setState(() {
                _sliderValue =
                    (vehicle.odometerReminderFreqDays ?? 14)
                        .toDouble()
                        .clamp(1, 90);
              });
            }
            _saveFreq(value);
          },
        ),
        if (_isCustom && selected == null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Text('1', style: theme.textTheme.bodySmall),
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
              Text('90', style: theme.textTheme.bodySmall),
              const SizedBox(width: 16),
            ],
          ),
          Center(
            child: Text(
              l.notificationFreqDays(_sliderValue.round()),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
        if (selected == null && !_isCustom && _vehicle?.odometerReminderFreqDays == null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              l.notificationFreqOff,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMaintenanceToggle(
      Vehicle vehicle, ThemeData theme, AppLocalizations l) {
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
            final repo = ref.read(vehicleRepositoryProvider);
            await repo.save(updated);
            ref.invalidate(vehicleProvider(widget.vehicleId));
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
                final repo = ref.read(vehicleRepositoryProvider);
                await repo.save(updated);
                ref.invalidate(vehicleProvider(widget.vehicleId));
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSnoozeBanner(
      Vehicle vehicle, ThemeData theme, AppLocalizations l) {
    final remaining = vehicle.maintenanceReminderSnoozedUntil!
        .difference(DateTime.now())
        .inDays;
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l.notificationSnoozedBanner(remaining),
                style: theme.textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () async {
                final updated = vehicle.copyWith(
                  maintenanceReminderSnoozedUntil: null,
                );
                final repo = ref.read(vehicleRepositoryProvider);
                await repo.save(updated);
                ref.invalidate(vehicleProvider(widget.vehicleId));
              },
              child: Text(l.notificationSnoozeCancel),
            ),
          ],
        ),
      ),
    );
  }
}
