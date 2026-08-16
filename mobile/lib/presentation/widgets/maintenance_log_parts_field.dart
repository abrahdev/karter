import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/entities/vehicle_part.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/utils/part_line_formatter.dart';
import 'package:mobile/presentation/widgets/section_header.dart';

class MaintenanceLogPartsField extends ConsumerStatefulWidget {
  final List<MaintenanceLogPart> initialParts;
  final ValueChanged<List<MaintenanceLogPart>> onChanged;

  const MaintenanceLogPartsField({
    super.key,
    this.initialParts = const [],
    required this.onChanged,
  });

  @override
  ConsumerState<MaintenanceLogPartsField> createState() =>
      _MaintenanceLogPartsFieldState();
}

class _MaintenanceLogPartsFieldState
    extends ConsumerState<MaintenanceLogPartsField> {
  late List<MaintenanceLogPart> _parts;

  @override
  void initState() {
    super.initState();
    _parts = [...widget.initialParts];
  }

  void _setParts(List<MaintenanceLogPart> parts) {
    setState(() => _parts = parts);
    widget.onChanged(parts);
  }

  Future<void> _openPicker() async {
    final result = await karterShowModalBottomSheet<List<MaintenanceLogPart>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PartPickerSheet(initialParts: _parts),
    );
    if (result != null && mounted) {
      ref.read(hapticProvider.notifier).selectionTap();
      _setParts(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.partsSection),
        if (_parts.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              l.noParts,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final part in _parts)
                InputChip(
                  avatar: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(_partLine(context, part)),
                  visualDensity: VisualDensity.compact,
                  onDeleted: () => _setParts(
                    _parts.where((p) => p.id != part.id).toList(),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _openPicker,
          icon: const Icon(Icons.add, size: 18),
          label: Text(l.addPart),
        ),
      ],
    );
  }

  String _partLine(BuildContext context, MaintenanceLogPart part) {
    return formatPartLine(
      name: part.name,
      formattedQuantity: IntervalPartsView.formatQuantity(part.quantity),
      unitLabel: IntervalPartsView.unitLabel(context, part.unit),
    );
  }
}

Future<VehiclePart?> showQuickCreatePartSheet(BuildContext context) {
  return karterShowModalBottomSheet<VehiclePart>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => const QuickCreatePartSheet(),
  );
}

class _PartPickerSheet extends ConsumerStatefulWidget {
  final List<MaintenanceLogPart> initialParts;

  const _PartPickerSheet({required this.initialParts});

  @override
  ConsumerState<_PartPickerSheet> createState() => _PartPickerSheetState();
}

class _PartPickerSheetState extends ConsumerState<_PartPickerSheet> {
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialParts
        .where((p) => p.partId != null)
        .map((p) => p.partId!)
        .toSet();
  }

  Future<void> _quickCreate() async {
    final created = await showQuickCreatePartSheet(context);
    if (created != null && mounted) {
      ref.read(hapticProvider.notifier).success();
      ref.invalidate(vehiclePartsProvider);
      setState(() => _selectedIds.add(created.id));
    }
  }

  void _save() {
    final all =
        ref.read(vehiclePartsProvider).value ?? const <VehiclePart>[];
    final parts = all
        .where((p) => _selectedIds.contains(p.id))
        .map((p) => MaintenanceLogPart(
              id: uuid.v4(),
              logId: '',
              partId: p.id,
              name: p.name,
              quantity: p.quantity,
              unit: p.unit,
              oemNumber: p.oemNumber,
              description: p.description,
              links: p.links,
            ))
        .toList();
    Navigator.pop(context, parts);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final partsAsync = ref.watch(vehiclePartsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(l.partsTitle, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: partsAsync.when(
              data: (parts) {
                if (parts.isEmpty && _selectedIds.isEmpty) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CreatePartTile(onTap: _quickCreate),
                        const SizedBox(height: 16),
                        Text(
                          l.noParts,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  children: [
                    _CreatePartTile(onTap: _quickCreate),
                    for (final part in parts)
                      CheckboxListTile(
                        value: _selectedIds.contains(part.id),
                        onChanged: (checked) => setState(() {
                          if (checked == true) {
                            _selectedIds.add(part.id);
                          } else {
                            _selectedIds.remove(part.id);
                          }
                        }),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(part.name),
                        subtitle: Text(
                          _partLine(context, part),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        dense: true,
                      ),
                  ],
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(l.saveChangesShort),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _partLine(BuildContext context, VehiclePart part) {
    final unit = IntervalPartsView.unitLabel(context, part.unit);
    final qty = IntervalPartsView.formatQuantity(part.quantity);
    final line = unit.isEmpty
        ? (part.quantity == 1 ? '' : '\u00d7 $qty')
        : '\u00d7 $qty $unit';
    final oem = part.oemNumber == null || part.oemNumber!.isEmpty
        ? ''
        : ' \u00b7 ${part.oemNumber}';
    return (line + oem).trim();
  }
}

class _CreatePartTile extends StatelessWidget {
  final VoidCallback onTap;

  const _CreatePartTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return ListTile(
      leading: Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
      title: Text(l.createPart),
      onTap: onTap,
    );
  }
}

class QuickCreatePartSheet extends ConsumerStatefulWidget {
  const QuickCreatePartSheet({super.key});

  @override
  ConsumerState<QuickCreatePartSheet> createState() =>
      _QuickCreatePartSheetState();
}

class _QuickCreatePartSheetState extends ConsumerState<QuickCreatePartSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1');
  final _oemController = TextEditingController();
  String? _unit;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _oemController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final part = VehiclePart(
        id: uuid.v4(),
        name: _nameController.text.trim(),
        quantity: double.tryParse(_qtyController.text.trim()) ?? 1,
        unit: _unit,
        oemNumber: _oemController.text.trim().isEmpty
            ? null
            : _oemController.text.trim(),
        createdAt: DateTime.now(),
      );
      await ref.read(vehiclePartRepositoryProvider).save(part);
      if (mounted) Navigator.pop(context, part);
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
              const DragHandle(),
              const SizedBox(height: 16),
              Text(l.newPart, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: l.partName),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? l.required : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: InputDecoration(labelText: l.quantity),
                      keyboardType: const TextInputType
                          .numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _unit,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l.partUnitLabel,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'unit',
                          child: Text(l.partUnitUnit),
                        ),
                        DropdownMenuItem(
                          value: 'set',
                          child: Text(l.partUnitSet),
                        ),
                        DropdownMenuItem(
                          value: 'kit',
                          child: Text(l.partUnitKit),
                        ),
                        DropdownMenuItem(
                          value: 'can',
                          child: Text(l.partUnitCan),
                        ),
                      ],
                      onChanged: (v) => setState(() => _unit = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _oemController,
                decoration: InputDecoration(labelText: l.oemNumber),
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
                    child: FilledButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
