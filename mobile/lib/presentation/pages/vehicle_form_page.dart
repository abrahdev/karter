import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/database/app_database.dart';
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
import 'package:url_launcher/url_launcher.dart';

class VehicleFormPage extends ConsumerStatefulWidget {
  final String? vehicleId;

  const VehicleFormPage({super.key, this.vehicleId});

  @override
  ConsumerState<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends ConsumerState<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  final _vinController = TextEditingController();
  final _odometerController = TextEditingController();
  final _aliasController = TextEditingController();

  DistanceUnit _odometerUnit = DistanceUnit.kilometers;
  VolumeUnit _fuelVolumeUnit = VolumeUnit.liters;
  String _currency = 'USD';
  VehicleType _vehicleType = VehicleType.combustion;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _showAlias = false;

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
  }

  Future<void> _loadVehicle() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId!).future);
    if (vehicle != null && mounted) {
      _brandController.text = vehicle.brand;
      _modelController.text = vehicle.model;
      _yearController.text = vehicle.year.toString();
      _plateController.text = vehicle.plate?.value ?? '';
      _vinController.text = vehicle.vin?.code ?? '';
      _odometerController.text =
          vehicle.currentOdometer.distance.toStringAsFixed(0);
      _odometerUnit = vehicle.currentOdometer.unit;
      _fuelVolumeUnit = vehicle.fuelVolumeUnit;
      _currency = vehicle.currency;
      _vehicleType = vehicle.type;
      if (vehicle.alias != null && vehicle.alias!.isNotEmpty) {
        _showAlias = true;
        _aliasController.text = vehicle.alias!;
      }
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _vinController.dispose();
    _odometerController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_isEditing || widget.vehicleId == null) return;

    final confirmed = await showDialog<bool>(
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
      ref.invalidate(vehicleListProvider);
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.homeError(e.toString()))),
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

    final brand = _brandController.text.trim();
    final model = _modelController.text.trim();
    final yearStr = _yearController.text.trim();

    final year = int.tryParse(yearStr);
    if (year == null) return;

    setState(() => _isLoading = true);

    try {
      final resolver = ref.read(templateResolverProvider);
      final resolution = await resolver.findBestMatch(
        make: brand,
        model: model,
        year: year,
      );

      if (!mounted) return;

      if (resolution != null) {
        final intervals = resolution.items.map((r) {
          return MaintenanceInterval(
            id: uuid.v4(),
            vehicleId: '',
            label: r.label,
            i18nKey: r.i18nKey,
            descI18nKey: r.descI18nKey,
            kmInterval: r.intervalKm,
            monthsInterval: r.intervalMonths,
            description: r.description,
            isCustom: false,
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<String?> _showTemplatePreview(
      String name, List<MaintenanceInterval> intervals) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Plantilla encontrada'),
              const SizedBox(height: 4),
              Text(
                name,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.primary),
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
                final parts = <String>[
                  '${interval.kmInterval} km',
                ];
                if (interval.monthsInterval != null) {
                  parts.add('${interval.monthsInterval} meses');
                }
                return ListTile(
                  dense: true,
                  title: Text(interval.label),
                  subtitle: interval.description != null
                      ? Text(
                          interval.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: Text(
                    parts.join(' / '),
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx, 'defaults'),
              child: const Text('Usar defaults por tipo'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, 'template'),
              child: const Text('Usar plantilla'),
            ),
          ],
        );
      },
    );
    return result;
  }

  Future<void> _showNoTemplateFound(String searchParams) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return AlertDialog(
          title: const Text('Sin resultados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.search_off,
                      color: theme.colorScheme.outline, size: 48),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'No se encontró ninguna plantilla para los datos ingresados.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Parámetros de búsqueda:',
                  style: theme.textTheme.labelMedium),
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
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'El vehículo se creará con los intervalos por defecto.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline),
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
              label: const Text('Ver todas las plantillas'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Entendido'),
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
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
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
            .map((i) => MaintenanceInterval(
                  id: uuid.v4(),
                  vehicleId: id,
                  label: i.label,
                  i18nKey: i.i18nKey,
                  descI18nKey: i.descI18nKey,
                  kmInterval: i.kmInterval,
                  monthsInterval: i.monthsInterval,
                  description: i.description,
                  isCustom: false,
                ))
            .toList();
        await repo.save(vehicle, intervals: intervals);
      } else {
        await repo.save(vehicle);
      }

      ref.invalidate(vehicleListProvider);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.homeError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final composite = '${_brandController.text.trim()} '
        '${_modelController.text.trim()} '
        '${_yearController.text.trim()}'.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l.vehicleFormEdit : l.vehicleFormNew),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (composite.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  composite,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(labelText: l.brand),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.required : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _modelController,
              decoration: InputDecoration(labelText: l.model),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.required : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _yearController,
              decoration: InputDecoration(labelText: l.year),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.required;
                final year = int.tryParse(v);
                if (year == null || year < 1886 || year > DateTime.now().year + 1) {
                  return l.invalidYear;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (!_isEditing) ...[
              OutlinedButton.icon(
                onPressed:
                    _isLoading ? null : _searchTemplate,
                icon: _templateIntervals != null
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.search),
                label: Text(
                  _templateIntervals != null
                      ? 'Plantilla: $_templateName'
                      : 'Buscar plantilla',
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(l.vehicleType,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<VehicleType>(
              segments: [
                ButtonSegment(
                  value: VehicleType.combustion,
                  label: Text(l.combustion),
                  icon: Icon(Icons.local_gas_station),
                ),
                ButtonSegment(
                  value: VehicleType.electric,
                  label: Text(l.electric),
                  icon: Icon(Icons.electric_car),
                ),
                ButtonSegment(
                  value: VehicleType.motorcycle,
                  label: Text(l.motorcycle),
                  icon: Icon(Icons.motorcycle),
                ),
              ],
              selected: {_vehicleType},
              onSelectionChanged: (v) =>
                  setState(() => _vehicleType = v.first),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _plateController,
              decoration: InputDecoration(
                labelText: l.plateOptional,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _vinController,
              decoration: InputDecoration(
                labelText: l.vinOptional,
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 17,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odometerController,
                    decoration:
                        InputDecoration(labelText: l.odometer),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (_validatingForSearch) return null;
                      if (v == null || v.trim().isEmpty) return l.required;
                      final num = double.tryParse(v);
                      if (num == null || num < 0) return l.invalid;
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<DistanceUnit>(
                  segments: [
                    ButtonSegment(value: DistanceUnit.kilometers, label: Text(l.unitKm)),
                    ButtonSegment(value: DistanceUnit.miles, label: Text(l.unitMi)),
                  ],
                  selected: {_odometerUnit},
                  onSelectionChanged: (v) =>
                      setState(() => _odometerUnit = v.first),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(l.volumeUnit,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<VolumeUnit>(
              segments: [
                ButtonSegment(
                    value: VolumeUnit.liters, label: Text(l.unitL)),
                ButtonSegment(
                    value: VolumeUnit.gallons, label: Text(l.unitGal)),
              ],
              selected: {_fuelVolumeUnit},
              onSelectionChanged: (v) =>
                  setState(() => _fuelVolumeUnit = v.first),
            ),
            const SizedBox(height: 16),
            Text(l.currency,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _currency,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: Vehicle.currencies
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(
                            '${Vehicle.currencySymbol(c)}  $c'),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _currency = v);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l.aliasOptional),
              subtitle: _showAlias && _aliasController.text.isNotEmpty
                  ? Text(_aliasController.text)
                  : null,
              value: _showAlias,
              onChanged: (v) => setState(() => _showAlias = v),
            ),
            if (_showAlias) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _aliasController,
                decoration: InputDecoration(
                  labelText: l.aliasOptional,
                  hintText: l.aliasHint,
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? l.saveChanges : l.addVehicle),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
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
          ],
        ),
      ),
    );
  }
}
