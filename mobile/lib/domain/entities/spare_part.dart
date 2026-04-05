import 'fitment_rule.dart';
import 'vehicle.dart';

enum PartCategory {
  FLUIDS,
  BRAKES,
  FILTERS,
  ELECTRONICS,
}

class SparePart {
  final String sku;
  final String name;
  final String brand;
  final PartCategory category;
  final Map<String, String> attributes;
  final List<FitmentRule> fitmentRules;

  SparePart({
    required this.sku,
    required this.name,
    required this.brand,
    required this.category,
    this.attributes = const {},
    this.fitmentRules = const [],
  });

  String? getAttribute(String key) => attributes[key];

  bool isCompatibleWith(Vehicle vehicle) {
    if (fitmentRules.isEmpty) return true; // compatible con todos si no hay reglas
    return fitmentRules.any((rule) => rule.matches(vehicle));
  }
}