import '../enums/volume_unit.dart';

class Volume {
  final double amount;
  final VolumeUnit unit;

  Volume(this.amount, this.unit) {
    if (amount < 0) {
      throw ArgumentError('Volume cannot be negative');
    }
  }

  Volume add(Volume other) {
    if (unit != other.unit) {
      throw ArgumentError('Volume unit mismatch');
    }
    return Volume(amount + other.amount, unit);
  }

  @override
  String toString() => '$amount $unit';
}