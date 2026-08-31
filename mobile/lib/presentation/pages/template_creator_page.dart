import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/data/services/template_validator.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/widgets/template_autocomplete_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

const kBaseTemplateOptions = <(String, String)>[
  ('_base/car-common.json', '_base/car-common.json'),
  ('_base/car-combustion.json', '_base/car-combustion.json'),
  ('_base/car-diesel.json', '_base/car-diesel.json'),
  ('_base/car-electric.json', '_base/car-electric.json'),
  ('_base/motorcycle-common.json', '_base/motorcycle-common.json'),
  ('_base/motorcycle-2t.json', '_base/motorcycle-2t.json (2-stroke)'),
  ('_base/motorcycle-4t.json', '_base/motorcycle-4t.json (4-stroke)'),
  ('_base/motorcycle-ev.json', '_base/motorcycle-ev.json (electric)'),
];

const _fuelOptions = <(String, String)>[
  ('gasoline', 'Gasoline'),
  ('diesel', 'Diesel'),
  ('lpg', 'LPG'),
  ('cng', 'CNG'),
  ('hydrogen', 'Hydrogen'),
  ('ethanol', 'Ethanol'),
];

const _powertrainOptions = <(String, String)>[
  ('combustion', 'Combustion'),
  ('hybrid', 'Hybrid'),
  ('plugin-hybrid', 'Plugin Hybrid'),
  ('electric', 'Electric'),
];

const _unitOptions = <(String, String)>[
  ('unit', 'unit'),
  ('set', 'set'),
  ('L', 'L'),
  ('ml', 'ml'),
  ('g', 'g'),
  ('kg', 'kg'),
  ('kit', 'kit'),
  ('can', 'can'),
  ('m', 'm'),
];

String _slug(String value) {
  final slugified = value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slugified;
}

class _PartDraft {
  String id = '';
  String name = '';
  String i18nKey = '';
  String oemNumber = '';
  String quantity = '';
  String unit = 'unit';
  bool remove = false;
}

class _PartRefDraft {
  String partId = '';
  String quantity = '';
}

class _ItemDraft {
  String label = '';
  String id = '';
  String intervalKm = '';
  String intervalMonths = '';
  String description = '';
  String i18nKey = '';
  String descI18nKey = '';
  bool remove = false;
  final List<_PartRefDraft> parts = [];
}

class TemplateCreatorPage extends ConsumerStatefulWidget {
  const TemplateCreatorPage({super.key});

  @override
  ConsumerState<TemplateCreatorPage> createState() =>
      _TemplateCreatorPageState();
}

class _TemplateCreatorPageState extends ConsumerState<TemplateCreatorPage> {
  String _make = '';
  String _model = '';
  final _generation = TextEditingController();
  final _yearsFrom = TextEditingController();
  final _yearsTo = TextEditingController();
  final _engineCode = TextEditingController();
  final _engineDisplacement = TextEditingController();
  final _enginePower = TextEditingController();
  final _author = TextEditingController();
  final _version = TextEditingController(text: '1.0.0');
  final _customExtends = TextEditingController();

  String _fuel = '';
  String _powertrain = '';

  final Set<String> _extendsSelected = {};
  final List<_PartDraft> _parts = [];
  final List<_ItemDraft> _items = [];
  List<InheritedItem> _inheritedItems = [];
  List<InheritedPart> _inheritedParts = [];
  List<String> _inheritedFailed = [];
  Timer? _extendsDebounce;
  int _extendsRequestId = 0;

  @override
  void initState() {
    super.initState();
    ref.read(onlineTemplateIndexProvider);
    ref.read(onlineTemplateBaseUrlProvider);
  }

