import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/errors/domain_exception.dart';

void main() {
  group('Plate', () {
    test('valid plate should create successfully', () {
      final plate = Plate('ABC-123');
      expect(plate.getValue(), 'ABC-123');
    });

    test('empty plate should throw exception', () {
      expect(() => Plate(''), throwsA(isA<DomainException>()));
    });

  });
}