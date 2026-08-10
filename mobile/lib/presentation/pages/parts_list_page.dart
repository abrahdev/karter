import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/domain/entities/maintenance_log_part.dart';
import 'package:mobile/domain/entities/vehicle_part.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/widgets/add_maintenance_log_modal.dart';
import 'package:mobile/presentation/widgets/interval_parts_view.dart';
import 'package:mobile/presentation/widgets/maintenance_log_parts_field.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:url_launcher/url_launcher.dart';

class PartsListPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const PartsListPage({super.key, required this.vehicleId});

  @override
  ConsumerState<PartsListPage> createState() => _PartsListPageState();
}

class _PartsListPageState extends ConsumerState<PartsListPage> {
  Future<void> _createLocalPart() async {
    final created = await showQuickCreatePartSheet(context);
    if (created != null && mounted) {
      ref.invalidate(vehiclePartsProvider);
    }
  }

  Future<void> _savePart(_PartEntry entry, IntervalPart updated) async {
    final repo = ref.read(maintenanceIntervalRepositoryProvider);
    final intervals = await repo.getByVehicle(widget.vehicleId);
    for (final interval in intervals) {
      var dirty = false;
      final newParts = interval.parts.map((part) {
        final isTarget = entry.isTemplate
            ? part.partId == entry.partId
            : part.partId == entry.partId &&
                interval.id == entry.sourceIntervalId;
        if (!isTarget) return part;
        dirty = true;
        return IntervalPart(
          partId: part.partId,
          name: part.name,
          i18nKey: part.i18nKey,
          oemNumber: updated.oemNumber,
          quantity: part.quantity,
          unit: part.unit,
          description: updated.description,
          links: updated.links,
        );
      }).toList();
      if (dirty) {
        await repo.save(interval.copyWith(parts: newParts));
      }
    }
    if (mounted) {
      ref.invalidate(maintenanceIntervalsProvider(widget.vehicleId));
      ref.read(hapticProvider.notifier).selectionTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final intervalsAsync =
        ref.watch(maintenanceIntervalsProvider(widget.vehicleId));
    final localPartsAsync = ref.watch(vehiclePartsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.partsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: _createLocalPart,
        tooltip: l.newPart,
        child: const Icon(Icons.add),
      ),
      body: intervalsAsync.when(
        data: (intervals) {
          return localPartsAsync.when(
            data: (localParts) {
              final entries = _aggregate(intervals, l);
              if (localParts.isEmpty && entries.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    child: Text(
                      l.noParts,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                children: [
                  SectionHeader(title: l.localParts),
                  if (localParts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        l.noParts,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final part in localParts)
                      _LocalPartCard(vehicleId: widget.vehicleId, part: part),
                  SectionHeader(title: l.intervalParts),
                  if (entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        l.noParts,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final entry in entries)
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.check_circle_outline,
                            color: theme.colorScheme.primary,
                          ),
                          title: Text(_partLine(context, entry)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (entry.oemNumber != null &&
                                  entry.oemNumber!.isNotEmpty)
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${l.oemNumber}: ${entry.oemNumber}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy_outlined,
                                          size: 16),
                                      visualDensity: VisualDensity.compact,
                                      tooltip: l.copy,
                                      onPressed: () => _copy(
                                          context, entry.oemNumber!),
                                    ),
                                  ],
                                ),
                              if (entry.links.isNotEmpty)
                                _LinkChips(links: entry.links),
                              if (entry.relatedIntervals.isNotEmpty)
                                _RelatedServicesChips(
                                  intervals: entry.relatedIntervals,
                                  onTap: _openInterval,
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _openDetail(entry),
                        ),
                      ),
                ],
              );
            },
            loading: () => const Center(
              child: M3LoadingIndicator(
                  contained: true, size: 36, containerSize: 72),
            ),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(
          child: M3LoadingIndicator(contained: true, size: 36, containerSize: 72),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _partLine(BuildContext context, _PartEntry entry) {
    final l = AppLocalizations.of(context)!;
    final unit = IntervalPartsView.unitLabel(context, entry.unit);
    final qty = IntervalPartsView.formatQuantity(entry.quantity);
    final name = entry.displayName(l);
    if (unit.isEmpty) {
      if (entry.quantity == 1) return name;
      return '$name \u00d7 $qty';
    }
    return '$name \u00d7 $qty $unit';
  }

  Future<void> _copy(BuildContext context, String text) async {
    final l = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l.copied),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  Future<void> _openDetail(_PartEntry entry) async {
    final result = await karterShowModalBottomSheet<_PartEditResult>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _PartDetailSheet(entry: entry),
    );
    if (result != null && mounted) {
      final updated = IntervalPart(
        partId: entry.partId,
        name: entry.name,
        i18nKey: entry.i18nKey,
        oemNumber: result.oemNumber.trim().isEmpty
            ? null
            : result.oemNumber.trim(),
        quantity: entry.quantity,
        unit: entry.unit,
        description: result.description.trim(),
        links: result.links,
      );
      await _savePart(entry, updated);
    }
  }

  Future<void> _openInterval(MaintenanceInterval interval) async {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final label = localizedLabel(
      l.localeName,
      interval.i18nKey,
      interval.label,
    );
    final desc = localizedDesc(
      l.localeName,
      interval.descI18nKey,
      interval.description ?? '',
    );
    final subtitleParts = <String>[
      l.intervalSubtitleKm(_formatKm(interval.kmInterval, l)),
    ];
    if (interval.monthsInterval != null) {
      subtitleParts.add(l.intervalSubtitleMonths(interval.monthsInterval.toString()));
    }

    await karterShowModalBottomSheet<void>(
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
            Text(label, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              subtitleParts.join(' / '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc.isEmpty ? l.noDescriptionAvailable : desc,
              style: theme.textTheme.bodyMedium,
            ),
            if (interval.parts.isNotEmpty) ...[
              const SizedBox(height: 12),
              IntervalPartsView(parts: interval.parts),
            ],
            const SizedBox(height: 20),
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

  String _formatKm(int km, AppLocalizations l) {
    if (km >= 1000) return l.formattedKmK((km ~/ 1000).toString());
    return l.formattedKm(km.toString());
  }
}

class _PartEntry {
  final String partId;
  final String? name;
  final String? i18nKey;
  final String? oemNumber;
  final double quantity;
  final String? unit;
  final String? description;
  final List<String> links;
  final bool isTemplate;
  final String? sourceIntervalId;
  final List<MaintenanceInterval> relatedIntervals;

  _PartEntry({
    required this.partId,
    required this.quantity,
    required this.isTemplate,
    this.name,
    this.i18nKey,
    this.oemNumber,
    this.unit,
    this.description,
    this.links = const [],
    this.sourceIntervalId,
    this.relatedIntervals = const [],
  });

  String displayName(AppLocalizations l) {
    return localizedLabel(l.localeName, i18nKey, name ?? partId);
  }
}

List<_PartEntry> _aggregate(List<MaintenanceInterval> intervals, AppLocalizations l) {
  final byId = <String, _PartEntry>{};
  final custom = <String, _PartEntry>{};

  List<MaintenanceInterval> mergeIntervals(
    List<MaintenanceInterval> current,
    MaintenanceInterval interval,
  ) {
    if (current.any((i) => i.id == interval.id)) return current;
    return [...current, interval];
  }

  void addPart(String intervalId, IntervalPart p, MaintenanceInterval interval) {
    if (p.i18nKey != null) {
      final existing = byId[p.partId];
      if (existing == null) {
        byId[p.partId] = _PartEntry(
          partId: p.partId,
          name: p.name,
          i18nKey: p.i18nKey,
          oemNumber: p.oemNumber,
          quantity: p.quantity,
          unit: p.unit,
          description: p.description,
          links: p.links,
          isTemplate: true,
          relatedIntervals: [interval],
        );
      } else {
        byId[p.partId] = _PartEntry(
          partId: existing.partId,
          name: existing.name ?? p.name,
          i18nKey: existing.i18nKey,
          oemNumber: existing.oemNumber ?? p.oemNumber,
          quantity: existing.quantity + p.quantity,
          unit: existing.unit ?? p.unit,
          description: existing.description ?? p.description,
          links: existing.links.isNotEmpty ? existing.links : p.links,
          isTemplate: true,
          relatedIntervals: mergeIntervals(existing.relatedIntervals, interval),
        );
      }
    } else {
      final key = '$intervalId|${p.partId}';
      custom[key] = _PartEntry(
        partId: p.partId,
        name: p.name,
        oemNumber: p.oemNumber,
        quantity: p.quantity,
        unit: p.unit,
        description: p.description,
        links: p.links,
        isTemplate: false,
        sourceIntervalId: intervalId,
        relatedIntervals: [interval],
      );
    }
  }

  for (final interval in intervals) {
    for (final part in interval.parts) {
      addPart(interval.id, part, interval);
    }
  }

  final result = [...byId.values, ...custom.values];
  result.sort((a, b) {
    final na = a.displayName(l).toLowerCase();
    final nb = b.displayName(l).toLowerCase();
    final byName = na.compareTo(nb);
    if (byName != 0) return byName;
    return a.partId.compareTo(b.partId);
  });
  return result;
}

class _LocalPartCard extends ConsumerWidget {
  final String vehicleId;
  final VehiclePart part;

  const _LocalPartCard({required this.vehicleId, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final associationsAsync =
        ref.watch(maintenanceLogPartsByPartProvider(part.id));
    final logsAsync = ref.watch(maintenanceLogsProvider(vehicleId));

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.inventory_2_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(part.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _localPartLine(context, part),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (part.oemNumber != null && part.oemNumber!.isNotEmpty)
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${l.oemNumber}: ${part.oemNumber}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    visualDensity: VisualDensity.compact,
                    tooltip: l.copy,
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await Clipboard.setData(
                          ClipboardData(text: part.oemNumber!));
                      messenger.showSnackBar(SnackBar(
                        content: Text(l.copied),
                        duration: const Duration(seconds: 1),
                      ));
                    },
                  ),
                ],
              ),
            if (part.links.isNotEmpty) _LinkChips(links: part.links),
            _RelatedLogsChips(
              associationsAsync: associationsAsync,
              logsAsync: logsAsync,
              onTap: (log) => showEditMaintenanceLogModal(
                context,
                vehicleId: vehicleId,
                log: log,
                onSaved: () {
                  ref.invalidate(maintenanceLogsProvider(vehicleId));
                  ref.invalidate(
                      maintenanceIntervalsProvider(vehicleId));
                },
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openLocalPart(context, ref),
      ),
    );
  }

  String _localPartLine(BuildContext context, VehiclePart part) {
    final unit = IntervalPartsView.unitLabel(context, part.unit);
    final qty = IntervalPartsView.formatQuantity(part.quantity);
    if (unit.isEmpty) {
      if (part.quantity != 1) return '\u00d7 $qty';
    } else {
      return '\u00d7 $qty $unit';
    }
    return part.description ?? '';
  }

  Future<void> _openLocalPart(BuildContext context, WidgetRef ref) async {
    final result = await karterShowModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _LocalPartDetailSheet(part: part),
    );
    if (result == 'saved' && context.mounted) {
      ref.read(hapticProvider.notifier).success();
      ref.invalidate(vehiclePartsProvider);
    } else if (result == 'deleted' && context.mounted) {
      ref.read(hapticProvider.notifier).delete();
      ref.invalidate(vehiclePartsProvider);
    }
  }
}

class _RelatedLogsChips extends ConsumerWidget {
  final AsyncValue<List<MaintenanceLogPart>> associationsAsync;
  final AsyncValue<List<MaintenanceLog>> logsAsync;
  final ValueChanged<MaintenanceLog> onTap;

