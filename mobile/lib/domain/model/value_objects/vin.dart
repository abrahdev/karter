class Vin {
  final String value;

  Vin(this.value) {
    if (value.trim().isEmpty) {
      throw FormatException('El VIN no puede estar vacío');
    }
    if (value.length != 17) {
      throw FormatException('El VIN debe tener exactamente 17 caracteres');
    }
    if (!RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(value)) {
      throw FormatException('El VIN contiene caracteres inválidos');
    }
  }
}