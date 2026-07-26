import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
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
  final result = await karterShowModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AddFuelLogModal(vehicleId: vehicleId),
  );

  if (result == 'saved' && context.mounted) {
    onSaved();
  }
}

Future<void> showEditFuelLogModal(
  BuildContext context, {
  required String vehicleId,
  required FuelLog log,
  required void Function() onSaved,
}) async {
  var currentLog = log;
  var changed = false;

  while (true) {
    if (!context.mounted) return;
    final action = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _FuelLogPreview(
        vehicleId: vehicleId,
        log: currentLog,
      ),
    );

    if (!context.mounted) return;

    if (action != 'edit') break;

    final result = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddFuelLogModal(
        vehicleId: vehicleId,
        editLog: currentLog,
      ),
    );

    if (!context.mounted) return;

    if (result == 'saved') {
      changed = true;
      final repo = ProviderScope.containerOf(context)
          .read(fuelLogRepositoryProvider);
      final updated = await repo.getById(currentLog.id);
      if (updated != null) {
        currentLog = updated;
      }
    } else if (result == 'deleted') {
      changed = true;
      break;
    } else {
      break;
    }
  }

  if (changed && context.mounted) {
    onSaved();
  }
}

class _AddFuelLogModal extends ConsumerStatefulWidget {
  final String vehicleId;
  final FuelLog? editLog;

  const _AddFuelLogModal({required this.vehicleId, this.editLog});

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
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.editLog != null;

    if (_isEditing) {
      final log = widget.editLog!;
      _date = log.date;
      _volumeController.text = log.fueledVolume.amount.toString();
      _odometerController.text =
          log.odometerAtFueling.distance.toStringAsFixed(0);
      _priceController.text =
          log.pricePerUnit?.toString() ?? '';
      _isFullTank = log.isFullTank;
      _volumeUnit = log.fueledVolume.unit;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _loadCurrency());
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _loadVehicleData());
    }
  }

  Future<void> _loadCurrency() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId).future);
    if (vehicle != null && mounted) {
      _vehicleCurrency = vehicle.currency;
    }
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
        id: _isEditing ? widget.editLog!.id : uuid.v4(),
        vehicleId: widget.vehicleId,
        date: _date,
        isSynced: _isEditing ? widget.editLog!.isSynced : false,
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

      ref.read(hapticProvider.notifier).success();
      if (mounted) Navigator.pop(context, 'saved');
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

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete fuel-up'),
          content: const Text('Are you sure you want to delete this fuel-up?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
                foregroundColor: Theme.of(ctx).colorScheme.onError,
              ),
              child: Text(l.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(fuelLogRepositoryProvider);
      await repo.delete(widget.editLog!.id);
      ref.invalidate(fuelLogsProvider(widget.vehicleId));

      ref.read(hapticProvider.notifier).delete();
      if (mounted) Navigator.pop(context, 'deleted');
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
              Text(
                _isEditing ? 'Edit fuel-up' : l.fuelFormTitle,
                style: theme.textTheme.titleLarge,
              ),
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
              KarterSwitchListTile(
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
                  label: Text(_isEditing ? l.saveChangesShort : l.saveFuelUp),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FuelLogPreview extends ConsumerWidget {
  final String vehicleId;
  final FuelLog log;

  const _FuelLogPreview({
    required this.vehicleId,
    required this.log,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final volUnit = log.fueledVolume.unit == VolumeUnit.liters
        ? l.unitL
        : l.unitGal;
    final consumption = log.calculatedConsumption;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(
                l.date(DateFormat('dd/MM/yyyy').format(log.date))),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.local_gas_station),
            title: Text(
                '${log.fueledVolume.amount.toStringAsFixed(1)} $volUnit'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.speed),
            title: Text(
                '${log.odometerAtFueling.distance.toStringAsFixed(0)} ${l.km}'),
          ),
          if (log.pricePerUnit != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.attach_money),
              title: Text(
                  '\$${log.pricePerUnit!.toStringAsFixed(2)}/$volUnit'),
            ),
          KarterSwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.fullTank),
            value: log.isFullTank,
            onChanged: null,
          ),
          if (consumption > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.trending_down, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${consumption.toStringAsFixed(1)} L/100km',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context, 'edit'),
              icon: const Icon(Icons.edit),
              label: Text(l.edit),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