  @override
  void dispose() {
    _extendsDebounce?.cancel();
    _generation.dispose();
    _yearsFrom.dispose();
    _yearsTo.dispose();
    _engineCode.dispose();
    _engineDisplacement.dispose();
    _enginePower.dispose();
    _author.dispose();
    _version.dispose();
    _customExtends.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildJson() {
    final meta = <String, dynamic>{};
    final make = _make.trim();
    final model = _model.trim();
    if (make.isNotEmpty) meta['make'] = make;
    if (model.isNotEmpty) meta['model'] = model;
    final generation = _generation.text.trim();
    if (generation.isNotEmpty) meta['generation'] = generation;

    final from = int.tryParse(_yearsFrom.text.trim());
    final to = int.tryParse(_yearsTo.text.trim());
    if (from != null || to != null) meta['years'] = [from ?? 2000, to ?? 2030];

    final engine = <String, dynamic>{};
    if (_engineCode.text.trim().isNotEmpty) {
      engine['code'] = _engineCode.text.trim();
    }
    if (_fuel.isNotEmpty) engine['fuel'] = _fuel;
    if (_powertrain.isNotEmpty) engine['powertrain'] = _powertrain;
    final displacement = int.tryParse(_engineDisplacement.text.trim());
    if (displacement != null) engine['displacement_cc'] = displacement;
    final power = int.tryParse(_enginePower.text.trim());
    if (power != null) engine['power_hp'] = power;
    if (engine.isNotEmpty) meta['engine'] = engine;

    meta['author'] =
        _author.text.trim().isEmpty ? 'your-username' : _author.text.trim();
    meta['version'] =
        _version.text.trim().isEmpty ? '1.0.0' : _version.text.trim();

    final result = <String, dynamic>{
      'id': _templateId(make, model),
      'meta': meta,
    };

    final extendsList = <String>[
      ..._extendsSelected,
      ..._customExtends.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty),
    ];
    if (extendsList.isNotEmpty) result['extends'] = extendsList;

    final parts = <Map<String, dynamic>>[];
    for (final part in _parts) {
      final id = part.id.trim();
      if (id.isEmpty) continue;
      if (part.remove) {
        parts.add({'id': id, 'remove': true});
        continue;
      }
      final entry = <String, dynamic>{'id': id};
      if (part.name.trim().isNotEmpty) entry['name'] = part.name.trim();
      if (part.i18nKey.trim().isNotEmpty) {
        entry['i18n_key'] = part.i18nKey.trim();
      }
      if (part.oemNumber.trim().isNotEmpty) {
        entry['oem_number'] = part.oemNumber.trim();
      }
      final quantity = double.tryParse(part.quantity.trim());
      if (quantity != null) entry['quantity'] = quantity;
      if (part.unit.isNotEmpty) entry['unit'] = part.unit;
      parts.add(entry);
    }
    if (parts.isNotEmpty) result['parts'] = parts;

    final items = <Map<String, dynamic>>[];
    for (final item in _items) {
      final id = item.id.trim().isEmpty
          ? _slug(item.label)
          : item.id.trim();
      if (id.isEmpty) continue;
      if (item.remove) {
        items.add({'id': id, 'remove': true});
        continue;
      }
      final entry = <String, dynamic>{'id': id};
      final km = int.tryParse(item.intervalKm.trim());
      if (km != null) entry['interval_km'] = km;
      final months = int.tryParse(item.intervalMonths.trim());
      if (months != null) entry['interval_months'] = months;
      if (item.label.trim().isNotEmpty) entry['label'] = item.label.trim();
      if (item.i18nKey.trim().isNotEmpty) {
        entry['i18n_key'] = item.i18nKey.trim();
      }
      if (item.descI18nKey.trim().isNotEmpty) {
        entry['desc_i18n_key'] = item.descI18nKey.trim();
      }
      if (item.description.trim().isNotEmpty) {
        entry['description'] = item.description.trim();
      }
      final refs = <Map<String, dynamic>>[];
      for (final ref in item.parts) {
        if (ref.partId.trim().isEmpty) continue;
        final refEntry = <String, dynamic>{'part_id': ref.partId.trim()};
        final quantity = double.tryParse(ref.quantity.trim());
        if (quantity != null) refEntry['quantity'] = quantity;
        refs.add(refEntry);
      }
      if (refs.isNotEmpty) entry['parts'] = refs;
      items.add(entry);
    }
    if (items.isNotEmpty) result['maintenance_items'] = items;

    return result;
  }

  String _templateId(String make, String model) {
    final m = make.isEmpty ? 'yourmake' : make;
    final mo = model.isEmpty ? 'yourmodel' : model;
    return '${_slug(m)}-${_slug(mo)}';
  }

  String? _prettyJson() {
    final errors = TemplateValidator.validate(_buildJson());
    if (errors.isNotEmpty) return null;
    return const JsonEncoder.withIndent('  ').convert(_buildJson());
  }

