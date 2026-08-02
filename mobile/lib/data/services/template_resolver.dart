import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/data/models/template_dtc.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/models/template_item.dart';
import 'package:mobile/data/models/template_meta.dart';
import 'package:mobile/data/models/template_part.dart';

class ResolvedItem {
  final String id;
  final String label;
  final String? i18nKey;
  final String? descI18nKey;
  final int intervalKm;
  final int? intervalMonths;
  final String? description;
  final Map<String, double> parts;

  ResolvedItem({
    required this.id,
    required this.label,
    this.i18nKey,
    this.descI18nKey,
    required this.intervalKm,
    this.intervalMonths,
    this.description,
    this.parts = const {},
  });
}

class ResolvedPart {
  final String id;
  final String? name;
  final String? i18nKey;
  final String? oemNumber;
  final double? quantity;
  final String? unit;
  final String? userReference;
  final String? description;

  ResolvedPart({
    required this.id,
    this.name,
    this.i18nKey,
    this.oemNumber,
    this.quantity,
    this.unit,
    this.userReference,
    this.description,
  });
}

class ResolvedDtc {
  final String code;
  final String scope;
  final String? descI18nKey;
  final String? description;
  final List<String> relatedMaintenance;
  final List<String> relatedParts;

  ResolvedDtc({
    required this.code,
    required this.scope,
    this.descI18nKey,
    this.description,
    this.relatedMaintenance = const [],
    this.relatedParts = const [],
  });
}

class TemplateResolution {
  final TemplateIndexEntry entry;
  final List<ResolvedItem> items;
  final List<ResolvedDtc> dtcs;
  final List<ResolvedPart> parts;

  TemplateResolution({
    required this.entry,
    required this.items,
    this.dtcs = const [],
    this.parts = const [],
  });
}

class TemplateResolver {
  String? _lastBaseUrl;
  TemplateIndex? _index;
  final Map<String, Map<String, dynamic>> _templateCache = {};

  static const _dataPrefix = 'data/';

