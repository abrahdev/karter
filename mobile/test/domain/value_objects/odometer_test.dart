import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/errors/domain_exception.dart';
import 'package:mobile/domain/value_objects/odometer.dart';

void main() {
  group('Odometer', () {
    test('valid odometer should be created', () {
      final odo = Odometer(1000, DistanceUnit.kilometers);

      expect(odo.distance, 1000);
      expect(odo.unit, DistanceUnit.kilometers);
    });

    test('negative distance should throw', () {
      expect(
        () => Odometer(-10, DistanceUnit.kilometers),
        throwsA(isA<DomainException>()),
      );
    });

    test('add should increase distance', () {
      final odo = Odometer(1000, DistanceUnit.kilometers);
      final result = odo.add(500);

      expect(result.distance, 1500);
    });

    test('add with negative value should throw', () {
      final odo = Odometer(1000, DistanceUnit.kilometers);

      expect(
        () => odo.add(-100),
        throwsA(isA<DomainException>()),
      );
    });
  });
}