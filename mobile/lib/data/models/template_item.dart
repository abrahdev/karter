class TemplateItem {
  final String id;
  final String? label;
  final String? i18nKey;
  final String? descI18nKey;
  final int? intervalKm;
  final int? intervalMonths;
  final String? description;
  final bool remove;

  TemplateItem({
    required this.id,
    this.label,
    this.i18nKey,
    this.descI18nKey,
    this.intervalKm,
    this.intervalMonths,
    this.description,
    this.remove = false,
  });

  factory TemplateItem.fromJson(Map<String, dynamic> json) => TemplateItem(
        id: json['id'] as String,
        label: json['label'] as String?,
        i18nKey: json['i18n_key'] as String?,
        descI18nKey: json['desc_i18n_key'] as String?,
        intervalKm: json['interval_km'] as int?,
        intervalMonths: json.containsKey('interval_months')
            ? json['interval_months'] as int?
            : null,
        description: json['description'] as String?,
        remove: json['remove'] as bool? ?? false,
      );
}
