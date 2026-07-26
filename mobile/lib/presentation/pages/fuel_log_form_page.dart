import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/volume.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';

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
  String _vehicleCurrency = 'USD';
  bool _isFullTank = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadVehicleData());
  }

  Future<void> _loadVehicleData() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId).future);
    if (vehicle != null && mounted) {
      _odometerController.text =
          vehicle.currentOdometer.distance.toStringAsFixed(0);
      _volumeUnit = vehicle.fuelVolumeUnit;
      _vehicleCurrency = vehicle.currency;
    }
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
      final vehicle =
          await ref.read(vehicleProvider(widget.vehicleId).future);

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
          vehicle?.currentOdometer.unit ?? DistanceUnit.kilometers,
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
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.homeError(e.toString()))));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.fuelFormTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l.date(DateFormat('dd/MM/yyyy').format(_date))),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _volumeController,
              decoration: InputDecoration(
                labelText:
                    '${l.volume} (${_volumeUnit == VolumeUnit.liters ? l.unitL : l.unitGal})',
                hintText: '0.0',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.required;
                final n = double.tryParse(v);
                if (n == null || n <= 0) return l.invalid;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _odometerController,
              decoration:
                  InputDecoration(labelText: l.odometer, hintText: '0'),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return l.required;
                final n = double.tryParse(v);
                if (n == null || n < 0) return l.invalid;
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: l.pricePerUnit,
                hintText: '0.00',
                prefixText:
                    '${Vehicle.currencySymbol(_vehicleCurrency)} ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            KarterSwitchListTile(
              title: Text(l.fullTank),
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
                  : Text(l.saveFuelUp),
            ),
          ],
        ),
      ),
    );
  }
}
