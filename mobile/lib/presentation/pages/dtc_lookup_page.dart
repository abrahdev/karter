import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/dtc_search_view.dart';

class DtcLookupPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const DtcLookupPage({super.key, required this.vehicleId});

  @override
  ConsumerState<DtcLookupPage> createState() => _DtcLookupPageState();
}

class _DtcLookupPageState extends ConsumerState<DtcLookupPage> {
  List<ResolvedDtc> _dtcs = [];
  List<ResolvedItem> _items = [];
  String _dbName = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final vehicle = await ref.read(vehicleProvider(widget.vehicleId).future);
      if (!mounted) return;

      if (vehicle == null) {
        setState(() {
          _loading = false;
          _error = AppLocalizations.of(context)?.dtcVehicleNotFound;
        });
        return;
      }

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.dtcLookupTitle)),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
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
              onPressed: _load,
              child: Text(AppLocalizations.of(context)?.retry ?? ''),
            ),
          ],
        ),
      );
    }

    return DtcSearchView(dtcs: _dtcs, items: _items, dbName: _dbName);
  }
}
