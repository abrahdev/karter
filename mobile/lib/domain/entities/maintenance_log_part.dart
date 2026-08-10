class MaintenanceLogPart {
  final String id;
  final String logId;
  final String? partId;
  final String name;
  final double quantity;
  final String? unit;
  final String? oemNumber;
  final String? description;
  final List<String> links;

  MaintenanceLogPart({
    required this.id,
    required this.logId,
    this.partId,
    required this.name,
    this.quantity = 1,
    this.unit,
    this.oemNumber,
    this.description,
    this.links = const [],
  });

  MaintenanceLogPart copyWith({
    String? id,
    String? logId,
    String? partId,
    String? name,
    double? quantity,
    String? unit,
    String? oemNumber,
    String? description,
    List<String>? links,
  }) {
    return MaintenanceLogPart(
      id: id ?? this.id,
      logId: logId ?? this.logId,
      partId: partId ?? this.partId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      oemNumber: oemNumber ?? this.oemNumber,
      description: description ?? this.description,
      links: links ?? this.links,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'logId': logId,
        'partId': partId,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'oemNumber': oemNumber,
        'description': description,
        'links': links,
      };

  factory MaintenanceLogPart.fromJson(Map<String, dynamic> json) =>
      MaintenanceLogPart(
        id: json['id'],
        logId: json['logId'],
        partId: json['partId'],
        name: json['name'],
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        unit: json['unit'],
        oemNumber: json['oemNumber'],
        description: json['description'],
        links: (json['links'] as List?)?.cast<String>() ?? const [],
      );
}
