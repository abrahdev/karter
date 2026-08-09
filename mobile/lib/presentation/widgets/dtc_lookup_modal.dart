import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/dtc_search_view.dart';

Future<void> showDtcLookupModal(
  BuildContext context, {
  String? vehicleId,
}) {
  return karterShowModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DtcLookupSheet(vehicleId: vehicleId),
  );
}

class DtcLookupSheet extends ConsumerStatefulWidget {
  final String? vehicleId;

  const DtcLookupSheet({super.key, this.vehicleId});

  @override
  ConsumerState<DtcLookupSheet> createState() => _DtcLookupSheetState();
}

class _DtcLookupSheetState extends ConsumerState<DtcLookupSheet> {
  List<ResolvedDtc> _dtcs = [];
  List<ResolvedItem> _items = [];
  String _dbName = '';
  bool _loading = true;
  String? _error;
  String? _selectedVehicleId;

  @override
  void initState() {
    super.initState();
    _selectedVehicleId = widget.vehicleId;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = ref.read(catalogRepositoryProvider);

      if (_selectedVehicleId == null) {
        final dtcs = await repo.resolveGeneralDtcs();
        if (!mounted) return;
        setState(() {
          _dtcs = dtcs;
          _items = [];
          _dbName = AppLocalizations.of(context)?.dtcGeneralDb ?? '';
          _loading = false;
        });
        return;
      }

      final vehicle = await ref
          .read(vehicleProvider(_selectedVehicleId!).future);
      if (!mounted) return;

      if (vehicle == null) {
        setState(() {
          _loading = false;
          _error = AppLocalizations.of(context)?.dtcVehicleNotFound;
        });
        return;
      }

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
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(l.dtcLookupTitle, style: theme.textTheme.titleLarge),
            ),
          ),
          if (widget.vehicleId == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: _buildVehicleSelector(l),
            ),
          Expanded(child: _buildBody(theme, l)),
        ],
      ),
    );
  }

  Widget _buildVehicleSelector(AppLocalizations l) {
    final vehicles = ref.watch(vehicleListProvider).value;
    final list = vehicles ?? const <Vehicle>[];

    return DropdownButtonFormField<String>(
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
        ...list.map(
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
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l) {
    if (_loading) {
      return const Center(
        child: M3LoadingIndicator(contained: true, size: 36, containerSize: 72),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _load,
              child: Text(l.retry),
            ),
          ],
        ),
      );
    }

    return DtcSearchView(dtcs: _dtcs, items: _items, dbName: _dbName);
  }
}
