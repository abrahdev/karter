import '../errors/domain_exception.dart';
import '../enums/core_error.dart';

class Vin {
  final String code;

  Vin(String code) : code = code.toUpperCase() {
    if (!_isValid(this.code)) {
      throw DomainException(CoreError.invalidVehicleYear);
    }
  }

  bool _isValid(String code) {
    // VIN estándar: 17 caracteres sin I, O, Q
    if (code.length != 17) return false;

    final invalidChars = RegExp(r'[IOQ]');
    return !invalidChars.hasMatch(code);
  }

  String getManufacturer() {
    return code.substring(0, 3);
  }

  String getVehicleDescription() {
    return code.substring(3, 9);
  }

  String getCheckDigit() {
    return code[8];
  }

  int getModelYear() {
    // To-do: Simplified, implement full decoding logic based on the standard
    final yearCode = code[9];
    return _decodeYear(yearCode);
  }

  String getAssemblyPlant() {
    return code[10];
  }

  String getSerialNumber() {
    return code.substring(11);
  }

  int _decodeYear(String code) {
    const map = {
      'A': 2010,
      'B': 2011,
      'C': 2012,
      'D': 2013,
      'E': 2014,
      'F': 2015,
      'G': 2016,
      'H': 2017,
      'J': 2018,
      'K': 2019,
      'L': 2020,
      'M': 2021,
      'N': 2022,
      'P': 2023,
      'R': 2024,
      'S': 2025,
      'T': 2026,
    };

    return map[code] ?? 0;
  }

  @override
  String toString() => code;
}