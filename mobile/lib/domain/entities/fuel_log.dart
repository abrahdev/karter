import '../enums/distance_unit.dart';
import '../enums/volume_unit.dart';
import '../value_objects/odometer.dart';
import '../value_objects/volume.dart';

class FuelLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final bool isSynced;

  final Volume fueledVolume;
  final Odometer odometerAtFueling;
  final double? pricePerUnit;
  final bool isFullTank;

  FuelLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.isSynced,
    required this.fueledVolume,
    required this.odometerAtFueling,
    this.pricePerUnit,
    this.isFullTank = false,
  });

  FuelLog copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    bool? isSynced,
    Volume? fueledVolume,
    Odometer? odometerAtFueling,
    double? pricePerUnit,
    bool? isFullTank,
  }) {
    return FuelLog(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      isSynced: isSynced ?? this.isSynced,
      fueledVolume: fueledVolume ?? this.fueledVolume,
      odometerAtFueling: odometerAtFueling ?? this.odometerAtFueling,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      isFullTank: isFullTank ?? this.isFullTank,
    );
  }

  double get calculatedConsumption {
    if (odometerAtFueling.distance == 0) return 0;
    final distanceInKm = odometerAtFueling.unit == DistanceUnit.kilometers
        ? odometerAtFueling.distance
        : odometerAtFueling.distance * 1.60934;

    final volumeInLiters = fueledVolume.unit == VolumeUnit.liters
        ? fueledVolume.amount
        : fueledVolume.amount * 3.78541;

    return (volumeInLiters / distanceInKm) * 100;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date.toIso8601String(),
        'isSynced': isSynced,
        'fueledVolumeAmount': fueledVolume.amount,
        'fueledVolumeUnit': fueledVolume.unit.name,
        'odometerAtFuelingDistance': odometerAtFueling.distance,
        'odometerAtFuelingUnit': odometerAtFueling.unit.name,
        'pricePerUnit': pricePerUnit,
        'isFullTank': isFullTank,
      };

  factory FuelLog.fromJson(Map<String, dynamic> json) => FuelLog(
        id: json['id'],
        vehicleId: json['vehicleId'],
        date: DateTime.parse(json['date']),
        isSynced: json['isSynced'],
        fueledVolume: Volume(
          (json['fueledVolumeAmount'] as num).toDouble(),
          VolumeUnit.values.byName(json['fueledVolumeUnit']),
        ),
        odometerAtFueling: Odometer(
          (json['odometerAtFuelingDistance'] as num).toDouble(),
          DistanceUnit.values.byName(json['odometerAtFuelingUnit']),
        ),
        pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble(),
        isFullTank: json['isFullTank'] ?? false,
      );
}