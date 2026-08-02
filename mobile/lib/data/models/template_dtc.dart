class TemplateDtc {
  final String code;
  final String scope;
  final String? descI18nKey;
  final String? description;
  final List<String> relatedMaintenance;
  final List<String> relatedParts;
  final bool remove;

  TemplateDtc({
    required this.code,
    required this.scope,
    this.descI18nKey,
    this.description,
    this.relatedMaintenance = const [],
    this.relatedParts = const [],
    this.remove = false,
  });

  factory TemplateDtc.fromJson(Map<String, dynamic> json) => TemplateDtc(
        code: json['code'] as String,
        scope: json['scope'] as String,
        descI18nKey: json['desc_i18n_key'] as String?,
        description: json['description'] as String?,
        relatedMaintenance: (json['related_maintenance'] as List?)
                ?.cast<String>() ??
            const [],
        relatedParts:
            (json['related_parts'] as List?)?.cast<String>() ?? const [],
        remove: json['remove'] as bool? ?? false,
      );
}
