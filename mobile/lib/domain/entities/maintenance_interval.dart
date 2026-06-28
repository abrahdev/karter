class MaintenanceInterval {
  final String id;
  final String vehicleId;
  final String label;
  final int kmInterval;
  final double lastResetKm;
  final bool isEnabled;
  final bool isCustom;

  MaintenanceInterval({
    required this.id,
    required this.vehicleId,
    required this.label,
    required this.kmInterval,
    this.lastResetKm = 0,
    this.isEnabled = true,
    this.isCustom = false,
  });

  MaintenanceInterval copyWith({
    String? id,
    String? vehicleId,
    String? label,
    int? kmInterval,
    double? lastResetKm,
    bool? isEnabled,
    bool? isCustom,
  }) {
    return MaintenanceInterval(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      label: label ?? this.label,
      kmInterval: kmInterval ?? this.kmInterval,
      lastResetKm: lastResetKm ?? this.lastResetKm,
      isEnabled: isEnabled ?? this.isEnabled,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
