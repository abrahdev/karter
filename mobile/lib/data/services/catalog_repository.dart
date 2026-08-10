import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/models/template_meta.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:sqlite3/sqlite3.dart';

class CatalogRepository {
  CatalogRepository(this.service);

  final CatalogService service;

  static const _generalVehicleId = 'general';

  Future<TemplateIndex> loadIndex() async {
    final db = await service.database();
    final rows = db.select(
      "SELECT * FROM vehicles WHERE kind = 'vehicle' ORDER BY make, model",
    );
    return TemplateIndex(templates: rows.map(_entryFromRow).toList());
  }

  Future<TemplateResolution?> findBestMatch({
    required String make,
    required String model,
    required int year,
  }) async {
    final db = await service.database();
    final rows = db.select(
      "SELECT * FROM vehicles WHERE kind = 'vehicle' "
      "AND LOWER(make) = LOWER(?) AND LOWER(model) = LOWER(?) "
      "AND (year_from IS NULL OR (? BETWEEN year_from AND year_to)) "
      "ORDER BY CASE WHEN year_from IS NOT NULL THEN 0 ELSE 1 END, "
      "specificity DESC LIMIT 1",
      [make, model, year],
    );
    if (rows.isEmpty) return null;
    final row = rows.single;
    final vehicleId = row['id'] as String;
    return TemplateResolution(
      entry: _entryFromRow(row),
      items: _loadItems(db, vehicleId),
      dtcs: _loadDtcs(
        db,
        vehicleId,
        inheritsGeneral: (row['inherits_general'] as int) == 1,
      ),
      parts: _loadParts(db, vehicleId),
    );
  }

  Future<List<ResolvedDtc>> resolveGeneralDtcs() async {
    final db = await service.database();
    return _loadDtcs(db, _generalVehicleId, inheritsGeneral: true);
  }

  Future<List<String>> listMakes() async {
    final db = await service.database();
    final rows = db.select(
      "SELECT DISTINCT make FROM vehicles "
      "WHERE kind = 'vehicle' AND make != '_base' ORDER BY make",
    );
    return rows.map((r) => r['make'] as String).toList();
  }

  Future<({List<ResolvedDtc> dtcs, List<ResolvedItem> items})> resolveBrandDtcs(
    String make,
  ) async {
    final db = await service.database();
    final rows = db.select(
      "SELECT * FROM vehicles WHERE kind = 'vehicle' "
      "AND make != '_base' AND LOWER(make) = LOWER(?)",
      [make],
    );

    final dtcByCode = <String, ResolvedDtc>{};
    final itemById = <String, ResolvedItem>{};

    void addDtcs(List<ResolvedDtc> dtcs) {
      for (final dtc in dtcs) {
        final existing = dtcByCode[dtc.code];
        dtcByCode[dtc.code] =
            existing == null ? dtc : _mergeResolvedDtc(existing, dtc);
      }
    }

    void addItems(List<ResolvedItem> items) {
      for (final item in items) {
        final existing = itemById[item.id];
        itemById[item.id] =
            existing == null ? item : _mergeResolvedItem(existing, item);
      }
    }

    addDtcs(_loadDtcs(db, _generalVehicleId, inheritsGeneral: true));
    addItems(_loadItems(db, _generalVehicleId));

    for (final row in rows) {
      final vehicleId = row['id'] as String;
      final inheritsGeneral = (row['inherits_general'] as int) == 1;
      addDtcs(_loadDtcs(db, vehicleId, inheritsGeneral: inheritsGeneral));
      addItems(_loadItems(db, vehicleId));
    }

    return (dtcs: dtcByCode.values.toList(), items: itemById.values.toList());
  }

  List<ResolvedPart> _loadParts(Database db, String vehicleId) {
    return db
        .select('SELECT * FROM parts WHERE vehicle_id = ?', [vehicleId])
        .map(_partFromRow)
        .toList();
  }

  ResolvedPart _partFromRow(Row row) {
    return ResolvedPart(
      id: row['id'] as String,
      name: row['name'] as String?,
      i18nKey: row['i18n_key'] as String?,
      oemNumber: row['oem_number'] as String?,
      quantity: (row['quantity'] as num?)?.toDouble(),
      unit: row['unit'] as String?,
      description: row['description'] as String?,
    );
  }

  List<ResolvedItem> _loadItems(Database db, String vehicleId) {
    final partsByItem = <String, Map<String, double>>{};
    for (final row in db.select(
      'SELECT * FROM maintenance_item_parts WHERE vehicle_id = ?',
      [vehicleId],
    )) {
      final itemId = row['maintenance_item_id'] as String;
      final partId = row['part_id'] as String;
      final quantity = (row['quantity'] as num?)?.toDouble() ?? 1;
      (partsByItem[itemId] ??= {})[partId] = quantity;
    }
    return db
        .select(
          'SELECT * FROM maintenance_items WHERE vehicle_id = ?',
          [vehicleId],
        )
        .map((row) => ResolvedItem(
              id: row['id'] as String,
              label: row['label'] as String,
              i18nKey: row['i18n_key'] as String?,
              descI18nKey: row['desc_i18n_key'] as String?,
              intervalKm: row['interval_km'] as int,
              intervalMonths: row['interval_months'] as int?,
              description: row['description'] as String?,
              parts: partsByItem[row['id']] ?? const {},
            ))
        .toList();
  }

