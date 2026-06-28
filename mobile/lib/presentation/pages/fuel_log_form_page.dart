import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/volume.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class FuelLogFormPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const FuelLogFormPage({super.key, required this.vehicleId});

  @override
  ConsumerState<FuelLogFormPage> createState() => _FuelLogFormPageState();
}

class _FuelLogFormPageState extends ConsumerState<FuelLogFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _volumeController = TextEditingController();
  final _odometerController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _date = DateTime.now();
  VolumeUnit _volumeUnit = VolumeUnit.liters;
  DistanceUnit _odoUnit = DistanceUnit.kilometers;
  bool _isFullTank = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _volumeController.dispose();
    _odometerController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final log = FuelLog(
        id: uuid.v4(),
        vehicleId: widget.vehicleId,
        date: _date,
        isSynced: false,
        fueledVolume: Volume(
          double.parse(_volumeController.text.trim()),
          _volumeUnit,
        ),
        odometerAtFueling: Odometer(
          double.parse(_odometerController.text.trim()),
          _odoUnit,
        ),
        pricePerUnit: _priceController.text.trim().isEmpty
            ? null
            : double.parse(_priceController.text.trim()),
        isFullTank: _isFullTank,
      );

      final repo = ref.read(fuelLogRepositoryProvider);
      await repo.save(log);
      ref.invalidate(fuelLogsProvider(widget.vehicleId));

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva carga')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_date)}'),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _volumeController,
                    decoration: const InputDecoration(
                        labelText: 'Volumen', hintText: '0.0'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final n = double.tryParse(v);
                      if (n == null || n <= 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<VolumeUnit>(
                  segments: const [
                    ButtonSegment(value: VolumeUnit.liters, label: Text('L')),
                    ButtonSegment(
                        value: VolumeUnit.gallons, label: Text('gal')),
                  ],
                  selected: {_volumeUnit},
                  onSelectionChanged: (v) =>
                      setState(() => _volumeUnit = v.first),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _odometerController,
                    decoration: const InputDecoration(
                        labelText: 'Odómetro', hintText: '0'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Requerido';
                      final n = double.tryParse(v);
                      if (n == null || n < 0) return 'Inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SegmentedButton<DistanceUnit>(
                  segments: const [
                    ButtonSegment(
                        value: DistanceUnit.kilometers, label: Text('km')),
                    ButtonSegment(
                        value: DistanceUnit.miles, label: Text('mi')),
                  ],
                  selected: {_odoUnit},
                  onSelectionChanged: (v) =>
                      setState(() => _odoUnit = v.first),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio por unidad (opcional)',
                hintText: '0.00',
                prefixText: '\$',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Tanque lleno'),
              value: _isFullTank,
              onChanged: (v) => setState(() => _isFullTank = v),
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
                  : const Text('Guardar carga'),
            ),
          ],
        ),
      ),
    );
  }
}
