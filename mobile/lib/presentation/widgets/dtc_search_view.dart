import 'package:flutter/material.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';

class DtcSearchView extends StatefulWidget {
  final List<ResolvedDtc> dtcs;
  final List<ResolvedItem> items;
  final String dbName;

  const DtcSearchView({
    super.key,
    required this.dtcs,
    required this.items,
    required this.dbName,
  });

  @override
  State<DtcSearchView> createState() => _DtcSearchViewState();
}

class _DtcSearchViewState extends State<DtcSearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ResolvedDtc> get _matches {
    final query = _searchController.text.trim().toUpperCase();
    if (query.isEmpty) return const [];
    final start = widget.dtcs.where((d) => d.code.startsWith(query)).toList();
    if (start.length >= 50) return start.take(50).toList();
    final contains = widget.dtcs
        .where((d) => !d.code.startsWith(query) && d.code.contains(query));
    return [...start, ...contains].take(50).toList();
  }

  void _showDetails(AppLocalizations l, ResolvedDtc dtc) {
    final theme = Theme.of(context);
    final desc =
        localizedDesc(l.localeName, dtc.descI18nKey, dtc.description ?? '');
    final related = <String>[];
    for (final id in dtc.relatedMaintenance) {
      for (final item in widget.items) {
        if (item.id == id) {
          related.add(localizedLabel(l.localeName, item.i18nKey, item.label));
          break;
        }
      }
    }

    karterShowModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
            Row(
              children: [
                Text(
                  dtc.code,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text(
                    dtc.scope == 'standard'
                        ? l.dtcScopeStandard
                        : l.dtcScopeManufacturer,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (desc.isNotEmpty) ...[
              Text(desc, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
            ],
            if (related.isNotEmpty) ...[
              Text(l.dtcRelatedMaintenance,
                  style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              ...related.map((r) => Text(
                    r,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final matches = _matches;
    final query = _searchController.text.trim();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.directions_car,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.dbName, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.dtcs.length}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          textCapitalization: TextCapitalization.characters,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: l.dtcSearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        if (query.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                l.dtcEmptyState,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else if (matches.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Text(
                l.dtcNoMatch,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...matches.map(
            (d) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                d.scope == 'standard' ? Icons.public : Icons.build,
                color: theme.colorScheme.primary,
              ),
              title: Text(
                d.code,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                ),
              ),
              subtitle: Text(
                localizedDesc(
                  l.localeName,
                  d.descI18nKey,
                  d.description ?? '',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDetails(l, d),
            ),
          ),
      ],
    );
  }
}
