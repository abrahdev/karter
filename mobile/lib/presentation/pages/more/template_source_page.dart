import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/catalog_source.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/catalog_sources_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:mobile/presentation/widgets/section_header.dart';

class TemplateSourcePage extends ConsumerWidget {
  const TemplateSourcePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final config = ref.watch(templateSourceProvider);
    final activeSource = ref.watch(catalogSourcesProvider).active;

    return Scaffold(
      appBar: AppBar(title: Text(l.templatesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          SectionHeader(title: l.sectionData),
          GroupedCard(
            children: [
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
                title: Text(l.catalogDb),
                subtitle: Text(
                  activeSource != null
                      ? catalogSourceLabel(l, activeSource)
                      : l.catalogSourceBuiltin,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openCatalogSourcesSheet(context),
              ),
              KarterSwitchListTile(
                leading: Icon(config.enabled ? Icons.cloud : Icons.cloud_off),
                title: Text(l.moreTemplateSource),
                subtitle: Text(l.moreTemplateSourceSubtitle),
                value: config.enabled,
                onChanged: (v) =>
                    ref.read(templateSourceProvider.notifier).setEnabled(v),
              ),
              if (config.enabled) ...[
                ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(l.moreTemplateSourceUrl),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        config.repoUrl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        _versionLabel(l, config),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TestCatalogButton(
                        url: _testUrl(config.repoUrl, config.version),
                      ),
                      const Icon(Icons.edit),
                    ],
                  ),
                  onTap: () =>
                      _editUrl(context, ref, config.repoUrl, config.version),
                ),
              ],
            ],
          ),
          SectionHeader(title: l.sectionTemplates),
          GroupedCard(
            children: [
              ListTile(
                leading: const Icon(Icons.grid_view_outlined),
                title: Text(l.templatesTitle),
                subtitle: Text(l.templatesSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/templates'),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: Text(l.createTemplate),
                subtitle: Text(l.createTemplateSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/templates/create'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _versionLabel(AppLocalizations l, TemplateSourceConfig config) {
    return config.version.isEmpty
        ? l.moreTemplateSourceVersionLatest
        : config.version;
  }

  String _testUrl(String repoUrl, String version) {
    return version.isEmpty || !repoUrl.contains('<tag>')
        ? repoUrl
        : repoUrl.replaceAll('<tag>', version);
  }

  Future<void> _editUrl(
      BuildContext context, WidgetRef ref, String currentUrl, String currentVersion) async {
    final l = AppLocalizations.of(context)!;

    final result = await karterShowModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditTemplateSourceSheet(
        initialUrl: currentUrl,
        initialVersion: currentVersion,
      ),
    );

    if (result != null && result.$1.isNotEmpty) {
      await ref.read(templateSourceProvider.notifier).setRepoUrl(result.$1);
      await ref.read(templateSourceProvider.notifier).setVersion(result.$2);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.moreTemplateSourceUrlSaved)),
        );
      }
    }
  }

  void _openCatalogSourcesSheet(BuildContext context) {
    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _CatalogSourcesSheet(),
    );
  }
}

String catalogSourceLabel(AppLocalizations l, CatalogSource source) {
  return switch (source.kind) {
    CatalogSourceKind.builtin => l.catalogSourceBuiltin,
    CatalogSourceKind.online => l.catalogSourceOnline,
    CatalogSourceKind.local => source.name,
  };
}

IconData catalogSourceIcon(CatalogSource source) {
  return switch (source.kind) {
    CatalogSourceKind.builtin => Icons.archive_outlined,
    CatalogSourceKind.online => Icons.cloud_outlined,
    CatalogSourceKind.local => Icons.file_present_outlined,
  };
}

class _CatalogSourcesSheet extends ConsumerStatefulWidget {
  const _CatalogSourcesSheet();

  @override
  ConsumerState<_CatalogSourcesSheet> createState() =>
      _CatalogSourcesSheetState();
}