  Future<void> _copy() async {
    final l = AppLocalizations.of(context)!;
    final pretty = _prettyJson();
    if (pretty == null) {
      _showErrors();
      return;
    }
    await Clipboard.setData(ClipboardData(text: pretty));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.createCopied)),
    );
  }

  Future<void> _share() async {
    final l = AppLocalizations.of(context)!;
    final pretty = _prettyJson();
    if (pretty == null) {
      _showErrors();
      return;
    }
    await SharePlus.instance.share(
      ShareParams(text: pretty, subject: l.createTemplate),
    );
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final pretty = _prettyJson();
    if (pretty == null) {
      _showErrors();
      return;
    }
    final fileName = '${_templateId(_make, _model)}.json';

    if (!Platform.isLinux) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(pretty);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: l.createTemplate),
      );
      return;
    }

    final path = await FilePicker.saveFile(
      dialogTitle: l.saveTemplate,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: Uint8List.fromList(utf8.encode(pretty)),
    );
    if (path != null && mounted) {
      await File(path.toFilePath()).writeAsString(pretty);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.savedAt(path.toFilePath()))),
        );
      }
    }
  }

  void _showErrors() {
    final l = AppLocalizations.of(context)!;
    final errors = TemplateValidator.validate(_buildJson());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l.createHasErrors} (${errors.length})'),
      ),
    );
  }

  void _setState() => setState(() {});

  List<String> _computedExtends() {
    final index = ref.read(onlineTemplateIndexProvider).value;
    if (index == null) return const [];
    final make = _make.trim().toLowerCase();
    final model = _model.trim().toLowerCase();
    if (make.isEmpty || model.isEmpty) return const [];
    final result = <String>{};
    for (final entry in index.templates) {
      if (entry.meta.make.toLowerCase() != make) continue;
      if (entry.meta.model.toLowerCase() != model) continue;
      result.addAll(entry.extendsPaths);
    }
    return result.toList();
  }

  List<String> _activeExtends() {
    return <String>[
      ..._extendsSelected,
      ..._customExtends.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty),
    ];
  }

  Future<void> _reloadInherited() async {
    final id = ++_extendsRequestId;
    String? baseUrl;
    try {
      baseUrl = await ref.read(onlineTemplateBaseUrlProvider.future);
    } catch (_) {}
    final content = await ref
        .read(templateResolverProvider)
        .resolveExtendsChain(_activeExtends(), baseUrl: baseUrl);
    if (!mounted || id != _extendsRequestId) return;
    setState(() {
      _inheritedItems = content.items;
      _inheritedParts = content.parts;
      _inheritedFailed = content.failedPaths;
    });
  }

  void _onMakeModelChanged(String value, bool isMake) {
    if (isMake) {
      _make = value;
    } else {
      _model = value;
    }
    final computed = _computedExtends();
    if (computed.isNotEmpty) {
      _extendsSelected
        ..clear()
        ..addAll(computed);
    }
    _setState();
    _reloadInherited();
  }

  void _toggleExtend(String path, bool selected) {
    setState(() {
      if (selected) {
        _extendsSelected.add(path);
      } else {
        _extendsSelected.remove(path);
      }
    });
    _reloadInherited();
  }

  void _onCustomExtendsChanged() {
    _setState();
    _extendsDebounce?.cancel();
    _extendsDebounce = Timer(
      const Duration(milliseconds: 300),
      _reloadInherited,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final errors = TemplateValidator.validate(_buildJson());
    final json = _prettyJson();

    return Scaffold(
      appBar: AppBar(title: Text(l.createTemplate)),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          final form = SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRepoSource(l),
                const SizedBox(height: 8),
                _buildVehicleInfo(l),
                _buildEngine(l),
                _buildMetadata(l),
                _buildParts(l),
                _buildItems(l),
              ],
            ),
          );

          final preview = _buildPreview(l, errors, json);

          if (!isWide) {
            return ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                form,
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePadding,
                  ),
                  child: preview,
                ),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: form),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: preview),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepoSource(AppLocalizations l) {
    final theme = Theme.of(context);
    final config = ref.watch(templateSourceProvider);
    final indexState = ref.watch(onlineTemplateIndexProvider);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.cloud_outlined, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      config.repoUrl,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  if (indexState.isLoading)
                    Text(
                      l.templateRepoLoading,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (indexState.hasError)
                    Text(
                      l.templateRepoError,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfo(AppLocalizations l) {
    final onlineIndex = ref.watch(onlineTemplateIndexProvider).value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.templateInfo),
        const SizedBox(height: 8),
        KarterAutocompleteField(
          label: l.createMake,
          hint: 'Toyota',
          initialValue: _make,
          index: onlineIndex,
          optionsBuilder: (query, index) {
            final suggestions = <String>{};
            if (index != null) {
              suggestions.addAll(
                index.templates
                    .where((e) => e.meta.make != '_base')
                    .map((e) => e.meta.make)
                    .toSet()
                    .where(
                      (m) => m.toLowerCase().contains(query.toLowerCase()),
                    ),
              );
            }
            suggestions.add(query);
            return suggestions.toList()..sort();
          },
          onChanged: (value) => _onMakeModelChanged(value, true),
        ),
        const SizedBox(height: 12),
        KarterAutocompleteField(
          label: l.createModel,
          hint: 'Corolla',
          initialValue: _model,
          index: onlineIndex,
          optionsBuilder: (query, index) {
            final suggestions = <String>{};
            if (index != null && _make.isNotEmpty) {
              suggestions.addAll(
                index.templates
                    .where(
                      (e) =>
                          e.meta.make.toLowerCase() == _make.toLowerCase(),
                    )
                    .where(
                      (e) => e.meta.model.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                    )
                    .map((e) => e.meta.model),
              );
            }
            suggestions.add(query);
            return suggestions.toList()..sort();
          },
          onChanged: (value) => _onMakeModelChanged(value, false),
        ),
        const SizedBox(height: 12),
        _textTile(
          controller: _generation,
          label: l.createGeneration,
          hint: 'E210',
          onChanged: _setState,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _textTile(
                controller: _yearsFrom,
                label: l.createYearFrom,
                hint: '2019',
                keyboardType: TextInputType.number,
                onChanged: _setState,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textTile(
                controller: _yearsTo,
                label: l.createYearTo,
                hint: '2024',
                keyboardType: TextInputType.number,
                onChanged: _setState,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEngine(AppLocalizations l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.templateEngine),
        const SizedBox(height: 8),
        _selectTile(
          label: l.createFuel,
          value: _fuel,
          options: _fuelOptions,
          onChanged: (v) {
            _fuel = v;
            setState(() {});
          },
        ),
        const SizedBox(height: 12),
        _selectTile(
          label: l.createPowertrain,
          value: _powertrain,
          options: _powertrainOptions,
          onChanged: (v) {
            _powertrain = v;
            setState(() {});
          },
        ),
        const SizedBox(height: 12),
        _textTile(
          controller: _engineCode,
          label: l.createEngineCode,
          hint: 'M20A-FKS',
          onChanged: _setState,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _textTile(
                controller: _engineDisplacement,
                label: l.createDisplacement,
                hint: '1987',
                keyboardType: TextInputType.number,
                onChanged: _setState,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _textTile(
                controller: _enginePower,
                label: l.createPower,
                hint: '169',
                keyboardType: TextInputType.number,
                onChanged: _setState,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetadata(AppLocalizations l) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.templateMetadata),
        const SizedBox(height: 8),
        _textTile(
          controller: _author,
          label: l.createAuthor,
          hint: l.createAuthorHint,
          onChanged: _setState,
        ),
        const SizedBox(height: 12),
        _textTile(
          controller: _version,
          label: l.templateVersion,
          hint: '1.0.0',
          onChanged: _setState,
        ),
        const SizedBox(height: 12),
        Text(
          l.createExtends,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final (value, label) in kBaseTemplateOptions)
              FilterChip(
                label: Text(label),
                selected: _extendsSelected.contains(value),
                onSelected: (selected) => _toggleExtend(value, selected),
              ),
            for (final path in _extendsSelected)
              if (!kBaseTemplateOptions.any((o) => o.$1 == path))
                FilterChip(
                  label: Text(path),
                  selected: true,
                  onSelected: (selected) => _toggleExtend(path, selected),
                ),
          ],
        ),
        if (_inheritedFailed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l.templateExtendsNotLoaded,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        const SizedBox(height: 12),
        _textTile(
          controller: _customExtends,
          label: l.createCustomExtends,
          hint: 'audi/a3/base.json, _base/dtc.json',
          onChanged: _onCustomExtendsChanged,
        ),
      ],
    );
  }

  Widget _buildParts(AppLocalizations l) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.partsTitle),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_inheritedParts.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    l.createInheritedParts,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                for (final inherited in _inheritedParts)
                  _InheritedPartRow(inherited: inherited),
                const Divider(height: 24),
              ],
              for (var i = 0; i < _parts.length; i++)
                _PartEditor(
                  key: ObjectKey(_parts[i]),
                  draft: _parts[i],
                  onChanged: _setState,
                  onDelete: () => setState(() => _parts.removeAt(i)),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _parts.add(_PartDraft())),
                    icon: const Icon(Icons.add),
                    label: Text(l.createAddPart),
                  ),
                ),
              ),
              if (_parts.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    l.createNoParts,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItems(AppLocalizations l) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.maintenanceListTitle),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_inheritedItems.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    l.createInheritedItems,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
                for (final inherited in _inheritedItems)
                  _InheritedItemRow(inherited: inherited),
                const Divider(height: 24),
              ],
              for (var i = 0; i < _items.length; i++)
                _ItemEditor(
                  key: ObjectKey(_items[i]),
                  draft: _items[i],
                  partIds: _parts
                      .where((p) => !p.remove)
                      .map((p) => p.id.trim())
                      .where((id) => id.isNotEmpty)
                      .toList(),
                  onChanged: _setState,
                  onDelete: () => setState(() => _items.removeAt(i)),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _items.add(_ItemDraft())),
                    icon: const Icon(Icons.add),
                    label: Text(l.createAddItem),
                  ),
                ),
              ),
              if (_items.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    l.createNoItems,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(
    AppLocalizations l,
    List<String> errors,
    String? json,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.createPreview),
        if (errors.isNotEmpty)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.createErrorsFound(errors.length),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 4),
                for (final error in errors)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      error,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _copy,
                icon: const Icon(Icons.copy, size: 18),
                label: Text(l.createCopy),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _share,
                icon: const Icon(Icons.share, size: 18),
                label: Text(l.createShare),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined, size: 18),
                label: Text(l.createSave),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 420),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: SelectableText(
              json ?? '{}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textTile({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    required VoidCallback onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      keyboardType: keyboardType,
      onChanged: (_) => onChanged(),
    );
  }

  Widget _selectTile({
    required String label,
    required String value,
    required List<(String, String)> options,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem<String>(
          value: '',
          child: Text('—'),
        ),
        for (final (optionValue, optionLabel) in options)
          DropdownMenuItem<String>(
            value: optionValue,
            child: Text(optionLabel),
          ),
      ],
      onChanged: (v) => onChanged(v ?? ''),
    );
  }
}

