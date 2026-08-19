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
  TextColumn get fuelVolumeUnit =>
      text().withDefault(const Constant('liters'))();
  TextColumn get currency =>
      text().withDefault(const Constant('USD'))();
  IntColumn get odometerReminderFreqDays => integer().nullable()();
  DateTimeColumn get odometerReminderLastNotified => dateTime().nullable()();
  BoolColumn get maintenanceReminderEnabled =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get maintenanceReminderSnoozedUntil =>
      dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FuelLogEntry')
@TableIndex(name: 'idx_fuel_logs_vehicle_id', columns: {#vehicleId})
@TableIndex(name: 'idx_fuel_logs_date', columns: {#date})
class FuelLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  RealColumn get volumeAmount => real()();
  TextColumn get volumeUnit => text()();
  RealColumn get odometerDistance => real()();
  TextColumn get odometerUnit => text()();
  BoolColumn get isSynced => boolean()();
  BoolColumn get isFullTank => boolean().withDefault(const Constant(false))();
  RealColumn get pricePerUnit => real().nullable()();
  TextColumn get photoPaths => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceLogEntry')
@TableIndex(name: 'idx_maintenance_logs_vehicle_id', columns: {#vehicleId})
@TableIndex(name: 'idx_maintenance_logs_date', columns: {#date})
class MaintenanceLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
  RealColumn get odometerAtService => real().withDefault(const Constant(0.0))();
  BoolColumn get isSynced => boolean()();
  TextColumn get resetIntervalId => text().nullable()();
  RealColumn get restoreResetKm => real().nullable()();
  DateTimeColumn get restoreResetDate => dateTime().nullable()();
  TextColumn get photoPaths => text().nullable()();
  RealColumn get costAmount => real().nullable()();
  TextColumn get costCurrency => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceIntervalEntry')
@TableIndex(name: 'idx_maintenance_intervals_vehicle_id', columns: {#vehicleId})
class MaintenanceIntervals extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  IntColumn get kmInterval => integer()();
  IntColumn get monthsInterval => integer().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get i18nKey => text().nullable()();
  RealColumn get lastResetKm => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastResetDate => dateTime().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  TextColumn get partsJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VehiclePartEntry')
class VehicleParts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get partId => text().nullable()();
  TextColumn get quantity => text().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get oemNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get links => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceLogPartEntry')
@TableIndex(name: 'idx_maintenance_log_parts_log_id', columns: {#logId})
@TableIndex(name: 'idx_maintenance_log_parts_part_id', columns: {#partId})
class MaintenanceLogParts extends Table {
  TextColumn get id => text()();
  TextColumn get logId => text().references(MaintenanceLogs, #id, onDelete: KeyAction.cascade)();
  TextColumn get partId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get quantity => text().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get oemNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get links => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VehicleDocumentEntry')
@TableIndex(name: 'idx_vehicle_documents_vehicle_id', columns: {#vehicleId})
class VehicleDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  TextColumn get mimeType => text().nullable()();
  RealColumn get fileSize => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get filePaths => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Vehicles,
    FuelLogs,
    MaintenanceLogs,
    MaintenanceIntervals,
    VehicleParts,
    MaintenanceLogParts,
    VehicleDocuments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async => await m.createAll(),
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
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
        if (from < 8) {
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.photoPaths);
          } catch (_) {}
        }
        if (from < 9) {
          try {
            await m.addColumn(vehicles, vehicles.fuelVolumeUnit);
          } catch (_) {}
        }
        if (from < 10) {
          try {
            await m.addColumn(vehicles, vehicles.currency);
          } catch (_) {}
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.costAmount);
          } catch (_) {}
          try {
            await m.addColumn(
                maintenanceLogs, maintenanceLogs.costCurrency);
          } catch (_) {}
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
        if (from < 11) {
          try {
            await m.addColumn(
                vehicles, vehicles.odometerReminderFreqDays);
          } catch (_) {}
          try {
            await m.addColumn(
                vehicles, vehicles.odometerReminderLastNotified);
          } catch (_) {}
          try {
            await m.addColumn(
                vehicles, vehicles.maintenanceReminderEnabled);
          } catch (_) {}
          try {
            await m.addColumn(
                vehicles, vehicles.maintenanceReminderSnoozedUntil);
          } catch (_) {}
        }
        if (from < 12) {
          try {
            await m.addColumn(
                maintenanceIntervals, maintenanceIntervals.i18nKey);
          } catch (_) {}
        }
        if (from < 13) {
          try {
            await m.addColumn(fuelLogs, fuelLogs.photoPaths);
          } catch (_) {}
        }
        if (from < 14) {
          try {
            await m.database.customStatement(
                'ALTER TABLE vehicle_documents ADD COLUMN file_paths TEXT');
            await m.database.customStatement(
                "UPDATE vehicle_documents SET file_paths = json_array(file_path) WHERE file_paths IS NULL");
          } catch (_) {}
        }
        if (from < 15) {
          try {
            await m.addColumn(
                maintenanceIntervals, maintenanceIntervals.partsJson);
          } catch (_) {}
        }
        if (from < 16) {
          await m.createTable(vehicleParts);
          await m.createTable(maintenanceLogParts);
        }
        if (from < 17) {
          await m.database.customStatement('PRAGMA foreign_keys = OFF');

          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS fuel_logs_new (
              id TEXT NOT NULL PRIMARY KEY,
              vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
              date TEXT NOT NULL,
              volume_amount REAL NOT NULL,
              volume_unit TEXT NOT NULL,
              odometer_distance REAL NOT NULL,
              odometer_unit TEXT NOT NULL,
              is_synced INTEGER NOT NULL,
              is_full_tank INTEGER NOT NULL DEFAULT 0,
              price_per_unit REAL,
              photo_paths TEXT
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO fuel_logs_new (
              id, vehicle_id, date, volume_amount, volume_unit,
              odometer_distance, odometer_unit, is_synced, is_full_tank,
              price_per_unit, photo_paths
            )
            SELECT
              id, vehicle_id, date, volume_amount, volume_unit,
              odometer_distance, odometer_unit,
              COALESCE(is_synced, 0), COALESCE(is_full_tank, 0),
              price_per_unit, photo_paths
            FROM fuel_logs
          ''');
          await m.database.customStatement('DROP TABLE fuel_logs');
          await m.database.customStatement('ALTER TABLE fuel_logs_new RENAME TO fuel_logs');
          await m.database.customStatement('CREATE INDEX idx_fuel_logs_vehicle_id ON fuel_logs(vehicle_id)');
          await m.database.customStatement('CREATE INDEX idx_fuel_logs_date ON fuel_logs(date)');

          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS maintenance_logs_new (
              id TEXT NOT NULL PRIMARY KEY,
              vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
              date TEXT NOT NULL,
              description TEXT NOT NULL,
              odometer_at_service REAL NOT NULL DEFAULT 0.0,
              is_synced INTEGER NOT NULL,
              reset_interval_id TEXT,
              restore_reset_km REAL,
              restore_reset_date TEXT,
              photo_paths TEXT,
              cost_amount REAL,
              cost_currency TEXT
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO maintenance_logs_new (
              id, vehicle_id, date, description, odometer_at_service,
              is_synced, reset_interval_id, restore_reset_km,
              restore_reset_date, photo_paths, cost_amount, cost_currency
            )
            SELECT
              id, vehicle_id, date, description,
              COALESCE(odometer_at_service, 0.0),
              COALESCE(is_synced, 0),
              reset_interval_id, restore_reset_km,
              restore_reset_date, photo_paths, cost_amount, cost_currency
            FROM maintenance_logs
          ''');
          await m.database.customStatement('DROP TABLE maintenance_logs');
          await m.database.customStatement('ALTER TABLE maintenance_logs_new RENAME TO maintenance_logs');
          await m.database.customStatement('CREATE INDEX idx_maintenance_logs_vehicle_id ON maintenance_logs(vehicle_id)');
          await m.database.customStatement('CREATE INDEX idx_maintenance_logs_date ON maintenance_logs(date)');

          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS maintenance_intervals_new (
              id TEXT NOT NULL PRIMARY KEY,
              vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
              label TEXT NOT NULL,
              km_interval INTEGER NOT NULL,
              months_interval INTEGER,
              description TEXT,
              i18n_key TEXT,
              last_reset_km REAL NOT NULL DEFAULT 0.0,
              last_reset_date TEXT,
              is_enabled INTEGER NOT NULL DEFAULT 1,
              is_custom INTEGER NOT NULL DEFAULT 0,
              parts_json TEXT
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO maintenance_intervals_new (
              id, vehicle_id, label, km_interval, months_interval,
              description, i18n_key, last_reset_km, last_reset_date,
              is_enabled, is_custom, parts_json
            )
            SELECT
              id, vehicle_id, label, km_interval, months_interval,
              description, i18n_key,
              COALESCE(last_reset_km, 0.0),
              last_reset_date,
              COALESCE(is_enabled, 1),
              COALESCE(is_custom, 0),
              parts_json
            FROM maintenance_intervals
          ''');
          await m.database.customStatement('DROP TABLE maintenance_intervals');
          await m.database.customStatement('ALTER TABLE maintenance_intervals_new RENAME TO maintenance_intervals');
          await m.database.customStatement('CREATE INDEX idx_maintenance_intervals_vehicle_id ON maintenance_intervals(vehicle_id)');

          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS maintenance_log_parts_new (
              id TEXT NOT NULL PRIMARY KEY,
              log_id TEXT NOT NULL REFERENCES maintenance_logs(id) ON DELETE CASCADE,
              part_id TEXT,
              name TEXT NOT NULL,
              quantity TEXT,
              unit TEXT,
              oem_number TEXT,
              description TEXT,
              links TEXT
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO maintenance_log_parts_new (
              id, log_id, part_id, name, quantity, unit,
              oem_number, description, links
            )
            SELECT
              id, log_id, part_id, name, quantity, unit,
              oem_number, description, links
            FROM maintenance_log_parts
          ''');
          await m.database.customStatement('DROP TABLE maintenance_log_parts');
          await m.database.customStatement('ALTER TABLE maintenance_log_parts_new RENAME TO maintenance_log_parts');
          await m.database.customStatement('CREATE INDEX idx_maintenance_log_parts_log_id ON maintenance_log_parts(log_id)');
          await m.database.customStatement('CREATE INDEX idx_maintenance_log_parts_part_id ON maintenance_log_parts(part_id)');

          await m.database.customStatement('''
            CREATE TABLE IF NOT EXISTS vehicle_documents_new (
              id TEXT NOT NULL PRIMARY KEY,
              vehicle_id TEXT NOT NULL REFERENCES vehicles(id) ON DELETE CASCADE,
              type TEXT NOT NULL,
              name TEXT NOT NULL,
              file_name TEXT NOT NULL,
              file_path TEXT NOT NULL,
              mime_type TEXT,
              file_size REAL,
              notes TEXT,
              expiry_date TEXT,
              created_at TEXT NOT NULL,
              file_paths TEXT
            )
          ''');
          await m.database.customStatement('''
            INSERT INTO vehicle_documents_new (
              id, vehicle_id, type, name, file_name, file_path,
              mime_type, file_size, notes, expiry_date,
              created_at, file_paths
            )
            SELECT
              id, vehicle_id, type, name, file_name, file_path,
              mime_type, file_size, notes, expiry_date,
              created_at, file_paths
            FROM vehicle_documents
          ''');
          await m.database.customStatement('DROP TABLE vehicle_documents');
          await m.database.customStatement('ALTER TABLE vehicle_documents_new RENAME TO vehicle_documents');
          await m.database.customStatement('CREATE INDEX idx_vehicle_documents_vehicle_id ON vehicle_documents(vehicle_id)');

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
