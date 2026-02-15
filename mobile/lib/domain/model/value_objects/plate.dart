class PlatformException {
  final String value;

  PlatformException(this.value) {
    if (value.trim().isEmpty) {
      throw FormatException('La matrícula no puede estar vacía');
    }
  }
}