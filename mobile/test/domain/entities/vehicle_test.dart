import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/value_objects/plate.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/enums/distance_unit.dart';

void main() {
  group('Vehicle', () {
    test('create vehicle successfully', () {
      final vehicle = Vehicle(
        id: '1',
        brand: 'Toyota',
        model: 'Corolla',
        year: 2020,
        createdAt: DateTime.now(),
        isSynced: false,
        plate: Plate('ABC-123'),
        vin: Vin('1HGCM82633A004352'),
        currentOdometer: Odometer(10000, DistanceUnit.kilometers),
      );

      expect(vehicle.displayName, 'Toyota Corolla 2020');
      expect(vehicle.alias, isNull);
      expect(vehicle.currentOdometer.distance, 10000);
    });

    test('displayName returns alias when set', () {
      final vehicle = Vehicle(
        id: '1',
        brand: 'Toyota',
        model: 'Corolla',
        year: 2020,
        alias: 'Mi nave',
        createdAt: DateTime.now(),
        isSynced: false,
        plate: Plate('ABC-123'),
        vin: Vin('1HGCM82633A004352'),
        currentOdometer: Odometer(10000, DistanceUnit.kilometers),
      );

      expect(vehicle.displayName, 'Mi nave');
    });
  });
}