class _PartEditor extends StatefulWidget {
  const _PartEditor({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onDelete,
  });

  final _PartDraft draft;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  State<_PartEditor> createState() => _PartEditorState();
}

class _PartEditorState extends State<_PartEditor> {
  late final _id = TextEditingController(text: widget.draft.id);
  late final _name = TextEditingController(text: widget.draft.name);
  late final _i18nKey = TextEditingController(text: widget.draft.i18nKey);
  late final _oem = TextEditingController(text: widget.draft.oemNumber);
  late final _quantity = TextEditingController(text: widget.draft.quantity);

  @override
  void dispose() {
    _id.dispose();
    _name.dispose();
    _i18nKey.dispose();
    _oem.dispose();
    _quantity.dispose();
    super.dispose();
  }

  void _update() {
    widget.draft.id = _id.text;
    widget.draft.name = _name.text;
    widget.draft.i18nKey = _i18nKey.text;
    widget.draft.oemNumber = _oem.text;
    widget.draft.quantity = _quantity.text;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${l.partSingular} ${widget.draft.id.isEmpty ? '—' : widget.draft.id}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          TextField(
            controller: _id,
            decoration: InputDecoration(isDense: true, labelText: l.createFieldId),
            onChanged: (_) => _update(),
          ),
          TextField(
            controller: _name,
            decoration: InputDecoration(isDense: true, labelText: l.createFieldName),
            onChanged: (_) => _update(),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantity,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l.createQuantity,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _update(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: widget.draft.unit,
                  decoration: InputDecoration(isDense: true, labelText: l.createFieldUnit),
                  items: [
                    for (final (value, label) in _unitOptions)
                      DropdownMenuItem(value: value, child: Text(label)),
                  ],
                  onChanged: (v) {
                    widget.draft.unit = v ?? 'unit';
                    _update();
                  },
                ),
              ),
            ],
          ),
          TextField(
            controller: _oem,
            decoration: InputDecoration(isDense: true, labelText: l.createFieldOem),
            onChanged: (_) => _update(),
          ),
          TextField(
            controller: _i18nKey,
            decoration: InputDecoration(
              isDense: true,
              labelText: l.createI18nKey,
            ),
            onChanged: (_) => _update(),
          ),
        ],
      ),
    );
  }
}

