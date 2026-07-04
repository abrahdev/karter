import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

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
  VehicleType _vehicleType = VehicleType.combustion;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _showAlias = false;

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
      );

      final repo = ref.read(vehicleRepositoryProvider);
      await repo.save(vehicle);
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
