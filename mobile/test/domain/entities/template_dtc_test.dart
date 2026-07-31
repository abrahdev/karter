import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/template_dtc.dart';

void main() {
  group('TemplateDtc', () {
    test('parses a full entry', () {
      final dtc = TemplateDtc.fromJson({
        'code': 'P0171',
        'scope': 'standard',
        'desc_i18n_key': 'dtc_p0171',
        'description': 'System Too Lean Bank 1',
        'related_maintenance': ['oil_change'],
        'related_parts': ['oil_filter'],
      });

      expect(dtc.code, 'P0171');
      expect(dtc.scope, 'standard');
      expect(dtc.descI18nKey, 'dtc_p0171');
      expect(dtc.description, 'System Too Lean Bank 1');
      expect(dtc.relatedMaintenance, ['oil_change']);
      expect(dtc.relatedParts, ['oil_filter']);
      expect(dtc.remove, isFalse);
    });

    test('defaults optional fields', () {
      final dtc = TemplateDtc.fromJson({'code': 'P1100', 'scope': 'manufacturer'});

      expect(dtc.descI18nKey, isNull);
      expect(dtc.description, isNull);
      expect(dtc.relatedMaintenance, isEmpty);
      expect(dtc.relatedParts, isEmpty);
      expect(dtc.remove, isFalse);
    });

    test('parses remove flag', () {
      final dtc = TemplateDtc.fromJson({
        'code': 'P0300',
        'scope': 'standard',
        'remove': true,
      });

      expect(dtc.remove, isTrue);
    });
  });
}