class _ItemEditor extends StatefulWidget {
  const _ItemEditor({
    super.key,
    required this.draft,
    required this.partIds,
    required this.onChanged,
    required this.onDelete,
  });

  final _ItemDraft draft;
  final List<String> partIds;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  State<_ItemEditor> createState() => _ItemEditorState();
}

class _ItemEditorState extends State<_ItemEditor> {
  late final _label = TextEditingController(text: widget.draft.label);
  late final _id = TextEditingController(text: widget.draft.id);
  late final _km = TextEditingController(text: widget.draft.intervalKm);
  late final _months = TextEditingController(text: widget.draft.intervalMonths);
  late final _description = TextEditingController(text: widget.draft.description);
  late final _i18nKey = TextEditingController(text: widget.draft.i18nKey);
  late final _descI18nKey = TextEditingController(text: widget.draft.descI18nKey);

  @override
  void dispose() {
    _label.dispose();
    _id.dispose();
    _km.dispose();
    _months.dispose();
    _description.dispose();
    _i18nKey.dispose();
    _descI18nKey.dispose();
    super.dispose();
  }

  void _update() {
    widget.draft.label = _label.text;
    widget.draft.id = _id.text;
    widget.draft.intervalKm = _km.text;
    widget.draft.intervalMonths = _months.text;
    widget.draft.description = _description.text;
    widget.draft.i18nKey = _i18nKey.text;
    widget.draft.descI18nKey = _descI18nKey.text;
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final autoId = widget.draft.id.trim().isEmpty
        ? _slug(_label.text)
        : widget.draft.id.trim();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  autoId.isEmpty ? '—' : autoId,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          TextField(
            controller: _label,
            decoration: InputDecoration(isDense: true, labelText: l.createFieldLabel),
            onChanged: (_) => _update(),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _km,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l.createIntervalKm,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _update(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _months,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l.createIntervalMonths,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _update(),
                ),
              ),
            ],
          ),
          TextField(
            controller: _description,
            decoration: InputDecoration(
              isDense: true,
              labelText: l.createDescription,
            ),
            onChanged: (_) => _update(),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _i18nKey,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l.createI18nKey,
                  ),
                  onChanged: (_) => _update(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _descI18nKey,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: l.createDescI18nKey,
                  ),
                  onChanged: (_) => _update(),
                ),
              ),
            ],
          ),
          for (var i = 0; i < widget.draft.parts.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: widget.draft.parts[i].partId,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: l.createFieldPart,
                      ),
                      items: [
                        for (final id in widget.partIds)
                          DropdownMenuItem(value: id, child: Text(id)),
                      ],
                      onChanged: (v) {
                        widget.draft.parts[i].partId = v ?? '';
                        _update();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: widget.draft.parts[i].quantity,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: l.createQuantity,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        widget.draft.parts[i].quantity = v;
                        _update();
                      },
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() => widget.draft.parts.removeAt(i));
                      _update();
                    },
                  ),
                ],
              ),
            ),
          if (widget.partIds.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() => widget.draft.parts.add(_PartRefDraft()));
                  _update();
                },
                icon: const Icon(Icons.add_link, size: 18),
                label: Text(l.createAddPartRef),
              ),
            ),
        ],
      ),
    );
  }
}

