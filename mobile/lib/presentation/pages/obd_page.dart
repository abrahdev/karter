import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/dtc_search_view.dart';

class ObdPage extends ConsumerStatefulWidget {
  const ObdPage({super.key});

  @override
  ConsumerState<ObdPage> createState() => _ObdPageState();
}

class _ObdPageState extends ConsumerState<ObdPage> {
  String? _selectedVehicleId;
  List<ResolvedDtc> _dtcs = [];
  List<ResolvedItem> _items = [];
  String _dbName = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGeneral();
  }

  Future<void> _loadGeneral() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final dtcs = await repo.resolveGeneralDtcs();
      if (!mounted) return;
      setState(() {
        _dtcs = dtcs;
        _items = [];
        _dbName = AppLocalizations.of(context)?.dtcGeneralDb ?? '';
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.dtcLoadError;
      });
    }
  }

  Future<void> _loadVehicle(Vehicle vehicle) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(catalogRepositoryProvider);

      final resolution = await repo.findBestMatch(
        make: vehicle.brand,
        model: vehicle.model,
        year: vehicle.year,
      );

      if (!mounted) return;

      if (resolution != null) {
        final meta = resolution.entry.meta;
        final name = [
          meta.make,
          meta.model,
          if (meta.generation != null) meta.generation,
        ].join(' ');
        setState(() {
          _dtcs = resolution.dtcs;
          _items = resolution.items;
          _dbName = name;
          _loading = false;
        });
      } else {
        final dtcs = await repo.resolveGeneralDtcs();
        if (!mounted) return;
        setState(() {
          _dtcs = dtcs;
          _items = [];
          _dbName = AppLocalizations.of(context)?.dtcGeneralDb ?? '';
          _loading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.dtcLoadError;
      });
    }
  }

  void _onVehicleChanged(String? vehicleId) {
    setState(() => _selectedVehicleId = vehicleId);
    if (vehicleId == null) {
      _loadGeneral();
      return;
    }
    final vehicles = ref.read(vehicleListProvider).value;
    Vehicle? selected;
    if (vehicles != null) {
      for (final v in vehicles) {
        if (v.id == vehicleId) {
          selected = v;
          break;
        }
      }
    }
    if (selected != null) _loadVehicle(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final vehiclesAsync = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.navObd)),
      body: vehiclesAsync.when(
        data: (vehicles) => _buildBody(l, theme, vehicles),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.dtcLoadError, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: _loadGeneral,
                child: Text(l.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations l,
    ThemeData theme,
    List<Vehicle> vehicles,
  ) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;
    final selectorWidth = isWide ? 400.0 : double.infinity;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            0,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: selectorWidth,
              child: DropdownButtonFormField<String>(
                initialValue: _selectedVehicleId,
                decoration: InputDecoration(
                  labelText: l.dtcVehicle,
                  prefixIcon: const Icon(Icons.directions_car),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l.dtcGeneralDb),
                  ),
                  ...vehicles.map(
                    (v) => DropdownMenuItem<String>(
                      value: v.id,
                      child: Text(
                        v.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: _onVehicleChanged,
              ),
            ),
          ),
        ),
        Expanded(child: _buildResults(l, theme)),
      ],
    );
  }

  Widget _buildResults(AppLocalizations l, ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _selectedVehicleId == null
                  ? _loadGeneral
                  : () => _onVehicleChanged(_selectedVehicleId),
              child: Text(l.retry),
            ),
          ],
        ),
      );
    }

    return DtcSearchView(dtcs: _dtcs, items: _items, dbName: _dbName);
  }
}
