import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';

void main() {
  group('MaintenanceLog', () {
    test('creates maintenance log successfully', () {
      final log = MaintenanceLog(
        id: '1',
        vehicleId: 'v1',
        date: DateTime(2024, 6, 10),
        description: 'Oil change',
        isSynced: false,
      );

      expect(log.id, '1');
      expect(log.description, 'Oil change');
    });

    test('default replacedParts is empty', () {
      final log = MaintenanceLog(
        id: '1',
        vehicleId: 'v1',
        date: DateTime.now(),
        description: 'Checkup',
        isSynced: false,
      );

      expect(log.replacedParts, isEmpty);
    });
  });
}
