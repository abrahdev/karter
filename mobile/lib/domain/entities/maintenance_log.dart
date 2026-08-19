class MaintenanceLog {
  final String id;
  final String vehicleId;
  final DateTime date;
  final String description;
  final double odometerAtService;
  final bool isSynced;
  final String? resetIntervalId;
  final double? restoreResetKm;
  final DateTime? restoreResetDate;

  final List<String> photoPaths;
  final double? costAmount;
  final String? costCurrency;

  MaintenanceLog({
    required this.id,
    required this.vehicleId,
    required this.date,
    required this.description,
    required this.isSynced,
    this.odometerAtService = 0,
    this.resetIntervalId,
    this.restoreResetKm,
    this.restoreResetDate,
    this.photoPaths = const [],
    this.costAmount,
    this.costCurrency,
  });

  MaintenanceLog copyWith({
    String? id,
    String? vehicleId,
    DateTime? date,
    String? description,
    double? odometerAtService,
    bool? isSynced,
    String? resetIntervalId,
    double? restoreResetKm,
    DateTime? restoreResetDate,
    List<String>? photoPaths,
    double? costAmount,
    String? costCurrency,
  }) {
    return MaintenanceLog(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      date: date ?? this.date,
      description: description ?? this.description,
      odometerAtService: odometerAtService ?? this.odometerAtService,
      isSynced: isSynced ?? this.isSynced,
      resetIntervalId: resetIntervalId ?? this.resetIntervalId,
      restoreResetKm: restoreResetKm ?? this.restoreResetKm,
      restoreResetDate: restoreResetDate ?? this.restoreResetDate,
      photoPaths: photoPaths ?? this.photoPaths,
      costAmount: costAmount ?? this.costAmount,
      costCurrency: costCurrency ?? this.costCurrency,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicleId': vehicleId,
        'date': date.toIso8601String(),
        'description': description,
        'odometerAtService': odometerAtService,
        'isSynced': isSynced,
        'resetIntervalId': resetIntervalId,
        'restoreResetKm': restoreResetKm,
        'restoreResetDate': restoreResetDate?.toIso8601String(),
        'photoPaths': photoPaths,
        'costAmount': costAmount,
        'costCurrency': costCurrency,
      };

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) =>
      MaintenanceLog(
        id: json['id'],
        vehicleId: json['vehicleId'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        odometerAtService: (json['odometerAtService'] as num?)?.toDouble() ?? 0,
        isSynced: json['isSynced'],
        resetIntervalId: json['resetIntervalId'],
        restoreResetKm: (json['restoreResetKm'] as num?)?.toDouble(),
        restoreResetDate: json['restoreResetDate'] != null
            ? DateTime.parse(json['restoreResetDate'])
            : null,
        photoPaths: (json['photoPaths'] as List?)?.cast<String>() ?? const [],
        costAmount: (json['costAmount'] as num?)?.toDouble(),
        costCurrency: json['costCurrency'],
      );
}
