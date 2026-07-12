import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/models/template_item.dart';
import 'package:mobile/data/models/template_meta.dart';

class ResolvedItem {
  final String id;
  final String label;
  final String? i18nKey;
  final String? descI18nKey;
  final int intervalKm;
  final int? intervalMonths;
  final String? description;

  ResolvedItem({
    required this.id,
    required this.label,
    this.i18nKey,
    this.descI18nKey,
    required this.intervalKm,
    this.intervalMonths,
    this.description,
  });
}

class TemplateResolution {
  final TemplateIndexEntry entry;
  final List<ResolvedItem> items;

  TemplateResolution({required this.entry, required this.items});
}

class TemplateResolver {
  String? _lastBaseUrl;
  TemplateIndex? _index;
  final Map<String, Map<String, dynamic>> _templateCache = {};

  Future<String> _loadString(String assetPath, {String? baseUrl}) async {
    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        final uri = Uri.parse('$baseUrl/$assetPath');
        final resp = await http.get(uri).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) return resp.body;
      } catch (_) {}
    }
    return rootBundle.loadString('templates/$assetPath');
  }

  Future<TemplateIndex> loadIndex({String? baseUrl}) async {
    if (_index != null && _lastBaseUrl == baseUrl) return _index!;
    final jsonStr = await _loadString('index.json', baseUrl: baseUrl);
    _index = TemplateIndex.fromJson(json.decode(jsonStr) as Map<String, dynamic>);
    _lastBaseUrl = baseUrl;
    return _index!;
  }

  Future<Map<String, dynamic>> _loadRawTemplate(
    String path, {
    String? baseUrl,
  }) async {
    final cacheKey = '$baseUrl|$path';
    if (_templateCache.containsKey(cacheKey)) return _templateCache[cacheKey]!;
    final jsonStr = await _loadString(path, baseUrl: baseUrl);
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    _templateCache[cacheKey] = data;
    return data;
  }

  Future<Map<String, ResolvedItem>> _resolveWithVisited(
    String path,
    Set<String> visited, {
    String? baseUrl,
  }) async {
    if (visited.contains(path)) return {};
    visited.add(path);

    final data = await _loadRawTemplate(path, baseUrl: baseUrl);
    final items = <String, ResolvedItem>{};

    final extendsList = (data['extends'] as List?)?.cast<String>() ?? [];
    for (final extPath in extendsList) {
      final ancestorItems =
          await _resolveWithVisited(extPath, visited, baseUrl: baseUrl);
      _applyItems(items, ancestorItems, keepExisting: false);
    }

    final rawItems = (data['maintenance_items'] as List)
        .map((e) => TemplateItem.fromJson(e as Map<String, dynamic>))
        .toList();

    _applyTemplateItems(items, rawItems);

    return items;
  }

  void _applyItems(
    Map<String, ResolvedItem> target,
    Map<String, ResolvedItem> source, {
    required bool keepExisting,
  }) {
    for (final entry in source.entries) {
      if (keepExisting && target.containsKey(entry.key)) continue;
      target[entry.key] = entry.value;
    }
  }

  void _applyTemplateItems(
    Map<String, ResolvedItem> target,
    List<TemplateItem> templateItems,
  ) {
    for (final item in templateItems) {
      if (item.remove) {
        target.remove(item.id);
        continue;
      }
      final existing = target[item.id];
      if (existing == null) {
        target[item.id] = _resolveItem(item);
      } else {
        target[item.id] = _mergeItems(existing, item);
      }
    }
  }

  ResolvedItem _resolveItem(TemplateItem item) {
    assert(item.intervalKm != null, 'Item ${item.id} must have interval_km');
    return ResolvedItem(
      id: item.id,
      label: item.label ?? _defaultLabel(item.id),
      i18nKey: item.i18nKey,
      descI18nKey: item.descI18nKey,
      intervalKm: item.intervalKm!,
      intervalMonths: item.intervalMonths,
      description: item.description,
    );
  }

  ResolvedItem _mergeItems(ResolvedItem existing, TemplateItem override) {
    return ResolvedItem(
      id: existing.id,
      label: override.label ?? existing.label,
      i18nKey: override.i18nKey ?? existing.i18nKey,
      descI18nKey: override.descI18nKey ?? existing.descI18nKey,
      intervalKm: override.intervalKm ?? existing.intervalKm,
      intervalMonths: override.intervalMonths,
      description: override.description ?? existing.description,
    );
  }

  Future<TemplateResolution?> resolve(
    String path, {
    String? baseUrl,
  }) async {
    final visited = <String>{};
    final items = await _resolveWithVisited(path, visited, baseUrl: baseUrl);

    final index = await loadIndex(baseUrl: baseUrl);
    final entry = index.templates.firstWhere(
      (e) => e.path == path,
      orElse: () => throw StateError('Template entry not found in index: $path'),
    );

    return TemplateResolution(
      entry: entry,
      items: items.values.toList(),
    );
  }

  Future<TemplateResolution?> findBestMatch({
    required String make,
    required String model,
    required int year,
    String? baseUrl,
  }) async {
    final index = await loadIndex(baseUrl: baseUrl);

    final candidates = <TemplateIndexEntry>[];

    for (final entry in index.templates) {
      if (entry.meta.make == '_base') continue;

      if (!_matchesMakeModel(entry.meta, make, model)) continue;

      if (entry.meta.years != null) {
        if (year < entry.meta.years![0] || year > entry.meta.years![1]) continue;
      }

      candidates.add(entry);
    }

    if (candidates.isEmpty) return null;

    _sortCandidates(candidates, model, year);

    return resolve(candidates.first.path, baseUrl: baseUrl);
  }

  bool _matchesMakeModel(TemplateMeta meta, String make, String model) {
    if (meta.make.toLowerCase() != make.toLowerCase()) return false;
    return meta.model.toLowerCase() == model.toLowerCase();
  }

  void _sortCandidates(
    List<TemplateIndexEntry> candidates,
    String model,
    int year,
  ) {
    candidates.sort((a, b) {
      final aExact = a.meta.model.toLowerCase() == model.toLowerCase();
      final bExact = b.meta.model.toLowerCase() == model.toLowerCase();
      if (aExact != bExact) return aExact ? -1 : 1;

      final aYear = a.meta.years;
      final bYear = b.meta.years;
      final aInRange = aYear != null && year >= aYear[0] && year <= aYear[1];
      final bInRange = bYear != null && year >= bYear[0] && year <= bYear[1];
      if (aInRange != bInRange) return aInRange ? -1 : 1;

      final aScore = _specificityScore(a);
      final bScore = _specificityScore(b);
      return bScore.compareTo(aScore);
    });
  }

  int _specificityScore(TemplateIndexEntry entry) {
    int score = 0;
    if (entry.meta.generation != null && entry.meta.generation!.isNotEmpty) {
      score++;
    }
    if (entry.meta.engine != null) {
      score++;
      if (entry.meta.engine!.code != null) score++;
      if (entry.meta.engine!.fuel != null) score++;
    }
    if (entry.meta.years != null) score++;
    return score;
  }

  String _defaultLabel(String id) {
    return id.replaceAll('-', ' ');
  }
}
