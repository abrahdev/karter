import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/vehicle_detail_page.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

const _sensorChannel = MethodChannel(
  'dev.fluttercommunity.plus/sensors/accelerometer',
);

Vehicle _vehicle() => Vehicle(
      id: '1',
      brand: 'Toyota',
      model: 'Corolla',
      year: 2020,
      createdAt: DateTime(2020),
      isSynced: false,
      currentOdometer: Odometer(125000, DistanceUnit.kilometers),
      alias: 'Mi Corolla',
    );

Future<void> _pump(
  WidgetTester tester, {
  required double width,
  double textScale = 1.0,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 1600));
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        vehicleProvider('1').overrideWith((ref) async => _vehicle()),
        maintenanceIntervalsProvider('1').overrideWith(
          (ref) async => [
            MaintenanceInterval(
              id: 'i1',
              vehicleId: '1',
              label: 'Engine oil and oil filter change',
              kmInterval: 10000,
            ),
          ],
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VehicleDetailPage(vehicleId: '1'),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_sensorChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_sensorChannel, null);
  });

  testWidgets('stacks buttons below text on narrow screens', (tester) async {
    await _pump(tester, width: 320);

    expect(tester.takeException(), isNull);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).width, greaterThan(200));
  });

  testWidgets('keeps trailing buttons when column has room', (tester) async {
    await _pump(tester, width: 800);

    expect(tester.takeException(), isNull);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).width, lessThan(200));
  });

  testWidgets('stacks buttons at large text scale', (tester) async {
    await _pump(tester, width: 360, textScale: 1.3);

    expect(tester.takeException(), isNull);
    expect(find.text('Update'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(tester.getSize(find.byType(FilledButton)).width, greaterThan(200));
  });
}
