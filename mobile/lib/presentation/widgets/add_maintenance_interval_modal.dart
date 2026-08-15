import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/utils/template_interval_builder.dart';
import 'package:mobile/presentation/widgets/karter_segmented_button.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
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
    if (!context.mounted) return;
    final action = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) =>
          _IntervalPreview(vehicleId: vehicleId, interval: currentInterval),
    );

    if (!context.mounted) return;

    if (action == 'toggled') {
      changed = true;
      final repo = ProviderScope.containerOf(
        context,
      ).read(maintenanceIntervalRepositoryProvider);
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
      final repo = ProviderScope.containerOf(
        context,
      ).read(maintenanceIntervalRepositoryProvider);
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

  const _IntervalPreview({required this.vehicleId, required this.interval});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final desc = localizedDesc(
      l.localeName,
      interval.descI18nKey,
      interval.description ?? '',
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
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

  const _AddIntervalModal({required this.vehicleId, this.editInterval});

  @override
  ConsumerState<_AddIntervalModal> createState() => _AddIntervalModalState();
}

enum _AddMode { manual, template }

class _AddIntervalModalState extends ConsumerState<_AddIntervalModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _monthsCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<IntervalPart> _parts = [];
  final List<TextEditingController> _partNameCtrls = [];
  final List<TextEditingController> _partQtyCtrls = [];
  var _hasMonths = false;
  var _saving = false;
  var _mode = _AddMode.manual;

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
      _parts.addAll(i.parts);
      for (final p in i.parts) {
        _partNameCtrls.add(TextEditingController(text: p.name ?? ''));
        _partQtyCtrls.add(
          TextEditingController(
            text: IntervalPartsView.formatQuantity(p.quantity),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kmCtrl.dispose();
    _monthsCtrl.dispose();
    _descCtrl.dispose();
    for (final c in _partNameCtrls) {
      c.dispose();
    }
    for (final c in _partQtyCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addPart() {
    setState(() {
      _parts.add(IntervalPart(partId: const Uuid().v4(), quantity: 1));
      _partNameCtrls.add(TextEditingController());
      _partQtyCtrls.add(TextEditingController(text: '1'));
    });
  }

  void _removePart(int index) {
    setState(() {
      _partNameCtrls[index].dispose();
      _partQtyCtrls[index].dispose();
      _parts.removeAt(index);
      _partNameCtrls.removeAt(index);
      _partQtyCtrls.removeAt(index);
    });
  }

  List<IntervalPart> _buildParts() {
    final result = <IntervalPart>[];
    for (var i = 0; i < _parts.length; i++) {
      final part = _parts[i];
      final quantity =
          double.tryParse(_partQtyCtrls[i].text.trim()) ?? part.quantity;
      final isTemplatePart = part.i18nKey != null;
      final name = isTemplatePart
          ? part.name
          : (_partNameCtrls[i].text.trim().isEmpty
                ? null
                : _partNameCtrls[i].text.trim());
      result.add(part.copyWith(name: name, quantity: quantity));
    }
    return result;
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
        await repo.save(
          i.copyWith(
            kmInterval: km,
            monthsInterval: months,
            description: _descCtrl.text.trim().isEmpty
                ? null
                : _descCtrl.text.trim(),
            parts: _buildParts(),
          ),
        );
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
          parts: _buildParts(),
        );
        await repo.save(interval);
      }

      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
      ref.read(hapticProvider.notifier).success();
      if (mounted) Navigator.pop(context, 'saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.homeError(e.toString()),
            ),
          ),
        );
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
        content: Text(l.deleteIntervalConfirm),
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
      ref.read(hapticProvider.notifier).delete();
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.homeError(e.toString()),
            ),
          ),
        );
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            if (!_isEditing) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: KarterSegmentedButton<_AddMode>(
                  segments: [
                    ButtonSegment(
                      value: _AddMode.manual,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(l.addModeManual),
                    ),
                    ButtonSegment(
                      value: _AddMode.template,
                      icon: const Icon(Icons.cloud_download_outlined, size: 18),
                      label: Text(l.addModeTemplate),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (v) => setState(() => _mode = v.first),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_isEditing || _mode == _AddMode.manual)
              _buildManualForm(theme, l)
            else
              _TemplateSyncSection(vehicleId: widget.vehicleId),
          ],
        ),
      ),
    );
  }

  Widget _buildManualForm(ThemeData theme, AppLocalizations l) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEditing
                ? localizedLabel(
                    l.localeName,
                    widget.editInterval!.i18nKey,
                    widget.editInterval!.label,
                  )
                : l.newInterval,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          if (!_isEditing) ...[
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l.name,
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
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l.required;
              final km = int.tryParse(v.trim());
              if (km == null || km <= 0) return l.invalid;
              return null;
            },
          ),
          const SizedBox(height: 12),
          KarterSwitchListTile(
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
            ),
          ),
          if (_parts.isNotEmpty) ...[
            SectionHeader(title: l.partsTitle),
            for (var i = 0; i < _parts.length; i++)
              _PartRow(
                part: _parts[i],
                nameCtrl: _partNameCtrls[i],
                qtyCtrl: _partQtyCtrls[i],
                isTemplatePart: _parts[i].i18nKey != null,
                onRemove: () => _removePart(i),
              ),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addPart,
            icon: const Icon(Icons.add, size: 18),
            label: Text(l.addPart),
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
                    ? const Center(child: M3LoadingIndicator(size: 20))
                    : FilledButton(
                        onPressed: _save,
                        child: Text(_isEditing ? l.saveChanges : l.add),
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
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TemplateSyncSection extends ConsumerStatefulWidget {
  const _TemplateSyncSection({required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<_TemplateSyncSection> createState() =>
      _TemplateSyncSectionState();
}

class _PartRow extends StatelessWidget {
  const _PartRow({
    required this.part,
    required this.nameCtrl,
    required this.qtyCtrl,
    required this.isTemplatePart,
    required this.onRemove,
  });

  final IntervalPart part;
  final TextEditingController nameCtrl;
  final TextEditingController qtyCtrl;
  final bool isTemplatePart;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Icon(Icons.build_outlined, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isTemplatePart
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      localizedLabel(
                        l.localeName,
                        part.i18nKey,
                        part.name ?? '',
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: l.partName,
                      isDense: true,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: TextFormField(
              controller: qtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: l.quantity,
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (part.links.isNotEmpty) ...[
                  Icon(
                    Icons.link,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: l.delete,
                  onPressed: onRemove,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateSyncSectionState extends ConsumerState<_TemplateSyncSection> {
  final Set<String> _selectedNewIds = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final resolutionAsync = ref.watch(
      templateResolutionProvider(widget.vehicleId),
    );
    final intervalsAsync = ref.watch(
      maintenanceIntervalsProvider(widget.vehicleId),
    );

    return resolutionAsync.when(
      loading: () => const _SyncLoading(),
      error: (_, _) => _SyncMessage(message: l.noTemplate),
      data: (resolution) {
        if (resolution == null) return _SyncMessage(message: l.noTemplate);
        return intervalsAsync.when(
          loading: () => const _SyncLoading(),
          error: (_, _) => _SyncMessage(message: l.noTemplate),
          data: (intervals) => _buildSync(theme, l, resolution, intervals),
        );
      },
    );
  }

  String _itemKey(ResolvedItem item) => item.i18nKey ?? item.id;

  Widget _buildSync(
    ThemeData theme,
    AppLocalizations l,
    TemplateResolution resolution,
    List<MaintenanceInterval> intervals,
  ) {
    final byKey = <String, MaintenanceInterval>{
      for (final i in intervals)
        if (i.i18nKey != null && !i.isCustom) i.i18nKey!: i,
    };
    final newItems = <ResolvedItem>[];
    final updateItems = <ResolvedItem>[];
    for (final item in resolution.items) {
      final key = item.i18nKey;
      if (key == null) {
        newItems.add(item);
      } else {
        final existing = byKey[key];
        if (existing == null) {
          newItems.add(item);
        } else if (templateItemChanged(item, existing)) {
          updateItems.add(item);
        }
      }
    }

    final meta = resolution.entry.meta;
    final templateName = [
      meta.make,
      meta.model,
      if (meta.generation != null) meta.generation!,
    ].join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.syncInstruction, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text(
          templateName,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        if (newItems.isEmpty && updateItems.isEmpty)
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(l.upToDate, style: theme.textTheme.bodyLarge),
            ],
          )
        else ...[
          if (newItems.isNotEmpty) ...[
            SectionHeader(
              title: l.newFromTemplate,
              topPadding: 0,
              bottomPadding: 4,
            ),
            for (final item in newItems)
              _buildNewTile(theme, l, resolution, item),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _selectedNewIds.isEmpty
                    ? null
                    : () => _addSelected(resolution),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.add),
              ),
            ),
          ],
          if (updateItems.isNotEmpty) ...[
            if (newItems.isNotEmpty) const SizedBox(height: 20),
            SectionHeader(
              title: l.updatesAvailable,
              topPadding: 0,
              bottomPadding: 4,
            ),
            for (final item in updateItems)
              _buildUpdateTile(
                theme,
                l,
                resolution,
                item,
                byKey[item.i18nKey]!,
              ),
          ],
        ],
      ],
    );
  }

  Widget _buildNewTile(
    ThemeData theme,
    AppLocalizations l,
    TemplateResolution resolution,
    ResolvedItem item,
  ) {
    final parts = templateParts(resolution, item);
    final key = _itemKey(item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _selectedNewIds.contains(key),
              onChanged: (v) => setState(() {
                if (v == true) {
                  _selectedNewIds.add(key);
                } else {
                  _selectedNewIds.remove(key);
                }
              }),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedLabel(l.localeName, item.i18nKey, item.label),
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    _intervalLine(l, item),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (parts.isNotEmpty) ...[
          const SizedBox(height: 4),
          IntervalPartsView(parts: parts),
        ],
      ],
    );
  }

  Widget _buildUpdateTile(
    ThemeData theme,
    AppLocalizations l,
    TemplateResolution resolution,
    ResolvedItem item,
    MaintenanceInterval existing,
  ) {
    final parts = templateParts(resolution, item);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedLabel(l.localeName, item.i18nKey, item.label),
                    style: theme.textTheme.bodyLarge,
                  ),
                  Text(
                    _intervalLine(l, item),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _restore(resolution, item, existing),
              child: Text(l.restore),
            ),
          ],
        ),
        if (parts.isNotEmpty) ...[
          const SizedBox(height: 4),
          IntervalPartsView(parts: parts),
        ],
      ],
    );
  }

  String _intervalLine(AppLocalizations l, ResolvedItem item) {
    final parts = <String>['${item.intervalKm} ${l.km}'];
    if (item.intervalMonths != null) {
      parts.add('${item.intervalMonths} ${l.months}');
    }
    return parts.join(' / ');
  }

  Future<void> _addSelected(TemplateResolution resolution) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(maintenanceIntervalRepositoryProvider);
    for (final item in resolution.items) {
      if (!_selectedNewIds.contains(_itemKey(item))) continue;
      await repo.save(intervalFromTemplate(widget.vehicleId, item, resolution));
    }
    _selectedNewIds.clear();
    ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
    ref.read(hapticProvider.notifier).success();
    messenger.showSnackBar(SnackBar(content: Text(l.syncAdded)));
  }

  Future<void> _restore(
    TemplateResolution resolution,
    ResolvedItem item,
    MaintenanceInterval existing,
  ) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(maintenanceIntervalRepositoryProvider);
    await repo.save(
      MaintenanceInterval(
        id: existing.id,
        vehicleId: existing.vehicleId,
        label: item.label,
        i18nKey: item.i18nKey,
        descI18nKey: item.descI18nKey,
        kmInterval: item.intervalKm,
        monthsInterval: item.intervalMonths,
        description: item.description,
        lastResetKm: existing.lastResetKm,
        lastResetDate: existing.lastResetDate,
        isEnabled: existing.isEnabled,
        isCustom: false,
        parts: templateParts(resolution, item),
      ),
    );
    ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
    ref.read(hapticProvider.notifier).success();
    messenger.showSnackBar(SnackBar(content: Text(l.syncRestored)));
  }
}

class _SyncLoading extends StatelessWidget {
  const _SyncLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: M3LoadingIndicator()),
    );
  }
}

class _SyncMessage extends StatelessWidget {
  const _SyncMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}
