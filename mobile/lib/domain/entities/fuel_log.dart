import '../value_objects/odometer.dart';
import '../value_objects/volume.dart';
import '../enums/distance_unit.dart';
import '../enums/volume_unit.dart';

class FuelLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final bool isSynced;

  final Volume fueledVolume;
  final Odometer odometerAtFueling;

  FuelLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.isSynced,
    required this.fueledVolume,
    required this.odometerAtFueling,
  });

  double get calculatedConsumption {
    // Consumption is calculated as (volume / distance) * 100 to get liters per 100km
    if (odometerAtFueling.distance == 0) return 0;
    final distanceInKm = odometerAtFueling.unit == DistanceUnit.kilometers
        ? odometerAtFueling.distance
        : odometerAtFueling.distance * 1.60934;

    final volumeInLiters = fueledVolume.unit == VolumeUnit.liters
        ? fueledVolume.amount
        : fueledVolume.amount * 3.78541;

    return (volumeInLiters / distanceInKm) * 100;
  }
}