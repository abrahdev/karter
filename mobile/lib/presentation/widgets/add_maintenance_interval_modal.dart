import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:uuid/uuid.dart';

Future<void> showAddCustomIntervalModal(
  BuildContext context, {
  required String vehicleId,
  required void Function() onSaved,
}) async {
  final result = await karterShowModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AddIntervalModal(vehicleId: vehicleId),
  );

  if (result == 'saved' && context.mounted) {
    onSaved();
  }
}

Future<void> showEditIntervalModal(
  BuildContext context, {
  required String vehicleId,
  required MaintenanceInterval interval,
  required void Function() onSaved,
}) async {
  var currentInterval = interval;
  var changed = false;

  while (true) {
    final action = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _IntervalPreview(
        vehicleId: vehicleId,
        interval: currentInterval,
      ),
    );

    if (!context.mounted) return;

    if (action == 'toggled') {
      changed = true;
      final repo = ProviderScope.containerOf(context)
          .read(maintenanceIntervalRepositoryProvider);
      final updated = await repo.getById(currentInterval.id);
      if (updated != null) currentInterval = updated;
      continue;
    }

    if (action != 'edit') break;

    final result = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddIntervalModal(
        vehicleId: vehicleId,
        editInterval: currentInterval,
      ),
    );

    if (!context.mounted) return;

    if (result == 'saved') {
      changed = true;
      final repo = ProviderScope.containerOf(context)
          .read(maintenanceIntervalRepositoryProvider);
      final updated = await repo.getById(currentInterval.id);
      if (updated != null) currentInterval = updated;
    } else if (result == 'deleted') {
      changed = true;
      break;
    } else {
      break;
    }
  }

  if (changed && context.mounted) {
    onSaved();
  }
}

class _IntervalPreview extends ConsumerWidget {
  final String vehicleId;
  final MaintenanceInterval interval;

  const _IntervalPreview({
    required this.vehicleId,
    required this.interval,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final desc = localizedDesc(
        l, interval.descI18nKey, interval.description ?? '');

    return Padding(
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
          if (desc.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(desc, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context, 'edit'),
              icon: const Icon(Icons.edit),
              label: Text(l.edit),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddIntervalModal extends ConsumerStatefulWidget {
  final String vehicleId;
  final MaintenanceInterval? editInterval;

  const _AddIntervalModal({
    required this.vehicleId,
    this.editInterval,
  });

  @override
  ConsumerState<_AddIntervalModal> createState() =>
      _AddIntervalModalState();
}

class _AddIntervalModalState
    extends ConsumerState<_AddIntervalModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  var _hasMonths = false;
  var _saving = false;

  bool get _isEditing => widget.editInterval != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final i = widget.editInterval!;
      _kmCtrl.text = i.kmInterval.toString();
      if (i.monthsInterval != null) {
        _hasMonths = true;
        _monthsCtrl.text = i.monthsInterval.toString();
      }
      _descCtrl.text = i.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kmCtrl.dispose();
    _monthsCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(maintenanceIntervalRepositoryProvider);

      if (_isEditing) {
        final i = widget.editInterval!;
        final km = int.parse(_kmCtrl.text.trim());
        final months = _hasMonths && _monthsCtrl.text.trim().isNotEmpty
            ? int.parse(_monthsCtrl.text.trim())
            : null;
        await repo.save(i.copyWith(
          kmInterval: km,
          monthsInterval: months,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
        ));
      } else {
        final name = _nameCtrl.text.trim();
        final km = int.parse(_kmCtrl.text.trim());
        final months = _hasMonths && _monthsCtrl.text.trim().isNotEmpty
            ? int.parse(_monthsCtrl.text.trim())
            : null;
        final interval = MaintenanceInterval(
          id: const Uuid().v4(),
          vehicleId: widget.vehicleId,
          label: name,
          kmInterval: km,
          monthsInterval: months,
          description: _descCtrl.text.trim().isEmpty
              ? null
              : _descCtrl.text.trim(),
          isCustom: true,
        );
        await repo.save(interval);
      }

      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
      HapticFeedback.mediumImpact();
      if (mounted) Navigator.pop(context, 'saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.homeError(e.toString())),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteInterval),
        content: Text('Are you sure you want to delete this interval?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(maintenanceIntervalRepositoryProvider);
      await repo.delete(widget.editInterval!.id);
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
      HapticFeedback.mediumImpact();
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.homeError(e.toString())),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Form(
          key: _formKey,
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
              Text(
                _isEditing
                    ? localizedLabel(l, widget.editInterval!.i18nKey,
                        widget.editInterval!.label)
                    : l.newInterval,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              if (!_isEditing) ...[
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: l.name,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? l.required : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _kmCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l.unitKm,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return l.required;
                  final km = int.tryParse(v.trim());
                  if (km == null || km <= 0) return l.invalid;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(l.timeMonths),
                value: _hasMonths,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _hasMonths = v),
              ),
              if (_hasMonths) ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _monthsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l.months,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                minLines: 2,
                decoration: InputDecoration(
                  labelText: l.description,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _saving
                        ? const Center(
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator()),
                          )
                        : FilledButton(
                            onPressed: _save,
                            child: Text(
                                _isEditing ? l.saveChanges : l.add),
                          ),
                  ),
                ],
              ),
              if (_isEditing && widget.editInterval!.isCustom) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(
                          color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
