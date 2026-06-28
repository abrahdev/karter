import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/fitment_rule.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';

Vehicle _makeVehicle({
  String brand = 'Toyota',
  String model = 'Corolla',
  int year = 2020,
  String vin = '1HGCM82633A004352',
}) {
  return Vehicle(
    id: '1',
    name: 'Test',
    brand: brand,
    model: model,
    year: year,
    createdAt: DateTime.now(),
    isSynced: false,
    plate: Plate('ABC-123'),
    vin: Vin(vin),
    currentOdometer: Odometer(10000, DistanceUnit.kilometers),
  );
}

void main() {
  group('FitmentRule', () {
    test('matches vehicle when all conditions met', () {
      final rule = FitmentRule(
        make: 'Toyota',
        model: 'Corolla',
        startYear: 2015,
        endYear: 2025,
      );
      final vehicle = _makeVehicle();

      expect(rule.matches(vehicle), isTrue);
    });

    test('does not match when brand differs', () {
      final rule = FitmentRule(
        make: 'Honda',
        model: 'Corolla',
        startYear: 2015,
        endYear: 2025,
      );
      final vehicle = _makeVehicle();

      expect(rule.matches(vehicle), isFalse);
    });

    test('does not match when year out of range', () {
      final rule = FitmentRule(
        make: 'Toyota',
        model: 'Corolla',
        startYear: 2021,
        endYear: 2025,
      );
      final vehicle = _makeVehicle(year: 2020);

      expect(rule.matches(vehicle), isFalse);
    });
  });
}
