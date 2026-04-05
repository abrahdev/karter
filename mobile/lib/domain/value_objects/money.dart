import '../errors/domain_exception.dart';
import '../enums/core_error.dart';

class Money {
  final double amount;
  final String currency;

  Money(double amount, this.currency) : amount = amount {
    if (amount < 0) {
      throw DomainException(CoreError.negativeMoneyAmount);
    }
  }

  Money add(Money other) {
    _ensureSameCurrency(other);
    return Money(amount + other.amount, currency);
  }

  Money multiply(double factor) {
    return Money(amount * factor, currency);
  }

  void _ensureSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Currency mismatch');
    }
  }

  @override
  String toString() => '$amount $currency';
}