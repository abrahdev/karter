import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

String fuelLabel(AppLocalizations l, String? fuel) => switch (fuel) {
      'gasoline' => l.fuelGasoline,
      'diesel' => l.fuelDiesel,
      'lpg' => l.fuelLpg,
      'cng' => l.fuelCng,
      'hydrogen' => l.fuelHydrogen,
      'ethanol' => l.fuelEthanol,
      _ => fuel ?? '',
    };

String powertrainLabel(AppLocalizations l, String? powertrain) =>
    switch (powertrain) {
      'combustion' => l.powertrainCombustion,
      'hybrid' => l.powertrainHybrid,
      'plugin-hybrid' => l.powertrainPluginHybrid,
      'electric' => l.powertrainElectric,
      _ => powertrain ?? '',
    };

class TemplateListPage extends ConsumerStatefulWidget {
  const TemplateListPage({super.key});

  @override
  ConsumerState<TemplateListPage> createState() => _TemplateListPageState();
}

class _TemplateListPageState extends ConsumerState<TemplateListPage> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedMake;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) setState(() => _query = value.trim().toLowerCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final index = ref.watch(templateIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.templatesTitle),
        actions: [
          IconButton(
            tooltip: l.createTemplate,
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push('/templates/create'),
          ),
        ],
      ),
      body: switch (index) {
        AsyncData(:final value) => _buildBody(l, value),
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

  Widget _buildBody(AppLocalizations l, TemplateIndex index) {
    final entries = index.templates
        .where((e) => e.meta.make != '_base')
        .where((e) => _selectedMake == null || e.meta.make == _selectedMake)
        .where((e) => _matches(e))
        .toList()
      ..sort(_compareByMakeModel);

    final makes = index.templates
        .map((e) => e.meta.make)
        .where((m) => m != '_base')
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            AppSpacing.pagePadding,
            0,
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l.searchTemplatesHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
              if (makes.length > 1) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedMake,
                    decoration: const InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(Icons.filter_list),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(l.allMakes),
                      ),
                      ...makes.map(
                        (m) => DropdownMenuItem(value: m, child: Text(m)),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedMake = v),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final padding = EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                12,
                AppSpacing.pagePadding,
                AppSpacing.pagePadding,
              );
              if (entries.isEmpty) {
                return Center(
                  child: Padding(
                    padding: padding,
                    child: Text(
                      l.noTemplatesFound,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }
              if (isWide) {
                return GridView.builder(
                  padding: padding,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 420,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: entries.length,
                  itemBuilder: (context, i) =>
                      _TemplateCard(entry: entries[i]),
                );
              }
              return ListView.builder(
                padding: padding,
                itemCount: entries.length,
                itemBuilder: (context, i) =>
                    _TemplateCard(entry: entries[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _matches(TemplateIndexEntry entry) {
    if (_query.isEmpty) return true;
    final haystack = [
      entry.meta.make,
      entry.meta.model,
      entry.meta.generation ?? '',
      entry.id,
    ].join(' ').toLowerCase();
    return haystack.contains(_query);
  }

  int _compareByMakeModel(TemplateIndexEntry a, TemplateIndexEntry b) {
    final byMake = a.meta.make.toLowerCase().compareTo(b.meta.make.toLowerCase());
    if (byMake != 0) return byMake;
    return a.meta.model.toLowerCase().compareTo(b.meta.model.toLowerCase());
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.entry});

  final TemplateIndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final meta = entry.meta;
    final engine = meta.engine;

    final years = meta.years != null
        ? (meta.years![1] == null
            ? '${meta.years![0]}–${l.templateYearsOpen}'
            : '${meta.years![0]}–${meta.years![1]}')
        : null;

    final engineBits = <String>[
      if (engine?.fuel != null) fuelLabel(l, engine!.fuel),
      if (engine?.powertrain != null) powertrainLabel(l, engine!.powertrain),
      if (engine?.code != null) engine!.code!,
      if (engine?.displacementCc != null) '${engine!.displacementCc}cc',
      if (engine?.powerHp != null) '${engine!.powerHp} hp',
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: InkWell(
        onTap: () => context.push('/templates/${entry.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${meta.make} ${meta.model}',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (meta.generation != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        meta.generation!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              if (years != null)
                Text(years, style: theme.textTheme.bodySmall),
              if (engineBits.isNotEmpty)
                Text(
                  engineBits.join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l.templateItemsCount(entry.itemCount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'v${meta.version}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}