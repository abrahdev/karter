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
      );
}
