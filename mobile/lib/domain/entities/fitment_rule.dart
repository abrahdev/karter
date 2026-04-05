import 'vehicle.dart';

class FitmentRule {
  final String make;
  final String model;
  final int startYear;
  final int endYear;
  final String? requiredEngineCode;

  FitmentRule({
    required this.make,
    required this.model,
    required this.startYear,
    required this.endYear,
    this.requiredEngineCode,
  });

  bool matches(Vehicle vehicle) {
    final yearMatch = vehicle.year >= startYear && vehicle.year <= endYear;
    final makeMatch = vehicle.brand == make;
    final modelMatch = vehicle.model == model;

    final engineMatch = requiredEngineCode == null || vehicle.vin.getVehicleDescription().contains(requiredEngineCode!);

    return yearMatch && makeMatch && modelMatch && engineMatch;
  }
}