String _originLabel(String origin) {
  final slash = origin.lastIndexOf('/');
  return slash == -1 ? origin : origin.substring(slash + 1);
}

class _InheritedPartRow extends StatelessWidget {
  const _InheritedPartRow({required this.inherited});

  final InheritedPart inherited;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final part = inherited.part;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.name ?? part.id,
                  style: theme.textTheme.bodyMedium,
                ),
                if (part.oemNumber != null && part.oemNumber!.isNotEmpty)
                  Text(
                    '${part.id} · ${part.oemNumber}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Text(
                    part.id,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: inherited.origin,
            child: Chip(
              visualDensity: VisualDensity.compact,
              label: Text(_originLabel(inherited.origin)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InheritedItemRow extends StatelessWidget {
  const _InheritedItemRow({required this.inherited});

  final InheritedItem inherited;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final item = inherited.item;
    final parts = <String>[l.intervalSubtitleKm(item.intervalKm)];
    if (item.intervalMonths != null) {
      parts.add(l.intervalSubtitleMonths(item.intervalMonths.toString()));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  item.id,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  parts.join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: inherited.origin,
            child: Chip(
              visualDensity: VisualDensity.compact,
              label: Text(_originLabel(inherited.origin)),
            ),
          ),
        ],
      ),
    );
  }
}