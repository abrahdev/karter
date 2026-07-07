import '../enums/distance_unit.dart';
import '../enums/vehicle_type.dart';
import '../enums/volume_unit.dart';
import '../value_objects/odometer.dart';
import '../value_objects/plate.dart';
import '../value_objects/vin.dart';

class _Sentinel {
  const _Sentinel();
}

class Vehicle {
  static const _sentinel = _Sentinel();

  final String id;
  final String brand;
  final String model;
  final int year;
  final String? alias;
  final DateTime createdAt;
  final bool isSynced;
  final VehicleType type;

  final Plate? plate;
  final Vin? vin;
  final Odometer currentOdometer;
  final VolumeUnit fuelVolumeUnit;
  final String currency;
  final int? odometerReminderFreqDays;
  final DateTime? odometerReminderLastNotified;
  final bool maintenanceReminderEnabled;
  final DateTime? maintenanceReminderSnoozedUntil;

  static const List<String> currencies = [
    'USD', 'ARS', 'EUR', 'GBP', 'BRL', 'CLP', 'COP', 'MXN', 'PEN', 'UYU',
  ];

  static String currencySymbol(String code) {
    switch (code) {
      case 'USD': return '\$';
      case 'ARS': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'BRL': return 'R\$';
      case 'CLP': return '\$';
      case 'COP': return '\$';
      case 'MXN': return '\$';
      case 'PEN': return 'S/';
      case 'UYU': return '\$U';
      default: return '\$';
    }
  }

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.createdAt,
    required this.isSynced,
    this.plate,
    this.vin,
    required this.currentOdometer,
    this.alias,
    this.type = VehicleType.combustion,
    this.fuelVolumeUnit = VolumeUnit.liters,
    this.currency = 'USD',
    this.odometerReminderFreqDays,
    this.odometerReminderLastNotified,
    this.maintenanceReminderEnabled = true,
    this.maintenanceReminderSnoozedUntil,
  });

  String get displayName {
    if (alias != null && alias!.isNotEmpty) return alias!;
    return '$brand $model $year';
  }

  Vehicle copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    Object? alias = _sentinel,
    DateTime? createdAt,
    bool? isSynced,
    Object? plate = _sentinel,
    Object? vin = _sentinel,
    Odometer? currentOdometer,
    VehicleType? type,
    VolumeUnit? fuelVolumeUnit,
    String? currency,
    Object? odometerReminderFreqDays = _sentinel,
    Object? odometerReminderLastNotified = _sentinel,
    bool? maintenanceReminderEnabled,
    Object? maintenanceReminderSnoozedUntil = _sentinel,
  }) {
    return Vehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      alias: identical(alias, _sentinel) ? this.alias : alias as String?,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      plate: identical(plate, _sentinel) ? this.plate : plate as Plate?,
      vin: identical(vin, _sentinel) ? this.vin : vin as Vin?,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      type: type ?? this.type,
      fuelVolumeUnit: fuelVolumeUnit ?? this.fuelVolumeUnit,
      currency: currency ?? this.currency,
      odometerReminderFreqDays: identical(odometerReminderFreqDays, _sentinel)
          ? this.odometerReminderFreqDays
          : odometerReminderFreqDays as int?,
      odometerReminderLastNotified:
          identical(odometerReminderLastNotified, _sentinel)
              ? this.odometerReminderLastNotified
              : odometerReminderLastNotified as DateTime?,
      maintenanceReminderEnabled:
          maintenanceReminderEnabled ?? this.maintenanceReminderEnabled,
      maintenanceReminderSnoozedUntil:
          identical(maintenanceReminderSnoozedUntil, _sentinel)
              ? this.maintenanceReminderSnoozedUntil
              : maintenanceReminderSnoozedUntil as DateTime?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
        'year': year,
        'alias': alias,
        'createdAt': createdAt.toIso8601String(),
        'isSynced': isSynced,
        'type': type.name,
        'plate': plate?.value,
        'vin': vin?.code,
        'currentOdometerDistance': currentOdometer.distance,
        'currentOdometerUnit': currentOdometer.unit.name,
        'fuelVolumeUnit': fuelVolumeUnit.name,
        'currency': currency,
        'odometerReminderFreqDays': odometerReminderFreqDays,
        'odometerReminderLastNotified':
            odometerReminderLastNotified?.toIso8601String(),
        'maintenanceReminderEnabled': maintenanceReminderEnabled,
        'maintenanceReminderSnoozedUntil':
            maintenanceReminderSnoozedUntil?.toIso8601String(),
      };

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'],
        brand: json['brand'],
        model: json['model'],
        year: json['year'],
        alias: json['alias'],
        createdAt: DateTime.parse(json['createdAt']),
        isSynced: json['isSynced'],
        type: VehicleType.values.byName(json['type']),
        plate: json['plate'] != null ? Plate(json['plate']) : null,
        vin: json['vin'] != null ? Vin(json['vin']) : null,
        currentOdometer: Odometer(
          (json['currentOdometerDistance'] as num).toDouble(),
          DistanceUnit.values.byName(json['currentOdometerUnit']),
        ),
        fuelVolumeUnit: json['fuelVolumeUnit'] != null
            ? VolumeUnit.values.byName(json['fuelVolumeUnit'])
            : VolumeUnit.liters,
        currency: json['currency'] ?? 'USD',
        odometerReminderFreqDays: json['odometerReminderFreqDays'] as int?,
        odometerReminderLastNotified:
            json['odometerReminderLastNotified'] != null
                ? DateTime.parse(json['odometerReminderLastNotified'])
                : null,
        maintenanceReminderEnabled:
            json['maintenanceReminderEnabled'] ?? true,
        maintenanceReminderSnoozedUntil:
            json['maintenanceReminderSnoozedUntil'] != null
                ? DateTime.parse(json['maintenanceReminderSnoozedUntil'])
                : null,
      );
}