import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/template_list_page.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/utils/template_interval_builder.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';
import 'package:mobile/presentation/widgets/dtc_search_view.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/section_header.dart';

class TemplateDetailPage extends ConsumerWidget {
  const TemplateDetailPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final resolution = ref.watch(templateByIdProvider(vehicleId));

    final title = switch (resolution) {
      AsyncData(:final value) => value == null
          ? l.templateNotFound
          : [
              value.entry.meta.make,
              value.entry.meta.model,
              if (value.entry.meta.generation != null) value.entry.meta.generation!,
            ].join(' '),
      _ => l.templatesTitle,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: switch (resolution) {
        AsyncData(:final value) when value != null =>
          _TemplateDetailBody(resolution: value),
        AsyncData() => Center(child: Text(l.templateNotFound)),
        AsyncError() => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Text(l.templatesLoadError),
            ),
          ),
        _ => const Center(child: M3LoadingIndicator(size: 32)),
      },
    );
  }
}

class _TemplateDetailBody extends ConsumerWidget {
  const _TemplateDetailBody({required this.resolution});

  final TemplateResolution resolution;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final meta = resolution.entry.meta;
    final engine = meta.engine;

    final engineBits = <String>[
      if (engine?.code != null) engine!.code!,
      if (engine?.fuel != null) fuelLabel(l, engine!.fuel),
      if (engine?.powertrain != null) powertrainLabel(l, engine!.powertrain),
      if (engine?.displacementCc != null) '${engine!.displacementCc} cc',
      if (engine?.powerHp != null) '${engine!.powerHp} hp',
    ];

    final metaTiles = <Widget>[
      if (meta.years != null)
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text(l.templateYears),
          trailing: Text(
            meta.years![1] == null
                ? '${meta.years![0]}–${l.templateYearsOpen}'
                : '${meta.years![0]}–${meta.years![1]}',
          ),
        ),
      if (engineBits.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.engineering),
          title: Text(l.templateEngine),
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Text(
              engineBits.join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(l.templateAuthor),
        trailing: Text(meta.author.isEmpty ? '—' : meta.author),
      ),
      ListTile(
        leading: const Icon(Icons.tag),
        title: Text(l.templateVersion),
        trailing: Text(meta.version.isEmpty ? '—' : meta.version),
      ),
      if (meta.sources != null && meta.sources!.isNotEmpty)
        ListTile(
          leading: const Icon(Icons.source),
          title: Text(l.templateSources),
          trailing: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: Text(
              meta.sources!.join('\n'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
    ];

    final maintenanceSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.maintenanceListTitle),
        GroupedCard(
          children: [
            for (final item in resolution.items)
              _MaintenanceItemTile(item: item, resolution: resolution),
          ],
        ),
      ],
    );

    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l.partsTitle),
        GroupedCard(
          children: resolution.parts.isEmpty
              ? [
                  ListTile(
                    title: Text(
                      l.noPartsFound,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ]
              : [
                  for (final part in resolution.parts)
                    _PartTile(part: part),
                ],
        ),
        SectionHeader(title: l.dtcCodesTitle),
        GroupedCard(
          children: [
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: Text(l.dtcCount(resolution.dtcs.length)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openDtcSearch(context, l),
            ),
          ],
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        if (!isWide) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: [
              SectionHeader(title: l.templateInfo),
              GroupedCard(children: metaTiles),
              maintenanceSection,
              ...rightColumn.children,
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(title: l.templateInfo),
                      GroupedCard(children: metaTiles),
                      maintenanceSection,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(child: rightColumn),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openDtcSearch(BuildContext context, AppLocalizations l) {
    karterShowModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DtcSearchSheet(
        dtcs: resolution.dtcs,
        items: resolution.items,
        dbName: [
          resolution.entry.meta.make,
          resolution.entry.meta.model,
          if (resolution.entry.meta.generation != null)
            resolution.entry.meta.generation!,
        ].join(' '),
      ),
    );
  }
}

class _DtcSearchSheet extends StatelessWidget {
  const _DtcSearchSheet({
    required this.dtcs,
    required this.items,
    required this.dbName,
  });

  final List<ResolvedDtc> dtcs;
  final List<ResolvedItem> items;
  final String dbName;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            const DragHandle(),
            const SizedBox(height: 4),
            Expanded(
              child: DtcSearchView(
                dtcs: dtcs,
                items: items,
                dbName: dbName,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MaintenanceItemTile extends StatelessWidget {
  const _MaintenanceItemTile({required this.item, required this.resolution});

  final ResolvedItem item;
  final TemplateResolution resolution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final locale = l.localeName;
    final label = localizedLabel(locale, item.i18nKey, item.label);
    final description =
        localizedDesc(locale, item.descI18nKey, item.description ?? '');
    final parts = templateParts(resolution, item);

    final intervalBits = <String>[
      '${item.intervalKm} km',
      if (item.intervalMonths != null) '${item.intervalMonths} ${l.months}',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          title: Text(label),
          subtitle: description.isEmpty
              ? null
              : Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
          trailing: Text(
            intervalBits.join(' / '),
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
        if (parts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: IntervalPartsView(parts: parts),
          ),
      ],
    );
  }
}

class _PartTile extends StatelessWidget {
  const _PartTile({required this.part});

  final ResolvedPart part;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final locale = l.localeName;
    final name = localizedLabel(locale, part.i18nKey, part.name ?? part.id);

    final bits = <String>[
      if (part.oemNumber != null) part.oemNumber!,
      if (part.quantity != null)
        '${_fmtQty(part.quantity!)} ${_unit(theme, l, part.unit)}'.trim(),
    ];

    return ListTile(
      dense: true,
      title: Text(name),
      subtitle: part.description != null
          ? Text(
              part.description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: bits.isEmpty
          ? null
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                bits.join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
    );
  }

  String _fmtQty(double qty) {
    if (qty == qty.roundToDouble()) return qty.round().toString();
    return qty.toString();
  }

  String _unit(ThemeData theme, AppLocalizations l, String? unit) {
    switch (unit) {
      case 'unit':
        return l.partUnitUnit;
      case 'set':
        return l.partUnitSet;
      case 'kit':
        return l.partUnitKit;
      case 'can':
        return l.partUnitCan;
      default:
        return unit ?? '';
    }
  }
}