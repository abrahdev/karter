import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class MaintenanceLogFormPage extends ConsumerStatefulWidget {
  final String vehicleId;
  final String? logId;
  final String? initialDescription;
  final String? initialIntervalId;

  const MaintenanceLogFormPage({
    super.key,
    required this.vehicleId,
    this.logId,
    this.initialDescription,
    this.initialIntervalId,
  });

  @override
  ConsumerState<MaintenanceLogFormPage> createState() =>
      _MaintenanceLogFormPageState();
}

class _MaintenanceLogFormPageState
    extends ConsumerState<MaintenanceLogFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _odometerController = TextEditingController();

  DateTime _date = DateTime.now();
  String? _selectedIntervalId;
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.logId != null;
    if (!_isEditing) {
      if (widget.initialDescription != null) {
        _descriptionController.text = widget.initialDescription!;
      }
      _selectedIntervalId = widget.initialIntervalId;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    if (_isEditing) {
      final repo = ref.read(maintenanceLogRepositoryProvider);
      final log = await repo.getById(widget.logId!);
      if (log != null && mounted) {
        setState(() {
          _date = log.date;
          _descriptionController.text = log.description;
          if (log.odometerAtService > 0) {
            _odometerController.text =
                log.odometerAtService.toStringAsFixed(0);
          }
        });
      }
    } else {
      final vehicle =
          await ref.read(vehicleProvider(widget.vehicleId).future);
      if (vehicle != null && mounted) {
        _odometerController.text =
            vehicle.currentOdometer.distance.toStringAsFixed(0);
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _odometerController.dispose();
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
      final logId = _isEditing ? widget.logId! : uuid.v4();
      final odo = double.tryParse(_odometerController.text.trim()) ?? 0;

      String? resetIntervalId;
      double? restoreResetKm;
      DateTime? restoreResetDate;

      if (!_isEditing && _selectedIntervalId != null && odo > 0) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        final interval =
            await intervalRepo.getById(_selectedIntervalId!);
        if (interval != null) {
          resetIntervalId = _selectedIntervalId;
          restoreResetKm = interval.lastResetKm;
          restoreResetDate = interval.lastResetDate;
        }
      }

      final log = MaintenanceLog(
        id: logId,
        vehicleId: widget.vehicleId,
        date: _date,
        description: _descriptionController.text.trim(),
        odometerAtService: odo,
        isSynced: false,
        resetIntervalId: resetIntervalId,
        restoreResetKm: restoreResetKm,
        restoreResetDate: restoreResetDate,
      );

      final repo = ref.read(maintenanceLogRepositoryProvider);
      await repo.save(log);

      if (resetIntervalId != null) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        await intervalRepo.resetInterval(resetIntervalId, odo);
      }

      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

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

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final l = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(l.deleteService),
          content: Text(l.deleteServiceConfirm),
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

    if (confirmed != true) return;
    setState(() => _isLoading = true);

    try {
      final repo = ref.read(maintenanceLogRepositoryProvider);
      final log = await repo.getById(widget.logId!);

      if (log != null &&
          log.resetIntervalId != null &&
          log.restoreResetKm != null) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        final interval =
            await intervalRepo.getById(log.resetIntervalId!);
        if (interval != null) {
          await intervalRepo.save(interval.copyWith(
            lastResetKm: log.restoreResetKm!,
            lastResetDate: log.restoreResetDate,
          ));
        }
      }

      await repo.delete(widget.logId!);

      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

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
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(widget.vehicleId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l.maintenanceLogTitleEdit : l.maintenanceLogTitleNew),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(l.date(DateFormat('dd/MM/yyyy').format(_date))),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l.descriptionRequired),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? l.required : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _odometerController,
              decoration: InputDecoration(
                labelText: l.odometerAtService,
                hintText: '0',
              ),
              keyboardType: TextInputType.number,
            ),
            if (!_isEditing) ...[
              const SizedBox(height: 12),
              intervalsAsync.when(
                data: (intervals) {
                  final enabled = intervals.where((i) => i.isEnabled).toList();
                  if (enabled.isEmpty) return const SizedBox.shrink();
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedIntervalId,
                    decoration: InputDecoration(
                      labelText: l.resetInterval,
                    ),
                    items: enabled
                        .map((i) => DropdownMenuItem(
                              value: i.id,
                              child: Text(i.label),
                            ))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedIntervalId = v),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
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
                  : Text(_isEditing ? l.saveChangesShort : l.saveService),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _delete,
                icon: const Icon(Icons.delete_outline),
                label: Text(l.deleteService),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
