import 'dart:convert';

/// Mirrors the rules of `templates/schemas/template-v2.json` plus the
/// post-merge rules enforced by `templates/tools/build_catalog.py`.
///
/// Used by the in-app template creator to surface inline errors before a
/// template JSON is exported. Kept dependency-free on purpose so it stays in
/// sync with the JSON Schema without pulling a schema engine into the app.
class TemplateValidator {
  static const _slugPattern = r'^[a-z0-9]+(-[a-z0-9]+)*$';
  static const _i18nPattern = r'^[a-z0-9_]+$';
  static const _dtcPattern = r'^[PCBU][0-9A-F]{4}$';
  static const _versionPattern = r'^\d+\.\d+\.\d+$';

  static const fuels = {
    'gasoline',
    'diesel',
    'lpg',
    'cng',
    'hydrogen',
    'ethanol',
  };
  static const powertrains = {'combustion', 'hybrid', 'plugin-hybrid', 'electric'};
  static const units = {'unit', 'set', 'L', 'ml', 'g', 'kg', 'kit', 'can', 'm'};
  static const scopes = {'standard', 'manufacturer'};

  static List<String> validate(Map<String, dynamic> doc) {
    final errors = <String>[];

    final id = doc['id'];
    if (id is! String) {
      errors.add('id: required, must be a slug string');
    } else if (!RegExp(_slugPattern).hasMatch(id)) {
      errors.add('id: invalid slug (lowercase letters, digits and hyphens)');
    }

    if (doc['meta'] is! Map<String, dynamic>) {
      errors.add('meta: required object');
    } else {
      _validateMeta(doc['meta'] as Map<String, dynamic>, errors);
    }

    _validateSection(
      doc['parts'],
      'parts',
      errors,
      _validatePart,
    );
    _validateSection(
      doc['maintenance_items'],
      'maintenance_items',
      errors,
      _validateItem,
    );
    _validateSection(
      doc['obd_dtc_definitions'],
      'obd_dtc_definitions',
      errors,
      _validateDtc,
    );

    return errors;
  }

  static bool isValid(Map<String, dynamic> doc) => validate(doc).isEmpty;

  static String? toJsonPretty(Map<String, dynamic> doc) {
    final errors = validate(doc);
    if (errors.isNotEmpty) return null;
    return const JsonEncoder.withIndent('  ').convert(doc);
  }

  static void _validateMeta(Map<String, dynamic> meta, List<String> errors) {
    for (final key in ['make', 'model', 'author', 'version']) {
      final value = meta[key];
      if (value is! String || value.trim().isEmpty) {
        errors.add('meta.$key: required');
      }
    }
    final version = meta['version'];
    if (version is String && !RegExp(_versionPattern).hasMatch(version)) {
      errors.add('meta.version: must be semver (e.g. 1.0.0)');
    }

    final years = meta['years'];
    if (years != null) {
      if (years is! List || years.length != 2) {
        errors.add('meta.years: must be [start, end] (end may be null)');
      } else {
        final start = years[0];
        final end = years[1];
        if (start is! int) {
          errors.add('meta.years[0]: start year must be an integer');
        } else if (end != null && end is! int) {
          errors.add('meta.years[1]: end year must be an integer or null');
        } else if (end is int && start > end) {
          errors.add('meta.years: start ($start) must be <= end ($end)');
        }
      }
    }

    final engine = meta['engine'];
    if (engine != null) {
      if (engine is! Map<String, dynamic>) {
        errors.add('meta.engine: must be an object');
      } else {
        final fuel = engine['fuel'];
        if (fuel is String && !fuels.contains(fuel)) {
          errors.add('meta.engine.fuel: unknown fuel "$fuel"');
        }
        final powertrain = engine['powertrain'];
        if (powertrain is String && !powertrains.contains(powertrain)) {
          errors.add('meta.engine.powertrain: unknown powertrain "$powertrain"');
        }
        for (final key in ['displacement_cc', 'power_hp']) {
          final value = engine[key];
          if (value != null && value is! int) {
            errors.add('meta.engine.$key: must be an integer');
          }
        }
      }
    }
  }

