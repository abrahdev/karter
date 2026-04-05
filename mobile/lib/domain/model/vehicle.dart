import '../value_objects/plate.dart';
import '../value_objects/vin.dart';
import '../value_objects/odometer.dart';

class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final DateTime createdAt;
  final bool isSynced;

  final Plate plate;
  final Vin vin;
  final Odometer currentOdometer;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.createdAt,
    required this.isSynced,
    required this.plate,
    required this.vin,
    required this.currentOdometer,
  });

  Vehicle copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    int? year,
    DateTime? createdAt,
    bool? isSynced,
    Plate? plate,
    Vin? vin,
    Odometer? currentOdometer,
  }) {
    return Vehicle(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      plate: plate ?? this.plate,
      vin: vin ?? this.vin,
      currentOdometer: currentOdometer ?? this.currentOdometer,
    );
  }
}