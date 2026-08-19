import '../errors/domain_exception.dart';
import '../enums/core_error.dart';

class Plate {
  final String value;

  Plate(String value) : value = value.toUpperCase() {
    if (value.isEmpty) {
      throw DomainException(CoreError.emptyLicensePlate);
    }

    if (!_isValid(value)) {
      throw DomainException(CoreError.invalidLicensePlateFormat);
    }
  }

  Plate._(this.value);

  factory Plate.nullable(String? value) => Plate._((value ?? '').toUpperCase());

  bool _isValid(String value) {
    if (value.length < 2 || value.length > 10) return false;
    final validChars = RegExp(r'^[A-Z0-9\s\-]+$');
    return validChars.hasMatch(value);
  }

  String getValue() => value;

  String getCountryCode() {
    if (value.contains('-')) {
      return value.split('-').first;
    }
    return 'UNKNOWN';
  }
}