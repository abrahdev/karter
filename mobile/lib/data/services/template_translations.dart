import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TemplateTranslations {
  TemplateTranslations._();

  static final Map<String, Map<String, String>> _cache = {};

  static Future<void> preload({String? baseUrl}) async {
    await Future.wait([
      _load('en', baseUrl: baseUrl),
      _load('es', baseUrl: baseUrl),
    ]);
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

  static Future<Map<String, String>> _load(String locale, {String? baseUrl}) async {
    final cacheKey = '${baseUrl ?? ''}|$locale';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    Map<String, String>? result;

    if (baseUrl != null && baseUrl.isNotEmpty) {
      try {
        final uri = Uri.parse('$baseUrl/i18n/$locale.json');
        final resp = await http.get(uri).timeout(const Duration(seconds: 10));
        if (resp.statusCode == 200) {
          result = Map<String, String>.from(json.decode(resp.body));
        }
      } catch (_) {}
    }

    result ??= await _loadBundled(locale);

    _cache[cacheKey] = result;
    _cache[locale] = result;
    return result;
  }

  static Future<Map<String, String>> _loadBundled(String locale) async {
    final data = await rootBundle.loadString('i18n/$locale.json');
    return Map<String, String>.from(json.decode(data));
  }
}
