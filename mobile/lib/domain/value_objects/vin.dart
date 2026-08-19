import '../errors/domain_exception.dart';
import '../enums/core_error.dart';

class Vin {
  final String code;

  Vin(String code) : code = code.toUpperCase() {
    if (!_isValid(this.code)) {
      throw DomainException(CoreError.invalidVinFormat);
    }
  }

  Vin._(this.code);

  factory Vin.nullable(String? code) => Vin._((code ?? '').toUpperCase());

  bool _isValid(String code) {
    if (code.isEmpty) return true;
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
    const yearCodes = {
      'A': 1980, 'B': 1981, 'C': 1982, 'D': 1983, 'E': 1984,
      'F': 1985, 'G': 1986, 'H': 1987, 'J': 1988, 'K': 1989,
      'L': 1990, 'M': 1991, 'N': 1992, 'P': 1993, 'R': 1994,
      'S': 1995, 'T': 1996, 'V': 1997, 'W': 1998, 'X': 1999,
      'Y': 2000, '1': 2001, '2': 2002, '3': 2003, '4': 2004,
      '5': 2005, '6': 2006, '7': 2007, '8': 2008, '9': 2009,
    };

    final baseYear = yearCodes[code];
    if (baseYear == null) return 0;

    final currentYear = DateTime.now().year;
    final cycle = ((currentYear - baseYear) ~/ 30) * 30;
    return baseYear + cycle;
  }

  @override
  String toString() => code;
}