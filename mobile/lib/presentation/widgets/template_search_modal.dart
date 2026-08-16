import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/template_interval_builder.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class TemplateSearchOutcome {
  const TemplateSearchOutcome({required this.apply, this.name, this.intervals});

  final bool apply;
  final String? name;
  final List<MaintenanceInterval>? intervals;
}

VehicleType typeFromIntervals(List<MaintenanceInterval> intervals) {
  final keys = intervals.map((i) => i.i18nKey).toSet();
  if (keys.contains('seed_interval_battery_cooling') ||
      keys.contains('seed_interval_inverter_coolant')) {
    return VehicleType.electric;
  }
  if (keys.contains('seed_interval_chain') ||
      keys.contains('seed_interval_valve_adjustment') ||
      keys.contains('seed_interval_drive_kit')) {
    return VehicleType.motorcycle;
  }
  return VehicleType.combustion;
}

Future<TemplateSearchOutcome?> showTemplateSearchModal(
  BuildContext context, {
  required String brand,
  required String model,
  required int year,
}) {
  return karterShowModalBottomSheet<TemplateSearchOutcome>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) =>
        _TemplateSearchModal(brand: brand, model: model, year: year),
  );
}

enum _SearchStatus { loading, found, notFound, error }

class _TemplateSearchModal extends ConsumerStatefulWidget {
  final String brand;
  final String model;
  final int year;

  const _TemplateSearchModal({
    required this.brand,
    required this.model,
    required this.year,
  });

  @override
  ConsumerState<_TemplateSearchModal> createState() =>
      _TemplateSearchModalState();
}

class _TemplateSearchModalState extends ConsumerState<_TemplateSearchModal> {
  _SearchStatus _status = _SearchStatus.loading;
  List<MaintenanceInterval>? _intervals;
  String? _templateName;
  String _searchParams = '';
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final resolution = await repo.findBestMatch(
        make: widget.brand,
        model: widget.model,
        year: widget.year,
      );
      if (!mounted) return;
      if (resolution != null) {
        final intervals = resolution.items
            .map((r) => intervalFromTemplate('', r, resolution))
            .toList();
        final meta = resolution.entry.meta;
        final name = [
          meta.make,
          meta.model,
          if (meta.generation != null) meta.generation,
        ].join(' ');
        setState(() {
          _intervals = intervals;
          _templateName = name;
          _status = _SearchStatus.found;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 450), () {
            if (!mounted || !_scrollController.hasClients) return;
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
            );
          });
        });
      } else {
        setState(() {
          _searchParams = '${widget.brand} ${widget.model} ${widget.year}';
          _status = _SearchStatus.notFound;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchParams = '${widget.brand} ${widget.model} ${widget.year}';
        _status = _SearchStatus.error;
      });
    }
  }

  void _popKeepDefaults() {
    Navigator.pop(context, const TemplateSearchOutcome(apply: false));
  }

  void _launch(String url) {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DragHandle(),
            const SizedBox(height: 16),
            Text(l.searchTemplate, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            switch (_status) {
              _SearchStatus.loading => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: M3LoadingIndicator(size: 32),
                ),
              ),
              _SearchStatus.found => _buildFound(theme, l),
              _SearchStatus.notFound => _buildNotFound(theme, l),
              _SearchStatus.error => _buildError(theme, l),
            },
            const SizedBox(height: 16),
            ..._buildActions(l),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(AppLocalizations l) {
    switch (_status) {
      case _SearchStatus.loading:
        return const [];
      case _SearchStatus.found:
        return [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(
                context,
                TemplateSearchOutcome(
                  apply: true,
                  name: _templateName,
                  intervals: _intervals,
                ),
              ),
              child: Text(l.useTemplate),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _popKeepDefaults,
              child: Text(l.noTemplate),
            ),
          ),
        ];
      case _SearchStatus.notFound:
        return [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launch('https://karter.abrah.dev/templates'),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.viewAllTemplates),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launch('https://github.com/abrahdev/karter'),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.contribute),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _popKeepDefaults,
              child: Text(l.gotIt),
            ),
          ),
        ];
      case _SearchStatus.error:
        return [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launch('https://github.com/abrahdev/karter'),
              icon: const Icon(Icons.open_in_new, size: 18),
              label: Text(l.contributeOnGitHub),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _popKeepDefaults,
              child: Text(l.gotIt),
            ),
          ),
        ];
    }
  }

  Widget _buildFound(ThemeData theme, AppLocalizations l) {
    final intervals = _intervals ?? const <MaintenanceInterval>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(l.templateFound, style: theme.textTheme.titleMedium),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _templateName ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: intervals.length,
          itemBuilder: (ctx, i) {
            final interval = intervals[i];
            final parts = <String>['${interval.kmInterval} km'];
            if (interval.monthsInterval != null) {
              parts.add('${interval.monthsInterval} ${l.months}');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(interval.label),
                  subtitle: interval.description != null
                      ? Text(
                          interval.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: IntrinsicWidth(
                    child: Text(
                      parts.join(' / '),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.end,
                      softWrap: false,
                    ),
                  ),
                ),
                if (interval.parts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: l.partsTitle,
                          topPadding: 0,
                          bottomPadding: 2,
                          leftPadding: 0,
                        ),
                        IntervalPartsView(parts: interval.parts),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.templateDisclaimer,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotFound(ThemeData theme, AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.search_off, color: theme.colorScheme.outline, size: 48),
            const SizedBox(width: 16),
            Expanded(child: Text(l.noTemplateFoundDescription)),
          ],
        ),
        const SizedBox(height: 16),
        Text(l.searchParameters, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _searchParams,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l.defaultIntervalsHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.missingTemplateContribute,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildError(ThemeData theme, AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.construction,
              color: theme.colorScheme.primary,
              size: 48,
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(l.templateNotReady)),
          ],
        ),
        const SizedBox(height: 12),
        Text(l.contributionsWelcome, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'https://github.com/abrahdev/karter',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l.requestedParam(_searchParams),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