class _CatalogSourcesSheetState extends ConsumerState<_CatalogSourcesSheet> {
  bool _importing = false;
  bool _refreshing = false;
  String? _version;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await ref.read(catalogServiceProvider).catalogVersion();
    if (mounted) setState(() => _version = version);
  }

  Future<void> _select(CatalogSource source) async {
    try {
      await ref.read(catalogSourcesProvider.notifier).select(source.id);
      await _loadVersion();
    } catch (_) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source.isOnline ? l.catalogOnlineUnavailable : l.catalogNotAvailable,
          ),
        ),
      );
    }
  }

  Future<void> _refreshOnline() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _refreshing = true);
    try {
      await ref.read(catalogSourcesProvider.notifier).refreshOnline();
      await _loadVersion();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogRefreshed)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogRefreshFailed)),
      );
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _importing = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );
      if (result.isEmpty || result.first.path == null) return;
      final path = result.first.path!;
      await ref.read(catalogSourcesProvider.notifier).importLocal(path);
      await _loadVersion();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogImported)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogImportFailed)),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _delete(CatalogSource source) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.catalogDelete),
        content: Text(l.catalogDeleteConfirm(source.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l.catalogDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(catalogSourcesProvider.notifier).deleteSource(source.id);
    await _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(catalogSourcesProvider);
    final active = state.active;
    final config = ref.watch(templateSourceProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(l.catalogDb, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      active != null
                          ? catalogSourceIcon(active)
                          : Icons.archive_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            active != null
                                ? catalogSourceLabel(l, active)
                                : l.catalogSourceBuiltin,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _version != null
                                ? l.catalogDbVersion(_version!)
                                : l.catalogVersionUnknown,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (active?.isOnline ?? false) ...[
                            const SizedBox(height: 2),
                            Text(
                              l.templateSourceRelease(
                                config.version.isEmpty
                                    ? l.moreTemplateSourceVersionLatest
                                    : config.version,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (active?.isOnline ?? false)
                      IconButton(
                        tooltip: l.catalogRefreshOnline,
                        onPressed: _refreshing ? null : _refreshOnline,
                        icon: _refreshing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Icon(Icons.refresh),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(l.catalogSourcesTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            for (final source in state.sources)
              ListTile(
                leading: Icon(catalogSourceIcon(source)),
                title: Text(catalogSourceLabel(l, source)),
                subtitle: source.isOnline
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.repoUrl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            config.version.isEmpty
                                ? l.moreTemplateSourceVersionLatest
                                : config.version,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      )
                    : source.isBuiltin
                        ? Text(
                            l.catalogCannotDelete,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                selected: source.id == state.activeId,
                trailing: source.deletable
                    ? IconButton(
                        tooltip: l.catalogDelete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _delete(source),
                      )
                    : (source.id == state.activeId
                        ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                        : null),
                onTap: source.id == state.activeId
                    ? null
                    : () => _select(source),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _importing ? null : _import,
                icon: _importing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(Icons.upload_file_outlined),
                label: Text(l.catalogImportDb),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EditTemplateSourceSheet extends ConsumerStatefulWidget {
  const _EditTemplateSourceSheet({
    required this.initialUrl,
    required this.initialVersion,
  });

  final String initialUrl;
  final String initialVersion;

  @override
  ConsumerState<_EditTemplateSourceSheet> createState() =>
      _EditTemplateSourceSheetState();
}

class _EditTemplateSourceSheetState
    extends ConsumerState<_EditTemplateSourceSheet> {
  static const _latestSentinel = '';

  late final TextEditingController _controller;
  Timer? _debounce;
  bool _testing = false;
  bool _loadingVersions = false;
  bool _versionsFailed = false;
  List<String> _tags = const [];
  String _selectedTag = _latestSentinel;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl);
    _selectedTag = widget.initialVersion;
    _scheduleRefresh();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) => _scheduleRefresh();

  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _refresh();
    });
  }

  Future<void> _refresh() async {
    final url = _controller.text.trim();
    final parsed = CatalogService.parseOwnerRepo(url);
    final hasTag = url.contains('<tag>');

    if (!hasTag || parsed == null) {
      if (_tags.isNotEmpty || _loadingVersions || _versionsFailed) {
        setState(() {
          _tags = const [];
          _selectedTag = _latestSentinel;
          _versionsFailed = false;
          _loadingVersions = false;
        });
      }
      return;
    }

    setState(() {
      _loadingVersions = true;
      _versionsFailed = false;
    });

    final latest = await CatalogService.latestReleaseRef(
      owner: parsed.$1,
      repo: parsed.$2,
    );
    final tags = await CatalogService.listTags(
      owner: parsed.$1,
      repo: parsed.$2,
    );
    if (!mounted) return;

    setState(() {
      _loadingVersions = false;
      _tags = tags;
      _versionsFailed = tags.isEmpty && latest == null;
      if (_selectedTag != _latestSentinel && !tags.contains(_selectedTag)) {
        _selectedTag = _latestSentinel;
      }
    });
  }

  void _onVersionSelected(String value) {
    setState(() {
      _selectedTag = value;
    });
  }

  String _urlToTest() {
    final raw = _controller.text.trim();
    if (_selectedTag != _latestSentinel && raw.contains('<tag>')) {
      return raw.replaceAll('<tag>', _selectedTag);
    }
    return raw;
  }

  Future<void> _test() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _testing = true);
    try {
      final check =
          await ref.read(catalogServiceProvider).checkImport(_urlToTest());
      if (!mounted) return;
      setState(() => _testing = false);
      await karterShowModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _CatalogCheckSheet(check: check),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _testing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogNotAvailable)),
      );
    }
  }

  void _reset(BuildContext context) {
    ref.read(templateSourceProvider.notifier).resetToDefault();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final hasTag = _controller.text.contains('<tag>');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.moreTemplateSourceEditUrl,
                        style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    tooltip: l.templateUrlHelp,
                    onPressed: () => karterShowModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const _TemplateSourceHelpSheet(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  labelText: l.moreTemplateSourceUrlLabel,
                  hintText: l.moreTemplateSourceUrlHint,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _reset(context),
                  icon: const Icon(Icons.restore),
                  label: Text(l.moreTemplateSourceReset),
                ),
              ),
              if (hasTag) ...[
                const SizedBox(height: 16),
                if (_loadingVersions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  ),
                if (!_loadingVersions && _versionsFailed)
                  Text(
                    l.templateUrlVersionsFailed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                if (!_loadingVersions && _tags.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTag,
                    decoration: InputDecoration(
                      labelText: l.templateUrlVersion,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: _latestSentinel,
                        child: Text(l.templateUrlLatest),
                      ),
                      for (final tag in _tags)
                        DropdownMenuItem<String>(
                          value: tag,
                          child: Text(tag),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        _onVersionSelected(v);
                      }
                    },
                  ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _testing ? null : _test,
                  icon: _testing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.play_circle_outline),
                  label: Text(l.testConnection),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final url = _controller.text.trim();
                    if (url.isNotEmpty) {
                      Navigator.pop(context, (url, _selectedTag));
                    }
                  },
                  child: Text(l.saveChangesShort),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateSourceHelpSheet extends StatelessWidget {
  const _TemplateSourceHelpSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(l.templateUrlHelp, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(
                l.templateUrlExample,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              Text(
                l.templateUrlTagExplanation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.templateUrlUsage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestCatalogButton extends ConsumerStatefulWidget {
  const _TestCatalogButton({required this.url});

  final String url;

  @override
  ConsumerState<_TestCatalogButton> createState() => _TestCatalogButtonState();
}

class _TestCatalogButtonState extends ConsumerState<_TestCatalogButton> {
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    final check =
        await ref.read(catalogServiceProvider).checkImport(widget.url);
    if (!mounted) return;
    setState(() => _loading = false);
    await karterShowModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CatalogCheckSheet(check: check),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.play_circle_outline),
      tooltip: AppLocalizations.of(context)!.testConnection,
      onPressed: _run,
    );
  }
}

class _CatalogCheckSheet extends StatelessWidget {
  const _CatalogCheckSheet({required this.check});

  final CatalogImportCheck check;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final okColor = theme.colorScheme.primary;
    final errColor = theme.colorScheme.error;

    Widget statusRow(bool ok, String text, {String? detail}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.error_outline,
              color: ok ? okColor : errColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: theme.textTheme.bodyMedium),
                  if (detail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        detail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget section(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          title,
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.primary),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(l.testConnection, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                check.baseUrl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              section(l.importCheckTranslations),
              statusRow(
                check.translationsOk,
                l.importCheckTranslationsResult(
                  check.translationsFound,
                  check.translationsTotal,
                ),
              ),
              section(l.importCheckIndex),
              statusRow(
                check.indexOk,
                l.importCheckIndexResult(check.templateCount),
              ),
              section(l.importCheckDb),
              statusRow(
                check.dbRemoteFound,
                check.dbRemoteFound
                    ? l.importCheckDbRemoteFound
                    : l.importCheckDbRemoteNotFound,
                detail: check.dbRemoteFound && check.dbRemoteModified != null
                    ? l.catalogDbModifiedAt(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(check.dbRemoteModified!.toLocal()),
                      )
                    : null,
              ),
              if (check.dbRemoteFound) ...[
                section(l.importCheckDbLocal),
                if (check.localDbOk) ...[
                  if (check.catalogVersion != null)
                    statusRow(true,
                        l.importCheckCatalogVersion(check.catalogVersion!)),
                  statusRow(true, l.importCheckVehicles(check.vehicles)),
                  statusRow(
                      true, l.importCheckMaintenanceItems(check.maintenanceItems)),
                  statusRow(true, l.importCheckParts(check.parts)),
                  statusRow(true, l.importCheckObdCodes(check.obdCodes)),
                ] else
                  statusRow(false, l.importCheckDbLocalFailed),
              ],
            ],
          ),
        ),
      ],
    );
  }
}