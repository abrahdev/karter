// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles
    with TableInfo<$VehiclesTable, VehicleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
    'vin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerDistanceMeta = const VerificationMeta(
    'odometerDistance',
  );
  @override
  late final GeneratedColumn<double> odometerDistance = GeneratedColumn<double>(
    'odometer_distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerUnitMeta = const VerificationMeta(
    'odometerUnit',
  );
  @override
  late final GeneratedColumn<String> odometerUnit = GeneratedColumn<String>(
    'odometer_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    model,
    year,
    plate,
    vin,
    odometerDistance,
    odometerUnit,
    createdAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    } else if (isInserting) {
      context.missing(_plateMeta);
    }
    if (data.containsKey('vin')) {
      context.handle(
        _vinMeta,
        vin.isAcceptableOrUnknown(data['vin']!, _vinMeta),
      );
    } else if (isInserting) {
      context.missing(_vinMeta);
    }
    if (data.containsKey('odometer_distance')) {
      context.handle(
        _odometerDistanceMeta,
        odometerDistance.isAcceptableOrUnknown(
          data['odometer_distance']!,
          _odometerDistanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometerDistanceMeta);
    }
    if (data.containsKey('odometer_unit')) {
      context.handle(
        _odometerUnitMeta,
        odometerUnit.isAcceptableOrUnknown(
          data['odometer_unit']!,
          _odometerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometerUnitMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    } else if (isInserting) {
      context.missing(_isSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      vin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin'],
      )!,
      odometerDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_distance'],
      )!,
      odometerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}odometer_unit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class VehicleEntry extends DataClass implements Insertable<VehicleEntry> {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final String vin;
  final double odometerDistance;
  final String odometerUnit;
  final DateTime createdAt;
  final bool isSynced;
  const VehicleEntry({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.vin,
    required this.odometerDistance,
    required this.odometerUnit,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['year'] = Variable<int>(year);
    map['plate'] = Variable<String>(plate);
    map['vin'] = Variable<String>(vin);
    map['odometer_distance'] = Variable<double>(odometerDistance);
    map['odometer_unit'] = Variable<String>(odometerUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      brand: Value(brand),
      model: Value(model),
      year: Value(year),
      plate: Value(plate),
      vin: Value(vin),
      odometerDistance: Value(odometerDistance),
      odometerUnit: Value(odometerUnit),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory VehicleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int>(json['year']),
      plate: serializer.fromJson<String>(json['plate']),
      vin: serializer.fromJson<String>(json['vin']),
      odometerDistance: serializer.fromJson<double>(json['odometerDistance']),
      odometerUnit: serializer.fromJson<String>(json['odometerUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int>(year),
      'plate': serializer.toJson<String>(plate),
      'vin': serializer.toJson<String>(vin),
      'odometerDistance': serializer.toJson<double>(odometerDistance),
      'odometerUnit': serializer.toJson<String>(odometerUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  VehicleEntry copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    int? year,
    String? plate,
    String? vin,
    double? odometerDistance,
    String? odometerUnit,
    DateTime? createdAt,
    bool? isSynced,
  }) => VehicleEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year ?? this.year,
    plate: plate ?? this.plate,
    vin: vin ?? this.vin,
    odometerDistance: odometerDistance ?? this.odometerDistance,
    odometerUnit: odometerUnit ?? this.odometerUnit,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
  );
  VehicleEntry copyWithCompanion(VehiclesCompanion data) {
    return VehicleEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      plate: data.plate.present ? data.plate.value : this.plate,
      vin: data.vin.present ? data.vin.value : this.vin,
      odometerDistance: data.odometerDistance.present
          ? data.odometerDistance.value
          : this.odometerDistance,
      odometerUnit: data.odometerUnit.present
          ? data.odometerUnit.value
          : this.odometerUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    model,
    year,
    plate,
    vin,
    odometerDistance,
    odometerUnit,
    createdAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.plate == this.plate &&
          other.vin == this.vin &&
          other.odometerDistance == this.odometerDistance &&
          other.odometerUnit == this.odometerUnit &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class VehiclesCompanion extends UpdateCompanion<VehicleEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> year;
  final Value<String> plate;
  final Value<String> vin;
  final Value<double> odometerDistance;
  final Value<String> odometerUnit;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.plate = const Value.absent(),
    this.vin = const Value.absent(),
    this.odometerDistance = const Value.absent(),
    this.odometerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    required String name,
    required String brand,
    required String model,
    required int year,
    required String plate,
    required String vin,
    required double odometerDistance,
    required String odometerUnit,
    required DateTime createdAt,
    required bool isSynced,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       brand = Value(brand),
       model = Value(model),
       year = Value(year),
       plate = Value(plate),
       vin = Value(vin),
       odometerDistance = Value(odometerDistance),
       odometerUnit = Value(odometerUnit),
       createdAt = Value(createdAt),
       isSynced = Value(isSynced);
  static Insertable<VehicleEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? plate,
    Expression<String>? vin,
    Expression<double>? odometerDistance,
    Expression<String>? odometerUnit,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (plate != null) 'plate': plate,
      if (vin != null) 'vin': vin,
      if (odometerDistance != null) 'odometer_distance': odometerDistance,
      if (odometerUnit != null) 'odometer_unit': odometerUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? brand,
    Value<String>? model,
    Value<int>? year,
    Value<String>? plate,
    Value<String>? vin,
    Value<double>? odometerDistance,
    Value<String>? odometerUnit,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
      odometerDistance: odometerDistance ?? this.odometerDistance,
      odometerUnit: odometerUnit ?? this.odometerUnit,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (odometerDistance.present) {
      map['odometer_distance'] = Variable<double>(odometerDistance.value);
    }
    if (odometerUnit.present) {
      map['odometer_unit'] = Variable<String>(odometerUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FuelLogsTable extends FuelLogs
    with TableInfo<$FuelLogsTable, FuelLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FuelLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeAmountMeta = const VerificationMeta(
    'volumeAmount',
  );
  @override
  late final GeneratedColumn<double> volumeAmount = GeneratedColumn<double>(
    'volume_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeUnitMeta = const VerificationMeta(
    'volumeUnit',
  );
  @override
  late final GeneratedColumn<String> volumeUnit = GeneratedColumn<String>(
    'volume_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerDistanceMeta = const VerificationMeta(
    'odometerDistance',
  );
  @override
  late final GeneratedColumn<double> odometerDistance = GeneratedColumn<double>(
    'odometer_distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _odometerUnitMeta = const VerificationMeta(
    'odometerUnit',
  );
  @override
  late final GeneratedColumn<String> odometerUnit = GeneratedColumn<String>(
    'odometer_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    volumeAmount,
    volumeUnit,
    odometerDistance,
    odometerUnit,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fuel_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FuelLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('volume_amount')) {
      context.handle(
        _volumeAmountMeta,
        volumeAmount.isAcceptableOrUnknown(
          data['volume_amount']!,
          _volumeAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_volumeAmountMeta);
    }
    if (data.containsKey('volume_unit')) {
      context.handle(
        _volumeUnitMeta,
        volumeUnit.isAcceptableOrUnknown(data['volume_unit']!, _volumeUnitMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeUnitMeta);
    }
    if (data.containsKey('odometer_distance')) {
      context.handle(
        _odometerDistanceMeta,
        odometerDistance.isAcceptableOrUnknown(
          data['odometer_distance']!,
          _odometerDistanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometerDistanceMeta);
    }
    if (data.containsKey('odometer_unit')) {
      context.handle(
        _odometerUnitMeta,
        odometerUnit.isAcceptableOrUnknown(
          data['odometer_unit']!,
          _odometerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_odometerUnitMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    } else if (isInserting) {
      context.missing(_isSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FuelLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FuelLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      volumeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume_amount'],
      )!,
      volumeUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}volume_unit'],
      )!,
      odometerDistance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_distance'],
      )!,
      odometerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}odometer_unit'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $FuelLogsTable createAlias(String alias) {
    return $FuelLogsTable(attachedDatabase, alias);
  }
}

class FuelLogEntry extends DataClass implements Insertable<FuelLogEntry> {
  final String id;
  final String vehicleId;
  final DateTime date;
  final double volumeAmount;
  final String volumeUnit;
  final double odometerDistance;
  final String odometerUnit;
  final bool isSynced;
  const FuelLogEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.volumeAmount,
    required this.volumeUnit,
    required this.odometerDistance,
    required this.odometerUnit,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['volume_amount'] = Variable<double>(volumeAmount);
    map['volume_unit'] = Variable<String>(volumeUnit);
    map['odometer_distance'] = Variable<double>(odometerDistance);
    map['odometer_unit'] = Variable<String>(odometerUnit);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  FuelLogsCompanion toCompanion(bool nullToAbsent) {
    return FuelLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      volumeAmount: Value(volumeAmount),
      volumeUnit: Value(volumeUnit),
      odometerDistance: Value(odometerDistance),
      odometerUnit: Value(odometerUnit),
      isSynced: Value(isSynced),
    );
  }

  factory FuelLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FuelLogEntry(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      volumeAmount: serializer.fromJson<double>(json['volumeAmount']),
      volumeUnit: serializer.fromJson<String>(json['volumeUnit']),
      odometerDistance: serializer.fromJson<double>(json['odometerDistance']),
      odometerUnit: serializer.fromJson<String>(json['odometerUnit']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'volumeAmount': serializer.toJson<double>(volumeAmount),
      'volumeUnit': serializer.toJson<String>(volumeUnit),
      'odometerDistance': serializer.toJson<double>(odometerDistance),
      'odometerUnit': serializer.toJson<String>(odometerUnit),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  FuelLogEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    double? volumeAmount,
    String? volumeUnit,
    double? odometerDistance,
    String? odometerUnit,
    bool? isSynced,
  }) => FuelLogEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    volumeAmount: volumeAmount ?? this.volumeAmount,
    volumeUnit: volumeUnit ?? this.volumeUnit,
    odometerDistance: odometerDistance ?? this.odometerDistance,
    odometerUnit: odometerUnit ?? this.odometerUnit,
    isSynced: isSynced ?? this.isSynced,
  );
  FuelLogEntry copyWithCompanion(FuelLogsCompanion data) {
    return FuelLogEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      volumeAmount: data.volumeAmount.present
          ? data.volumeAmount.value
          : this.volumeAmount,
      volumeUnit: data.volumeUnit.present
          ? data.volumeUnit.value
          : this.volumeUnit,
      odometerDistance: data.odometerDistance.present
          ? data.odometerDistance.value
          : this.odometerDistance,
      odometerUnit: data.odometerUnit.present
          ? data.odometerUnit.value
          : this.odometerUnit,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FuelLogEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('volumeAmount: $volumeAmount, ')
          ..write('volumeUnit: $volumeUnit, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    volumeAmount,
    volumeUnit,
    odometerDistance,
    odometerUnit,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FuelLogEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.volumeAmount == this.volumeAmount &&
          other.volumeUnit == this.volumeUnit &&
          other.odometerDistance == this.odometerDistance &&
          other.odometerUnit == this.odometerUnit &&
          other.isSynced == this.isSynced);
}

class FuelLogsCompanion extends UpdateCompanion<FuelLogEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> date;
  final Value<double> volumeAmount;
  final Value<String> volumeUnit;
  final Value<double> odometerDistance;
  final Value<String> odometerUnit;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const FuelLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.volumeAmount = const Value.absent(),
    this.volumeUnit = const Value.absent(),
    this.odometerDistance = const Value.absent(),
    this.odometerUnit = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FuelLogsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime date,
    required double volumeAmount,
    required String volumeUnit,
    required double odometerDistance,
    required String odometerUnit,
    required bool isSynced,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       date = Value(date),
       volumeAmount = Value(volumeAmount),
       volumeUnit = Value(volumeUnit),
       odometerDistance = Value(odometerDistance),
       odometerUnit = Value(odometerUnit),
       isSynced = Value(isSynced);
  static Insertable<FuelLogEntry> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<DateTime>? date,
    Expression<double>? volumeAmount,
    Expression<String>? volumeUnit,
    Expression<double>? odometerDistance,
    Expression<String>? odometerUnit,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (volumeAmount != null) 'volume_amount': volumeAmount,
      if (volumeUnit != null) 'volume_unit': volumeUnit,
      if (odometerDistance != null) 'odometer_distance': odometerDistance,
      if (odometerUnit != null) 'odometer_unit': odometerUnit,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FuelLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? date,
    Value<double>? volumeAmount,
    Value<String>? volumeUnit,
    Value<double>? odometerDistance,
    Value<String>? odometerUnit,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return FuelLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      volumeAmount: volumeAmount ?? this.volumeAmount,
      volumeUnit: volumeUnit ?? this.volumeUnit,
      odometerDistance: odometerDistance ?? this.odometerDistance,
      odometerUnit: odometerUnit ?? this.odometerUnit,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (volumeAmount.present) {
      map['volume_amount'] = Variable<double>(volumeAmount.value);
    }
    if (volumeUnit.present) {
      map['volume_unit'] = Variable<String>(volumeUnit.value);
    }
    if (odometerDistance.present) {
      map['odometer_distance'] = Variable<double>(odometerDistance.value);
    }
    if (odometerUnit.present) {
      map['odometer_unit'] = Variable<String>(odometerUnit.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FuelLogsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('volumeAmount: $volumeAmount, ')
          ..write('volumeUnit: $volumeUnit, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaintenanceLogsTable extends MaintenanceLogs
    with TableInfo<$MaintenanceLogsTable, MaintenanceLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<String> vehicleId = GeneratedColumn<String>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    description,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    } else if (isInserting) {
      context.missing(_isSyncedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $MaintenanceLogsTable createAlias(String alias) {
    return $MaintenanceLogsTable(attachedDatabase, alias);
  }
}

class MaintenanceLogEntry extends DataClass
    implements Insertable<MaintenanceLogEntry> {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String description;
  final bool isSynced;
  const MaintenanceLogEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  MaintenanceLogsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      description: Value(description),
      isSynced: Value(isSynced),
    );
  }

  factory MaintenanceLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceLogEntry(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String>(json['description']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String>(description),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  MaintenanceLogEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    String? description,
    bool? isSynced,
  }) => MaintenanceLogEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    description: description ?? this.description,
    isSynced: isSynced ?? this.isSynced,
  );
  MaintenanceLogEntry copyWithCompanion(MaintenanceLogsCompanion data) {
    return MaintenanceLogEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vehicleId, date, description, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceLogEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.description == this.description &&
          other.isSynced == this.isSynced);
}

class MaintenanceLogsCompanion extends UpdateCompanion<MaintenanceLogEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const MaintenanceLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceLogsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime date,
    required String description,
    required bool isSynced,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       date = Value(date),
       description = Value(description),
       isSynced = Value(isSynced);
  static Insertable<MaintenanceLogEntry> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? date,
    Value<String>? description,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return MaintenanceLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      description: description ?? this.description,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<String>(vehicleId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReplacedPartsTable extends ReplacedParts
    with TableInfo<$ReplacedPartsTable, ReplacedPartEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReplacedPartsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maintenanceLogIdMeta = const VerificationMeta(
    'maintenanceLogId',
  );
  @override
  late final GeneratedColumn<String> maintenanceLogId = GeneratedColumn<String>(
    'maintenance_log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES maintenance_logs (id)',
    ),
  );
  static const VerificationMeta _sparePartIdMeta = const VerificationMeta(
    'sparePartId',
  );
  @override
  late final GeneratedColumn<String> sparePartId = GeneratedColumn<String>(
    'spare_part_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceAmountMeta = const VerificationMeta(
    'unitPriceAmount',
  );
  @override
  late final GeneratedColumn<double> unitPriceAmount = GeneratedColumn<double>(
    'unit_price_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceCurrencyMeta = const VerificationMeta(
    'unitPriceCurrency',
  );
  @override
  late final GeneratedColumn<String> unitPriceCurrency =
      GeneratedColumn<String>(
        'unit_price_currency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    maintenanceLogId,
    sparePartId,
    quantity,
    unitPriceAmount,
    unitPriceCurrency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'replaced_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReplacedPartEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('maintenance_log_id')) {
      context.handle(
        _maintenanceLogIdMeta,
        maintenanceLogId.isAcceptableOrUnknown(
          data['maintenance_log_id']!,
          _maintenanceLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maintenanceLogIdMeta);
    }
    if (data.containsKey('spare_part_id')) {
      context.handle(
        _sparePartIdMeta,
        sparePartId.isAcceptableOrUnknown(
          data['spare_part_id']!,
          _sparePartIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sparePartIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_amount')) {
      context.handle(
        _unitPriceAmountMeta,
        unitPriceAmount.isAcceptableOrUnknown(
          data['unit_price_amount']!,
          _unitPriceAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceAmountMeta);
    }
    if (data.containsKey('unit_price_currency')) {
      context.handle(
        _unitPriceCurrencyMeta,
        unitPriceCurrency.isAcceptableOrUnknown(
          data['unit_price_currency']!,
          _unitPriceCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceCurrencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReplacedPartEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReplacedPartEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      maintenanceLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maintenance_log_id'],
      )!,
      sparePartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spare_part_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price_amount'],
      )!,
      unitPriceCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_price_currency'],
      )!,
    );
  }

  @override
  $ReplacedPartsTable createAlias(String alias) {
    return $ReplacedPartsTable(attachedDatabase, alias);
  }
}

class ReplacedPartEntry extends DataClass
    implements Insertable<ReplacedPartEntry> {
  final String id;
  final String maintenanceLogId;
  final String sparePartId;
  final int quantity;
  final double unitPriceAmount;
  final String unitPriceCurrency;
  const ReplacedPartEntry({
    required this.id,
    required this.maintenanceLogId,
    required this.sparePartId,
    required this.quantity,
    required this.unitPriceAmount,
    required this.unitPriceCurrency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['maintenance_log_id'] = Variable<String>(maintenanceLogId);
    map['spare_part_id'] = Variable<String>(sparePartId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_amount'] = Variable<double>(unitPriceAmount);
    map['unit_price_currency'] = Variable<String>(unitPriceCurrency);
    return map;
  }

  ReplacedPartsCompanion toCompanion(bool nullToAbsent) {
    return ReplacedPartsCompanion(
      id: Value(id),
      maintenanceLogId: Value(maintenanceLogId),
      sparePartId: Value(sparePartId),
      quantity: Value(quantity),
      unitPriceAmount: Value(unitPriceAmount),
      unitPriceCurrency: Value(unitPriceCurrency),
    );
  }

  factory ReplacedPartEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReplacedPartEntry(
      id: serializer.fromJson<String>(json['id']),
      maintenanceLogId: serializer.fromJson<String>(json['maintenanceLogId']),
      sparePartId: serializer.fromJson<String>(json['sparePartId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceAmount: serializer.fromJson<double>(json['unitPriceAmount']),
      unitPriceCurrency: serializer.fromJson<String>(json['unitPriceCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'maintenanceLogId': serializer.toJson<String>(maintenanceLogId),
      'sparePartId': serializer.toJson<String>(sparePartId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceAmount': serializer.toJson<double>(unitPriceAmount),
      'unitPriceCurrency': serializer.toJson<String>(unitPriceCurrency),
    };
  }

  ReplacedPartEntry copyWith({
    String? id,
    String? maintenanceLogId,
    String? sparePartId,
    int? quantity,
    double? unitPriceAmount,
    String? unitPriceCurrency,
  }) => ReplacedPartEntry(
    id: id ?? this.id,
    maintenanceLogId: maintenanceLogId ?? this.maintenanceLogId,
    sparePartId: sparePartId ?? this.sparePartId,
    quantity: quantity ?? this.quantity,
    unitPriceAmount: unitPriceAmount ?? this.unitPriceAmount,
    unitPriceCurrency: unitPriceCurrency ?? this.unitPriceCurrency,
  );
  ReplacedPartEntry copyWithCompanion(ReplacedPartsCompanion data) {
    return ReplacedPartEntry(
      id: data.id.present ? data.id.value : this.id,
      maintenanceLogId: data.maintenanceLogId.present
          ? data.maintenanceLogId.value
          : this.maintenanceLogId,
      sparePartId: data.sparePartId.present
          ? data.sparePartId.value
          : this.sparePartId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceAmount: data.unitPriceAmount.present
          ? data.unitPriceAmount.value
          : this.unitPriceAmount,
      unitPriceCurrency: data.unitPriceCurrency.present
          ? data.unitPriceCurrency.value
          : this.unitPriceCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReplacedPartEntry(')
          ..write('id: $id, ')
          ..write('maintenanceLogId: $maintenanceLogId, ')
          ..write('sparePartId: $sparePartId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceAmount: $unitPriceAmount, ')
          ..write('unitPriceCurrency: $unitPriceCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    maintenanceLogId,
    sparePartId,
    quantity,
    unitPriceAmount,
    unitPriceCurrency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReplacedPartEntry &&
          other.id == this.id &&
          other.maintenanceLogId == this.maintenanceLogId &&
          other.sparePartId == this.sparePartId &&
          other.quantity == this.quantity &&
          other.unitPriceAmount == this.unitPriceAmount &&
          other.unitPriceCurrency == this.unitPriceCurrency);
}

class ReplacedPartsCompanion extends UpdateCompanion<ReplacedPartEntry> {
  final Value<String> id;
  final Value<String> maintenanceLogId;
  final Value<String> sparePartId;
  final Value<int> quantity;
  final Value<double> unitPriceAmount;
  final Value<String> unitPriceCurrency;
  final Value<int> rowid;
  const ReplacedPartsCompanion({
    this.id = const Value.absent(),
    this.maintenanceLogId = const Value.absent(),
    this.sparePartId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceAmount = const Value.absent(),
    this.unitPriceCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReplacedPartsCompanion.insert({
    required String id,
    required String maintenanceLogId,
    required String sparePartId,
    required int quantity,
    required double unitPriceAmount,
    required String unitPriceCurrency,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       maintenanceLogId = Value(maintenanceLogId),
       sparePartId = Value(sparePartId),
       quantity = Value(quantity),
       unitPriceAmount = Value(unitPriceAmount),
       unitPriceCurrency = Value(unitPriceCurrency);
  static Insertable<ReplacedPartEntry> custom({
    Expression<String>? id,
    Expression<String>? maintenanceLogId,
    Expression<String>? sparePartId,
    Expression<int>? quantity,
    Expression<double>? unitPriceAmount,
    Expression<String>? unitPriceCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (maintenanceLogId != null) 'maintenance_log_id': maintenanceLogId,
      if (sparePartId != null) 'spare_part_id': sparePartId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceAmount != null) 'unit_price_amount': unitPriceAmount,
      if (unitPriceCurrency != null) 'unit_price_currency': unitPriceCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReplacedPartsCompanion copyWith({
    Value<String>? id,
    Value<String>? maintenanceLogId,
    Value<String>? sparePartId,
    Value<int>? quantity,
    Value<double>? unitPriceAmount,
    Value<String>? unitPriceCurrency,
    Value<int>? rowid,
  }) {
    return ReplacedPartsCompanion(
      id: id ?? this.id,
      maintenanceLogId: maintenanceLogId ?? this.maintenanceLogId,
      sparePartId: sparePartId ?? this.sparePartId,
      quantity: quantity ?? this.quantity,
      unitPriceAmount: unitPriceAmount ?? this.unitPriceAmount,
      unitPriceCurrency: unitPriceCurrency ?? this.unitPriceCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (maintenanceLogId.present) {
      map['maintenance_log_id'] = Variable<String>(maintenanceLogId.value);
    }
    if (sparePartId.present) {
      map['spare_part_id'] = Variable<String>(sparePartId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceAmount.present) {
      map['unit_price_amount'] = Variable<double>(unitPriceAmount.value);
    }
    if (unitPriceCurrency.present) {
      map['unit_price_currency'] = Variable<String>(unitPriceCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReplacedPartsCompanion(')
          ..write('id: $id, ')
          ..write('maintenanceLogId: $maintenanceLogId, ')
          ..write('sparePartId: $sparePartId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceAmount: $unitPriceAmount, ')
          ..write('unitPriceCurrency: $unitPriceCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $FuelLogsTable fuelLogs = $FuelLogsTable(this);
  late final $MaintenanceLogsTable maintenanceLogs = $MaintenanceLogsTable(
    this,
  );
  late final $ReplacedPartsTable replacedParts = $ReplacedPartsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    fuelLogs,
    maintenanceLogs,
    replacedParts,
  ];
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      required String name,
      required String brand,
      required String model,
      required int year,
      required String plate,
      required String vin,
      required double odometerDistance,
      required String odometerUnit,
      required DateTime createdAt,
      required bool isSynced,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> brand,
      Value<String> model,
      Value<int> year,
      Value<String> plate,
      Value<String> vin,
      Value<double> odometerDistance,
      Value<String> odometerUnit,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, VehicleEntry> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FuelLogsTable, List<FuelLogEntry>>
  _fuelLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fuelLogs,
    aliasName: $_aliasNameGenerator(db.vehicles.id, db.fuelLogs.vehicleId),
  );

  $$FuelLogsTableProcessedTableManager get fuelLogsRefs {
    final manager = $$FuelLogsTableTableManager(
      $_db,
      $_db.fuelLogs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_fuelLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MaintenanceLogsTable, List<MaintenanceLogEntry>>
  _maintenanceLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.maintenanceLogs,
    aliasName: $_aliasNameGenerator(
      db.vehicles.id,
      db.maintenanceLogs.vehicleId,
    ),
  );

  $$MaintenanceLogsTableProcessedTableManager get maintenanceLogsRefs {
    final manager = $$MaintenanceLogsTableTableManager(
      $_db,
      $_db.maintenanceLogs,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fuelLogsRefs(
    Expression<bool> Function($$FuelLogsTableFilterComposer f) f,
  ) {
    final $$FuelLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelLogsTableFilterComposer(
            $db: $db,
            $table: $db.fuelLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> maintenanceLogsRefs(
    Expression<bool> Function($$MaintenanceLogsTableFilterComposer f) f,
  ) {
    final $$MaintenanceLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vin => $composableBuilder(
    column: $table.vin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> fuelLogsRefs<T extends Object>(
    Expression<T> Function($$FuelLogsTableAnnotationComposer a) f,
  ) {
    final $$FuelLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fuelLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FuelLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.fuelLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> maintenanceLogsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceLogsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          VehicleEntry,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (VehicleEntry, $$VehiclesTableReferences),
          VehicleEntry,
          PrefetchHooks Function({bool fuelLogsRefs, bool maintenanceLogsRefs})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<String> vin = const Value.absent(),
                Value<double> odometerDistance = const Value.absent(),
                Value<String> odometerUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String brand,
                required String model,
                required int year,
                required String plate,
                required String vin,
                required double odometerDistance,
                required String odometerUnit,
                required DateTime createdAt,
                required bool isSynced,
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fuelLogsRefs = false, maintenanceLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fuelLogsRefs) db.fuelLogs,
                    if (maintenanceLogsRefs) db.maintenanceLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fuelLogsRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          FuelLogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._fuelLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).fuelLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (maintenanceLogsRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          MaintenanceLogEntry
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      VehicleEntry,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (VehicleEntry, $$VehiclesTableReferences),
      VehicleEntry,
      PrefetchHooks Function({bool fuelLogsRefs, bool maintenanceLogsRefs})
    >;
typedef $$FuelLogsTableCreateCompanionBuilder =
    FuelLogsCompanion Function({
      required String id,
      required String vehicleId,
      required DateTime date,
      required double volumeAmount,
      required String volumeUnit,
      required double odometerDistance,
      required String odometerUnit,
      required bool isSynced,
      Value<int> rowid,
    });
typedef $$FuelLogsTableUpdateCompanionBuilder =
    FuelLogsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<DateTime> date,
      Value<double> volumeAmount,
      Value<String> volumeUnit,
      Value<double> odometerDistance,
      Value<String> odometerUnit,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$FuelLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FuelLogsTable, FuelLogEntry> {
  $$FuelLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) => db.vehicles
      .createAlias($_aliasNameGenerator(db.fuelLogs.vehicleId, db.vehicles.id));

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FuelLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumeAmount => $composableBuilder(
    column: $table.volumeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get volumeUnit => $composableBuilder(
    column: $table.volumeUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumeAmount => $composableBuilder(
    column: $table.volumeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get volumeUnit => $composableBuilder(
    column: $table.volumeUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FuelLogsTable> {
  $$FuelLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get volumeAmount => $composableBuilder(
    column: $table.volumeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get volumeUnit => $composableBuilder(
    column: $table.volumeUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get odometerDistance => $composableBuilder(
    column: $table.odometerDistance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get odometerUnit => $composableBuilder(
    column: $table.odometerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FuelLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FuelLogsTable,
          FuelLogEntry,
          $$FuelLogsTableFilterComposer,
          $$FuelLogsTableOrderingComposer,
          $$FuelLogsTableAnnotationComposer,
          $$FuelLogsTableCreateCompanionBuilder,
          $$FuelLogsTableUpdateCompanionBuilder,
          (FuelLogEntry, $$FuelLogsTableReferences),
          FuelLogEntry,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$FuelLogsTableTableManager(_$AppDatabase db, $FuelLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FuelLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FuelLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FuelLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> volumeAmount = const Value.absent(),
                Value<String> volumeUnit = const Value.absent(),
                Value<double> odometerDistance = const Value.absent(),
                Value<String> odometerUnit = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FuelLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                volumeAmount: volumeAmount,
                volumeUnit: volumeUnit,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime date,
                required double volumeAmount,
                required String volumeUnit,
                required double odometerDistance,
                required String odometerUnit,
                required bool isSynced,
                Value<int> rowid = const Value.absent(),
              }) => FuelLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                volumeAmount: volumeAmount,
                volumeUnit: volumeUnit,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FuelLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$FuelLogsTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$FuelLogsTableReferences
                                    ._vehicleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FuelLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FuelLogsTable,
      FuelLogEntry,
      $$FuelLogsTableFilterComposer,
      $$FuelLogsTableOrderingComposer,
      $$FuelLogsTableAnnotationComposer,
      $$FuelLogsTableCreateCompanionBuilder,
      $$FuelLogsTableUpdateCompanionBuilder,
      (FuelLogEntry, $$FuelLogsTableReferences),
      FuelLogEntry,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$MaintenanceLogsTableCreateCompanionBuilder =
    MaintenanceLogsCompanion Function({
      required String id,
      required String vehicleId,
      required DateTime date,
      required String description,
      required bool isSynced,
      Value<int> rowid,
    });
typedef $$MaintenanceLogsTableUpdateCompanionBuilder =
    MaintenanceLogsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<DateTime> date,
      Value<String> description,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$MaintenanceLogsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceLogsTable,
          MaintenanceLogEntry
        > {
  $$MaintenanceLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenanceLogs.vehicleId, db.vehicles.id),
      );

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<String>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReplacedPartsTable, List<ReplacedPartEntry>>
  _replacedPartsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.replacedParts,
    aliasName: $_aliasNameGenerator(
      db.maintenanceLogs.id,
      db.replacedParts.maintenanceLogId,
    ),
  );

  $$ReplacedPartsTableProcessedTableManager get replacedPartsRefs {
    final manager = $$ReplacedPartsTableTableManager($_db, $_db.replacedParts)
        .filter(
          (f) => f.maintenanceLogId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_replacedPartsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MaintenanceLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> replacedPartsRefs(
    Expression<bool> Function($$ReplacedPartsTableFilterComposer f) f,
  ) {
    final $$ReplacedPartsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.replacedParts,
      getReferencedColumn: (t) => t.maintenanceLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReplacedPartsTableFilterComposer(
            $db: $db,
            $table: $db.replacedParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaintenanceLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MaintenanceLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceLogsTable> {
  $$MaintenanceLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> replacedPartsRefs<T extends Object>(
    Expression<T> Function($$ReplacedPartsTableAnnotationComposer a) f,
  ) {
    final $$ReplacedPartsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.replacedParts,
      getReferencedColumn: (t) => t.maintenanceLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReplacedPartsTableAnnotationComposer(
            $db: $db,
            $table: $db.replacedParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MaintenanceLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceLogsTable,
          MaintenanceLogEntry,
          $$MaintenanceLogsTableFilterComposer,
          $$MaintenanceLogsTableOrderingComposer,
          $$MaintenanceLogsTableAnnotationComposer,
          $$MaintenanceLogsTableCreateCompanionBuilder,
          $$MaintenanceLogsTableUpdateCompanionBuilder,
          (MaintenanceLogEntry, $$MaintenanceLogsTableReferences),
          MaintenanceLogEntry,
          PrefetchHooks Function({bool vehicleId, bool replacedPartsRefs})
        > {
  $$MaintenanceLogsTableTableManager(
    _$AppDatabase db,
    $MaintenanceLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaintenanceLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                description: description,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime date,
                required String description,
                required bool isSynced,
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                description: description,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({vehicleId = false, replacedPartsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (replacedPartsRefs) db.replacedParts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (vehicleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.vehicleId,
                                    referencedTable:
                                        $$MaintenanceLogsTableReferences
                                            ._vehicleIdTable(db),
                                    referencedColumn:
                                        $$MaintenanceLogsTableReferences
                                            ._vehicleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (replacedPartsRefs)
                        await $_getPrefetchedData<
                          MaintenanceLogEntry,
                          $MaintenanceLogsTable,
                          ReplacedPartEntry
                        >(
                          currentTable: table,
                          referencedTable: $$MaintenanceLogsTableReferences
                              ._replacedPartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaintenanceLogsTableReferences(
                                db,
                                table,
                                p0,
                              ).replacedPartsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.maintenanceLogId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MaintenanceLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceLogsTable,
      MaintenanceLogEntry,
      $$MaintenanceLogsTableFilterComposer,
      $$MaintenanceLogsTableOrderingComposer,
      $$MaintenanceLogsTableAnnotationComposer,
      $$MaintenanceLogsTableCreateCompanionBuilder,
      $$MaintenanceLogsTableUpdateCompanionBuilder,
      (MaintenanceLogEntry, $$MaintenanceLogsTableReferences),
      MaintenanceLogEntry,
      PrefetchHooks Function({bool vehicleId, bool replacedPartsRefs})
    >;
typedef $$ReplacedPartsTableCreateCompanionBuilder =
    ReplacedPartsCompanion Function({
      required String id,
      required String maintenanceLogId,
      required String sparePartId,
      required int quantity,
      required double unitPriceAmount,
      required String unitPriceCurrency,
      Value<int> rowid,
    });
typedef $$ReplacedPartsTableUpdateCompanionBuilder =
    ReplacedPartsCompanion Function({
      Value<String> id,
      Value<String> maintenanceLogId,
      Value<String> sparePartId,
      Value<int> quantity,
      Value<double> unitPriceAmount,
      Value<String> unitPriceCurrency,
      Value<int> rowid,
    });

final class $$ReplacedPartsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReplacedPartsTable, ReplacedPartEntry> {
  $$ReplacedPartsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MaintenanceLogsTable _maintenanceLogIdTable(_$AppDatabase db) =>
      db.maintenanceLogs.createAlias(
        $_aliasNameGenerator(
          db.replacedParts.maintenanceLogId,
          db.maintenanceLogs.id,
        ),
      );

  $$MaintenanceLogsTableProcessedTableManager get maintenanceLogId {
    final $_column = $_itemColumn<String>('maintenance_log_id')!;

    final manager = $$MaintenanceLogsTableTableManager(
      $_db,
      $_db.maintenanceLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_maintenanceLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReplacedPartsTableFilterComposer
    extends Composer<_$AppDatabase, $ReplacedPartsTable> {
  $$ReplacedPartsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sparePartId => $composableBuilder(
    column: $table.sparePartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPriceAmount => $composableBuilder(
    column: $table.unitPriceAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => ColumnFilters(column),
  );

  $$MaintenanceLogsTableFilterComposer get maintenanceLogId {
    final $$MaintenanceLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maintenanceLogId,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReplacedPartsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReplacedPartsTable> {
  $$ReplacedPartsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sparePartId => $composableBuilder(
    column: $table.sparePartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPriceAmount => $composableBuilder(
    column: $table.unitPriceAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaintenanceLogsTableOrderingComposer get maintenanceLogId {
    final $$MaintenanceLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maintenanceLogId,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableOrderingComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReplacedPartsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReplacedPartsTable> {
  $$ReplacedPartsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sparePartId => $composableBuilder(
    column: $table.sparePartId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPriceAmount => $composableBuilder(
    column: $table.unitPriceAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unitPriceCurrency => $composableBuilder(
    column: $table.unitPriceCurrency,
    builder: (column) => column,
  );

  $$MaintenanceLogsTableAnnotationComposer get maintenanceLogId {
    final $$MaintenanceLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.maintenanceLogId,
      referencedTable: $db.maintenanceLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.maintenanceLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReplacedPartsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReplacedPartsTable,
          ReplacedPartEntry,
          $$ReplacedPartsTableFilterComposer,
          $$ReplacedPartsTableOrderingComposer,
          $$ReplacedPartsTableAnnotationComposer,
          $$ReplacedPartsTableCreateCompanionBuilder,
          $$ReplacedPartsTableUpdateCompanionBuilder,
          (ReplacedPartEntry, $$ReplacedPartsTableReferences),
          ReplacedPartEntry,
          PrefetchHooks Function({bool maintenanceLogId})
        > {
  $$ReplacedPartsTableTableManager(_$AppDatabase db, $ReplacedPartsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReplacedPartsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReplacedPartsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReplacedPartsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> maintenanceLogId = const Value.absent(),
                Value<String> sparePartId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> unitPriceAmount = const Value.absent(),
                Value<String> unitPriceCurrency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReplacedPartsCompanion(
                id: id,
                maintenanceLogId: maintenanceLogId,
                sparePartId: sparePartId,
                quantity: quantity,
                unitPriceAmount: unitPriceAmount,
                unitPriceCurrency: unitPriceCurrency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String maintenanceLogId,
                required String sparePartId,
                required int quantity,
                required double unitPriceAmount,
                required String unitPriceCurrency,
                Value<int> rowid = const Value.absent(),
              }) => ReplacedPartsCompanion.insert(
                id: id,
                maintenanceLogId: maintenanceLogId,
                sparePartId: sparePartId,
                quantity: quantity,
                unitPriceAmount: unitPriceAmount,
                unitPriceCurrency: unitPriceCurrency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReplacedPartsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({maintenanceLogId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (maintenanceLogId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.maintenanceLogId,
                                referencedTable: $$ReplacedPartsTableReferences
                                    ._maintenanceLogIdTable(db),
                                referencedColumn: $$ReplacedPartsTableReferences
                                    ._maintenanceLogIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReplacedPartsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReplacedPartsTable,
      ReplacedPartEntry,
      $$ReplacedPartsTableFilterComposer,
      $$ReplacedPartsTableOrderingComposer,
      $$ReplacedPartsTableAnnotationComposer,
      $$ReplacedPartsTableCreateCompanionBuilder,
      $$ReplacedPartsTableUpdateCompanionBuilder,
      (ReplacedPartEntry, $$ReplacedPartsTableReferences),
      ReplacedPartEntry,
      PrefetchHooks Function({bool maintenanceLogId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$FuelLogsTableTableManager get fuelLogs =>
      $$FuelLogsTableTableManager(_db, _db.fuelLogs);
  $$MaintenanceLogsTableTableManager get maintenanceLogs =>
      $$MaintenanceLogsTableTableManager(_db, _db.maintenanceLogs);
  $$ReplacedPartsTableTableManager get replacedParts =>
      $$ReplacedPartsTableTableManager(_db, _db.replacedParts);
}
