import '../value_objects/money.dart';

class ReplacedPart {
  final String sparePartId;
  final int quantity;
  final Money unitPrice;

  ReplacedPart({
    required this.sparePartId,
    required this.quantity,
    required this.unitPrice,
  });

  Money getTotal() {
    return unitPrice.multiply(quantity.toDouble());
  }
}