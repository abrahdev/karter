import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/catalog_source.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

const builtinSourceId = 'builtin';
const onlineSourceId = 'online';

class CatalogSourcesState {
  const CatalogSourcesState({required this.sources, required this.activeId});

  final List<CatalogSource> sources;
  final String activeId;

  CatalogSource? get active {
    for (final s in sources) {
      if (s.id == activeId) return s;
    }
    return null;
  }
}

final catalogSourcesProvider =
    NotifierProvider<CatalogSourcesNotifier, CatalogSourcesState>(
  CatalogSourcesNotifier.new,
);

class CatalogSourcesNotifier extends Notifier<CatalogSourcesState> {
  static const _sourcesKey = 'catalog_sources_v1';
  static const _activeKey = 'catalog_active_source_v1';
  static const _builtinRel = CatalogService.catalogDbFileName;
  static const _onlineRel = CatalogService.onlineCatalogDbFileName;
  static const _uuid = Uuid();

  @override
  CatalogSourcesState build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final sources = _decode(prefs.getString(_sourcesKey));
    final persistedActive = prefs.getString(_activeKey);
    final activeId = sources.any((s) => s.id == persistedActive)
        ? persistedActive!
        : builtinSourceId;

    if (activeId != builtinSourceId) {
      _applyActiveFile(activeId);
    }
    return CatalogSourcesState(sources: sources, activeId: activeId);
  }

  Future<void> select(String id) async {
    final current = state;
    final source = current.sources.firstWhere((s) => s.id == id);
    final abs = await _abs(source.filePath);

    if (source.isOnline && !File(abs).existsSync()) {
      try {
        await ref.read(catalogServiceProvider).refreshFromRelease();
      } catch (_) {}
    }

    if (!File(abs).existsSync()) {
      throw StateError('Catalog file not available: ${source.name}');
    }

    ref.read(catalogServiceProvider).useFile(abs);
    state = CatalogSourcesState(sources: current.sources, activeId: id);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_activeKey, id);
  }

  Future<void> refreshOnline() async {
    final service = ref.read(catalogServiceProvider);
    try {
      await service.refreshFromRelease();
    } catch (_) {
      rethrow;
    }
    if (state.active?.isOnline ?? false) {
      final abs = await _abs(_onlineRel);
      service.useFile(abs);
    }
  }

  Future<void> importLocal(String sourcePath) async {
    final id = 'local-${_uuid.v4()}';
    final rel = 'catalogs/$id.db';
    final abs = await _abs(rel);
    await File(abs).parent.create(recursive: true);
    await File(sourcePath).copy(abs);

    final current = state;
    final source = CatalogSource(
      id: id,
      name: p.basename(sourcePath),
      kind: CatalogSourceKind.local,
      filePath: rel,
    );
    final sources = [...current.sources, source];
    state = CatalogSourcesState(sources: sources, activeId: current.activeId);
    await _persist();
    await select(id);
  }

  Future<void> deleteSource(String id) async {
    final current = state;
    final source = current.sources.firstWhere((s) => s.id == id);
    if (!source.deletable) return;

    final abs = await _abs(source.filePath);
    if (File(abs).existsSync()) await File(abs).delete();

    final sources = current.sources.where((s) => s.id != id).toList();
    final activeId =
        current.activeId == id ? builtinSourceId : current.activeId;
    state = CatalogSourcesState(sources: sources, activeId: activeId);
    await _persist();

    if (current.activeId == id) {
      final absBuiltin = await _abs(_builtinRel);
      ref.read(catalogServiceProvider).useFile(absBuiltin);
    }
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_sourcesKey, _encode(state.sources));
    await prefs.setString(_activeKey, state.activeId);
  }

  void _applyActiveFile(String id) {
    Future(() async {
      try {
        final source = state.sources.firstWhere((s) => s.id == id);
        final abs = await _abs(source.filePath);
        if (File(abs).existsSync()) {
          ref.read(catalogServiceProvider).useFile(abs);
        }
      } catch (_) {}
    });
  }

  Future<String> _abs(String rel) async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, rel);
  }

  List<CatalogSource> _decode(String? raw) {
    final sources = <CatalogSource>[];
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        sources.addAll(list.map((e) => CatalogSource.fromJson(e as Map<String, dynamic>)));
      } catch (_) {}
    }

    final ids = sources.map((s) => s.id).toSet();
    if (!ids.contains(builtinSourceId)) {
      sources.insert(
        0,
        CatalogSource(
          id: builtinSourceId,
          name: builtinSourceId,
          kind: CatalogSourceKind.builtin,
          filePath: _builtinRel,
        ),
      );
    }
    if (!ids.contains(onlineSourceId)) {
      sources.insert(
        1,
        CatalogSource(
          id: onlineSourceId,
          name: onlineSourceId,
          kind: CatalogSourceKind.online,
          filePath: _onlineRel,
        ),
      );
    }
    return sources;
  }

  String _encode(List<CatalogSource> sources) =>
      jsonEncode(sources.map((s) => s.toJson()).toList());
}