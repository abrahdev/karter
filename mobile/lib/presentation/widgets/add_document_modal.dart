import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
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
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _AddDocumentModal(vehicleId: vehicleId),
  );

  if (result == true && context.mounted) {
    final l = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.documentSaved)),
    );
    onSaved();
  }
}

class _AddDocumentModal extends ConsumerStatefulWidget {
  final String vehicleId;

  const _AddDocumentModal({required this.vehicleId});

  @override
  ConsumerState<_AddDocumentModal> createState() => _AddDocumentModalState();
}

class _AddDocumentModalState extends ConsumerState<_AddDocumentModal> {
  DocumentType _selectedType = DocumentType.fine;
  PlatformFile? _selectedFile;
  final _notesController = TextEditingController();
  DateTime? _expiryDate;
  bool _saving = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'xls', 'xlsx',
      ],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _selectedFile = result.files.first);
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
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.pleaseSelectFile)),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final uuid = const Uuid().v4();
      final ext = _selectedFile!.extension ?? 'bin';
      final dir = await getApplicationDocumentsDirectory();
      final docDir =
          Directory('${dir.path}/documents/${widget.vehicleId}');
      await docDir.create(recursive: true);

      final destPath = '${docDir.path}/$uuid.$ext';
      if (_selectedFile!.path != null) {
        await File(_selectedFile!.path!).copy(destPath);
      }

      final repo = ref.read(vehicleDocumentRepositoryProvider);
      await repo.save(VehicleDocument(
        id: uuid,
        vehicleId: widget.vehicleId,
        type: _selectedType,
        name: _selectedFile!.name,
        fileName: _selectedFile!.name,
        filePath: destPath,
        mimeType: _selectedFile!.extension != null
            ? 'application/${_selectedFile!.extension}'
            : null,
        fileSize: _selectedFile!.size.toDouble(),
        notes: _notesController.text.isNotEmpty
            ? _notesController.text
            : null,
        expiryDate: _expiryDate,
        createdAt: DateTime.now(),
      ));

      if (mounted) Navigator.pop(context, true);
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
            Text(l.addDocument,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            DropdownButtonFormField<DocumentType>(
              value: _selectedType,
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
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(_selectedFile != null
                  ? _selectedFile!.name
                  : l.selectFile),
            ),
            if (_selectedFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
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
            InkWell(
              onTap: _pickExpiryDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.expiryDateOptional,
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  _expiryDate != null
                      ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                      : '',
                ),
              ),
            ),
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
                label: Text(l.saveChangesShort),
              ),
            ),
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
