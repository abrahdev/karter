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
import 'package:mobile/presentation/widgets/notification_permission_modal.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/widgets/template_autocomplete_field.dart';
import 'package:mobile/presentation/widgets/karter_segmented_button.dart';
import 'package:mobile/presentation/widgets/new_vehicle_overdue_modal.dart';
import 'package:mobile/presentation/widgets/template_search_modal.dart';

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
    if (vehicle == null || !mounted) return;
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

    final intervals = await ref
        .read(maintenanceIntervalsProvider(widget.vehicleId!).future);
    if (!mounted) return;
    final templateIntervals = intervals.where((i) => !i.isCustom).toList();
    if (templateIntervals.isEmpty) return;
    final resolution =
        await ref.read(templateResolutionProvider(widget.vehicleId!).future);
    if (!mounted) return;
    String? name;
    if (resolution != null) {
      final meta = resolution.entry.meta;
      name = [
        meta.make,
        meta.model,
        if (meta.generation != null) meta.generation,
      ].join(' ');
    }
    setState(() {
      _templateIntervals = templateIntervals;
      _templateName = name;
    });
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

    final year = int.tryParse(_yearController.text.trim());
    if (year == null) return;

    final outcome = await showTemplateSearchModal(
      context,
      brand: _brand.trim(),
      model: _model.trim(),
      year: year,
    );

    if (!mounted || outcome == null) return;

    setState(() {
      if (outcome.apply) {
        _templateIntervals = outcome.intervals;
        _templateName = outcome.name;
        _vehicleType = typeFromIntervals(outcome.intervals!);
        _markDirty();
      } else {
        _templateIntervals = null;
        _templateName = null;
      }
    });
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
        ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId!));
      }

      if (mounted) {
        context.pop();
        if (!_isEditing) {
          final distanceKm = _odometerUnit == DistanceUnit.kilometers
              ? double.parse(_odometerController.text.trim())
              : double.parse(_odometerController.text.trim()) * 1.60934;
          if (distanceKm > 500) {
            showNewVehicleServicesOverdueModal(context);
          }
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

  void _markDirty() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
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
                    decoration: InputDecoration(
                      labelText: l.aliasOptional,
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
                  KarterAutocompleteField(
                    label: l.brand,
                    initialValue: _brand,
                    optionsBuilder: (query, index) {
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
                    onChanged: (value) {
                      _brand = value;
                      _hasUnsavedChanges = true;
                    },
                    validator: (v) => v == null || v.trim().isEmpty
                        ? l.required
                        : null,
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final modelField = KarterAutocompleteField(
                        label: l.model,
                        initialValue: _model,
                        optionsBuilder: (query, index) {
                          final suggestions = <String>{};
                          if (index != null && _brand.isNotEmpty) {
                            suggestions.addAll(
                              index.templates
                                  .where(
                                    (e) =>
                                        e.meta.make.toLowerCase() ==
                                        _brand.toLowerCase(),
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
                        onChanged: (value) {
                          _model = value;
                          _hasUnsavedChanges = true;
                        },
                        validator: (v) => v == null || v.trim().isEmpty
                            ? l.required
                            : null,
                      );
                      final yearField = TextFormField(
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: l.year,
                        ),
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
                    decoration: InputDecoration(
                      labelText: l.plateOptional,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => _markDirty(),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _vinController,
                    decoration: InputDecoration(
                      labelText: l.vinOptional,
                    ),
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
                          decoration: InputDecoration(
                            labelText: l.odometer,
                          ),
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
                    decoration: InputDecoration(
                      labelText: l.currency,
                    ),
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
