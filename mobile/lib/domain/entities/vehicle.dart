import '../enums/distance_unit.dart';
import '../enums/vehicle_type.dart';
import '../value_objects/odometer.dart';
import '../value_objects/plate.dart';
import '../value_objects/vin.dart';

class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String? alias;
  final DateTime createdAt;
  final bool isSynced;
  final VehicleType type;

  final Plate plate;
  final Vin vin;
  final Odometer currentOdometer;

  Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.createdAt,
    required this.isSynced,
    required this.plate,
    required this.vin,
    required this.currentOdometer,
    this.alias,
    this.type = VehicleType.combustion,
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
    String? alias,
    DateTime? createdAt,
    bool? isSynced,
    Plate? plate,
    Vin? vin,
    Odometer? currentOdometer,
    VehicleType? type,
  }) {
    return Vehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      alias: alias ?? this.alias,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      type: type ?? this.type,
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
        'plate': plate.value,
        'vin': vin.code,
        'currentOdometerDistance': currentOdometer.distance,
        'currentOdometerUnit': currentOdometer.unit.name,
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
        plate: Plate(json['plate']),
        vin: Vin(json['vin']),
        currentOdometer: Odometer(
          (json['currentOdometerDistance'] as num).toDouble(),
          DistanceUnit.values.byName(json['currentOdometerUnit']),
        ),
      );
}