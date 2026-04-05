import '../enums/core_error.dart';

class DomainException implements Exception {
  final CoreError error;

  DomainException(this.error);

  @override
  String toString() => 'DomainException: $error';
}