import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/fuel_log.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/domain/value_objects/volume.dart';

void main() {
  group('FuelLog', () {
    test('creates fuel log successfully', () {
      final log = FuelLog(
        id: '1',
        vehicleId: 'v1',
        date: DateTime(2024, 1, 15),
        isSynced: false,
        fueledVolume: Volume(50, VolumeUnit.liters),
        odometerAtFueling: Odometer(10000, DistanceUnit.kilometers),
      );

      expect(log.vehicleId, 'v1');
      expect(log.fueledVolume.amount, 50);
    });

    test('calculatedConsumption returns 0 when distance is 0', () {
      final log = FuelLog(
        id: '1',
        vehicleId: 'v1',
        date: DateTime.now(),
        isSynced: false,
        fueledVolume: Volume(50, VolumeUnit.liters),
        odometerAtFueling: Odometer(0, DistanceUnit.kilometers),
      );

      expect(log.calculatedConsumption, 0);
    });

    test('calculatedConsumption returns correct L/100km', () {
      final log = FuelLog(
        id: '1',
        vehicleId: 'v1',
        date: DateTime.now(),
        isSynced: false,
        fueledVolume: Volume(50, VolumeUnit.liters),
        odometerAtFueling: Odometer(500, DistanceUnit.kilometers),
      );

      // (50 / 500) * 100 = 10 L/100km
      expect(log.calculatedConsumption, closeTo(10, 0.01));
    });
  });
}
