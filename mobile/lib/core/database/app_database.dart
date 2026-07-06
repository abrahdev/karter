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
  TextColumn get plate => text().nullable()();
  TextColumn get vin => text().nullable()();
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
  TextColumn get resetIntervalId => text().nullable()();
  RealColumn get restoreResetKm => real().nullable()();
  DateTimeColumn get restoreResetDate => dateTime().nullable()();

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
  IntColumn get monthsInterval => integer().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get lastResetKm => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastResetDate => dateTime().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VehicleDocumentEntry')
class VehicleDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  TextColumn get mimeType => text().nullable()();
  RealColumn get fileSize => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

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
    VehicleDocuments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

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
          await m.database.customStatement(
              'ALTER TABLE vehicles ADD COLUMN alias TEXT');
        }
        if (from < 4) {
          for (final stmt in [
            'ALTER TABLE maintenance_intervals ADD COLUMN months_interval INTEGER',
            'ALTER TABLE maintenance_intervals ADD COLUMN description TEXT',
            'ALTER TABLE maintenance_intervals ADD COLUMN last_reset_date TEXT',
          ]) {
            try {
              await m.database.customStatement(stmt);
            } catch (_) {
              // column may already exist
            }
          }
        }
        if (from < 5) {
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.resetIntervalId);
          } catch (_) {}
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.restoreResetKm);
          } catch (_) {}
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.restoreResetDate);
          } catch (_) {}
        }
        if (from < 7) {
          await m.createTable(vehicleDocuments);
        }
        if (from < 6) {
          await m.database.customStatement('PRAGMA foreign_keys = OFF');
          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS vehicles_new (
              id TEXT NOT NULL PRIMARY KEY,
              name TEXT NOT NULL DEFAULT '',
              alias TEXT,
              brand TEXT NOT NULL,
              model TEXT NOT NULL,
              year INTEGER NOT NULL,
              plate TEXT,
              vin TEXT,
              odometer_distance REAL NOT NULL,
              odometer_unit TEXT NOT NULL,
              created_at TEXT NOT NULL,
              is_synced INTEGER NOT NULL,
              type TEXT NOT NULL DEFAULT 'combustion'
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO vehicles_new (
              id, name, alias, brand, model, year, plate, vin,
              odometer_distance, odometer_unit, created_at, is_synced, type
            )
            SELECT
              id, name, alias, brand, model, year, plate, vin,
              odometer_distance, odometer_unit, created_at, is_synced,
              COALESCE(type, 'combustion')
            FROM vehicles
          ''');
          await m.database.customStatement('DROP TABLE vehicles');
          await m.database.customStatement(
              'ALTER TABLE vehicles_new RENAME TO vehicles');
          await m.database.customStatement('PRAGMA foreign_keys = ON');
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
