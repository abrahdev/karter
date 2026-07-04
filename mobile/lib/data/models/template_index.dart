import 'template_meta.dart';

class TemplateIndexEntry {
  final String id;
  final String path;
  final TemplateMeta meta;
  final int itemCount;
  final List<String> extendsPaths;

  TemplateIndexEntry({
    required this.id,
    required this.path,
    required this.meta,
    required this.itemCount,
    required this.extendsPaths,
  });

  factory TemplateIndexEntry.fromJson(Map<String, dynamic> json) =>
      TemplateIndexEntry(
        id: json['id'] as String,
        path: json['path'] as String,
        meta: TemplateMeta.fromJson(json['meta'] as Map<String, dynamic>),
        itemCount: json['item_count'] as int,
        extendsPaths: (json['extends'] as List?)?.cast<String>() ?? [],
      );
}

class TemplateIndex {
  final List<TemplateIndexEntry> templates;

  TemplateIndex({required this.templates});

  factory TemplateIndex.fromJson(Map<String, dynamic> json) => TemplateIndex(
        templates: (json['templates'] as List)
            .map((e) =>
                TemplateIndexEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
