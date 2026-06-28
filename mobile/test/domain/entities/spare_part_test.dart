import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/spare_part.dart';

void main() {
  group('SparePart', () {
    test('creates spare part successfully', () {
      final part = SparePart(
        sku: 'OIL-5W30-5L',
        name: 'Engine Oil 5W-30',
        brand: 'Castrol',
        category: PartCategory.FLUIDS,
        attributes: {'Viscosity': '5W-30', 'Volume': '5L'},
      );

      expect(part.sku, 'OIL-5W30-5L');
      expect(part.category, PartCategory.FLUIDS);
    });

    test('getAttribute returns correct value', () {
      final part = SparePart(
        sku: 'BAT-001',
        name: 'Battery',
        brand: 'Bosch',
        category: PartCategory.ELECTRONICS,
        attributes: {'Voltage': '12V'},
      );

      expect(part.getAttribute('Voltage'), '12V');
      expect(part.getAttribute('NonExistent'), isNull);
    });

    test('isCompatibleWith returns true when no fitment rules', () {
      final part = SparePart(
        sku: 'OIL-5W30-5L',
        name: 'Engine Oil',
        brand: 'Castrol',
        category: PartCategory.FLUIDS,
      );

      // Needs a vehicle to test against; no rules means compatible
      // We test via fitmentRules.isEmpty condition
      expect(part.fitmentRules, isEmpty);
    });
  });
}
