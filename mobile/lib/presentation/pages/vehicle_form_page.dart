import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class VehicleFormPage extends ConsumerStatefulWidget {
  final String? vehicleId;

  const VehicleFormPage({super.key, this.vehicleId});

  @override
  ConsumerState<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends ConsumerState<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  final _vinController = TextEditingController();
  final _odometerController = TextEditingController();

  DistanceUnit _odometerUnit = DistanceUnit.kilometers;
  bool _isLoading = false;
  bool _isEditing = false;

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
      _nameController.text = vehicle.name;
      _brandController.text = vehicle.brand;
      _modelController.text = vehicle.model;
      _yearController.text = vehicle.year.toString();
      _plateController.text = vehicle.plate.value;
      _vinController.text = vehicle.vin.code;
      _odometerController.text =
          vehicle.currentOdometer.distance.toStringAsFixed(0);
      _odometerUnit = vehicle.currentOdometer.unit;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _vinController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final id = _isEditing ? widget.vehicleId! : uuid.v4();
      final vehicle = Vehicle(
        id: id,
        name: _nameController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        createdAt: DateTime.now(),
        isSynced: false,
        plate: Plate(_plateController.text.trim()),
        vin: Vin(_vinController.text.trim()),
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
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar vehículo' : 'Nuevo vehículo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marca'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Modelo'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Año'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Requerido';
                final year = int.tryParse(v);
                if (year == null || year < 1886 || year > DateTime.now().year + 1) {
                  return 'Año inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _plateController,
              decoration: const InputDecoration(labelText: 'Placa'),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _vinController,
              decoration: const InputDecoration(labelText: 'VIN'),
              textCapitalization: TextCapitalization.characters,
              maxLength: 17,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odometerController,
                    decoration:
                        const InputDecoration(labelText: 'Odómetro'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final num = double.tryParse(v);
                      if (num == null || num < 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<DistanceUnit>(
                  segments: const [
                    ButtonSegment(value: DistanceUnit.kilometers, label: Text('km')),
                    ButtonSegment(value: DistanceUnit.miles, label: Text('mi')),
                  ],
                  selected: {_odometerUnit},
                  onSelectionChanged: (v) =>
                      setState(() => _odometerUnit = v.first),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Guardar cambios' : 'Agregar vehículo'),
            ),
          ],
        ),
      ),
    );
  }
}
