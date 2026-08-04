import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/template_interval_builder.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/notification_permission_modal.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/widgets/karter_segmented_button.dart';
import 'package:url_launcher/url_launcher.dart';

class VehicleFormPage extends ConsumerStatefulWidget {
  final String? vehicleId;

  const VehicleFormPage({super.key, this.vehicleId});

  @override
  ConsumerState<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends ConsumerState<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  final _vinController = TextEditingController();
  final _odometerController = TextEditingController();
  final _aliasController = TextEditingController();

  String _brand = '';
  String _model = '';
  DistanceUnit _odometerUnit = DistanceUnit.kilometers;
  VolumeUnit _fuelVolumeUnit = VolumeUnit.liters;
  String _currency = 'USD';
  VehicleType _vehicleType = VehicleType.combustion;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _showAlias = false;
  bool _editingAlias = false;
  bool _hasUnsavedChanges = false;

  List<MaintenanceInterval>? _templateIntervals;
  String? _templateName;
  bool _validatingForSearch = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.vehicleId != null;
    if (_isEditing) {
      _loadVehicle();
    }
    ref.read(templateIndexProvider);
  }

  Future<void> _loadVehicle() async {
    final vehicle = await ref.read(vehicleProvider(widget.vehicleId!).future);
    if (vehicle != null && mounted) {
      setState(() {
        _brand = vehicle.brand;
        _model = vehicle.model;
        _yearController.text = vehicle.year.toString();
        _plateController.text = vehicle.plate?.value ?? '';
        _vinController.text = vehicle.vin?.code ?? '';
        _odometerController.text = vehicle.currentOdometer.distance
            .toStringAsFixed(0);
        _odometerUnit = vehicle.currentOdometer.unit;
        _fuelVolumeUnit = vehicle.fuelVolumeUnit;
        _currency = vehicle.currency;
        _vehicleType = vehicle.type;
        if (vehicle.alias != null && vehicle.alias!.isNotEmpty) {
          _showAlias = true;
          _aliasController.text = vehicle.alias!;
        }
      });
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _plateController.dispose();
    _vinController.dispose();
    _odometerController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_isEditing || widget.vehicleId == null) return;

    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l.deleteVehicle),
          content: Text(l.deleteVehicleConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              child: Text(l.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(vehicleRepositoryProvider);
      await repo.delete(widget.vehicleId!);
      _hasUnsavedChanges = false;
      ref.invalidate(vehicleListProvider);
      ref.invalidate(vehicleProvider(widget.vehicleId!));
      if (mounted) context.go('/');
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchTemplate() async {
    setState(() => _validatingForSearch = true);
    final valid = _formKey.currentState!.validate();
    setState(() => _validatingForSearch = false);
    if (!valid) return;

    final brand = _brand.trim();
    final model = _model.trim();
    final yearStr = _yearController.text.trim();

    final year = int.tryParse(yearStr);
    if (year == null) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(catalogRepositoryProvider);
      final resolution = await repo.findBestMatch(
        make: brand,
        model: model,
        year: year,
      );

      if (!mounted) return;

      if (resolution != null) {
        final intervals = resolution.items.map((r) {
          return intervalFromTemplate('', r, resolution);
        }).toList();

        final templateMeta = resolution.entry.meta;
        final name = [
          templateMeta.make,
          templateMeta.model,
          if (templateMeta.generation != null) templateMeta.generation,
        ].join(' ');

        final choice = await _showTemplatePreview(name, intervals);

        if (mounted) {
          setState(() {
            if (choice == 'template') {
              _templateIntervals = intervals;
              _templateName = name;
              _vehicleType = _typeFromIntervals(intervals);
              _markDirty();
            } else {
              _templateIntervals = null;
              _templateName = null;
            }
          });
        }
      } else {
        final searchParams = '$brand $model $year';
        await _showNoTemplateFound(searchParams);
        if (mounted) {
          setState(() {
            _templateIntervals = null;
            _templateName = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        final searchParams = '$brand $model $year';
        await _showTemplateError(searchParams);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _showTemplatePreview(
    String name,
    List<MaintenanceInterval> intervals,
  ) async {
    final result = await karterShowDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.templateFound),
              const SizedBox(height: 4),
              Text(
                name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: intervals.length,
              itemBuilder: (ctx, i) {
                final interval = intervals[i];
                final parts = <String>['${interval.kmInterval} km'];
                if (interval.monthsInterval != null) {
                  parts.add('${interval.monthsInterval} ${l.months}');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(interval.label),
                      subtitle: interval.description != null
                          ? Text(
                              interval.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: IntrinsicWidth(
                        child: Text(
                          parts.join(' / '),
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.end,
                          softWrap: false,
                        ),
                      ),
                    ),
                    if (interval.parts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.partsTitle.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 2),
                            IntervalPartsView(parts: interval.parts),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, 'defaults'),
                      child: Text(l.noTemplate),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx, 'template'),
                      child: Text(l.useTemplate),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    return result;
  }

  Future<void> _showTemplateError(String searchParams) async {
    await karterShowDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l.templateUnderConstruction),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.construction,
                    color: theme.colorScheme.primary,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(l.templateNotReady)),
                ],
              ),
              const SizedBox(height: 12),
              Text(l.contributionsWelcome, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'https://github.com/abrahdev/karter',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.requestedParam(searchParams),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () => launchUrl(
                Uri.parse('https://github.com/abrahdev/karter'),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.contributeOnGitHub),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.gotIt),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNoTemplateFound(String searchParams) async {
    await karterShowDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l.noResultsTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search_off,
                    color: theme.colorScheme.outline,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: Text(l.noTemplateFoundDescription)),
                ],
              ),
              const SizedBox(height: 16),
              Text(l.searchParameters, style: theme.textTheme.labelMedium),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  searchParams,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.defaultIntervalsHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.missingTemplateContribute,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton.icon(
              onPressed: () => launchUrl(
                Uri.parse('https://karter.abrah.dev/templates'),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.viewAllTemplates),
            ),
            OutlinedButton.icon(
              onPressed: () => launchUrl(
                Uri.parse('https://github.com/abrahdev/karter'),
                mode: LaunchMode.externalApplication,
              ),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.contribute),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.gotIt),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final id = _isEditing ? widget.vehicleId! : uuid.v4();
      final vehicle = Vehicle(
        id: id,
        brand: _brand.trim(),
        model: _model.trim(),
        year: int.parse(_yearController.text.trim()),
        alias: _showAlias ? _aliasController.text.trim() : null,
        createdAt: DateTime.now(),
        isSynced: false,
        type: _vehicleType,
        plate: _plateController.text.trim().isNotEmpty
            ? Plate(_plateController.text.trim())
            : null,
        vin: _vinController.text.trim().isNotEmpty
            ? Vin(_vinController.text.trim())
            : null,
        currentOdometer: Odometer(
          double.parse(_odometerController.text.trim()),
          _odometerUnit,
        ),
        fuelVolumeUnit: _fuelVolumeUnit,
        currency: _currency,
      );

      final repo = ref.read(vehicleRepositoryProvider);

      if (_templateIntervals != null) {
        final intervals = _templateIntervals!
            .map(
              (i) => MaintenanceInterval(
                id: uuid.v4(),
                vehicleId: id,
                label: i.label,
                i18nKey: i.i18nKey,
                descI18nKey: i.descI18nKey,
                kmInterval: i.kmInterval,
                monthsInterval: i.monthsInterval,
                description: i.description,
                isCustom: false,
                parts: i.parts,
              ),
            )
            .toList();
        await repo.save(
          vehicle,
          intervals: intervals,
          replaceNonCustom: _isEditing,
        );
      } else {
        await repo.save(vehicle);
      }

      _hasUnsavedChanges = false;
      ref.invalidate(vehicleListProvider);
      if (_isEditing) {
        ref.invalidate(vehicleProvider(widget.vehicleId!));
      }

      if (mounted) {
        context.pop();
        if (!_isEditing) {
          final service = ref.read(notificationServiceProvider);
          final enabled = await service.areNotificationsEnabled();
          if (mounted && !enabled) {
            showNotificationPermissionModal(context);
          }
        }
      }
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  VehicleType _typeFromIntervals(List<MaintenanceInterval> intervals) {
    final keys = intervals.map((i) => i.i18nKey).toSet();
    if (keys.contains('seed_interval_battery_cooling') ||
        keys.contains('seed_interval_inverter_coolant')) {
      return VehicleType.electric;
    }
    if (keys.contains('seed_interval_chain') ||
        keys.contains('seed_interval_valve_adjustment') ||
        keys.contains('seed_interval_drive_kit')) {
      return VehicleType.motorcycle;
    }
    return VehicleType.combustion;
  }

  void _markDirty() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
  }

  InputDecoration _fieldDecoration(String label, {String? hintText}) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (!_isEditing || !_hasUnsavedChanges) return true;
    final result = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l.unsavedChanges),
          content: Text(l.discardChangesConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.discard),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final composite =
        '${_brand.trim()} '
                '${_model.trim()} '
                '${_yearController.text.trim()}'
            .trim();

    return PopScope(
      canPop: !(_isEditing && _hasUnsavedChanges),
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onBackPressed();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l.vehicleFormEdit : l.vehicleFormNew),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: [
              if (composite.isNotEmpty || _showAlias || _editingAlias)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (composite.isNotEmpty)
                              Text(
                                composite,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (_showAlias && _aliasController.text.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  _aliasController.text,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_showAlias)
                        IconButton(
                          tooltip: l.resetToDefault,
                          icon: const Icon(Icons.settings_backup_restore),
                          onPressed: () => setState(() {
                            _aliasController.clear();
                            _showAlias = false;
                            _editingAlias = false;
                            _markDirty();
                          }),
                        ),
                      IconButton(
                        tooltip: l.edit,
                        icon: Icon(_editingAlias ? Icons.check : Icons.edit),
                        onPressed: () => setState(() {
                          if (_editingAlias &&
                              _aliasController.text.trim().isEmpty) {
                            _showAlias = false;
                          } else {
                            _showAlias = true;
                          }
                          _editingAlias = !_editingAlias;
                          _markDirty();
                        }),
                      ),
                    ],
                  ),
                ),
              if (_editingAlias)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _aliasController,
                    autofocus: true,
                    decoration: _fieldDecoration(
                      l.aliasOptional,
                      hintText: l.aliasHint,
                    ),
                    onChanged: (_) => _markDirty(),
                    onFieldSubmitted: (_) => setState(() {
                      if (_aliasController.text.trim().isNotEmpty) {
                        _showAlias = true;
                      } else {
                        _showAlias = false;
                        _editingAlias = false;
                      }
                    }),
                  ),
                ),

              // ── Vehicle Type ──
              SectionHeader(title: l.vehicleType),
              AbsorbPointer(
                absorbing: _templateIntervals != null,
                child: KarterSegmentedButton<VehicleType>(
                  segments: [
                    ButtonSegment(
                      value: VehicleType.combustion,
                      icon: const Icon(Icons.local_gas_station),
                    ),
                    ButtonSegment(
                      value: VehicleType.electric,
                      icon: const Icon(Icons.electric_car),
                    ),
                    ButtonSegment(
                      value: VehicleType.motorcycle,
                      icon: const Icon(Icons.motorcycle),
                    ),
                  ],
                  selected: {_vehicleType},
                  onSelectionChanged: (v) => setState(() {
                    _vehicleType = v.first;
                    _markDirty();
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  switch (_vehicleType) {
                    VehicleType.combustion => l.combustion,
                    VehicleType.electric => l.electric,
                    VehicleType.motorcycle => l.motorcycle,
                  },
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              // ── Vehicle ──
              SectionHeader(title: l.vehicleFormVehicle),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: _brand),
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty) return [];
                      final query = textEditingValue.text;
                      final index = ref.read(templateIndexProvider).value;
                      final suggestions = <String>{};
                      if (index != null) {
                        suggestions.addAll(
                          index.templates
                              .where((e) => e.meta.make != '_base')
                              .map((e) => e.meta.make)
                              .toSet()
                              .where(
                                (m) => m.toLowerCase().contains(
                                  query.toLowerCase(),
                                ),
                              ),
                        );
                      }
                      suggestions.add(query);
                      return suggestions.toList()..sort();
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: _fieldDecoration(l.brand),
                            onChanged: (value) {
                              _brand = value;
                              _hasUnsavedChanges = true;
                            },
                            validator: (v) => v == null || v.trim().isEmpty
                                ? l.required
                                : null,
                          );
                        },
                    onSelected: (value) {
                      _brand = value;
                    },
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final modelField = Autocomplete<String>(
                        initialValue: TextEditingValue(text: _model),
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text.isEmpty) return [];
                          final query = textEditingValue.text;
                          final index = ref.read(templateIndexProvider).value;
                          final suggestions = <String>{};
                          if (index != null && _brand.isNotEmpty) {
                            suggestions.addAll(
                              index.templates
                                  .where(
                                    (e) =>
                                        e.meta.make.toLowerCase() ==
                                            _brand.toLowerCase() &&
                                        e.meta.model.toLowerCase().contains(
                                          query.toLowerCase(),
                                        ),
                                  )
                                  .map((e) => e.meta.model)
                                  .toSet(),
                            );
                          }
                          suggestions.add(query);
                          return suggestions.toList()..sort();
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onSubmitted) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: _fieldDecoration(l.model),
                                onChanged: (value) {
                                  _model = value;
                                  _hasUnsavedChanges = true;
                                },
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? l.required
                                    : null,
                              );
                            },
                        onSelected: (value) {
                          _model = value;
                        },
                      );
                      final yearField = TextFormField(
                        controller: _yearController,
                        decoration: _fieldDecoration(l.year),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _markDirty(),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return l.required;
                          final year = int.tryParse(v);
                          if (year == null ||
                              year < 1886 ||
                              year > DateTime.now().year + 1) {
                            return l.invalidYear;
                          }
                          return null;
                        },
                      );
                      if (constraints.maxWidth >= 320) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: modelField),
                            const SizedBox(width: 12),
                            Expanded(flex: 2, child: yearField),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          modelField,
                          const SizedBox(height: 12),
                          yearField,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _searchTemplate,
                icon: _templateIntervals != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.search),
                label: Text(
                  _templateIntervals != null
                      ? AppLocalizations.of(
                          context,
                        )!.templateWithName(_templateName ?? '')
                      : AppLocalizations.of(context)!.searchTemplate,
                ),
              ),
              const SizedBox(height: 8),

              // ── Details ──
              SectionHeader(title: l.vehicleFormDetails),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _plateController,
                    decoration: _fieldDecoration(l.plateOptional),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => _markDirty(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vinController,
                    decoration: _fieldDecoration(l.vinOptional),
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 17,
                    onChanged: (_) => _markDirty(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              // ── Units ──
              SectionHeader(title: l.odometer),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _odometerController,
                          decoration: _fieldDecoration(l.odometer),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _markDirty(),
                          validator: (v) {
                            if (_validatingForSearch) return null;
                            if (v == null || v.trim().isEmpty) {
                              return l.required;
                            }
                            final num = double.tryParse(v);
                            if (num == null || num < 0) return l.invalid;
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      KarterSegmentedButton<DistanceUnit>(
                        segments: [
                          ButtonSegment(
                            value: DistanceUnit.kilometers,
                            label: Text(l.unitKm),
                          ),
                          ButtonSegment(
                            value: DistanceUnit.miles,
                            label: Text(l.unitMi),
                          ),
                        ],
                        selected: {_odometerUnit},
                        onSelectionChanged: (v) => setState(() {
                          _odometerUnit = v.first;
                          _markDirty();
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: KarterSegmentedButton<VolumeUnit>(
                          segments: [
                            ButtonSegment(
                              value: VolumeUnit.liters,
                              label: Text(l.unitL),
                            ),
                            ButtonSegment(
                              value: VolumeUnit.gallons,
                              label: Text(l.unitGal),
                            ),
                          ],
                          selected: {_fuelVolumeUnit},
                          onSelectionChanged: (v) => setState(() {
                            _fuelVolumeUnit = v.first;
                            _markDirty();
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _currency,
                    decoration: _fieldDecoration(l.currency),
                    items: Vehicle.currencies
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text('${Vehicle.currencySymbol(c)}  $c'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          _currency = v;
                          _markDirty();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              // ── Actions ──
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const M3LoadingIndicator(size: 20)
                    : Text(_isEditing ? l.saveChanges : l.addVehicle),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _isLoading ? null : _delete,
                  icon: const Icon(Icons.delete),
                  label: Text(l.deleteVehicle),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
