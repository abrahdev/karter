import 'dart:convert';

List<String> decodePaths(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  try {
    return (jsonDecode(raw) as List).cast<String>();
  } catch (_) {
    return [];
  }
}

String? encodePaths(List<String> paths) {
  if (paths.isEmpty) return null;
  return jsonEncode(paths);
}
