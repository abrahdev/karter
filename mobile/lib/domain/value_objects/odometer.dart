import '../enums/distance_unit.dart';
import '../errors/domain_exception.dart';
import '../enums/core_error.dart';

class Odometer {
  final double distance;
  final DistanceUnit unit;

  Odometer(this.distance, this.unit) {
    if (distance < 0) {
      throw DomainException(CoreError.negativeOdometer);
    }
  }

  Odometer add(double value) {
    if (value < 0) {
      throw DomainException(CoreError.negativeOdometer);
    }
    return Odometer(distance + value, unit);
  }

  @override
  String toString() => '$distance $unit';
}