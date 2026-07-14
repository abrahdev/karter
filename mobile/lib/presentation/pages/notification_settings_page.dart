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
  late double _snoozeDays;
  late Set<int> _selectedFreq;
  bool _initialized = false;

  Vehicle? get _vehicle =>
      ref.watch(vehicleProvider(widget.vehicleId)).value;

  bool get _isCustom => _selectedFreq.contains(-1);

  bool get _showSlider => _isCustom;

  @override
  void initState() {
    super.initState();
    _sliderValue = 14;
    _snoozeDays = 7;
    _selectedFreq = {};
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromVehicle());
  }

  Future<void> _initFromVehicle() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId).future);
    if (vehicle != null && mounted) {
      setState(() {
        final freq = vehicle.odometerReminderFreqDays;
        if (freq == null) {
          _selectedFreq = {};
        } else if (freq == 7) {
          _selectedFreq = {7};
        } else if (freq == 30) {
          _selectedFreq = {30};
        } else {
          _selectedFreq = {-1};
          _sliderValue = freq.toDouble().clamp(1, 90);
        }
        if (vehicle.maintenanceReminderSnoozedUntil != null &&
            vehicle.maintenanceReminderSnoozedUntil!.isAfter(DateTime.now())) {
          _snoozeDays = vehicle
              .maintenanceReminderSnoozedUntil!
              .difference(DateTime.now())
              .inDays
              .clamp(1, 14)
              .toDouble();
        }
        _initialized = true;
      });
    }
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
    ref.invalidate(vehicleListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = _vehicle;
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    if (vehicle == null || !_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      controller: widget.scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
      ],
    );
  }

  Widget _buildFreqSelector(ThemeData theme, AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<int>(
          emptySelectionAllowed: true,
          segments: [
            ButtonSegment(value: 7, label: Text(l.notificationFreqWeekly)),
            ButtonSegment(value: 30, label: Text(l.notificationFreqMonthly)),
            ButtonSegment(value: -1, label: Text(l.notificationFreqCustom)),
          ],
          selected: _selectedFreq,
          onSelectionChanged: (selectedSet) {
            setState(() => _selectedFreq = selectedSet);
            if (selectedSet.isEmpty) {
              _saveFreq(null);
            } else {
              final value = selectedSet.first;
              if (value == -1) {
                _saveFreq(_sliderValue.round());
              } else {
                _saveFreq(value);
              }
            }
          },
        ),
        if (_showSlider) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Text('1', style: theme.textTheme.bodySmall),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.colorScheme.secondary,
                    inactiveTrackColor:
                        theme.colorScheme.surfaceContainerHighest,
                    thumbColor: theme.colorScheme.secondary,
                    trackHeight: 8,
                    overlayColor:
                        theme.colorScheme.secondary.withValues(alpha: 0.12),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 90,
                    divisions: 89,
                    label: l.notificationFreqDays(_sliderValue.round()),
                    onChanged: (v) {
                      setState(() => _sliderValue = v);
                    },
                    onChangeEnd: (v) {
                      _saveFreq(v.round());
                    },
                  ),
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
        if (_selectedFreq.isEmpty)
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
    final isSnoozed = vehicle.maintenanceReminderSnoozedUntil != null &&
        vehicle.maintenanceReminderSnoozedUntil!.isAfter(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: Text(l.notificationMaintenanceToggle),
          subtitle: Text(l.notificationMaintenanceToggleSubtitle),
          value: vehicle.maintenanceReminderEnabled,
          contentPadding: EdgeInsets.zero,
          onChanged: (enabled) async {
            final v =
                ref.read(vehicleProvider(widget.vehicleId)).value;
            if (v == null) return;
            final updated = v.copyWith(
              maintenanceReminderEnabled: enabled,
              maintenanceReminderSnoozedUntil:
                  enabled ? null : v.maintenanceReminderSnoozedUntil,
            );
            final repo = ref.read(vehicleRepositoryProvider);
            await repo.save(updated);
            ref.invalidate(vehicleProvider(widget.vehicleId));
            ref.invalidate(vehicleListProvider);
          },
        ),
        if (vehicle.maintenanceReminderEnabled) ...[
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l.notificationSnoozeToggle),
            subtitle: Text(l.notificationSnoozeDays(_snoozeDays.round())),
            value: isSnoozed,
            contentPadding: EdgeInsets.zero,
            onChanged: (snooze) async {
              final v =
                  ref.read(vehicleProvider(widget.vehicleId)).value;
              if (v == null) return;
              final updated = v.copyWith(
                maintenanceReminderSnoozedUntil: snooze
                    ? DateTime.now().add(
                        Duration(days: _snoozeDays.round()))
                    : null,
              );
              final repo = ref.read(vehicleRepositoryProvider);
              await repo.save(updated);
              ref.invalidate(vehicleProvider(widget.vehicleId));
              ref.invalidate(vehicleListProvider);
            },
          ),
          if (isSnoozed) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.colorScheme.secondary,
                  inactiveTrackColor:
                      theme.colorScheme.surfaceContainerHighest,
                  thumbColor: theme.colorScheme.secondary,
                  trackHeight: 8,
                  overlayColor:
                      theme.colorScheme.secondary.withValues(alpha: 0.12),
                ),
                child: Slider(
                  value: _snoozeDays,
                  min: 1,
                  max: 14,
                  divisions: 13,
                  label: l.notificationSnoozeDays(_snoozeDays.round()),
                  onChanged: (v) {
                    setState(() => _snoozeDays = v);
                  },
                  onChangeEnd: (v) async {
                    final updated = vehicle.copyWith(
                      maintenanceReminderSnoozedUntil:
                          DateTime.now().add(Duration(days: v.round())),
                    );
                    final repo = ref.read(vehicleRepositoryProvider);
                    await repo.save(updated);
                    ref.invalidate(vehicleProvider(widget.vehicleId));
                    ref.invalidate(vehicleListProvider);
                  },
                ),
              ),
            ),
            Center(
              child: Text(
                l.notificationSnoozeDays(_snoozeDays.round()),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}