  static void _validateSection(
    dynamic section,
    String sectionName,
    List<String> errors,
    void Function(Map<String, dynamic>, String, List<String>) itemValidator,
  ) {
    if (section == null) return;
    if (section is! List) {
      errors.add('$sectionName: must be an array');
      return;
    }
    final ids = <String>{};
    for (var i = 0; i < section.length; i++) {
      final entry = section[i];
      final path = '$sectionName[$i]';
      if (entry is! Map<String, dynamic>) {
        errors.add('$path: must be an object');
        continue;
      }
      final keyName = sectionName == 'obd_dtc_definitions' ? 'code' : 'id';
      final key = entry[keyName];
      if (key is! String) {
        errors.add('$path.$keyName: required');
      } else {
        if (sectionName != 'obd_dtc_definitions' &&
            !RegExp(_slugPattern).hasMatch(key)) {
          errors.add('$path.$keyName: invalid slug');
        }
        if (!ids.add(key)) {
          errors.add('$path.$keyName: duplicate "$key" in $sectionName');
        }
      }
      itemValidator(entry, path, errors);
    }
  }

  static void _validatePart(Map<String, dynamic> part, String path, List<String> errors) {
    final remove = part['remove'] == true;
    if (!remove) {
      final name = part['name'];
      final i18nKey = part['i18n_key'];
      if ((name is! String || name.trim().isEmpty) &&
          (i18nKey is! String || i18nKey.trim().isEmpty)) {
        errors.add('$path: new parts need a name or i18n_key');
      }
    }
    if (part['i18n_key'] is String &&
        !RegExp(_i18nPattern).hasMatch(part['i18n_key'] as String)) {
      errors.add('$path.i18n_key: invalid key');
    }
    final quantity = part['quantity'];
    if (quantity != null) {
      if (quantity is! num || quantity <= 0) {
        errors.add('$path.quantity: must be greater than 0');
      }
    }
    final unit = part['unit'];
    if (unit is String && !units.contains(unit)) {
      errors.add('$path.unit: unknown unit "$unit"');
    }
  }

  static void _validateItem(Map<String, dynamic> item, String path, List<String> errors) {
    final remove = item['remove'] == true;
    if (!remove) {
      final intervalKm = item['interval_km'];
      if (intervalKm is! int || intervalKm < 1) {
        errors.add('$path: new items need interval_km (>= 1)');
      }
      final label = item['label'];
      final i18nKey = item['i18n_key'];
      if ((label is! String || label.trim().isEmpty) &&
          (i18nKey is! String || i18nKey.trim().isEmpty)) {
        errors.add('$path: new items need a label or i18n_key');
      }
    }
    final months = item['interval_months'];
    if (months is int && months < 1) {
      errors.add('$path.interval_months: must be >= 1');
    }
    for (final key in ['i18n_key', 'desc_i18n_key']) {
      final value = item[key];
      if (value is String && !RegExp(_i18nPattern).hasMatch(value)) {
        errors.add('$path.$key: invalid key');
      }
    }
    final parts = item['parts'];
    if (parts != null) {
      if (parts is! List) {
        errors.add('$path.parts: must be an array');
      } else {
        for (var i = 0; i < parts.length; i++) {
          final ref = parts[i];
          if (ref is! Map<String, dynamic>) {
            errors.add('$path.parts[$i]: must be an object');
            continue;
          }
          if (ref['part_id'] is! String || ref['part_id'].toString().isEmpty) {
            errors.add('$path.parts[$i].part_id: required');
          }
          final qty = ref['quantity'];
          if (qty != null && (qty is! num || qty <= 0)) {
            errors.add('$path.parts[$i].quantity: must be greater than 0');
          }
        }
      }
    }
    final codes = item['obd_codes'];
    if (codes is List) {
      for (final code in codes) {
        if (code is! String || !RegExp(_dtcPattern).hasMatch(code)) {
          errors.add('$path.obd_codes: invalid DTC code "$code"');
        }
      }
    }
  }

  static void _validateDtc(Map<String, dynamic> dtc, String path, List<String> errors) {
    final code = dtc['code'];
    if (code is String && !RegExp(_dtcPattern).hasMatch(code)) {
      errors.add('$path.code: invalid DTC code "$code"');
    }
    final scope = dtc['scope'];
    if (scope is String && !scopes.contains(scope)) {
      errors.add('$path.scope: unknown scope "$scope"');
    }
    final remove = dtc['remove'] == true;
    if (!remove) {
      final description = dtc['description'];
      final key = dtc['desc_i18n_key'];
      if ((description is! String || description.trim().isEmpty) &&
          (key is! String || key.trim().isEmpty)) {
        errors.add('$path: new codes need a description or desc_i18n_key');
      }
    }
    final descKey = dtc['desc_i18n_key'];
    if (descKey is String && !RegExp(_i18nPattern).hasMatch(descKey)) {
      errors.add('$path.desc_i18n_key: invalid key');
    }
  }
}