String formatPartLine({
  required String name,
  required String formattedQuantity,
  required String unitLabel,
}) {
  if (unitLabel.isEmpty) {
    if (formattedQuantity == '1') return name;
    return '$name \u00d7 $formattedQuantity';
  }
  return '$name \u00d7 $formattedQuantity $unitLabel';
}