  const _RelatedLogsChips({
    required this.associationsAsync,
    required this.logsAsync,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    final logs = logsAsync.value ?? const <MaintenanceLog>[];
    final ids = associationsAsync.value ?? const <MaintenanceLogPart>[];
    final related = ids
        .map((a) => logs.where((log) => log.id == a.logId).firstOrNull)
        .whereType<MaintenanceLog>()
        .toList();
    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final log in related.take(4))
            ActionChip(
              avatar: Icon(
                Icons.build,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              label: Text(log.description),
              visualDensity: VisualDensity.compact,
              onPressed: () => onTap(log),
            ),
          if (related.length > 4)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                l.usedInServicesCount((related.length - 4).toString()),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LocalPartDetailSheet extends ConsumerStatefulWidget {
  final VehiclePart part;

  const _LocalPartDetailSheet({required this.part});

  @override
  ConsumerState<_LocalPartDetailSheet> createState() =>
      _LocalPartDetailSheetState();
}

class _LocalPartDetailSheetState
    extends ConsumerState<_LocalPartDetailSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _qtyCtrl;
  late final TextEditingController _oemCtrl;
  late final TextEditingController _descCtrl;
  String? _unit;
  late List<String> _links;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.part.name);
    _qtyCtrl = TextEditingController(
        text: IntervalPartsView.formatQuantity(widget.part.quantity));
    _oemCtrl = TextEditingController(text: widget.part.oemNumber ?? '');
    _descCtrl =
        TextEditingController(text: widget.part.description ?? '');
    _unit = widget.part.unit;
    _links = [...widget.part.links];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _oemCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _addLink() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final ctrl = TextEditingController();
    final result = await karterShowDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addLink),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: l.linkUrl,
            hintText: 'https://example.com',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text(l.add),
          ),
        ],
      ),
    );
    if (!mounted) return;
    final url = _normalizeUrl(result?.trim(), messenger, l);
    if (url == null) return;
    setState(() => _links.add(url));
  }

  String? _normalizeUrl(
    String? raw,
    ScaffoldMessengerState messenger,
    AppLocalizations l,
  ) {
    if (raw == null || raw.isEmpty) return null;
    var candidate = raw;
    if (!candidate.startsWith('http://') &&
        !candidate.startsWith('https://')) {
      candidate = 'https://$candidate';
    }
    final uri = Uri.tryParse(candidate);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
      return null;
    }
    return candidate;
  }

  Future<void> _openLink(String url) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.required)));
      return;
    }
    final updated = widget.part.copyWith(
      name: _nameCtrl.text.trim(),
      quantity: double.tryParse(_qtyCtrl.text.trim()) ?? 1,
      unit: _unit,
      oemNumber:
          _oemCtrl.text.trim().isEmpty ? null : _oemCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      links: _links,
    );
    await ref.read(vehiclePartRepositoryProvider).save(updated);
    if (mounted) Navigator.pop(context, 'saved');
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final associations =
        await ref.read(maintenanceLogPartRepositoryProvider).getByPartId(
              widget.part.id,
            );
    if (!mounted) return;
    final confirmed = await karterShowDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.delete),
        content: Text(associations.isEmpty
            ? l.deletePartConfirm('0')
            : l.deletePartConfirm(associations.length.toString())),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref.read(vehiclePartRepositoryProvider).delete(widget.part.id);
      await ref
          .read(maintenanceLogPartRepositoryProvider)
          .deleteByPartId(widget.part.id);
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      messenger
          .showSnackBar(SnackBar(content: Text(l.homeError(e.toString()))));
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final part = widget.part;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
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
            Text(part.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: l.partName),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _qtyCtrl,
                    decoration: InputDecoration(labelText: l.quantity),
                    keyboardType: const TextInputType
                        .numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _unit,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l.partUnitLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'unit',
                        child: Text(l.partUnitUnit),
                      ),
                      DropdownMenuItem(
                        value: 'set',
                        child: Text(l.partUnitSet),
                      ),
                      DropdownMenuItem(
                        value: 'kit',
                        child: Text(l.partUnitKit),
                      ),
                      DropdownMenuItem(
                        value: 'can',
                        child: Text(l.partUnitCan),
                      ),
                    ],
                    onChanged: (v) => setState(() => _unit = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _oemCtrl,
              decoration: InputDecoration(
                labelText: l.oemNumber,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 20),
                  tooltip: l.copy,
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(
                        ClipboardData(text: _oemCtrl.text));
                    messenger.showSnackBar(SnackBar(
                      content: Text(l.copied),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(
                labelText: l.description,
              ),
            ),
            SectionHeader(title: l.linksTitle),
            if (_links.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.noLinks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final link in _links)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.open_in_new, size: 20),
                        tooltip: l.openLink,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _openLink(link),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: l.delete,
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            setState(() => _links.remove(link)),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addLink),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(l.saveChanges),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleting ? null : _delete,
                icon: const Icon(Icons.delete_outline),
                label: Text(l.delete),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkChips extends StatelessWidget {
  final List<String> links;

  const _LinkChips({required this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final link in links)
            ActionChip(
              avatar: Icon(Icons.link,
                  size: 16, color: theme.colorScheme.primary),
              label: Text(_shortUrl(link)),
              visualDensity: VisualDensity.compact,
              onPressed: () => _open(context, link),
            ),
        ],
      ),
    );
  }

  String _shortUrl(String url) {
    final display = url.replaceFirst(RegExp(r'^https?://'), '');
    return display.length > 32 ? '${display.substring(0, 29)}...' : display;
  }

  Future<void> _open(BuildContext context, String url) async {
    final l = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.invalidUrl)));
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.invalidUrl)));
    }
  }
}