  List<ResolvedDtc> _loadDtcs(
    Database db,
    String vehicleId, {
    required bool inheritsGeneral,
  }) {
    final related = db.select(
      'SELECT * FROM obd_related WHERE vehicle_id = ?',
      [vehicleId],
    );
    final maintByCode = <String, List<String>>{};
    final partsByCode = <String, List<String>>{};
    for (final r in related) {
      final code = r['code'] as String;
      final type = r['related_type'] as String;
      final id = r['related_id'] as String;
      final bucket = type == 'maintenance' ? maintByCode : partsByCode;
      (bucket[code] ??= []).add(id);
    }

    final result = <String, ResolvedDtc>{};
    if (inheritsGeneral) {
      for (final row in db.select(
        'SELECT * FROM obd_codes WHERE vehicle_id = ? AND removed = 0',
        [_generalVehicleId],
      )) {
        final code = row['code'] as String;
        result[code] = _dtcFromRow(
          row,
          maintByCode[code] ?? const [],
          partsByCode[code] ?? const [],
        );
      }
    }

    for (final row in db.select(
      'SELECT * FROM obd_codes WHERE vehicle_id = ?',
      [vehicleId],
    )) {
      final code = row['code'] as String;
      if ((row['removed'] as int) == 1) {
        result.remove(code);
        continue;
      }
      result[code] = _dtcFromRow(
        row,
        maintByCode[code] ?? const [],
        partsByCode[code] ?? const [],
      );
    }
    return result.values.toList();
  }

  ResolvedDtc _dtcFromRow(
    Row row,
    List<String> relatedMaint,
    List<String> relatedParts,
  ) {
    return ResolvedDtc(
      code: row['code'] as String,
      scope: row['scope'] as String,
      descI18nKey: row['desc_i18n_key'] as String?,
      description: row['description'] as String?,
      relatedMaintenance: relatedMaint,
      relatedParts: relatedParts,
    );
  }

  ResolvedDtc _mergeResolvedDtc(ResolvedDtc a, ResolvedDtc b) {
    final manufacturer = a.scope == 'manufacturer' || b.scope == 'manufacturer';
    return ResolvedDtc(
      code: a.code,
      scope: manufacturer ? 'manufacturer' : a.scope,
      descI18nKey: b.descI18nKey ?? a.descI18nKey,
      description: b.description ?? a.description,
      relatedMaintenance:
          _unionIds(a.relatedMaintenance, b.relatedMaintenance),
      relatedParts: _unionIds(a.relatedParts, b.relatedParts),
    );
  }

  ResolvedItem _mergeResolvedItem(ResolvedItem a, ResolvedItem b) {
    return ResolvedItem(
      id: a.id,
      label: b.label.isNotEmpty ? b.label : a.label,
      i18nKey: b.i18nKey ?? a.i18nKey,
      descI18nKey: b.descI18nKey ?? a.descI18nKey,
      intervalKm: b.intervalKm,
      intervalMonths: b.intervalMonths ?? a.intervalMonths,
      description: b.description ?? a.description,
      parts: {...a.parts, ...b.parts},
    );
  }

  List<String> _unionIds(List<String> a, List<String> b) {
    final seen = <String>{...a};
    return [...a, ...b.where(seen.add)];
  }

  TemplateIndexEntry _entryFromRow(Row row) {
    final years = <int>[];
    final yearFrom = row['year_from'] as int?;
    final yearTo = row['year_to'] as int?;
    if (yearFrom != null) years.add(yearFrom);
    if (yearTo != null) years.add(yearTo);
    final engineCode = row['engine_code'] as String?;
    final fuel = row['fuel'] as String?;
    final displacement = row['displacement_cc'] as int?;
    final power = row['power_hp'] as int?;
    final engine = (engineCode != null ||
            fuel != null ||
            displacement != null ||
            power != null)
        ? EngineMeta(
            code: engineCode,
            fuel: fuel,
            displacementCc: displacement,
            powerHp: power,
          )
        : null;
    return TemplateIndexEntry(
      id: row['id'] as String,
      path: row['path'] as String,
      meta: TemplateMeta(
        make: row['make'] as String,
        model: row['model'] as String,
        generation: row['generation'] as String?,
        years: years.isEmpty ? null : years,
        engine: engine,
        author: '',
        version: '',
      ),
      itemCount: row['item_count'] as int,
      extendsPaths: const [],
    );
  }
}
