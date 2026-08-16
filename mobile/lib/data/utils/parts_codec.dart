import 'dart:convert';

import 'package:mobile/domain/entities/maintenance_interval.dart';

String? encodeParts(List<IntervalPart> parts) {
  if (parts.isEmpty) return null;
  return jsonEncode(parts.map((p) => p.toJson()).toList());
}

List<IntervalPart> decodeParts(String? json) {
  if (json == null || json.isEmpty) return const [];
  try {
    final raw = jsonDecode(json) as List;
    return raw
        .map((e) => IntervalPart.fromJson(e as Map<String, dynamic>))
        .toList();
  } catch (_) {
    return const [];
  }
}
