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
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
    'vin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('combustion'),
  );
  static const VerificationMeta _fuelVolumeUnitMeta = const VerificationMeta(
    'fuelVolumeUnit',
  );
  @override
  late final GeneratedColumn<String> fuelVolumeUnit = GeneratedColumn<String>(
    'fuel_volume_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('liters'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    alias,
    brand,
    model,
    year,
    plate,
    vin,
    odometerDistance,
    odometerUnit,
    createdAt,
    isSynced,
    type,
    fuelVolumeUnit,
    currency,
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
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
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
    }
    if (data.containsKey('vin')) {
      context.handle(
        _vinMeta,
        vin.isAcceptableOrUnknown(data['vin']!, _vinMeta),
      );
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('fuel_volume_unit')) {
      context.handle(
        _fuelVolumeUnitMeta,
        fuelVolumeUnit.isAcceptableOrUnknown(
          data['fuel_volume_unit']!,
          _fuelVolumeUnitMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
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
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
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
      ),
      vin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vin'],
      ),
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
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      fuelVolumeUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fuel_volume_unit'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
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
  final String? alias;
  final String brand;
  final String model;
  final int year;
  final String? plate;
  final String? vin;
  final double odometerDistance;
  final String odometerUnit;
  final DateTime createdAt;
  final bool isSynced;
  final String type;
  final String fuelVolumeUnit;
  final String currency;
  const VehicleEntry({
    required this.id,
    required this.name,
    this.alias,
    required this.brand,
    required this.model,
    required this.year,
    this.plate,
    this.vin,
    required this.odometerDistance,
    required this.odometerUnit,
    required this.createdAt,
    required this.isSynced,
    required this.type,
    required this.fuelVolumeUnit,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    map['brand'] = Variable<String>(brand);
    map['model'] = Variable<String>(model);
    map['year'] = Variable<int>(year);
    if (!nullToAbsent || plate != null) {
      map['plate'] = Variable<String>(plate);
    }
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    map['odometer_distance'] = Variable<double>(odometerDistance);
    map['odometer_unit'] = Variable<String>(odometerUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['type'] = Variable<String>(type);
    map['fuel_volume_unit'] = Variable<String>(fuelVolumeUnit);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      brand: Value(brand),
      model: Value(model),
      year: Value(year),
      plate: plate == null && nullToAbsent
          ? const Value.absent()
          : Value(plate),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      odometerDistance: Value(odometerDistance),
      odometerUnit: Value(odometerUnit),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      type: Value(type),
      fuelVolumeUnit: Value(fuelVolumeUnit),
      currency: Value(currency),
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
      alias: serializer.fromJson<String?>(json['alias']),
      brand: serializer.fromJson<String>(json['brand']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int>(json['year']),
      plate: serializer.fromJson<String?>(json['plate']),
      vin: serializer.fromJson<String?>(json['vin']),
      odometerDistance: serializer.fromJson<double>(json['odometerDistance']),
      odometerUnit: serializer.fromJson<String>(json['odometerUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      type: serializer.fromJson<String>(json['type']),
      fuelVolumeUnit: serializer.fromJson<String>(json['fuelVolumeUnit']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'alias': serializer.toJson<String?>(alias),
      'brand': serializer.toJson<String>(brand),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int>(year),
      'plate': serializer.toJson<String?>(plate),
      'vin': serializer.toJson<String?>(vin),
      'odometerDistance': serializer.toJson<double>(odometerDistance),
      'odometerUnit': serializer.toJson<String>(odometerUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'type': serializer.toJson<String>(type),
      'fuelVolumeUnit': serializer.toJson<String>(fuelVolumeUnit),
      'currency': serializer.toJson<String>(currency),
    };
  }

  VehicleEntry copyWith({
    String? id,
    String? name,
    Value<String?> alias = const Value.absent(),
    String? brand,
    String? model,
    int? year,
    Value<String?> plate = const Value.absent(),
    Value<String?> vin = const Value.absent(),
    double? odometerDistance,
    String? odometerUnit,
    DateTime? createdAt,
    bool? isSynced,
    String? type,
    String? fuelVolumeUnit,
    String? currency,
  }) => VehicleEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    alias: alias.present ? alias.value : this.alias,
    brand: brand ?? this.brand,
    model: model ?? this.model,
    year: year ?? this.year,
    plate: plate.present ? plate.value : this.plate,
    vin: vin.present ? vin.value : this.vin,
    odometerDistance: odometerDistance ?? this.odometerDistance,
    odometerUnit: odometerUnit ?? this.odometerUnit,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    type: type ?? this.type,
    fuelVolumeUnit: fuelVolumeUnit ?? this.fuelVolumeUnit,
    currency: currency ?? this.currency,
  );
  VehicleEntry copyWithCompanion(VehiclesCompanion data) {
    return VehicleEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      alias: data.alias.present ? data.alias.value : this.alias,
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
      type: data.type.present ? data.type.value : this.type,
      fuelVolumeUnit: data.fuelVolumeUnit.present
          ? data.fuelVolumeUnit.value
          : this.fuelVolumeUnit,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('alias: $alias, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('type: $type, ')
          ..write('fuelVolumeUnit: $fuelVolumeUnit, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    alias,
    brand,
    model,
    year,
    plate,
    vin,
    odometerDistance,
    odometerUnit,
    createdAt,
    isSynced,
    type,
    fuelVolumeUnit,
    currency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.alias == this.alias &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.year == this.year &&
          other.plate == this.plate &&
          other.vin == this.vin &&
          other.odometerDistance == this.odometerDistance &&
          other.odometerUnit == this.odometerUnit &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.type == this.type &&
          other.fuelVolumeUnit == this.fuelVolumeUnit &&
          other.currency == this.currency);
}

class VehiclesCompanion extends UpdateCompanion<VehicleEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> alias;
  final Value<String> brand;
  final Value<String> model;
  final Value<int> year;
  final Value<String?> plate;
  final Value<String?> vin;
  final Value<double> odometerDistance;
  final Value<String> odometerUnit;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<String> type;
  final Value<String> fuelVolumeUnit;
  final Value<String> currency;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.plate = const Value.absent(),
    this.vin = const Value.absent(),
    this.odometerDistance = const Value.absent(),
    this.odometerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.type = const Value.absent(),
    this.fuelVolumeUnit = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.alias = const Value.absent(),
    required String brand,
    required String model,
    required int year,
    this.plate = const Value.absent(),
    this.vin = const Value.absent(),
    required double odometerDistance,
    required String odometerUnit,
    required DateTime createdAt,
    required bool isSynced,
    this.type = const Value.absent(),
    this.fuelVolumeUnit = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       brand = Value(brand),
       model = Value(model),
       year = Value(year),
       odometerDistance = Value(odometerDistance),
       odometerUnit = Value(odometerUnit),
       createdAt = Value(createdAt),
       isSynced = Value(isSynced);
  static Insertable<VehicleEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? alias,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? plate,
    Expression<String>? vin,
    Expression<double>? odometerDistance,
    Expression<String>? odometerUnit,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<String>? type,
    Expression<String>? fuelVolumeUnit,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (alias != null) 'alias': alias,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (plate != null) 'plate': plate,
      if (vin != null) 'vin': vin,
      if (odometerDistance != null) 'odometer_distance': odometerDistance,
      if (odometerUnit != null) 'odometer_unit': odometerUnit,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (type != null) 'type': type,
      if (fuelVolumeUnit != null) 'fuel_volume_unit': fuelVolumeUnit,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? alias,
    Value<String>? brand,
    Value<String>? model,
    Value<int>? year,
    Value<String?>? plate,
    Value<String?>? vin,
    Value<double>? odometerDistance,
    Value<String>? odometerUnit,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<String>? type,
    Value<String>? fuelVolumeUnit,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
      odometerDistance: odometerDistance ?? this.odometerDistance,
      odometerUnit: odometerUnit ?? this.odometerUnit,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      type: type ?? this.type,
      fuelVolumeUnit: fuelVolumeUnit ?? this.fuelVolumeUnit,
      currency: currency ?? this.currency,
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
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fuelVolumeUnit.present) {
      map['fuel_volume_unit'] = Variable<String>(fuelVolumeUnit.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
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
          ..write('alias: $alias, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('plate: $plate, ')
          ..write('vin: $vin, ')
          ..write('odometerDistance: $odometerDistance, ')
          ..write('odometerUnit: $odometerUnit, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('type: $type, ')
          ..write('fuelVolumeUnit: $fuelVolumeUnit, ')
          ..write('currency: $currency, ')
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
  static const VerificationMeta _isFullTankMeta = const VerificationMeta(
    'isFullTank',
  );
  @override
  late final GeneratedColumn<bool> isFullTank = GeneratedColumn<bool>(
    'is_full_tank',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full_tank" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pricePerUnitMeta = const VerificationMeta(
    'pricePerUnit',
  );
  @override
  late final GeneratedColumn<double> pricePerUnit = GeneratedColumn<double>(
    'price_per_unit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
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
    isFullTank,
    pricePerUnit,
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
    if (data.containsKey('is_full_tank')) {
      context.handle(
        _isFullTankMeta,
        isFullTank.isAcceptableOrUnknown(
          data['is_full_tank']!,
          _isFullTankMeta,
        ),
      );
    }
    if (data.containsKey('price_per_unit')) {
      context.handle(
        _pricePerUnitMeta,
        pricePerUnit.isAcceptableOrUnknown(
          data['price_per_unit']!,
          _pricePerUnitMeta,
        ),
      );
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
      isFullTank: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full_tank'],
      )!,
      pricePerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_unit'],
      ),
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
  final bool isFullTank;
  final double? pricePerUnit;
  const FuelLogEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.volumeAmount,
    required this.volumeUnit,
    required this.odometerDistance,
    required this.odometerUnit,
    required this.isSynced,
    required this.isFullTank,
    this.pricePerUnit,
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
    map['is_full_tank'] = Variable<bool>(isFullTank);
    if (!nullToAbsent || pricePerUnit != null) {
      map['price_per_unit'] = Variable<double>(pricePerUnit);
    }
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
      isFullTank: Value(isFullTank),
      pricePerUnit: pricePerUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerUnit),
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
      isFullTank: serializer.fromJson<bool>(json['isFullTank']),
      pricePerUnit: serializer.fromJson<double?>(json['pricePerUnit']),
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
      'isFullTank': serializer.toJson<bool>(isFullTank),
      'pricePerUnit': serializer.toJson<double?>(pricePerUnit),
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
    bool? isFullTank,
    Value<double?> pricePerUnit = const Value.absent(),
  }) => FuelLogEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    volumeAmount: volumeAmount ?? this.volumeAmount,
    volumeUnit: volumeUnit ?? this.volumeUnit,
    odometerDistance: odometerDistance ?? this.odometerDistance,
    odometerUnit: odometerUnit ?? this.odometerUnit,
    isSynced: isSynced ?? this.isSynced,
    isFullTank: isFullTank ?? this.isFullTank,
    pricePerUnit: pricePerUnit.present ? pricePerUnit.value : this.pricePerUnit,
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
      isFullTank: data.isFullTank.present
          ? data.isFullTank.value
          : this.isFullTank,
      pricePerUnit: data.pricePerUnit.present
          ? data.pricePerUnit.value
          : this.pricePerUnit,
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
          ..write('isSynced: $isSynced, ')
          ..write('isFullTank: $isFullTank, ')
          ..write('pricePerUnit: $pricePerUnit')
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
    isFullTank,
    pricePerUnit,
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
          other.isSynced == this.isSynced &&
          other.isFullTank == this.isFullTank &&
          other.pricePerUnit == this.pricePerUnit);
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
  final Value<bool> isFullTank;
  final Value<double?> pricePerUnit;
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
    this.isFullTank = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
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
    this.isFullTank = const Value.absent(),
    this.pricePerUnit = const Value.absent(),
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
    Expression<bool>? isFullTank,
    Expression<double>? pricePerUnit,
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
      if (isFullTank != null) 'is_full_tank': isFullTank,
      if (pricePerUnit != null) 'price_per_unit': pricePerUnit,
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
    Value<bool>? isFullTank,
    Value<double?>? pricePerUnit,
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
      isFullTank: isFullTank ?? this.isFullTank,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
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
    if (isFullTank.present) {
      map['is_full_tank'] = Variable<bool>(isFullTank.value);
    }
    if (pricePerUnit.present) {
      map['price_per_unit'] = Variable<double>(pricePerUnit.value);
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
          ..write('isFullTank: $isFullTank, ')
          ..write('pricePerUnit: $pricePerUnit, ')
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
  static const VerificationMeta _odometerAtServiceMeta = const VerificationMeta(
    'odometerAtService',
  );
  @override
  late final GeneratedColumn<double> odometerAtService =
      GeneratedColumn<double>(
        'odometer_at_service',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
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
  static const VerificationMeta _resetIntervalIdMeta = const VerificationMeta(
    'resetIntervalId',
  );
  @override
  late final GeneratedColumn<String> resetIntervalId = GeneratedColumn<String>(
    'reset_interval_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restoreResetKmMeta = const VerificationMeta(
    'restoreResetKm',
  );
  @override
  late final GeneratedColumn<double> restoreResetKm = GeneratedColumn<double>(
    'restore_reset_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restoreResetDateMeta = const VerificationMeta(
    'restoreResetDate',
  );
  @override
  late final GeneratedColumn<DateTime> restoreResetDate =
      GeneratedColumn<DateTime>(
        'restore_reset_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _photoPathsMeta = const VerificationMeta(
    'photoPaths',
  );
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
    'photo_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costAmountMeta = const VerificationMeta(
    'costAmount',
  );
  @override
  late final GeneratedColumn<double> costAmount = GeneratedColumn<double>(
    'cost_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCurrencyMeta = const VerificationMeta(
    'costCurrency',
  );
  @override
  late final GeneratedColumn<String> costCurrency = GeneratedColumn<String>(
    'cost_currency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    date,
    description,
    odometerAtService,
    isSynced,
    resetIntervalId,
    restoreResetKm,
    restoreResetDate,
    photoPaths,
    costAmount,
    costCurrency,
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
    if (data.containsKey('odometer_at_service')) {
      context.handle(
        _odometerAtServiceMeta,
        odometerAtService.isAcceptableOrUnknown(
          data['odometer_at_service']!,
          _odometerAtServiceMeta,
        ),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    } else if (isInserting) {
      context.missing(_isSyncedMeta);
    }
    if (data.containsKey('reset_interval_id')) {
      context.handle(
        _resetIntervalIdMeta,
        resetIntervalId.isAcceptableOrUnknown(
          data['reset_interval_id']!,
          _resetIntervalIdMeta,
        ),
      );
    }
    if (data.containsKey('restore_reset_km')) {
      context.handle(
        _restoreResetKmMeta,
        restoreResetKm.isAcceptableOrUnknown(
          data['restore_reset_km']!,
          _restoreResetKmMeta,
        ),
      );
    }
    if (data.containsKey('restore_reset_date')) {
      context.handle(
        _restoreResetDateMeta,
        restoreResetDate.isAcceptableOrUnknown(
          data['restore_reset_date']!,
          _restoreResetDateMeta,
        ),
      );
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
        _photoPathsMeta,
        photoPaths.isAcceptableOrUnknown(data['photo_paths']!, _photoPathsMeta),
      );
    }
    if (data.containsKey('cost_amount')) {
      context.handle(
        _costAmountMeta,
        costAmount.isAcceptableOrUnknown(data['cost_amount']!, _costAmountMeta),
      );
    }
    if (data.containsKey('cost_currency')) {
      context.handle(
        _costCurrencyMeta,
        costCurrency.isAcceptableOrUnknown(
          data['cost_currency']!,
          _costCurrencyMeta,
        ),
      );
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
      odometerAtService: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}odometer_at_service'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      resetIntervalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reset_interval_id'],
      ),
      restoreResetKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}restore_reset_km'],
      ),
      restoreResetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}restore_reset_date'],
      ),
      photoPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_paths'],
      ),
      costAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost_amount'],
      ),
      costCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cost_currency'],
      ),
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
  final double odometerAtService;
  final bool isSynced;
  final String? resetIntervalId;
  final double? restoreResetKm;
  final DateTime? restoreResetDate;
  final String? photoPaths;
  final double? costAmount;
  final String? costCurrency;
  const MaintenanceLogEntry({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.odometerAtService,
    required this.isSynced,
    this.resetIntervalId,
    this.restoreResetKm,
    this.restoreResetDate,
    this.photoPaths,
    this.costAmount,
    this.costCurrency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    map['odometer_at_service'] = Variable<double>(odometerAtService);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || resetIntervalId != null) {
      map['reset_interval_id'] = Variable<String>(resetIntervalId);
    }
    if (!nullToAbsent || restoreResetKm != null) {
      map['restore_reset_km'] = Variable<double>(restoreResetKm);
    }
    if (!nullToAbsent || restoreResetDate != null) {
      map['restore_reset_date'] = Variable<DateTime>(restoreResetDate);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    if (!nullToAbsent || costAmount != null) {
      map['cost_amount'] = Variable<double>(costAmount);
    }
    if (!nullToAbsent || costCurrency != null) {
      map['cost_currency'] = Variable<String>(costCurrency);
    }
    return map;
  }

  MaintenanceLogsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceLogsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      date: Value(date),
      description: Value(description),
      odometerAtService: Value(odometerAtService),
      isSynced: Value(isSynced),
      resetIntervalId: resetIntervalId == null && nullToAbsent
          ? const Value.absent()
          : Value(resetIntervalId),
      restoreResetKm: restoreResetKm == null && nullToAbsent
          ? const Value.absent()
          : Value(restoreResetKm),
      restoreResetDate: restoreResetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(restoreResetDate),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      costAmount: costAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(costAmount),
      costCurrency: costCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(costCurrency),
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
      odometerAtService: serializer.fromJson<double>(json['odometerAtService']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      resetIntervalId: serializer.fromJson<String?>(json['resetIntervalId']),
      restoreResetKm: serializer.fromJson<double?>(json['restoreResetKm']),
      restoreResetDate: serializer.fromJson<DateTime?>(
        json['restoreResetDate'],
      ),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      costAmount: serializer.fromJson<double?>(json['costAmount']),
      costCurrency: serializer.fromJson<String?>(json['costCurrency']),
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
      'odometerAtService': serializer.toJson<double>(odometerAtService),
      'isSynced': serializer.toJson<bool>(isSynced),
      'resetIntervalId': serializer.toJson<String?>(resetIntervalId),
      'restoreResetKm': serializer.toJson<double?>(restoreResetKm),
      'restoreResetDate': serializer.toJson<DateTime?>(restoreResetDate),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'costAmount': serializer.toJson<double?>(costAmount),
      'costCurrency': serializer.toJson<String?>(costCurrency),
    };
  }

  MaintenanceLogEntry copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    String? description,
    double? odometerAtService,
    bool? isSynced,
    Value<String?> resetIntervalId = const Value.absent(),
    Value<double?> restoreResetKm = const Value.absent(),
    Value<DateTime?> restoreResetDate = const Value.absent(),
    Value<String?> photoPaths = const Value.absent(),
    Value<double?> costAmount = const Value.absent(),
    Value<String?> costCurrency = const Value.absent(),
  }) => MaintenanceLogEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    date: date ?? this.date,
    description: description ?? this.description,
    odometerAtService: odometerAtService ?? this.odometerAtService,
    isSynced: isSynced ?? this.isSynced,
    resetIntervalId: resetIntervalId.present
        ? resetIntervalId.value
        : this.resetIntervalId,
    restoreResetKm: restoreResetKm.present
        ? restoreResetKm.value
        : this.restoreResetKm,
    restoreResetDate: restoreResetDate.present
        ? restoreResetDate.value
        : this.restoreResetDate,
    photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
    costAmount: costAmount.present ? costAmount.value : this.costAmount,
    costCurrency: costCurrency.present ? costCurrency.value : this.costCurrency,
  );
  MaintenanceLogEntry copyWithCompanion(MaintenanceLogsCompanion data) {
    return MaintenanceLogEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      odometerAtService: data.odometerAtService.present
          ? data.odometerAtService.value
          : this.odometerAtService,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      resetIntervalId: data.resetIntervalId.present
          ? data.resetIntervalId.value
          : this.resetIntervalId,
      restoreResetKm: data.restoreResetKm.present
          ? data.restoreResetKm.value
          : this.restoreResetKm,
      restoreResetDate: data.restoreResetDate.present
          ? data.restoreResetDate.value
          : this.restoreResetDate,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      costAmount: data.costAmount.present
          ? data.costAmount.value
          : this.costAmount,
      costCurrency: data.costCurrency.present
          ? data.costCurrency.value
          : this.costCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceLogEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('odometerAtService: $odometerAtService, ')
          ..write('isSynced: $isSynced, ')
          ..write('resetIntervalId: $resetIntervalId, ')
          ..write('restoreResetKm: $restoreResetKm, ')
          ..write('restoreResetDate: $restoreResetDate, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('costAmount: $costAmount, ')
          ..write('costCurrency: $costCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    date,
    description,
    odometerAtService,
    isSynced,
    resetIntervalId,
    restoreResetKm,
    restoreResetDate,
    photoPaths,
    costAmount,
    costCurrency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceLogEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.date == this.date &&
          other.description == this.description &&
          other.odometerAtService == this.odometerAtService &&
          other.isSynced == this.isSynced &&
          other.resetIntervalId == this.resetIntervalId &&
          other.restoreResetKm == this.restoreResetKm &&
          other.restoreResetDate == this.restoreResetDate &&
          other.photoPaths == this.photoPaths &&
          other.costAmount == this.costAmount &&
          other.costCurrency == this.costCurrency);
}

class MaintenanceLogsCompanion extends UpdateCompanion<MaintenanceLogEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<double> odometerAtService;
  final Value<bool> isSynced;
  final Value<String?> resetIntervalId;
  final Value<double?> restoreResetKm;
  final Value<DateTime?> restoreResetDate;
  final Value<String?> photoPaths;
  final Value<double?> costAmount;
  final Value<String?> costCurrency;
  final Value<int> rowid;
  const MaintenanceLogsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.odometerAtService = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.resetIntervalId = const Value.absent(),
    this.restoreResetKm = const Value.absent(),
    this.restoreResetDate = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.costAmount = const Value.absent(),
    this.costCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceLogsCompanion.insert({
    required String id,
    required String vehicleId,
    required DateTime date,
    required String description,
    this.odometerAtService = const Value.absent(),
    required bool isSynced,
    this.resetIntervalId = const Value.absent(),
    this.restoreResetKm = const Value.absent(),
    this.restoreResetDate = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.costAmount = const Value.absent(),
    this.costCurrency = const Value.absent(),
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
    Expression<double>? odometerAtService,
    Expression<bool>? isSynced,
    Expression<String>? resetIntervalId,
    Expression<double>? restoreResetKm,
    Expression<DateTime>? restoreResetDate,
    Expression<String>? photoPaths,
    Expression<double>? costAmount,
    Expression<String>? costCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (odometerAtService != null) 'odometer_at_service': odometerAtService,
      if (isSynced != null) 'is_synced': isSynced,
      if (resetIntervalId != null) 'reset_interval_id': resetIntervalId,
      if (restoreResetKm != null) 'restore_reset_km': restoreResetKm,
      if (restoreResetDate != null) 'restore_reset_date': restoreResetDate,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (costAmount != null) 'cost_amount': costAmount,
      if (costCurrency != null) 'cost_currency': costCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<DateTime>? date,
    Value<String>? description,
    Value<double>? odometerAtService,
    Value<bool>? isSynced,
    Value<String?>? resetIntervalId,
    Value<double?>? restoreResetKm,
    Value<DateTime?>? restoreResetDate,
    Value<String?>? photoPaths,
    Value<double?>? costAmount,
    Value<String?>? costCurrency,
    Value<int>? rowid,
  }) {
    return MaintenanceLogsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      description: description ?? this.description,
      odometerAtService: odometerAtService ?? this.odometerAtService,
      isSynced: isSynced ?? this.isSynced,
      resetIntervalId: resetIntervalId ?? this.resetIntervalId,
      restoreResetKm: restoreResetKm ?? this.restoreResetKm,
      restoreResetDate: restoreResetDate ?? this.restoreResetDate,
      photoPaths: photoPaths ?? this.photoPaths,
      costAmount: costAmount ?? this.costAmount,
      costCurrency: costCurrency ?? this.costCurrency,
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
    if (odometerAtService.present) {
      map['odometer_at_service'] = Variable<double>(odometerAtService.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (resetIntervalId.present) {
      map['reset_interval_id'] = Variable<String>(resetIntervalId.value);
    }
    if (restoreResetKm.present) {
      map['restore_reset_km'] = Variable<double>(restoreResetKm.value);
    }
    if (restoreResetDate.present) {
      map['restore_reset_date'] = Variable<DateTime>(restoreResetDate.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (costAmount.present) {
      map['cost_amount'] = Variable<double>(costAmount.value);
    }
    if (costCurrency.present) {
      map['cost_currency'] = Variable<String>(costCurrency.value);
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
          ..write('odometerAtService: $odometerAtService, ')
          ..write('isSynced: $isSynced, ')
          ..write('resetIntervalId: $resetIntervalId, ')
          ..write('restoreResetKm: $restoreResetKm, ')
          ..write('restoreResetDate: $restoreResetDate, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('costAmount: $costAmount, ')
          ..write('costCurrency: $costCurrency, ')
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

class $MaintenanceIntervalsTable extends MaintenanceIntervals
    with TableInfo<$MaintenanceIntervalsTable, MaintenanceIntervalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaintenanceIntervalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kmIntervalMeta = const VerificationMeta(
    'kmInterval',
  );
  @override
  late final GeneratedColumn<int> kmInterval = GeneratedColumn<int>(
    'km_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthsIntervalMeta = const VerificationMeta(
    'monthsInterval',
  );
  @override
  late final GeneratedColumn<int> monthsInterval = GeneratedColumn<int>(
    'months_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastResetKmMeta = const VerificationMeta(
    'lastResetKm',
  );
  @override
  late final GeneratedColumn<double> lastResetKm = GeneratedColumn<double>(
    'last_reset_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lastResetDateMeta = const VerificationMeta(
    'lastResetDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastResetDate =
      GeneratedColumn<DateTime>(
        'last_reset_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    label,
    kmInterval,
    monthsInterval,
    description,
    lastResetKm,
    lastResetDate,
    isEnabled,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maintenance_intervals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaintenanceIntervalEntry> instance, {
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
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('km_interval')) {
      context.handle(
        _kmIntervalMeta,
        kmInterval.isAcceptableOrUnknown(data['km_interval']!, _kmIntervalMeta),
      );
    } else if (isInserting) {
      context.missing(_kmIntervalMeta);
    }
    if (data.containsKey('months_interval')) {
      context.handle(
        _monthsIntervalMeta,
        monthsInterval.isAcceptableOrUnknown(
          data['months_interval']!,
          _monthsIntervalMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('last_reset_km')) {
      context.handle(
        _lastResetKmMeta,
        lastResetKm.isAcceptableOrUnknown(
          data['last_reset_km']!,
          _lastResetKmMeta,
        ),
      );
    }
    if (data.containsKey('last_reset_date')) {
      context.handle(
        _lastResetDateMeta,
        lastResetDate.isAcceptableOrUnknown(
          data['last_reset_date']!,
          _lastResetDateMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaintenanceIntervalEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaintenanceIntervalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      kmInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}km_interval'],
      )!,
      monthsInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}months_interval'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      lastResetKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_reset_km'],
      )!,
      lastResetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reset_date'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $MaintenanceIntervalsTable createAlias(String alias) {
    return $MaintenanceIntervalsTable(attachedDatabase, alias);
  }
}

class MaintenanceIntervalEntry extends DataClass
    implements Insertable<MaintenanceIntervalEntry> {
  final String id;
  final String vehicleId;
  final String label;
  final int kmInterval;
  final int? monthsInterval;
  final String? description;
  final double lastResetKm;
  final DateTime? lastResetDate;
  final bool isEnabled;
  final bool isCustom;
  const MaintenanceIntervalEntry({
    required this.id,
    required this.vehicleId,
    required this.label,
    required this.kmInterval,
    this.monthsInterval,
    this.description,
    required this.lastResetKm,
    this.lastResetDate,
    required this.isEnabled,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['label'] = Variable<String>(label);
    map['km_interval'] = Variable<int>(kmInterval);
    if (!nullToAbsent || monthsInterval != null) {
      map['months_interval'] = Variable<int>(monthsInterval);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['last_reset_km'] = Variable<double>(lastResetKm);
    if (!nullToAbsent || lastResetDate != null) {
      map['last_reset_date'] = Variable<DateTime>(lastResetDate);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  MaintenanceIntervalsCompanion toCompanion(bool nullToAbsent) {
    return MaintenanceIntervalsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      label: Value(label),
      kmInterval: Value(kmInterval),
      monthsInterval: monthsInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(monthsInterval),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      lastResetKm: Value(lastResetKm),
      lastResetDate: lastResetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastResetDate),
      isEnabled: Value(isEnabled),
      isCustom: Value(isCustom),
    );
  }

  factory MaintenanceIntervalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaintenanceIntervalEntry(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      label: serializer.fromJson<String>(json['label']),
      kmInterval: serializer.fromJson<int>(json['kmInterval']),
      monthsInterval: serializer.fromJson<int?>(json['monthsInterval']),
      description: serializer.fromJson<String?>(json['description']),
      lastResetKm: serializer.fromJson<double>(json['lastResetKm']),
      lastResetDate: serializer.fromJson<DateTime?>(json['lastResetDate']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'label': serializer.toJson<String>(label),
      'kmInterval': serializer.toJson<int>(kmInterval),
      'monthsInterval': serializer.toJson<int?>(monthsInterval),
      'description': serializer.toJson<String?>(description),
      'lastResetKm': serializer.toJson<double>(lastResetKm),
      'lastResetDate': serializer.toJson<DateTime?>(lastResetDate),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  MaintenanceIntervalEntry copyWith({
    String? id,
    String? vehicleId,
    String? label,
    int? kmInterval,
    Value<int?> monthsInterval = const Value.absent(),
    Value<String?> description = const Value.absent(),
    double? lastResetKm,
    Value<DateTime?> lastResetDate = const Value.absent(),
    bool? isEnabled,
    bool? isCustom,
  }) => MaintenanceIntervalEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    label: label ?? this.label,
    kmInterval: kmInterval ?? this.kmInterval,
    monthsInterval: monthsInterval.present
        ? monthsInterval.value
        : this.monthsInterval,
    description: description.present ? description.value : this.description,
    lastResetKm: lastResetKm ?? this.lastResetKm,
    lastResetDate: lastResetDate.present
        ? lastResetDate.value
        : this.lastResetDate,
    isEnabled: isEnabled ?? this.isEnabled,
    isCustom: isCustom ?? this.isCustom,
  );
  MaintenanceIntervalEntry copyWithCompanion(
    MaintenanceIntervalsCompanion data,
  ) {
    return MaintenanceIntervalEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      label: data.label.present ? data.label.value : this.label,
      kmInterval: data.kmInterval.present
          ? data.kmInterval.value
          : this.kmInterval,
      monthsInterval: data.monthsInterval.present
          ? data.monthsInterval.value
          : this.monthsInterval,
      description: data.description.present
          ? data.description.value
          : this.description,
      lastResetKm: data.lastResetKm.present
          ? data.lastResetKm.value
          : this.lastResetKm,
      lastResetDate: data.lastResetDate.present
          ? data.lastResetDate.value
          : this.lastResetDate,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceIntervalEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('label: $label, ')
          ..write('kmInterval: $kmInterval, ')
          ..write('monthsInterval: $monthsInterval, ')
          ..write('description: $description, ')
          ..write('lastResetKm: $lastResetKm, ')
          ..write('lastResetDate: $lastResetDate, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    label,
    kmInterval,
    monthsInterval,
    description,
    lastResetKm,
    lastResetDate,
    isEnabled,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaintenanceIntervalEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.label == this.label &&
          other.kmInterval == this.kmInterval &&
          other.monthsInterval == this.monthsInterval &&
          other.description == this.description &&
          other.lastResetKm == this.lastResetKm &&
          other.lastResetDate == this.lastResetDate &&
          other.isEnabled == this.isEnabled &&
          other.isCustom == this.isCustom);
}

class MaintenanceIntervalsCompanion
    extends UpdateCompanion<MaintenanceIntervalEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> label;
  final Value<int> kmInterval;
  final Value<int?> monthsInterval;
  final Value<String?> description;
  final Value<double> lastResetKm;
  final Value<DateTime?> lastResetDate;
  final Value<bool> isEnabled;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const MaintenanceIntervalsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.label = const Value.absent(),
    this.kmInterval = const Value.absent(),
    this.monthsInterval = const Value.absent(),
    this.description = const Value.absent(),
    this.lastResetKm = const Value.absent(),
    this.lastResetDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaintenanceIntervalsCompanion.insert({
    required String id,
    required String vehicleId,
    required String label,
    required int kmInterval,
    this.monthsInterval = const Value.absent(),
    this.description = const Value.absent(),
    this.lastResetKm = const Value.absent(),
    this.lastResetDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       label = Value(label),
       kmInterval = Value(kmInterval);
  static Insertable<MaintenanceIntervalEntry> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? label,
    Expression<int>? kmInterval,
    Expression<int>? monthsInterval,
    Expression<String>? description,
    Expression<double>? lastResetKm,
    Expression<DateTime>? lastResetDate,
    Expression<bool>? isEnabled,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (label != null) 'label': label,
      if (kmInterval != null) 'km_interval': kmInterval,
      if (monthsInterval != null) 'months_interval': monthsInterval,
      if (description != null) 'description': description,
      if (lastResetKm != null) 'last_reset_km': lastResetKm,
      if (lastResetDate != null) 'last_reset_date': lastResetDate,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaintenanceIntervalsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? label,
    Value<int>? kmInterval,
    Value<int?>? monthsInterval,
    Value<String?>? description,
    Value<double>? lastResetKm,
    Value<DateTime?>? lastResetDate,
    Value<bool>? isEnabled,
    Value<bool>? isCustom,
    Value<int>? rowid,
  }) {
    return MaintenanceIntervalsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      label: label ?? this.label,
      kmInterval: kmInterval ?? this.kmInterval,
      monthsInterval: monthsInterval ?? this.monthsInterval,
      description: description ?? this.description,
      lastResetKm: lastResetKm ?? this.lastResetKm,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
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
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (kmInterval.present) {
      map['km_interval'] = Variable<int>(kmInterval.value);
    }
    if (monthsInterval.present) {
      map['months_interval'] = Variable<int>(monthsInterval.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (lastResetKm.present) {
      map['last_reset_km'] = Variable<double>(lastResetKm.value);
    }
    if (lastResetDate.present) {
      map['last_reset_date'] = Variable<DateTime>(lastResetDate.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaintenanceIntervalsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('label: $label, ')
          ..write('kmInterval: $kmInterval, ')
          ..write('monthsInterval: $monthsInterval, ')
          ..write('description: $description, ')
          ..write('lastResetKm: $lastResetKm, ')
          ..write('lastResetDate: $lastResetDate, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VehicleDocumentsTable extends VehicleDocuments
    with TableInfo<$VehicleDocumentsTable, VehicleDocumentEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehicleDocumentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
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
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<double> fileSize = GeneratedColumn<double>(
    'file_size',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    vehicleId,
    type,
    name,
    fileName,
    filePath,
    mimeType,
    fileSize,
    notes,
    expiryDate,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicle_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<VehicleDocumentEntry> instance, {
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VehicleDocumentEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VehicleDocumentEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}file_size'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $VehicleDocumentsTable createAlias(String alias) {
    return $VehicleDocumentsTable(attachedDatabase, alias);
  }
}

class VehicleDocumentEntry extends DataClass
    implements Insertable<VehicleDocumentEntry> {
  final String id;
  final String vehicleId;
  final String type;
  final String name;
  final String fileName;
  final String filePath;
  final String? mimeType;
  final double? fileSize;
  final String? notes;
  final DateTime? expiryDate;
  final DateTime createdAt;
  const VehicleDocumentEntry({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.name,
    required this.fileName,
    required this.filePath,
    this.mimeType,
    this.fileSize,
    this.notes,
    this.expiryDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['vehicle_id'] = Variable<String>(vehicleId);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    if (!nullToAbsent || fileSize != null) {
      map['file_size'] = Variable<double>(fileSize);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehicleDocumentsCompanion toCompanion(bool nullToAbsent) {
    return VehicleDocumentsCompanion(
      id: Value(id),
      vehicleId: Value(vehicleId),
      type: Value(type),
      name: Value(name),
      fileName: Value(fileName),
      filePath: Value(filePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      fileSize: fileSize == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSize),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      createdAt: Value(createdAt),
    );
  }

  factory VehicleDocumentEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VehicleDocumentEntry(
      id: serializer.fromJson<String>(json['id']),
      vehicleId: serializer.fromJson<String>(json['vehicleId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      fileSize: serializer.fromJson<double?>(json['fileSize']),
      notes: serializer.fromJson<String?>(json['notes']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'vehicleId': serializer.toJson<String>(vehicleId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'fileSize': serializer.toJson<double?>(fileSize),
      'notes': serializer.toJson<String?>(notes),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VehicleDocumentEntry copyWith({
    String? id,
    String? vehicleId,
    String? type,
    String? name,
    String? fileName,
    String? filePath,
    Value<String?> mimeType = const Value.absent(),
    Value<double?> fileSize = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<DateTime?> expiryDate = const Value.absent(),
    DateTime? createdAt,
  }) => VehicleDocumentEntry(
    id: id ?? this.id,
    vehicleId: vehicleId ?? this.vehicleId,
    type: type ?? this.type,
    name: name ?? this.name,
    fileName: fileName ?? this.fileName,
    filePath: filePath ?? this.filePath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    fileSize: fileSize.present ? fileSize.value : this.fileSize,
    notes: notes.present ? notes.value : this.notes,
    expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
    createdAt: createdAt ?? this.createdAt,
  );
  VehicleDocumentEntry copyWithCompanion(VehicleDocumentsCompanion data) {
    return VehicleDocumentEntry(
      id: data.id.present ? data.id.value : this.id,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      notes: data.notes.present ? data.notes.value : this.notes,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VehicleDocumentEntry(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('notes: $notes, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    vehicleId,
    type,
    name,
    fileName,
    filePath,
    mimeType,
    fileSize,
    notes,
    expiryDate,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VehicleDocumentEntry &&
          other.id == this.id &&
          other.vehicleId == this.vehicleId &&
          other.type == this.type &&
          other.name == this.name &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.mimeType == this.mimeType &&
          other.fileSize == this.fileSize &&
          other.notes == this.notes &&
          other.expiryDate == this.expiryDate &&
          other.createdAt == this.createdAt);
}

class VehicleDocumentsCompanion extends UpdateCompanion<VehicleDocumentEntry> {
  final Value<String> id;
  final Value<String> vehicleId;
  final Value<String> type;
  final Value<String> name;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<String?> mimeType;
  final Value<double?> fileSize;
  final Value<String?> notes;
  final Value<DateTime?> expiryDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const VehicleDocumentsCompanion({
    this.id = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.notes = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehicleDocumentsCompanion.insert({
    required String id,
    required String vehicleId,
    required String type,
    required String name,
    required String fileName,
    required String filePath,
    this.mimeType = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.notes = const Value.absent(),
    this.expiryDate = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       vehicleId = Value(vehicleId),
       type = Value(type),
       name = Value(name),
       fileName = Value(fileName),
       filePath = Value(filePath),
       createdAt = Value(createdAt);
  static Insertable<VehicleDocumentEntry> custom({
    Expression<String>? id,
    Expression<String>? vehicleId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? mimeType,
    Expression<double>? fileSize,
    Expression<String>? notes,
    Expression<DateTime>? expiryDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (fileSize != null) 'file_size': fileSize,
      if (notes != null) 'notes': notes,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehicleDocumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? vehicleId,
    Value<String>? type,
    Value<String>? name,
    Value<String>? fileName,
    Value<String>? filePath,
    Value<String?>? mimeType,
    Value<double?>? fileSize,
    Value<String?>? notes,
    Value<DateTime?>? expiryDate,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return VehicleDocumentsCompanion(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      type: type ?? this.type,
      name: name ?? this.name,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      notes: notes ?? this.notes,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<double>(fileSize.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehicleDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('fileSize: $fileSize, ')
          ..write('notes: $notes, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('createdAt: $createdAt, ')
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
  late final $MaintenanceIntervalsTable maintenanceIntervals =
      $MaintenanceIntervalsTable(this);
  late final $VehicleDocumentsTable vehicleDocuments = $VehicleDocumentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    fuelLogs,
    maintenanceLogs,
    replacedParts,
    maintenanceIntervals,
    vehicleDocuments,
  ];
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      required String id,
      Value<String> name,
      Value<String?> alias,
      required String brand,
      required String model,
      required int year,
      Value<String?> plate,
      Value<String?> vin,
      required double odometerDistance,
      required String odometerUnit,
      required DateTime createdAt,
      required bool isSynced,
      Value<String> type,
      Value<String> fuelVolumeUnit,
      Value<String> currency,
      Value<int> rowid,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> alias,
      Value<String> brand,
      Value<String> model,
      Value<int> year,
      Value<String?> plate,
      Value<String?> vin,
      Value<double> odometerDistance,
      Value<String> odometerUnit,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<String> type,
      Value<String> fuelVolumeUnit,
      Value<String> currency,
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

  static MultiTypedResultKey<
    $MaintenanceIntervalsTable,
    List<MaintenanceIntervalEntry>
  >
  _maintenanceIntervalsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.maintenanceIntervals,
        aliasName: $_aliasNameGenerator(
          db.vehicles.id,
          db.maintenanceIntervals.vehicleId,
        ),
      );

  $$MaintenanceIntervalsTableProcessedTableManager
  get maintenanceIntervalsRefs {
    final manager = $$MaintenanceIntervalsTableTableManager(
      $_db,
      $_db.maintenanceIntervals,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _maintenanceIntervalsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VehicleDocumentsTable, List<VehicleDocumentEntry>>
  _vehicleDocumentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.vehicleDocuments,
    aliasName: $_aliasNameGenerator(
      db.vehicles.id,
      db.vehicleDocuments.vehicleId,
    ),
  );

  $$VehicleDocumentsTableProcessedTableManager get vehicleDocumentsRefs {
    final manager = $$VehicleDocumentsTableTableManager(
      $_db,
      $_db.vehicleDocuments,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _vehicleDocumentsRefsTable($_db),
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

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fuelVolumeUnit => $composableBuilder(
    column: $table.fuelVolumeUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
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

  Expression<bool> maintenanceIntervalsRefs(
    Expression<bool> Function($$MaintenanceIntervalsTableFilterComposer f) f,
  ) {
    final $$MaintenanceIntervalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.maintenanceIntervals,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaintenanceIntervalsTableFilterComposer(
            $db: $db,
            $table: $db.maintenanceIntervals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vehicleDocumentsRefs(
    Expression<bool> Function($$VehicleDocumentsTableFilterComposer f) f,
  ) {
    final $$VehicleDocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicleDocuments,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehicleDocumentsTableFilterComposer(
            $db: $db,
            $table: $db.vehicleDocuments,
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

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelVolumeUnit => $composableBuilder(
    column: $table.fuelVolumeUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
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

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get fuelVolumeUnit => $composableBuilder(
    column: $table.fuelVolumeUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

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

  Expression<T> maintenanceIntervalsRefs<T extends Object>(
    Expression<T> Function($$MaintenanceIntervalsTableAnnotationComposer a) f,
  ) {
    final $$MaintenanceIntervalsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.maintenanceIntervals,
          getReferencedColumn: (t) => t.vehicleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$MaintenanceIntervalsTableAnnotationComposer(
                $db: $db,
                $table: $db.maintenanceIntervals,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> vehicleDocumentsRefs<T extends Object>(
    Expression<T> Function($$VehicleDocumentsTableAnnotationComposer a) f,
  ) {
    final $$VehicleDocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicleDocuments,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehicleDocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicleDocuments,
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
          PrefetchHooks Function({
            bool fuelLogsRefs,
            bool maintenanceLogsRefs,
            bool maintenanceIntervalsRefs,
            bool vehicleDocumentsRefs,
          })
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
                Value<String?> alias = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<String?> plate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                Value<double> odometerDistance = const Value.absent(),
                Value<String> odometerUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> fuelVolumeUnit = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                alias: alias,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                createdAt: createdAt,
                isSynced: isSynced,
                type: type,
                fuelVolumeUnit: fuelVolumeUnit,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                required String brand,
                required String model,
                required int year,
                Value<String?> plate = const Value.absent(),
                Value<String?> vin = const Value.absent(),
                required double odometerDistance,
                required String odometerUnit,
                required DateTime createdAt,
                required bool isSynced,
                Value<String> type = const Value.absent(),
                Value<String> fuelVolumeUnit = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                alias: alias,
                brand: brand,
                model: model,
                year: year,
                plate: plate,
                vin: vin,
                odometerDistance: odometerDistance,
                odometerUnit: odometerUnit,
                createdAt: createdAt,
                isSynced: isSynced,
                type: type,
                fuelVolumeUnit: fuelVolumeUnit,
                currency: currency,
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
              ({
                fuelLogsRefs = false,
                maintenanceLogsRefs = false,
                maintenanceIntervalsRefs = false,
                vehicleDocumentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fuelLogsRefs) db.fuelLogs,
                    if (maintenanceLogsRefs) db.maintenanceLogs,
                    if (maintenanceIntervalsRefs) db.maintenanceIntervals,
                    if (vehicleDocumentsRefs) db.vehicleDocuments,
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
                      if (maintenanceIntervalsRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          MaintenanceIntervalEntry
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._maintenanceIntervalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).maintenanceIntervalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (vehicleDocumentsRefs)
                        await $_getPrefetchedData<
                          VehicleEntry,
                          $VehiclesTable,
                          VehicleDocumentEntry
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._vehicleDocumentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).vehicleDocumentsRefs,
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
      PrefetchHooks Function({
        bool fuelLogsRefs,
        bool maintenanceLogsRefs,
        bool maintenanceIntervalsRefs,
        bool vehicleDocumentsRefs,
      })
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
      Value<bool> isFullTank,
      Value<double?> pricePerUnit,
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
      Value<bool> isFullTank,
      Value<double?> pricePerUnit,
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

  ColumnFilters<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
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

  ColumnOrderings<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
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

  GeneratedColumn<bool> get isFullTank => $composableBuilder(
    column: $table.isFullTank,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerUnit => $composableBuilder(
    column: $table.pricePerUnit,
    builder: (column) => column,
  );

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
                Value<bool> isFullTank = const Value.absent(),
                Value<double?> pricePerUnit = const Value.absent(),
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
                isFullTank: isFullTank,
                pricePerUnit: pricePerUnit,
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
                Value<bool> isFullTank = const Value.absent(),
                Value<double?> pricePerUnit = const Value.absent(),
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
                isFullTank: isFullTank,
                pricePerUnit: pricePerUnit,
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
      Value<double> odometerAtService,
      required bool isSynced,
      Value<String?> resetIntervalId,
      Value<double?> restoreResetKm,
      Value<DateTime?> restoreResetDate,
      Value<String?> photoPaths,
      Value<double?> costAmount,
      Value<String?> costCurrency,
      Value<int> rowid,
    });
typedef $$MaintenanceLogsTableUpdateCompanionBuilder =
    MaintenanceLogsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<DateTime> date,
      Value<String> description,
      Value<double> odometerAtService,
      Value<bool> isSynced,
      Value<String?> resetIntervalId,
      Value<double?> restoreResetKm,
      Value<DateTime?> restoreResetDate,
      Value<String?> photoPaths,
      Value<double?> costAmount,
      Value<String?> costCurrency,
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

  ColumnFilters<double> get odometerAtService => $composableBuilder(
    column: $table.odometerAtService,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resetIntervalId => $composableBuilder(
    column: $table.resetIntervalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get restoreResetKm => $composableBuilder(
    column: $table.restoreResetKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get restoreResetDate => $composableBuilder(
    column: $table.restoreResetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get costAmount => $composableBuilder(
    column: $table.costAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
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

  ColumnOrderings<double> get odometerAtService => $composableBuilder(
    column: $table.odometerAtService,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resetIntervalId => $composableBuilder(
    column: $table.resetIntervalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get restoreResetKm => $composableBuilder(
    column: $table.restoreResetKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get restoreResetDate => $composableBuilder(
    column: $table.restoreResetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get costAmount => $composableBuilder(
    column: $table.costAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
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

  GeneratedColumn<double> get odometerAtService => $composableBuilder(
    column: $table.odometerAtService,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get resetIntervalId => $composableBuilder(
    column: $table.resetIntervalId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get restoreResetKm => $composableBuilder(
    column: $table.restoreResetKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get restoreResetDate => $composableBuilder(
    column: $table.restoreResetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => column,
  );

  GeneratedColumn<double> get costAmount => $composableBuilder(
    column: $table.costAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get costCurrency => $composableBuilder(
    column: $table.costCurrency,
    builder: (column) => column,
  );

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
                Value<double> odometerAtService = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<String?> resetIntervalId = const Value.absent(),
                Value<double?> restoreResetKm = const Value.absent(),
                Value<DateTime?> restoreResetDate = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<double?> costAmount = const Value.absent(),
                Value<String?> costCurrency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion(
                id: id,
                vehicleId: vehicleId,
                date: date,
                description: description,
                odometerAtService: odometerAtService,
                isSynced: isSynced,
                resetIntervalId: resetIntervalId,
                restoreResetKm: restoreResetKm,
                restoreResetDate: restoreResetDate,
                photoPaths: photoPaths,
                costAmount: costAmount,
                costCurrency: costCurrency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required DateTime date,
                required String description,
                Value<double> odometerAtService = const Value.absent(),
                required bool isSynced,
                Value<String?> resetIntervalId = const Value.absent(),
                Value<double?> restoreResetKm = const Value.absent(),
                Value<DateTime?> restoreResetDate = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<double?> costAmount = const Value.absent(),
                Value<String?> costCurrency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceLogsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                date: date,
                description: description,
                odometerAtService: odometerAtService,
                isSynced: isSynced,
                resetIntervalId: resetIntervalId,
                restoreResetKm: restoreResetKm,
                restoreResetDate: restoreResetDate,
                photoPaths: photoPaths,
                costAmount: costAmount,
                costCurrency: costCurrency,
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
typedef $$MaintenanceIntervalsTableCreateCompanionBuilder =
    MaintenanceIntervalsCompanion Function({
      required String id,
      required String vehicleId,
      required String label,
      required int kmInterval,
      Value<int?> monthsInterval,
      Value<String?> description,
      Value<double> lastResetKm,
      Value<DateTime?> lastResetDate,
      Value<bool> isEnabled,
      Value<bool> isCustom,
      Value<int> rowid,
    });
typedef $$MaintenanceIntervalsTableUpdateCompanionBuilder =
    MaintenanceIntervalsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> label,
      Value<int> kmInterval,
      Value<int?> monthsInterval,
      Value<String?> description,
      Value<double> lastResetKm,
      Value<DateTime?> lastResetDate,
      Value<bool> isEnabled,
      Value<bool> isCustom,
      Value<int> rowid,
    });

final class $$MaintenanceIntervalsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $MaintenanceIntervalsTable,
          MaintenanceIntervalEntry
        > {
  $$MaintenanceIntervalsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.maintenanceIntervals.vehicleId, db.vehicles.id),
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
}

class $$MaintenanceIntervalsTableFilterComposer
    extends Composer<_$AppDatabase, $MaintenanceIntervalsTable> {
  $$MaintenanceIntervalsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kmInterval => $composableBuilder(
    column: $table.kmInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthsInterval => $composableBuilder(
    column: $table.monthsInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastResetKm => $composableBuilder(
    column: $table.lastResetKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastResetDate => $composableBuilder(
    column: $table.lastResetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
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

class $$MaintenanceIntervalsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaintenanceIntervalsTable> {
  $$MaintenanceIntervalsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kmInterval => $composableBuilder(
    column: $table.kmInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthsInterval => $composableBuilder(
    column: $table.monthsInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastResetKm => $composableBuilder(
    column: $table.lastResetKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastResetDate => $composableBuilder(
    column: $table.lastResetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
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

class $$MaintenanceIntervalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaintenanceIntervalsTable> {
  $$MaintenanceIntervalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get kmInterval => $composableBuilder(
    column: $table.kmInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthsInterval => $composableBuilder(
    column: $table.monthsInterval,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastResetKm => $composableBuilder(
    column: $table.lastResetKm,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastResetDate => $composableBuilder(
    column: $table.lastResetDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

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

class $$MaintenanceIntervalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaintenanceIntervalsTable,
          MaintenanceIntervalEntry,
          $$MaintenanceIntervalsTableFilterComposer,
          $$MaintenanceIntervalsTableOrderingComposer,
          $$MaintenanceIntervalsTableAnnotationComposer,
          $$MaintenanceIntervalsTableCreateCompanionBuilder,
          $$MaintenanceIntervalsTableUpdateCompanionBuilder,
          (MaintenanceIntervalEntry, $$MaintenanceIntervalsTableReferences),
          MaintenanceIntervalEntry,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$MaintenanceIntervalsTableTableManager(
    _$AppDatabase db,
    $MaintenanceIntervalsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaintenanceIntervalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaintenanceIntervalsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MaintenanceIntervalsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> kmInterval = const Value.absent(),
                Value<int?> monthsInterval = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> lastResetKm = const Value.absent(),
                Value<DateTime?> lastResetDate = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceIntervalsCompanion(
                id: id,
                vehicleId: vehicleId,
                label: label,
                kmInterval: kmInterval,
                monthsInterval: monthsInterval,
                description: description,
                lastResetKm: lastResetKm,
                lastResetDate: lastResetDate,
                isEnabled: isEnabled,
                isCustom: isCustom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String label,
                required int kmInterval,
                Value<int?> monthsInterval = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> lastResetKm = const Value.absent(),
                Value<DateTime?> lastResetDate = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaintenanceIntervalsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                label: label,
                kmInterval: kmInterval,
                monthsInterval: monthsInterval,
                description: description,
                lastResetKm: lastResetKm,
                lastResetDate: lastResetDate,
                isEnabled: isEnabled,
                isCustom: isCustom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaintenanceIntervalsTableReferences(db, table, e),
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
                                referencedTable:
                                    $$MaintenanceIntervalsTableReferences
                                        ._vehicleIdTable(db),
                                referencedColumn:
                                    $$MaintenanceIntervalsTableReferences
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

typedef $$MaintenanceIntervalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaintenanceIntervalsTable,
      MaintenanceIntervalEntry,
      $$MaintenanceIntervalsTableFilterComposer,
      $$MaintenanceIntervalsTableOrderingComposer,
      $$MaintenanceIntervalsTableAnnotationComposer,
      $$MaintenanceIntervalsTableCreateCompanionBuilder,
      $$MaintenanceIntervalsTableUpdateCompanionBuilder,
      (MaintenanceIntervalEntry, $$MaintenanceIntervalsTableReferences),
      MaintenanceIntervalEntry,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$VehicleDocumentsTableCreateCompanionBuilder =
    VehicleDocumentsCompanion Function({
      required String id,
      required String vehicleId,
      required String type,
      required String name,
      required String fileName,
      required String filePath,
      Value<String?> mimeType,
      Value<double?> fileSize,
      Value<String?> notes,
      Value<DateTime?> expiryDate,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$VehicleDocumentsTableUpdateCompanionBuilder =
    VehicleDocumentsCompanion Function({
      Value<String> id,
      Value<String> vehicleId,
      Value<String> type,
      Value<String> name,
      Value<String> fileName,
      Value<String> filePath,
      Value<String?> mimeType,
      Value<double?> fileSize,
      Value<String?> notes,
      Value<DateTime?> expiryDate,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$VehicleDocumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $VehicleDocumentsTable,
          VehicleDocumentEntry
        > {
  $$VehicleDocumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias(
        $_aliasNameGenerator(db.vehicleDocuments.vehicleId, db.vehicles.id),
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
}

class $$VehicleDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $VehicleDocumentsTable> {
  $$VehicleDocumentsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$VehicleDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $VehicleDocumentsTable> {
  $$VehicleDocumentsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
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

class $$VehicleDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehicleDocumentsTable> {
  $$VehicleDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<double> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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

class $$VehicleDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehicleDocumentsTable,
          VehicleDocumentEntry,
          $$VehicleDocumentsTableFilterComposer,
          $$VehicleDocumentsTableOrderingComposer,
          $$VehicleDocumentsTableAnnotationComposer,
          $$VehicleDocumentsTableCreateCompanionBuilder,
          $$VehicleDocumentsTableUpdateCompanionBuilder,
          (VehicleDocumentEntry, $$VehicleDocumentsTableReferences),
          VehicleDocumentEntry,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$VehicleDocumentsTableTableManager(
    _$AppDatabase db,
    $VehicleDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehicleDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehicleDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehicleDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> vehicleId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<double?> fileSize = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehicleDocumentsCompanion(
                id: id,
                vehicleId: vehicleId,
                type: type,
                name: name,
                fileName: fileName,
                filePath: filePath,
                mimeType: mimeType,
                fileSize: fileSize,
                notes: notes,
                expiryDate: expiryDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String vehicleId,
                required String type,
                required String name,
                required String fileName,
                required String filePath,
                Value<String?> mimeType = const Value.absent(),
                Value<double?> fileSize = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime?> expiryDate = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => VehicleDocumentsCompanion.insert(
                id: id,
                vehicleId: vehicleId,
                type: type,
                name: name,
                fileName: fileName,
                filePath: filePath,
                mimeType: mimeType,
                fileSize: fileSize,
                notes: notes,
                expiryDate: expiryDate,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehicleDocumentsTableReferences(db, table, e),
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
                                referencedTable:
                                    $$VehicleDocumentsTableReferences
                                        ._vehicleIdTable(db),
                                referencedColumn:
                                    $$VehicleDocumentsTableReferences
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

typedef $$VehicleDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehicleDocumentsTable,
      VehicleDocumentEntry,
      $$VehicleDocumentsTableFilterComposer,
      $$VehicleDocumentsTableOrderingComposer,
      $$VehicleDocumentsTableAnnotationComposer,
      $$VehicleDocumentsTableCreateCompanionBuilder,
      $$VehicleDocumentsTableUpdateCompanionBuilder,
      (VehicleDocumentEntry, $$VehicleDocumentsTableReferences),
      VehicleDocumentEntry,
      PrefetchHooks Function({bool vehicleId})
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
  $$MaintenanceIntervalsTableTableManager get maintenanceIntervals =>
      $$MaintenanceIntervalsTableTableManager(_db, _db.maintenanceIntervals);
  $$VehicleDocumentsTableTableManager get vehicleDocuments =>
      $$VehicleDocumentsTableTableManager(_db, _db.vehicleDocuments);
}
