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
  TextColumn get name => text()();
  TextColumn get brand => text()();
  TextColumn get model => text()();
  IntColumn get year => integer()();
  TextColumn get plate => text()();
  TextColumn get vin => text()();
  RealColumn get odometerDistance => real()();
  TextColumn get odometerUnit => text()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean()();

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

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MaintenanceLogEntry')
class MaintenanceLogs extends Table {
  TextColumn get id => text()();
  TextColumn get vehicleId => text().references(Vehicles, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();
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

@DriftDatabase(tables: [Vehicles, FuelLogs, MaintenanceLogs, ReplacedParts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      return NativeDatabase(File(p.join(dir.path, 'karter.db')));
    });
  }
}

final uuid = Uuid();