class _RelatedServicesChips extends StatelessWidget {
  final List<MaintenanceInterval> intervals;
  final ValueChanged<MaintenanceInterval> onTap;

  const _RelatedServicesChips({
    required this.intervals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final interval in intervals)
            ActionChip(
              avatar: Icon(
                Icons.build_circle_outlined,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                localizedLabel(
                  l.localeName,
                  interval.i18nKey,
                  interval.label,
                ),
              ),
              visualDensity: VisualDensity.compact,
              onPressed: () => onTap(interval),
            ),
        ],
      ),
    );
  }
}

class _PartEditResult {
  final String oemNumber;
  final String description;
  final List<String> links;

  _PartEditResult({
    required this.oemNumber,
    required this.description,
    required this.links,
  });
}

class _PartDetailSheet extends StatefulWidget {
  final _PartEntry entry;

  const _PartDetailSheet({required this.entry});

  @override
  State<_PartDetailSheet> createState() => _PartDetailSheetState();
}

class _PartDetailSheetState extends State<_PartDetailSheet> {
  late final TextEditingController _oemCtrl;
  late final TextEditingController _descCtrl;
  late final List<String> _links;

  @override
  void initState() {
    super.initState();
    _oemCtrl = TextEditingController(text: widget.entry.oemNumber ?? '');
    _descCtrl =
        TextEditingController(text: widget.entry.description ?? '');
    _links = [...widget.entry.links];
  }

