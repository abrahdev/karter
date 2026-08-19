import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/vehicle_document.dart';
import 'package:mobile/domain/enums/document_type.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/full_screen_photo_viewer.dart';

bool isImageFile(String path) {
  final ext = path.split('.').last.toLowerCase();
  return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif'].contains(ext);
}

String documentTypeLabel(AppLocalizations l, DocumentType type) {
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
    if (!context.mounted) return;
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
  final List<String> _selectedFilePaths = [];
  final List<String> _selectedFileNames = [];
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _expiryDate;
  bool _saving = false;
  String? _editingId;
  String? _editingFilePath;

  @override
  void initState() {
    super.initState();
    final doc = widget.editDocument;
    if (doc != null) {
      _editingId = doc.id;
      _selectedType = doc.type;
      _editingFilePath = doc.filePath;
      _nameController.text = doc.name;
      _notesController.text = doc.notes ?? '';
      _expiryDate = doc.expiryDate;
      if (doc.filePaths.isNotEmpty) {
        _selectedFilePaths.addAll(doc.filePaths);
        _selectedFileNames.addAll(doc.filePaths.map((p) => p.split('/').last));
      } else {
        _selectedFilePaths.add(doc.filePath);
        _selectedFileNames.add(doc.fileName);
      }
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
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 85,
    );
    if (file != null && mounted) {
      setState(() {
        _selectedFilePaths.add(file.path);
        _selectedFileNames.add(file.name);
        if (_nameController.text.isEmpty) _nameController.text = file.name;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final files = await _picker.pickMultiImage();
    if (files.isNotEmpty && mounted) {
      setState(() {
        for (final f in files) {
          _selectedFilePaths.add(f.path);
          _selectedFileNames.add(f.name);
        }
        if (_nameController.text.isEmpty) _nameController.text = files.first.name;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
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
        for (final f in result.files) {
          if (f.path != null) {
            _selectedFilePaths.add(f.path!);
            _selectedFileNames.add(f.name);
          }
        }
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
    if (_selectedFilePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.pleaseSelectFile)),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final repo = ref.read(vehicleDocumentRepositoryProvider);
      final id = _editingId ?? const Uuid().v4();

      final List<String> savedPaths = [];
      String? mimeType;
      double totalFileSize = 0;
      String primaryFileName = _selectedFileNames.first;

      if (_editingId != null && _selectedFilePaths.length == 1 &&
          _selectedFilePaths.first == _editingFilePath) {
        savedPaths.add(widget.editDocument!.filePath);
        mimeType = widget.editDocument!.mimeType;
        totalFileSize = widget.editDocument!.fileSize ?? 0;
        primaryFileName = widget.editDocument!.fileName;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final docDir =
            Directory('${dir.path}/documents/${widget.vehicleId}');
        await docDir.create(recursive: true);
        for (final src in _selectedFilePaths) {
          final ext = src.split('.').last;
          final dest = '${docDir.path}/${const Uuid().v4()}.$ext';
          await File(src).copy(dest);
          savedPaths.add(dest);
          final f = File(src);
          totalFileSize += await f.length();
          mimeType ??= ext;
        }
      }

      await repo.save(VehicleDocument(
        id: id,
        vehicleId: widget.vehicleId,
        type: _selectedType,
        name: _nameController.text.trim().isEmpty
            ? primaryFileName
            : _nameController.text.trim(),
        fileName: primaryFileName,
        filePath: savedPaths.first,
        mimeType: mimeType,
        fileSize: totalFileSize,
        notes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        expiryDate: _expiryDate,
        createdAt: widget.editDocument?.createdAt ?? DateTime.now(),
        filePaths: savedPaths,
      ));

      ref.read(hapticProvider.notifier).success();
      if (mounted) Navigator.pop(context, 'saved');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteDocument),
        content: Text(l.deleteDocumentConfirm),
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
        ref.read(hapticProvider.notifier).delete();
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
            const DragHandle(),
            const SizedBox(height: 16),
            Text(_editingId != null ? l.editDocument : l.addDocument,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            DropdownButtonFormField<DocumentType>(
              isExpanded: true,
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l.documentType,
              ),
              items: DocumentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(documentTypeLabel(l, type)),
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
                labelText: l.title,
                hintText: _selectedFileNames.isNotEmpty ? _selectedFileNames.first : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l.notesOptional,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _expiryDate != null
                    ? DateFormat.yMd(l.localeName).format(_expiryDate!)
                    : l.selectExpiryDate,
              ),
              onTap: _pickExpiryDate,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _showSourcePicker,
              icon: const Icon(Icons.attach_file),
              label: Text(
                _selectedFilePaths.isNotEmpty ? l.addMoreFiles : l.selectFile,
              ),
            ),
            if (_selectedFilePaths.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedFilePaths.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (ctx, i) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isImageFile(_selectedFilePaths[i])
                            ? Image.file(
                                File(_selectedFilePaths[i]),
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
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _selectedFilePaths.removeAt(i);
                            _selectedFileNames.removeAt(i);
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
                ),
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
}

class _DocumentPreview extends ConsumerWidget {
  final String vehicleId;
  final VehicleDocument document;

  const _DocumentPreview({
    required this.vehicleId,
    required this.document,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final doc = document;
    final allPaths = doc.filePaths.isNotEmpty ? doc.filePaths : [doc.filePath];
    final imagePaths = allPaths.where(isImageFile).toList();
    final nonImagePaths = allPaths.where((p) => !isImageFile(p)).toList();
    final hasImages = imagePaths.isNotEmpty;
    final width = MediaQuery.of(context).size.width - 40;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DragHandle(),
          const SizedBox(height: 16),
          if (hasImages && imagePaths.length == 1)
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => FullScreenPhotoViewer(
                      paths: imagePaths,
                      initialIndex: 0,
                      heroTag: 'document_photo_${doc.id}_0',
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Hero(
                  tag: 'document_photo_${doc.id}_0',
                  child: Image.file(
                    File(imagePaths.first),
                    height: 250,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else if (hasImages && imagePaths.length > 1)
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
                        paths: imagePaths,
                        initialIndex: index,
                        heroTag: 'document_photo_${doc.id}_$index',
                      ),
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                children: imagePaths.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: 'document_photo_${doc.id}_${entry.key}',
                      child: Image.file(
                        File(entry.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )).toList(),
              ),
            )
          else if (nonImagePaths.isNotEmpty)
            for (final path in nonImagePaths)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final uri = Uri.file(path);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(_iconForPath(path),
                              size: 40,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(path.split('/').last,
                                    style: theme.textTheme.bodyMedium),
                                const SizedBox(height: 2),
                                Text(
                                  path.split('.').last.toUpperCase(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.open_in_new,
                              size: 20, color: theme.colorScheme.outline),
                        ],
                      ),
                    ),
                  ),
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
          if (hasImages && imagePaths.length > 1) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagePaths.length,
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
          if (allPaths.length > 1) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${allPaths.length} ${l.files}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
          if (allPaths.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  SharePlus.instance.share(ShareParams(files: allPaths.map((p) => XFile(p)).toList()));
                },
                icon: const Icon(Icons.share),
                label: Text(l.share),
              ),
            ),
          ],
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
            title: Text(documentTypeLabel(l, doc.type)),
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

  IconData _iconForPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf,
      'doc' || 'docx' => Icons.article,
      'xls' || 'xlsx' => Icons.table_chart,
      _ => Icons.insert_drive_file,
    };
  }
}
