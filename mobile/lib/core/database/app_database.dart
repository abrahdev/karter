import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

@DataClassName('VehicleEntry')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get alias => text().nullable()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  TextColumn get plate => text()();
  TextColumn get vin => text()();
  RealColumn get odometerDistance => real()();
  TextColumn get odometerUnit => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean()();
  TextColumn get type => text().withDefault(const Constant('combustion'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FuelLogEntry')
class FuelLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get volumeAmount => real()();
  TextColumn get volumeUnit => text()();
  RealColumn get odometerDistance => real()();
  TextColumn get odometerUnit => text()();
  BoolColumn get isSynced => boolean()();
  BoolColumn get isFullTank => boolean().withDefault(const Constant(false))();
  RealColumn get pricePerUnit => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceLogEntry')
class MaintenanceLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
  RealColumn get odometerAtService => real().withDefault(const Constant(0.0))();
  BoolColumn get isSynced => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReplacedPartEntry')
class ReplacedParts extends Table {
  TextColumn get id => text()();
  TextColumn get maintenanceLogId =>
      text().references(MaintenanceLogs, #id)();
  TextColumn get sparePartId => text()();
  IntColumn get quantity => integer()();
  RealColumn get unitPriceAmount => real()();
  TextColumn get unitPriceCurrency => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceIntervalEntry')
class MaintenanceIntervals extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get label => text()();
  IntColumn get kmInterval => integer()();
  RealColumn get lastResetKm => real().withDefault(const Constant(0.0))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Vehicles,
    FuelLogs,
    MaintenanceLogs,
    ReplacedParts,
    MaintenanceIntervals,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => await m.createAll(),
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(vehicles, vehicles.type);
          await m.addColumn(fuelLogs, fuelLogs.isFullTank);
          await m.addColumn(fuelLogs, fuelLogs.pricePerUnit);
          await m.addColumn(maintenanceLogs, maintenanceLogs.odometerAtService);
          await m.createTable(maintenanceIntervals);
        }
        if (from < 3) {
          await m.addColumn(vehicles, vehicles.alias);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      return NativeDatabase(File(p.join(dir.path, 'karter.db')));
    });
  }
}

final uuid = Uuid();