  @override
  void dispose() {
    _oemCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _addLink() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final ctrl = TextEditingController();
    final result = await karterShowDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.addLink),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: l.linkUrl,
            hintText: 'https://example.com',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text(l.add),
          ),
        ],
      ),
    );
    if (!mounted) return;
    final url = _normalizeUrl(result?.trim(), messenger, l);
    if (url == null) return;
    setState(() => _links.add(url));
  }

  String? _normalizeUrl(
    String? raw,
    ScaffoldMessengerState messenger,
    AppLocalizations l,
  ) {
    if (raw == null || raw.isEmpty) return null;
    var candidate = raw;
    if (!candidate.startsWith('http://') &&
        !candidate.startsWith('https://')) {
      candidate = 'https://$candidate';
    }
    final uri = Uri.tryParse(candidate);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
      return null;
    }
    return candidate;
  }

  Future<void> _openLink(String url) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      messenger.showSnackBar(SnackBar(content: Text(l.invalidUrl)));
    }
  }

  void _save() {
    Navigator.pop(
      context,
      _PartEditResult(
        oemNumber: _oemCtrl.text,
        description: _descCtrl.text,
        links: _links,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final entry = widget.entry;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
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
            Text(
              entry.displayName(l),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '${IntervalPartsView.formatQuantity(entry.quantity)} \u00d7 '
              '${IntervalPartsView.unitLabel(context, entry.unit)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _oemCtrl,
              decoration: InputDecoration(
                labelText: l.oemNumber,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy_outlined, size: 20),
                  tooltip: l.copy,
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(
                        ClipboardData(text: _oemCtrl.text));
                    messenger.showSnackBar(SnackBar(
                      content: Text(l.copied),
                      duration: const Duration(seconds: 1),
                    ));
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              minLines: 2,
              decoration: InputDecoration(
                labelText: l.description,
              ),
            ),
            SectionHeader(title: l.linksTitle),
            if (_links.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  l.noLinks,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              for (final link in _links)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          link,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.open_in_new, size: 20),
                        tooltip: l.openLink,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _openLink(link),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        tooltip: l.delete,
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            setState(() => _links.remove(link)),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addLink,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addLink),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    child: Text(l.saveChanges),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
