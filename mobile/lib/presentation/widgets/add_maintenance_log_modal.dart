import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/rating_helper.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/full_screen_photo_viewer.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/maintenance_log_parts_field.dart';
import 'package:mobile/presentation/widgets/photo_source_picker.dart';
import 'package:mobile/presentation/utils/part_line_formatter.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
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
    showRatePrompt(context);
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
    if (!context.mounted) return;
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
  List<MaintenanceLogPart> _selectedParts = [];
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _loadCurrency();
        if (!mounted) return;
        final parts = await ref
            .read(maintenanceLogPartRepositoryProvider)
            .getByLog(log.id);
        if (mounted) setState(() => _selectedParts = parts);
      });
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
    showPhotoSourcePicker(
      context: context,
      onTakePhoto: _pickFromCamera,
      onChooseFromGallery: _pickFromGallery,
      onBrowseFiles: _pickFiles,
    );
  }

  Future<void> _pickFromCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (file != null && mounted) {
      setState(() => _selectedPhotos.add(file.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final files = await _picker.pickMultiImage();
    if (files.isNotEmpty && mounted) {
      setState(() {
        for (final f in files) {
          _selectedPhotos.add(f.path);
        }
      });
    }
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'webp'],
    );
    if (result.isNotEmpty && mounted) {
      setState(() {
        for (final f in result) {
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

      final partsToSave =
          _selectedParts.map((p) => p.copyWith(logId: logId)).toList();
      await ref
          .read(maintenanceLogPartRepositoryProvider)
          .replaceForLog(logId, partsToSave);

      if (!_isEditing && resetIntervalId != null) {
        final intervalRepo =
            ref.read(maintenanceIntervalRepositoryProvider);
        await intervalRepo.resetInterval(resetIntervalId, odo);
      }

      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

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
      await ref
          .read(maintenanceLogPartRepositoryProvider)
          .deleteByLog(log.id);
      ref.invalidate(maintenanceLogsProvider(widget.vehicleId));
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));

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
              const DragHandle(),
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
                    l.date(DateFormat.yMd(l.localeName).format(_date))),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l.descriptionRequired,
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
              MaintenanceLogPartsField(
                initialParts: _selectedParts,
                onChanged: (parts) => _selectedParts = parts,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                decoration: InputDecoration(
                  labelText: l.cost,
                  hintText: '0.00',
                  prefixText:
                      '${Vehicle.currencySymbol(_vehicleCurrency)} ',
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
                      isExpanded: true,
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const M3LoadingIndicator(size: 18)
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
          const DragHandle(),
          const SizedBox(height: 16),
          if (hasPhotos)
            StatefulBuilder(
              builder: (ctx, setCarouselState) {
                return Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: CarouselView(
                        shrinkExtent: 80,
                        itemExtent: 200,
                        padding: EdgeInsets.zero,
                        onTap: (index) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (_) => FullScreenPhotoViewer(
                                paths: log.photoPaths,
                                initialIndex: index,
                                heroTag: 'maintenance_photo_${log.id}_$index',
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        children: log.photoPaths.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Hero(
                              tag: 'maintenance_photo_${log.id}_${entry.key}',
                              child: Image.file(
                                File(entry.value),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                    if (log.photoPaths.length > 1) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          log.photoPaths.length,
                          (i) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.colorScheme.outline.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: Text(
                l.date(DateFormat.yMd(l.localeName).format(log.date))),
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
          _PreviewParts(logId: log.id),
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

class _PreviewParts extends ConsumerWidget {
  final String logId;

  const _PreviewParts({required this.logId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final partsAsync = ref.watch(maintenanceLogPartsProvider(logId));

    return partsAsync.when(
      data: (parts) {
        if (parts.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: l.usedParts),
            for (final part in parts)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _partLine(context, part),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  String _partLine(BuildContext context, MaintenanceLogPart part) {
    return formatPartLine(
      name: part.name,
      formattedQuantity: IntervalPartsView.formatQuantity(part.quantity),
      unitLabel: IntervalPartsView.unitLabel(context, part.unit),
    );
  }
}
