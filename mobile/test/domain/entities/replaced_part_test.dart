import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/replaced_part.dart';
import 'package:mobile/domain/value_objects/money.dart';

void main() {
  group('ReplacedPart', () {
    test('creates replaced part successfully', () {
      final part = ReplacedPart(
        sparePartId: 'sp1',
        quantity: 2,
        unitPrice: Money(25, 'USD'),
      );

      expect(part.sparePartId, 'sp1');
      expect(part.quantity, 2);
    });

    test('getTotal calculates correct total', () {
      final part = ReplacedPart(
        sparePartId: 'sp1',
        quantity: 3,
        unitPrice: Money(50, 'USD'),
      );

      final total = part.getTotal();
      expect(total.amount, 150);
      expect(total.currency, 'USD');
    });
  });
}
