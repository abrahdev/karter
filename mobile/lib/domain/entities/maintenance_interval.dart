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
    );
  }
}
