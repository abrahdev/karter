import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/export_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataManagerPage extends ConsumerStatefulWidget {
  const DataManagerPage({super.key});

  @override
  ConsumerState<DataManagerPage> createState() => _DataManagerPageState();
}

class _DataManagerPageState extends ConsumerState<DataManagerPage> {
  final Set<String> _selectedIds = {};
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final vehiclesAsync = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.dataManagerTitle)),
      body: vehiclesAsync.when(
        data: (vehicles) => Column(
          children: [
            Expanded(
              child: vehicles.isEmpty
                  ? Center(
                      child: Text(l.homeEmptyTitle,
                          style: theme.textTheme.bodyLarge),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      itemCount: vehicles.length,
                      itemBuilder: (_, i) {
                        final v = vehicles[i];
                        return CheckboxListTile(
                          title: Text(v.displayName),
                          subtitle: Text('${v.brand} ${v.model} ${v.year}'),
                          value: _selectedIds.contains(v.id),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedIds.add(v.id);
                              } else {
                                _selectedIds.remove(v.id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            if (vehicles.isNotEmpty)
              CheckboxListTile(
                title: Text(l.selectAll),
                value: _selectedIds.length == vehicles.length,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedIds.addAll(vehicles.map((v) => v.id));
                    } else {
                      _selectedIds.clear();
                    }
                  });
                },
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _selectedIds.isEmpty || _isExporting
                          ? null
                          : _export,
                      icon: _isExporting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload),
                      label: Text(
                          _isExporting ? l.exporting : l.export),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isImporting ? null : _import,
                      icon: _isImporting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.download),
                      label: Text(
                          _isImporting ? l.importing : l.import),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _export() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _isExporting = true);
    try {
      final service = ref.read(exportServiceProvider);
      final json = await service.exportVehicles(_selectedIds);
      final fileName =
          'karter-export-${DateTime.now().millisecondsSinceEpoch}.json';

      if (Platform.isLinux) {
        final path = await FilePicker.saveFile(
          dialogTitle: l.saveExport,
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['json'],
          bytes: Uint8List.fromList(utf8.encode(json)),
        );
        if (path != null) {
          await File(path).writeAsString(json);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.exportedAt(path))),
            );
          }
        }
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsString(json);

        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            text: l.exportShareText(_selectedIds.length.toString()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.exportError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context)!;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    final json = await file.readAsString();

    final preview = ExportService.preview(json);
    if (preview == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.invalidJson)),
        );
      }
      return;
    }

    if (!mounted) return;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.importData),
        content: Text(l.importPreview(
          preview.vehicles.length.toString(),
          preview.fuelLogs.length.toString(),
          preview.maintenanceLogs.length.toString(),
          preview.vehicleDocuments.length.toString(),
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.import),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isImporting = true);
    try {
      final service = ref.read(exportServiceProvider);
      await service.importJson(json);

      ref.invalidate(vehicleListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.importSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.importError(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}
