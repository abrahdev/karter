import 'dart:io' show File, Platform;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/export_service.dart';
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
    final vehiclesAsync = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Exportar / Importar datos')),
      body: vehiclesAsync.when(
        data: (vehicles) => Column(
          children: [
            Expanded(
              child: vehicles.isEmpty
                  ? Center(
                      child: Text('No hay vehículos',
                          style: theme.textTheme.bodyLarge),
                    )
                  : ListView.builder(
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
                title: const Text('Seleccionar todos'),
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
                          _isExporting ? 'Exportando...' : 'Exportar'),
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
                          _isImporting ? 'Importando...' : 'Importar'),
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
    setState(() => _isExporting = true);
    try {
      final service = ref.read(exportServiceProvider);
      final json = await service.exportVehicles(_selectedIds);
      final fileName =
          'karter-export-${DateTime.now().millisecondsSinceEpoch}.json';

      if (Platform.isLinux) {
        final path = await FilePicker.platform.saveFile(
          dialogTitle: 'Guardar exportación',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
        if (path != null) {
          await File(path).writeAsString(json);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exportado en $path')),
            );
          }
        }
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsString(json);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Exportación Karter - ${_selectedIds.length} vehículo(s)',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _import() async {
    final result = await FilePicker.platform.pickFiles(
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
          const SnackBar(content: Text('Archivo JSON inválido')),
        );
      }
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Importar datos'),
        content: Text(
          'Se encontraron:\n'
          '• ${preview.vehicles.length} vehículo(s)\n'
          '• ${preview.fuelLogs.length} registro(s) de combustible\n'
          '• ${preview.maintenanceLogs.length} servicio(s)\n'
          '• ${preview.maintenanceIntervals.length} intervalo(s)\n\n'
          '¿Importar? Los datos existentes con el mismo ID serán '
          'sobrescritos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Importar'),
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
          const SnackBar(content: Text('Datos importados correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al importar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }
}
