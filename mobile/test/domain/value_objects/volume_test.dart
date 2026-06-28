import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/enums/volume_unit.dart';
import 'package:mobile/domain/value_objects/volume.dart';

void main() {
  group('Volume', () {
    test('valid volume should be created', () {
      final vol = Volume(50, VolumeUnit.liters);

      expect(vol.amount, 50);
      expect(vol.unit, VolumeUnit.liters);
    });

    test('negative amount should throw', () {
      expect(
        () => Volume(-5, VolumeUnit.liters),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('add should sum volumes', () {
      final a = Volume(30, VolumeUnit.liters);
      final b = Volume(20, VolumeUnit.liters);
      final result = a.add(b);

      expect(result.amount, 50);
    });

    test('add with different units should throw', () {
      final a = Volume(30, VolumeUnit.liters);
      final b = Volume(5, VolumeUnit.gallons);

      expect(
        () => a.add(b),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}