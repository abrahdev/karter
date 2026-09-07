import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/export_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
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
        data: (vehicles) => ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            SectionHeader(title: l.moreExport),
            GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: Text(l.dataManagerTitle),
                  subtitle: Text(l.moreExportSubtitle),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_outlined),
                  title: Text(l.export),
                  subtitle: Text(
                    _selectedIds.isEmpty
                        ? l.dataManagerSelectHint
                        : l.dataManagerSelected(_selectedIds.length.toString()),
                  ),
                  trailing: _isExporting
                      ? const M3LoadingIndicator(size: 18)
                      : const Icon(Icons.chevron_right),
                  onTap: _selectedIds.isEmpty || _isExporting ? null : _export,
                ),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(l.import),
                  subtitle: Text(l.importHint),
                  trailing: _isImporting
                      ? const M3LoadingIndicator(size: 18)
                      : const Icon(Icons.chevron_right),
                  onTap: _isImporting ? null : _import,
                ),
              ],
            ),
            SectionHeader(title: l.navVehicles),
            if (vehicles.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l.homeEmptyTitle,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              )
            else
              GroupedCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.checklist),
                    title: Text(l.selectAll),
                    trailing: Checkbox(
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
                    onTap: () {
                      setState(() {
                        if (_selectedIds.length == vehicles.length) {
                          _selectedIds.clear();
                        } else {
                          _selectedIds.addAll(vehicles.map((v) => v.id));
                        }
                      });
                    },
                  ),
                  for (final v in vehicles)
                    CheckboxListTile(
                      secondary: const Icon(Icons.directions_car_outlined),
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
                    ),
                ],
              ),
          ],
        ),
        loading: () => const Center(
            child: M3LoadingIndicator(
                contained: true, size: 36, containerSize: 72)),
        error: (e, _) => Center(child: Text(l.errorGeneric(e.toString()))),
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
          await File(path.toFilePath()).writeAsString(json);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.exportedAt(path.toFilePath()))),
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

    if (result.isEmpty || result.first.path == null) return;

    final file = File(result.first.path!);
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
