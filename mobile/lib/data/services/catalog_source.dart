enum CatalogSourceKind { builtin, online, local }

class CatalogSource {
  const CatalogSource({
    required this.id,
    required this.name,
    required this.kind,
    required this.filePath,
  });

  final String id;
  final String name;
  final CatalogSourceKind kind;

  /// Path relative to the app documents directory.
  final String filePath;

  bool get deletable => kind == CatalogSourceKind.local;
  bool get isBuiltin => kind == CatalogSourceKind.builtin;
  bool get isOnline => kind == CatalogSourceKind.online;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kind': kind.name,
        'filePath': filePath,
      };

  factory CatalogSource.fromJson(Map<String, dynamic> json) => CatalogSource(
        id: json['id'] as String,
        name: json['name'] as String,
        kind: CatalogSourceKind.values.byName(json['kind'] as String),
        filePath: json['filePath'] as String,
      );
}