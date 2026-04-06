import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/value_objects/vin.dart';
import 'package:mobile/domain/errors/domain_exception.dart';

void main() {
  group('Vin', () {
    test('valid VIN should be created', () {
      final vin = Vin('1HGCM82633A004352');

      expect(vin.code, '1HGCM82633A004352');
    });

    test('invalid VIN length should throw', () {
      expect(() => Vin('123'), throwsA(isA<DomainException>()));
    });

    test('VIN with forbidden characters should throw', () {
      expect(
        () => Vin('1HGCM82633A00I352'),
        throwsA(isA<DomainException>()),
      );
    });

    test('manufacturer should be first 3 chars', () {
      final vin = Vin('1HGCM82633A004352');

      expect(vin.getManufacturer(), '1HG');
    });

    test('vehicle description should be chars 4-9', () {
      final vin = Vin('1HGCM82633A004352');

      expect(vin.getVehicleDescription(), 'CM8263');
    });

    test('check digit should be char 9', () {
      final vin = Vin('1HGCM82633A004352');

      expect(vin.getCheckDigit(), '3');
    });

    test('serial number should be last characters', () {
      final vin = Vin('1HGCM82633A004352');

      expect(vin.getSerialNumber(), '004352');
    });
  });
}