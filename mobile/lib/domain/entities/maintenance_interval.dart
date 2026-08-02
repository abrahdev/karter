class IntervalPart {
  final String partId;
  final String? name;
  final String? i18nKey;
  final String? oemNumber;
  final double quantity;
  final String? unit;
  final String? description;
  final List<String> links;

  IntervalPart({
    required this.partId,
    this.name,
    this.i18nKey,
    this.oemNumber,
    this.quantity = 1,
    this.unit,
    this.description,
    this.links = const [],
  });

  IntervalPart copyWith({
    String? partId,
    String? name,
    String? i18nKey,
    String? oemNumber,
    double? quantity,
    String? unit,
    String? description,
    List<String>? links,
  }) {
    return IntervalPart(
      partId: partId ?? this.partId,
      name: name ?? this.name,
      i18nKey: i18nKey ?? this.i18nKey,
      oemNumber: oemNumber ?? this.oemNumber,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      description: description ?? this.description,
      links: links ?? this.links,
    );
  }

  Map<String, dynamic> toJson() => {
        'partId': partId,
        'name': name,
        'i18nKey': i18nKey,
        'oemNumber': oemNumber,
        'quantity': quantity,
        'unit': unit,
        'description': description,
        'links': links,
      };

  factory IntervalPart.fromJson(Map<String, dynamic> json) => IntervalPart(
        partId: json['partId'] as String,
        name: json['name'] as String?,
        i18nKey: json['i18nKey'] as String?,
        oemNumber: json['oemNumber'] as String?,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        unit: json['unit'] as String?,
        description: json['description'] as String?,
        links: (json['links'] as List?)?.cast<String>() ?? const [],
      );
}

class MaintenanceInterval {
  final String id;
  final String vehicleId;
  final String label;
  final int kmInterval;
  final int? monthsInterval;
  final String? description;
  final double lastResetKm;
  final DateTime? lastResetDate;
  final bool isEnabled;
  final bool isCustom;
  final String? i18nKey;
  final String? descI18nKey;
  final List<IntervalPart> parts;

  MaintenanceInterval({
    required this.id,
    required this.vehicleId,
    required this.label,
    required this.kmInterval,
    this.monthsInterval,
    this.description,
    this.lastResetKm = 0,
    this.lastResetDate,
    this.isEnabled = true,
    this.isCustom = false,
    this.i18nKey,
    this.descI18nKey,
    this.parts = const [],
  });

  MaintenanceInterval copyWith({
    String? id,
    String? vehicleId,
    String? label,
    int? kmInterval,
    int? monthsInterval,
    String? description,
    double? lastResetKm,
    DateTime? lastResetDate,
    bool? isEnabled,
    bool? isCustom,
    String? i18nKey,
    String? descI18nKey,
    List<IntervalPart>? parts,
  }) {
    return MaintenanceInterval(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      label: label ?? this.label,
      kmInterval: kmInterval ?? this.kmInterval,
      monthsInterval: monthsInterval ?? this.monthsInterval,
      description: description ?? this.description,
      lastResetKm: lastResetKm ?? this.lastResetKm,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
      i18nKey: i18nKey ?? this.i18nKey,
      descI18nKey: descI18nKey ?? this.descI18nKey,
      parts: parts ?? this.parts,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'label': label,
        'kmInterval': kmInterval,
        'monthsInterval': monthsInterval,
        'description': description,
        'lastResetKm': lastResetKm,
        'lastResetDate': lastResetDate?.toIso8601String(),
        'isEnabled': isEnabled,
        'isCustom': isCustom,
        'parts': parts.map((p) => p.toJson()).toList(),
      };

  factory MaintenanceInterval.fromJson(Map<String, dynamic> json) =>
      MaintenanceInterval(
        id: json['id'],
        vehicleId: json['vehicleId'],
        label: json['label'],
        kmInterval: json['kmInterval'],
        monthsInterval: json['monthsInterval'],
        description: json['description'],
        lastResetKm: (json['lastResetKm'] as num?)?.toDouble() ?? 0,
        lastResetDate: json['lastResetDate'] != null
            ? DateTime.parse(json['lastResetDate'])
            : null,
        isEnabled: json['isEnabled'] ?? true,
        isCustom: json['isCustom'] ?? false,
        parts: (json['parts'] as List?)
                ?.map((p) => IntervalPart.fromJson(p as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
