import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/services/template_validator.dart';

void main() {
  Map<String, dynamic> validDoc() => {
        'id': 'honda-civic',
        'meta': {
          'make': 'Honda',
          'model': 'Civic',
          'generation': 'E210',
          'years': [2019, 2024],
          'engine': {
            'code': 'M20A-FKS',
            'fuel': 'gasoline',
            'powertrain': 'hybrid',
            'displacement_cc': 1987,
            'power_hp': 169,
          },
          'author': 'abrahdev',
          'version': '1.0.0',
        },
        'extends': ['_base/car-common.json'],
        'parts': [
          {
            'id': 'oil-filter',
            'name': 'Oil filter',
            'quantity': 1,
            'unit': 'unit',
          },
        ],
        'maintenance_items': [
          {
            'id': 'oil-change',
            'label': 'Oil change',
            'interval_km': 15000,
            'interval_months': 12,
            'i18n_key': 'seed_interval_oil_change',
            'parts': [
              {'part_id': 'oil-filter', 'quantity': 1},
            ],
          },
        ],
        'obd_dtc_definitions': [
          {
            'code': 'P0171',
            'scope': 'standard',
            'description': 'System too lean (Bank 1)',
          },
        ],
      };

  group('TemplateValidator', () {
    test('accepts a fully valid template', () {
      expect(TemplateValidator.validate(validDoc()), isEmpty);
      expect(TemplateValidator.isValid(validDoc()), isTrue);
      expect(TemplateValidator.toJsonPretty(validDoc()), isNotNull);
    });

    test('requires id slug and meta', () {
      final doc = validDoc();
      doc.remove('id');
      expect(TemplateValidator.validate(doc), isNotEmpty);

      doc['id'] = 'Not_A Slug!';
      expect(TemplateValidator.validate(doc), isNotEmpty);
    });

    test('rejects missing meta fields', () {
      final doc = validDoc();
      (doc['meta'] as Map<String, dynamic>).remove('model');
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('meta.model')), isTrue);
    });

    test('rejects bad version', () {
      final doc = validDoc();
      doc['meta'] = {
        ...doc['meta'] as Map<String, dynamic>,
        'version': '1.0',
      };
      expect(
        TemplateValidator.validate(doc).any((e) => e.contains('meta.version')),
        isTrue,
      );
    });

    test('rejects inverted years', () {
      final doc = validDoc();
      doc['meta'] = {
        ...doc['meta'] as Map<String, dynamic>,
        'years': [2024, 2019],
      };
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('meta.years')), isTrue);
    });

    test('accepts null end year', () {
      final doc = validDoc();
      doc['meta'] = {
        ...doc['meta'] as Map<String, dynamic>,
        'years': [2013, null],
      };
      expect(TemplateValidator.validate(doc), isEmpty);
    });

    test('rejects unknown fuel and powertrain', () {
      final doc = validDoc();
      doc['meta'] = {
        ...doc['meta'] as Map<String, dynamic>,
        'engine': {'fuel': 'nuclear', 'powertrain': 'warp'},
      };
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('meta.engine.fuel')), isTrue);
      expect(errors.any((e) => e.contains('meta.engine.powertrain')), isTrue);
    });

    test('rejects duplicate part ids', () {
      final doc = validDoc();
      (doc['parts'] as List).add({'id': 'oil-filter'});
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('duplicate')), isTrue);
    });

    test('rejects quantity <= 0 and unknown unit', () {
      final doc = validDoc();
      (doc['parts'] as List)[0] = {
        'id': 'coolant',
        'name': 'Coolant',
        'quantity': 0,
        'unit': 'pallets',
      };
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('quantity')), isTrue);
      expect(errors.any((e) => e.contains('unit')), isTrue);
    });

    test('rejects items without interval_km or label', () {
      final doc = validDoc();
      (doc['maintenance_items'] as List)[0] = {'id': 'mystery-task'};
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('interval_km')), isTrue);
      expect(errors.any((e) => e.contains('label or i18n_key')), isTrue);
    });

    test('allows remove-only overrides', () {
      final doc = validDoc();
      (doc['maintenance_items'] as List)[0] = {
        'id': 'timing-belt',
        'remove': true,
      };
      (doc['parts'] as List)[0] = {'id': 'oil-filter', 'remove': true};
      expect(TemplateValidator.validate(doc), isEmpty);
    });

    test('rejects invalid DTC code and scope', () {
      final doc = validDoc();
      (doc['obd_dtc_definitions'] as List)[0] = {
        'code': 'X123',
        'scope': 'custom',
        'description': 'nope',
      };
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('invalid DTC')), isTrue);
      expect(errors.any((e) => e.contains('scope')), isTrue);
    });

    test('rejects bad i18n keys', () {
      final doc = validDoc();
      final items =
          List<Map<String, dynamic>>.from(doc['maintenance_items'] as List);
      items[0] = {...items[0], 'i18n_key': 'camelCaseKey'};
      doc['maintenance_items'] = items;
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('i18n_key')), isTrue);
    });

    test('rejects invalid item part refs', () {
      final doc = validDoc();
      final items =
          List<Map<String, dynamic>>.from(doc['maintenance_items'] as List);
      items[0] = {...items[0], 'parts': [{'quantity': 0}]};
      doc['maintenance_items'] = items;
      final errors = TemplateValidator.validate(doc);
      expect(errors.any((e) => e.contains('part_id')), isTrue);
      expect(errors.any((e) => e.contains('quantity')), isTrue);
    });
  });
}