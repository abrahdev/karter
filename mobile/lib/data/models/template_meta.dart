class EngineMeta {
  final String? code;
  final String? fuel;
  final int? displacementCc;
  final int? powerHp;

  EngineMeta({
    this.code,
    this.fuel,
    this.displacementCc,
    this.powerHp,
  });

  factory EngineMeta.fromJson(Map<String, dynamic> json) => EngineMeta(
        code: json['code'] as String?,
        fuel: json['fuel'] as String?,
        displacementCc: json['displacement_cc'] as int?,
        powerHp: json['power_hp'] as int?,
      );
}

class TemplateMeta {
  final String make;
  final String model;
  final String? generation;
  final List<int>? years;
  final EngineMeta? engine;
  final String author;
  final String version;
  final List<String>? market;
  final List<String>? sources;

  TemplateMeta({
    required this.make,
    required this.model,
    this.generation,
    this.years,
    this.engine,
    required this.author,
    required this.version,
    this.market,
    this.sources,
  });

  factory TemplateMeta.fromJson(Map<String, dynamic> json) => TemplateMeta(
        make: json['make'] as String,
        model: json['model'] as String,
        generation: json['generation'] as String?,
        years: json['years'] != null
            ? (json['years'] as List).cast<int>()
            : null,
        engine: json['engine'] != null
            ? EngineMeta.fromJson(json['engine'] as Map<String, dynamic>)
            : null,
        author: json['author'] as String,
        version: json['version'] as String,
        market: (json['market'] as List?)?.cast<String>(),
        sources: (json['sources'] as List?)?.cast<String>(),
      );
}