  Future<String> _httpGet(String url) async {
    final uri = Uri.parse(url);
    final resp = await http.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) return resp.body;
    throw StateError('HTTP ${resp.statusCode} for $url');
  }

  Future<String> _loadIndex({String? baseUrl}) async {
    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        return await _httpGet('$baseUrl/index.json');
      } catch (_) {}
    }
    return rootBundle.loadString('templates/index.json');
  }

  Future<String> _loadTemplate(String path, {String? baseUrl}) async {
    final remotePath = '$_dataPrefix$path';
    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        return await _httpGet('$baseUrl/$remotePath');
      } catch (_) {}
    }
    return rootBundle.loadString('templates/data/$path');
  }

  Future<TemplateIndex> loadIndex({String? baseUrl}) async {
    if (_index != null && _lastBaseUrl == baseUrl) return _index!;
    final jsonStr = await _loadIndex(baseUrl: baseUrl);
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
    final jsonStr = await _loadTemplate(path, baseUrl: baseUrl);
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    _templateCache[cacheKey] = data;
    return data;
  }

  Future<_ResolutionData> _resolveWithVisited(
    String path,
    Set<String> visited, {
    String? baseUrl,
  }) async {
    if (visited.contains(path)) return const _ResolutionData();
    visited.add(path);

    final data = await _loadRawTemplate(path, baseUrl: baseUrl);
    final items = <String, ResolvedItem>{};
    final parts = <String, ResolvedPart>{};
    final dtcs = <String, ResolvedDtc>{};

    final extendsList = (data['extends'] as List?)?.cast<String>() ?? [];
    for (final extPath in extendsList) {
      final ancestor =
          await _resolveWithVisited(extPath, visited, baseUrl: baseUrl);
      _applyItems(items, ancestor.items, keepExisting: false);
      _applyParts(parts, ancestor.parts, keepExisting: false);
      _applyDtcs(dtcs, ancestor.dtcs, keepExisting: false);
    }

    final rawItems = (data['maintenance_items'] as List?)
            ?.map((e) => TemplateItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const <TemplateItem>[];
    _applyTemplateItems(items, rawItems);

    final rawParts = (data['parts'] as List?) ?? const [];
    for (final raw in rawParts) {
      final entry = TemplatePart.fromJson(raw as Map<String, dynamic>);
      if (entry.remove) {
        parts.remove(entry.id);
        continue;
      }
      final existing = parts[entry.id];
      parts[entry.id] =
          existing == null ? _resolvePart(entry) : _mergePart(existing, entry);
    }

    final rawDtcs = (data['obd_dtc_definitions'] as List?) ?? const [];
    for (final raw in rawDtcs) {
      final entry = TemplateDtc.fromJson(raw as Map<String, dynamic>);
      if (entry.remove) {
        dtcs.remove(entry.code);
        continue;
      }
      final existing = dtcs[entry.code];
      dtcs[entry.code] = existing == null
          ? _resolveDtc(entry)
          : _mergeDtcs(existing, entry);
    }

    return _ResolutionData(items: items, parts: parts, dtcs: dtcs);
  }

  void _applyDtcs(
    Map<String, ResolvedDtc> target,
    Map<String, ResolvedDtc> source, {
    required bool keepExisting,
  }) {
    for (final entry in source.entries) {
      if (keepExisting && target.containsKey(entry.key)) continue;
      target[entry.key] = entry.value;
    }
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

  void _applyParts(
    Map<String, ResolvedPart> target,
    Map<String, ResolvedPart> source, {
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
      parts: item.parts,
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
      parts: {...existing.parts, ...override.parts},
    );
  }

  ResolvedPart _resolvePart(TemplatePart part) {
    return ResolvedPart(
      id: part.id,
      name: part.name,
      i18nKey: part.i18nKey,
      oemNumber: part.oemNumber,
      quantity: part.quantity,
      unit: part.unit,
      userReference: part.userReference,
      description: part.description,
    );
  }

  ResolvedPart _mergePart(ResolvedPart existing, TemplatePart override) {
    return ResolvedPart(
      id: existing.id,
      name: override.name ?? existing.name,
      i18nKey: override.i18nKey ?? existing.i18nKey,
      oemNumber: override.oemNumber ?? existing.oemNumber,
      quantity: override.quantity ?? existing.quantity,
      unit: override.unit ?? existing.unit,
      userReference: override.userReference ?? existing.userReference,
      description: override.description ?? existing.description,
    );
  }

  ResolvedDtc _resolveDtc(TemplateDtc dtc) {
    return ResolvedDtc(
      code: dtc.code,
      scope: dtc.scope,
      descI18nKey: dtc.descI18nKey,
      description: dtc.description,
      relatedMaintenance: dtc.relatedMaintenance,
      relatedParts: dtc.relatedParts,
    );
  }

  ResolvedDtc _mergeDtcs(ResolvedDtc existing, TemplateDtc override) {
    return ResolvedDtc(
      code: existing.code,
      scope: override.scope == existing.scope ? existing.scope : override.scope,
      descI18nKey: override.descI18nKey ?? existing.descI18nKey,
      description: override.description ?? existing.description,
      relatedMaintenance: override.relatedMaintenance.isNotEmpty
          ? override.relatedMaintenance
          : existing.relatedMaintenance,
      relatedParts: override.relatedParts.isNotEmpty
          ? override.relatedParts
          : existing.relatedParts,
    );
  }

  Future<TemplateResolution?> resolve(
    String path, {
    String? baseUrl,
  }) async {
    final visited = <String>{};
    final data = await _resolveWithVisited(path, visited, baseUrl: baseUrl);

    final index = await loadIndex(baseUrl: baseUrl);
    final entry = index.templates.firstWhere(
      (e) => e.path == path,
      orElse: () => throw StateError('Template entry not found in index: $path'),
    );

    return TemplateResolution(
      entry: entry,
      items: data.items.values.toList(),
      dtcs: data.dtcs.values.toList(),
      parts: data.parts.values.toList(),
    );
  }

  Future<List<ResolvedDtc>> resolveDtc(
    String path, {
    String? baseUrl,
  }) async {
    final visited = <String>{};
    final data = await _resolveWithVisited(path, visited, baseUrl: baseUrl);
    return data.dtcs.values.toList();
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

class _ResolutionData {
  final Map<String, ResolvedItem> items;
  final Map<String, ResolvedPart> parts;
  final Map<String, ResolvedDtc> dtcs;

  const _ResolutionData({
    this.items = const {},
    this.parts = const {},
    this.dtcs = const {},
  });
}
