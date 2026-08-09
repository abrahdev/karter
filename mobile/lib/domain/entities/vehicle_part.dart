class VehiclePart {
  final String id;
  final String name;
  final String? partId;
  final double quantity;
  final String? unit;
  final String? oemNumber;
  final String? description;
  final List<String> links;
  final DateTime createdAt;

  VehiclePart({
    required this.id,
    required this.name,
    this.partId,
    this.quantity = 1,
    this.unit,
    this.oemNumber,
    this.description,
    this.links = const [],
    required this.createdAt,
  });

  VehiclePart copyWith({
    String? id,
    String? name,
    String? partId,
    double? quantity,
    String? unit,
    String? oemNumber,
    String? description,
    List<String>? links,
    DateTime? createdAt,
  }) {
    return VehiclePart(
      id: id ?? this.id,
      name: name ?? this.name,
      partId: partId ?? this.partId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      oemNumber: oemNumber ?? this.oemNumber,
      description: description ?? this.description,
      links: links ?? this.links,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'partId': partId,
        'quantity': quantity,
        'unit': unit,
        'oemNumber': oemNumber,
        'description': description,
        'links': links,
        'createdAt': createdAt.toIso8601String(),
      };

  factory VehiclePart.fromJson(Map<String, dynamic> json) => VehiclePart(
        id: json['id'],
        name: json['name'],
        partId: json['partId'],
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
        unit: json['unit'],
        oemNumber: json['oemNumber'],
        description: json['description'],
        links: (json['links'] as List?)?.cast<String>() ?? const [],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
