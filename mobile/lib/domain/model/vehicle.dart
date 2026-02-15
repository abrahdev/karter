// lib/domain/models/vehicle.dart

class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final String plate;
  final double currentDistance;
  final DateTime createdAt;
  
  final bool isSynced;

  Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    this.plate = '',
    this.currentDistance = 0,
    required this.createdAt,
    this.isSynced = false,
  });

  Vehicle copyWith({
    double? currentDistance,
    bool? isSynced,
  }) {
    return Vehicle(
      id: id,
      name: name,
      brand: brand,
      model: model,
      year: year,
      plate: plate,
      currentDistance: currentDistance ?? this.currentDistance,
      createdAt: createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}