import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/volume.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

Future<void> showAddFuelLogModal(
  BuildContext context, {
  required String vehicleId,
  required void Function() onSaved,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _AddFuelLogModal(vehicleId: vehicleId),
  );

  if (result == true && context.mounted) {
    onSaved();
  }
}

class _AddFuelLogModal extends ConsumerStatefulWidget {
  final String vehicleId;

  const _AddFuelLogModal({required this.vehicleId});

  @override
  ConsumerState<_AddFuelLogModal> createState() =>
      _AddFuelLogModalState();
}

class _AddFuelLogModalState extends ConsumerState<_AddFuelLogModal> {
  final _formKey = GlobalKey<FormState>();
  final _volumeController = TextEditingController();
  final _odometerController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _date = DateTime.now();
  VolumeUnit _volumeUnit = VolumeUnit.liters;
  String _vehicleCurrency = 'USD';
  bool _isFullTank = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadVehicleData());
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
    setState(() => _saving = true);

    try {
      final vehicle =
          await ref.read(vehicleProvider(widget.vehicleId).future);
      if (vehicle == null) return;

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
          vehicle.currentOdometer.unit,
        ),
        pricePerUnit: _priceController.text.trim().isEmpty
            ? null
            : double.parse(_priceController.text.trim()),
        isFullTank: _isFullTank,
      );

      final repo = ref.read(fuelLogRepositoryProvider);
      await repo.save(log);
      ref.invalidate(fuelLogsProvider(widget.vehicleId));

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              AppLocalizations.of(context)!.homeError(e.toString())),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.fuelFormTitle,
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(
                    l.date(DateFormat('dd/MM/yyyy').format(_date))),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _volumeController,
                decoration: InputDecoration(
                  labelText:
                      '${l.volume} (${_volumeUnit == VolumeUnit.liters ? l.unitL : l.unitGal})',
                  hintText: '0.0',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType
                    .numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l.required;
                  }
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return l.invalid;
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _odometerController,
                decoration: InputDecoration(
                  labelText: l.odometer,
                  hintText: '0',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l.required;
                  }
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
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType
                    .numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.fullTank),
                value: _isFullTank,
                onChanged: (v) => setState(() => _isFullTank = v),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(l.saveFuelUp),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
