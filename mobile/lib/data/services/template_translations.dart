import 'dart:convert';

import 'package:flutter/services.dart';

class TemplateTranslations {
  TemplateTranslations._();

  static final Map<String, Map<String, String>> _cache = {};

  static Future<void> preload() async {
    await Future.wait([_load('en'), _load('es')]);
  }

  static String getLabel(String locale, String key, String fallback) {
    final map = _cache[locale] ?? _cache['en'];
    if (map == null) return fallback;
    return map[key] ?? fallback;
  }

  static String getDesc(String locale, String key, String fallback) {
    final map = _cache[locale] ?? _cache['en'];
    if (map == null) return fallback;
    return map[key] ?? fallback;
  }

  static Future<Map<String, String>> _load(String locale) async {
    if (_cache.containsKey(locale)) return _cache[locale]!;
    final data = await rootBundle.loadString('i18n/$locale.json');
    final map = Map<String, String>.from(json.decode(data));
    _cache[locale] = map;
    return map;
  }
}
