class TemplatePart {
  final String id;
  final String? name;
  final String? i18nKey;
  final String? oemNumber;
  final double? quantity;
  final String? unit;
  final String? userReference;
  final String? description;
  final bool remove;

  TemplatePart({
    required this.id,
    this.name,
    this.i18nKey,
    this.oemNumber,
    this.quantity,
    this.unit,
    this.userReference,
    this.description,
    this.remove = false,
  });

  factory TemplatePart.fromJson(Map<String, dynamic> json) => TemplatePart(
        id: json['id'] as String,
        name: json['name'] as String?,
        i18nKey: json['i18n_key'] as String?,
        oemNumber: json['oem_number'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble(),
        unit: json['unit'] as String?,
        userReference: json['user_reference'] as String?,
        description: json['description'] as String?,
        remove: json['remove'] as bool? ?? false,
      );
}
