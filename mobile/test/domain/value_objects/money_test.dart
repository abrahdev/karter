import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/errors/domain_exception.dart';
import 'package:mobile/domain/value_objects/money.dart';

void main() {
  group('Money', () {
    test('valid money should be created', () {
      final money = Money(100.50, 'USD');

      expect(money.amount, 100.50);
      expect(money.currency, 'USD');
    });

    test('negative amount should throw', () {
      expect(
        () => Money(-10, 'USD'),
        throwsA(isA<DomainException>()),
      );
    });

    test('add should sum amounts', () {
      final a = Money(50, 'USD');
      final b = Money(30, 'USD');
      final result = a.add(b);

      expect(result.amount, 80);
    });

    test('add with different currencies should throw', () {
      final a = Money(50, 'USD');
      final b = Money(30, 'EUR');

      expect(
        () => a.add(b),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('multiply should scale the amount', () {
      final money = Money(10, 'USD');
      final result = money.multiply(3);

      expect(result.amount, 30);
      expect(result.currency, 'USD');
    });
  });
}