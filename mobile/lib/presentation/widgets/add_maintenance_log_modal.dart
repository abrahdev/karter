import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:path_provider/path_provider.dart';

Future<void> showAddMaintenanceLogModal(
  BuildContext context, {
  required String vehicleId,
  String? initialDescription,
  String? initialIntervalId,
  required void Function() onSaved,
}) async {
  final result = await karterShowModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AddMaintenanceLogModal(
      vehicleId: vehicleId,
      initialDescription: initialDescription,
      initialIntervalId: initialIntervalId,
    ),
  );

  if (result == 'saved' && context.mounted) {
    onSaved();
  }
}

Future<void> showEditMaintenanceLogModal(
  BuildContext context, {
  required String vehicleId,
  required MaintenanceLog log,
  required void Function() onSaved,
}) async {
  var currentLog = log;
  var changed = false;

  while (true) {
    final action = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _MaintenanceLogPreview(
        vehicleId: vehicleId,
        log: currentLog,
      ),
    );

    if (!context.mounted) return;

    if (action != 'edit') break;

    final result = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddMaintenanceLogModal(
        vehicleId: vehicleId,
        editLog: currentLog,
      ),
    );

    if (!context.mounted) return;

    if (result == 'saved') {
      changed = true;
      final repo = ProviderScope.containerOf(context)
          .read(maintenanceLogRepositoryProvider);
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

class _AddMaintenanceLogModal extends ConsumerStatefulWidget {
  final String vehicleId;
  final String? initialDescription;
  final String? initialIntervalId;
  final MaintenanceLog? editLog;

  const _AddMaintenanceLogModal({
    required this.vehicleId,
    this.initialDescription,
    this.initialIntervalId,
    this.editLog,
  });

  @override
  ConsumerState<_AddMaintenanceLogModal> createState() =>
      _AddMaintenanceLogModalState();
}

class _AddMaintenanceLogModalState
    extends ConsumerState<_AddMaintenanceLogModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _odometerController = TextEditingController();
  final _costController = TextEditingController();

  DateTime _date = DateTime.now();
  String? _selectedIntervalId;
  final List<String> _selectedPhotos = [];
  String _vehicleCurrency = 'USD';
  bool _saving = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.editLog != null;

    if (_isEditing) {
      final log = widget.editLog!;
      _date = log.date;
      _descriptionController.text = log.description;
      _odometerController.text =
          log.odometerAtService > 0 ? log.odometerAtService.toStringAsFixed(0) : '';
      _selectedPhotos.addAll(log.photoPaths);
      if (log.costAmount != null) {
        _costController.text = log.costAmount.toString();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrency());
    } else {
      if (widget.initialDescription != null) {
        _descriptionController.text = widget.initialDescription!;
      }
      _selectedIntervalId = widget.initialIntervalId;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadOdometer());
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _odometerController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrency() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId).future);
    if (vehicle != null && mounted) {
      _vehicleCurrency = vehicle.currency;
    }
  }

  Future<void> _loadOdometer() async {
    final vehicle =
        await ref.read(vehicleProvider(widget.vehicleId).future);
    if (vehicle != null && mounted) {
      _odometerController.text =
          vehicle.currentOdometer.distance.toStringAsFixed(0);
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

  final _picker = ImagePicker();

  void _showPhotoSourcePicker() {
    final l = AppLocalizations.of(context)!;
    karterShowModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(l.takePhoto),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.chooseFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(l.browseFiles),
              onTap: () {
                Navigator.pop(ctx);
                _pickFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null && mounted) {
      setState(() => _selectedPhotos.add(file.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() => _selectedPhotos.add(file.path));
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'webp'],
      allowMultiple: true,
    );
    if (result != null && mounted) {
      setState(() {
        for (final f in result.files) {
          if (f.path != null) {
            _selectedPhotos.add(f.path!);
          }
        }
      });
    }
  }

  void _removePhoto(int index) {
    setState(() => _selectedPhotos.removeAt(index));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      final logId = _isEditing ? widget.editLog!.id : uuid.v4();
      final odo =
          double.tryParse(_odometerController.text.trim()) ?? 0;

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

      final List<String> savedPaths = [];
      if (_selectedPhotos.isNotEmpty) {
        final appDir =
            await getApplicationDocumentsDirectory();
        final photosDir = Directory(
            '${appDir.path}/maintenance_photos/$logId');
        await photosDir.create(recursive: true);
        for (final src in _selectedPhotos) {
          final ext = src.split('.').last;
          final dest = '${photosDir.path}/${uuid.v4()}.$ext';
          await File(src).copy(dest);
          savedPaths.add(dest);
        }
      }

      final costText = _costController.text.trim();
      final costAmount =
          costText.isNotEmpty ? double.tryParse(costText) : null;

      final log = MaintenanceLog(
        id: logId,
        vehicleId: widget.vehicleId,
        date: _date,
        description: _descriptionController.text.trim(),
        odometerAtService: odo,
        isSynced: _isEditing ? widget.editLog!.isSynced : false,
        resetIntervalId: _isEditing ? widget.editLog!.resetIntervalId : resetIntervalId,
        restoreResetKm: _isEditing ? widget.editLog!.restoreResetKm : restoreResetKm,
        restoreResetDate: _isEditing ? widget.editLog!.restoreResetDate : restoreResetDate,
        photoPaths: savedPaths.isEmpty && _isEditing ? widget.editLog!.photoPaths : savedPaths,
        costAmount: costAmount,
        costCurrency: costAmount != null ? _vehicleCurrency : null,
      );

      final repo = ref.read(maintenanceLogRepositoryProvider);
      await repo.save(log);

      if (!_isEditing && resetIntervalId != null) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        await intervalRepo.resetInterval(resetIntervalId, odo);
      }

      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

      HapticFeedback.mediumImpact();
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

    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);

    try {
      final log = widget.editLog!;
      final repo = ref.read(maintenanceLogRepositoryProvider);

      if (log.resetIntervalId != null && log.restoreResetKm != null) {
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

      await repo.delete(log.id);
      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

      HapticFeedback.mediumImpact();
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
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(widget.vehicleId));
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
                _isEditing ? l.maintenanceLogTitleEdit : l.maintenanceLogTitleNew,
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l.descriptionRequired,
                  border: const OutlineInputBorder(),
                ),
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
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _showPhotoSourcePicker,
                    icon: const Icon(Icons.photo_library),
                    label: Text(l.addPhoto),
                  ),
                  if (_selectedPhotos.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedPhotos.length} ${l.photos}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              if (_selectedPhotos.isNotEmpty) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedPhotos.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedPhotos[i]),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removePhoto(i),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding:
                                  const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: l.cost,
                  hintText: '0.00',
                  prefixText:
                      '${Vehicle.currencySymbol(_vehicleCurrency)} ',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType
                    .numberWithOptions(decimal: true),
              ),
              if (!_isEditing) ...[
                const SizedBox(height: 12),
                intervalsAsync.when(
                  data: (intervals) {
                    final enabled =
                        intervals.where((i) => i.isEnabled).toList();
                    if (enabled.isEmpty) return const SizedBox.shrink();
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedIntervalId,
                      decoration: InputDecoration(
                        labelText: l.resetInterval,
                        border: const OutlineInputBorder(),
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
              const SizedBox(height: 20),
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
                  label: Text(_isEditing ? l.saveChangesShort : l.saveService),
                ),
              ),
              if (_isEditing) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _saving ? null : _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.deleteService),
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

class _MaintenanceLogPreview extends ConsumerWidget {
  final String vehicleId;
  final MaintenanceLog log;

  const _MaintenanceLogPreview({
    required this.vehicleId,
    required this.log,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasPhotos = log.photoPaths.isNotEmpty;

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
          if (hasPhotos)
            SizedBox(
              height: 250,
              child: CarouselView(
                shrinkExtent: 80,
                itemExtent: 200,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                children: log.photoPaths.map((path) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => _showPhotoFullScreen(context, path),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )).toList(),
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
            leading: const Icon(Icons.description),
            title: Text(log.description),
          ),
          if (log.odometerAtService > 0)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.speed),
              title: Text(
                  '${log.odometerAtService.toStringAsFixed(0)} ${l.km}'),
            ),
          if (log.costAmount != null && log.costAmount! > 0)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.attach_money),
              title: Text(
                '${Vehicle.currencySymbol(log.costCurrency ?? 'USD')} ${log.costAmount!.toStringAsFixed(2)}',
              ),
            ),
          if (hasPhotos)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.photo_library, size: 16),
                  const SizedBox(width: 4),
                  Text('${log.photoPaths.length} ${l.photos}',
                      style: theme.textTheme.bodySmall),
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

void _showPhotoFullScreen(BuildContext context, String path) {
  karterShowDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            child: Image.file(File(path), fit: BoxFit.contain),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
        ],
      ),
    ),
  );
}
