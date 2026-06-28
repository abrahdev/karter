import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

class MaintenanceLogFormPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const MaintenanceLogFormPage({super.key, required this.vehicleId});

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
      final logId = uuid.v4();
      final odo = double.tryParse(_odometerController.text.trim()) ?? 0;

      final log = MaintenanceLog(
        id: logId,
        vehicleId: widget.vehicleId,
        date: _date,
        description: _descriptionController.text.trim(),
        isSynced: false,
      );

      final repo = ref.read(maintenanceLogRepositoryProvider);
      await repo.save(log);

      if (_selectedIntervalId != null && odo > 0) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        await intervalRepo.resetInterval(_selectedIntervalId!, odo);
      }

      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

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
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(widget.vehicleId));

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo servicio')),
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
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _odometerController,
              decoration: const InputDecoration(
                labelText: 'Odómetro al servicio (opcional)',
                hintText: '0',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            intervalsAsync.when(
              data: (intervals) {
                final enabled = intervals.where((i) => i.isEnabled).toList();
                if (enabled.isEmpty) return const SizedBox.shrink();
                return DropdownButtonFormField<String>(
                  value: _selectedIntervalId,
                  decoration: const InputDecoration(
                    labelText: 'Resetear intervalo (opcional)',
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
              error: (_, __) => const SizedBox.shrink(),
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
                  : const Text('Guardar servicio'),
            ),
          ],
        ),
      ),
    );
  }
}
