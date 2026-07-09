import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/enums/document_type.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<void> showAddDocumentModal(
  BuildContext context, {
  required String vehicleId,
  required void Function() onSaved,
}) async {
  final result = await karterShowModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => _AddDocumentModal(vehicleId: vehicleId),
  );

  if (result == 'saved' && context.mounted) {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.documentSaved)),
    );
    onSaved();
  }
}

Future<void> showEditDocumentModal(
  BuildContext context, {
  required String vehicleId,
  required VehicleDocument document,
  required void Function() onSaved,
}) async {
  var currentDoc = document;
  var changed = false;

  while (true) {
    final action = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _DocumentPreview(
        vehicleId: vehicleId,
        document: currentDoc,
      ),
    );

    if (!context.mounted) return;

    if (action != 'edit') break;

    final result = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _AddDocumentModal(
        vehicleId: vehicleId,
        editDocument: currentDoc,
      ),
    );

    if (!context.mounted) return;

    if (result == 'saved') {
      changed = true;
      final repo = ProviderScope.containerOf(context)
          .read(vehicleDocumentRepositoryProvider);
      final updated = await repo.getById(currentDoc.id);
      if (updated != null) {
        currentDoc = updated;
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

class _AddDocumentModal extends ConsumerStatefulWidget {
  final String vehicleId;
  final VehicleDocument? editDocument;

  const _AddDocumentModal({required this.vehicleId, this.editDocument});

  @override
  ConsumerState<_AddDocumentModal> createState() =>
      _AddDocumentModalState();
}

class _AddDocumentModalState extends ConsumerState<_AddDocumentModal> {
  final _picker = ImagePicker();
  DocumentType _selectedType = DocumentType.fine;
  String? _selectedFilePath;
  String? _selectedFileName;
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _expiryDate;
  bool _saving = false;
  String? _editingId;

  @override
  void initState() {
    super.initState();
    final doc = widget.editDocument;
    if (doc != null) {
      _editingId = doc.id;
      _selectedType = doc.type;
      _selectedFilePath = doc.filePath;
      _selectedFileName = doc.fileName;
      _nameController.text = doc.name;
      _notesController.text = doc.notes ?? '';
      _expiryDate = doc.expiryDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSourcePicker() {
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
                _pickFile();
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
      setState(() {
        _selectedFilePath = file.path;
        _selectedFileName = file.name;
        if (_nameController.text.isEmpty) _nameController.text = file.name;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() {
        _selectedFilePath = file.path;
        _selectedFileName = file.name;
        if (_nameController.text.isEmpty) _nameController.text = file.name;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'jpg',
        'jpeg',
        'png',
        'doc',
        'docx',
        'xls',
        'xlsx',
      ],
    );
    if (result != null && result.files.isNotEmpty && mounted) {
      setState(() {
        _selectedFilePath = result.files.first.path;
        _selectedFileName = result.files.first.name;
        if (_nameController.text.isEmpty) _nameController.text = result.files.first.name;
      });
    }
  }

  Future<void> _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      initialDate: _expiryDate,
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.pleaseSelectFile)),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final repo = ref.read(vehicleDocumentRepositoryProvider);
      final id = _editingId ?? const Uuid().v4();

      String destPath;
      String? mimeType;
      double? fileSize;

      if (_editingId != null &&
          _selectedFilePath == widget.editDocument!.filePath) {
        destPath = widget.editDocument!.filePath;
        mimeType = widget.editDocument!.mimeType;
        fileSize = widget.editDocument!.fileSize;
      } else {
        final ext = _selectedFileName!.split('.').last;
        final dir = await getApplicationDocumentsDirectory();
        final docDir =
            Directory('${dir.path}/documents/${widget.vehicleId}');
        await docDir.create(recursive: true);
        destPath = '${docDir.path}/$id.$ext';
        await File(_selectedFilePath!).copy(destPath);
        final file = File(_selectedFilePath!);
        fileSize = (await file.length()).toDouble();
        mimeType = ext;
      }

      await repo.save(VehicleDocument(
        id: id,
        vehicleId: widget.vehicleId,
        type: _selectedType,
        name: _nameController.text.trim().isEmpty
            ? _selectedFileName!
            : _nameController.text.trim(),
        fileName: _selectedFileName!,
        filePath: destPath,
        mimeType: mimeType,
        fileSize: fileSize,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        expiryDate: _expiryDate,
        createdAt: widget.editDocument?.createdAt ?? DateTime.now(),
      ));

      if (mounted) Navigator.pop(context, 'saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool _isImageFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif']
        .contains(ext);
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete document'),
        content: Text('Are you sure you want to delete this document?'),
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
      ),
    );

    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);

    try {
      final repo = ref.read(vehicleDocumentRepositoryProvider);
      await repo.delete(widget.editDocument!.id);
      ref.invalidate(vehicleDocumentsProvider(widget.vehicleId));
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .homeError(e.toString())),
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
            Text(_editingId != null ? 'Edit document' : l.addDocument,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            DropdownButtonFormField<DocumentType>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l.documentType,
                border: const OutlineInputBorder(),
              ),
              items: DocumentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_documentTypeLabel(l, type)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => _selectedType = v);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: _selectedFileName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l.notesOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _expiryDate != null
                    ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                    : 'Select expiry date',
              ),
              onTap: _pickExpiryDate,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _showSourcePicker,
              icon: const Icon(Icons.attach_file),
              label: Text(
                _selectedFileName != null ? 'Change file' : l.selectFile,
              ),
            ),
            if (_selectedFilePath != null) ...[
              const SizedBox(height: 8),
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _isImageFile(_selectedFilePath!)
                            ? Image.file(
                                File(_selectedFilePath!),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme
                                      .surfaceContainerHighest,
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                    Icons.insert_drive_file,
                                    size: 40),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(_selectedFileName!,
                                style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            FutureBuilder<int>(
                              future: File(_selectedFilePath!)
                                  .length(),
                              builder: (ctx, snap) {
                                final size = snap.data ?? 0;
                                return Text(
                                  '${(size / 1024).toStringAsFixed(1)} KB',
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: theme
                                              .colorScheme.outline),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 60,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedFilePath = null;
                        _selectedFileName = null;
                      }),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(2),
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
                label: Text(_editingId != null
                    ? l.saveChangesShort
                    : l.saveFile),
              ),
            ),
            if (_editingId != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text('Delete document'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side:
                        BorderSide(color: theme.colorScheme.error),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String _documentTypeLabel(AppLocalizations l, DocumentType type) {
    return switch (type) {
      DocumentType.fine => l.docTypeFine,
      DocumentType.parkingFee => l.docTypeParkingFee,
      DocumentType.insurance => l.docTypeInsurance,
      DocumentType.vehicleCheck => l.docTypeVehicleCheck,
      DocumentType.tax => l.docTypeTax,
      DocumentType.complexInsurance => l.docTypeComplexInsurance,
      DocumentType.vehicleRegister => l.docTypeVehicleRegister,
      DocumentType.other => l.docTypeOther,
    };
  }
}

class _DocumentPreview extends ConsumerWidget {
  final String vehicleId;
  final VehicleDocument document;

  const _DocumentPreview({
    required this.vehicleId,
    required this.document,
  });

  bool _isImageFile(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif']
        .contains(ext);
  }

  String _documentTypeLabel(AppLocalizations l, DocumentType type) {
    return switch (type) {
      DocumentType.fine => l.docTypeFine,
      DocumentType.parkingFee => l.docTypeParkingFee,
      DocumentType.insurance => l.docTypeInsurance,
      DocumentType.vehicleCheck => l.docTypeVehicleCheck,
      DocumentType.tax => l.docTypeTax,
      DocumentType.complexInsurance => l.docTypeComplexInsurance,
      DocumentType.vehicleRegister => l.docTypeVehicleRegister,
      DocumentType.other => l.docTypeOther,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final doc = document;
    final isImage = doc.filePath.isNotEmpty && _isImageFile(doc.filePath);
    final width = MediaQuery.of(context).size.width - 40;

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
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(doc.filePath),
                height: 250,
                width: width,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.insert_drive_file,
                    size: 64, color: theme.colorScheme.outline),
              ),
            ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description),
            title: Text(doc.name),
            subtitle: Text(doc.fileName),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.label),
            title: Text(_documentTypeLabel(l, doc.type)),
          ),
          if (doc.notes != null && doc.notes!.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notes),
              title: Text(doc.notes!),
            ),
          if (doc.expiryDate != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                  '${doc.expiryDate!.day}/${doc.expiryDate!.month}/${doc.expiryDate!.year}'),
            ),
          if (doc.fileSize != null && doc.fileSize! > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.storage, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${(doc.fileSize! / 1024).toStringAsFixed(1)} KB',
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
