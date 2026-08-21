import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TemplateTranslations {
  TemplateTranslations._();

  static final Map<String, Map<String, String>> _cache = {};
  static String? _baseUrl;

  static Future<void> preload({String? baseUrl, String locale = 'en'}) async {
    _baseUrl = baseUrl;
    await _loadBundledCached(locale);
    if (baseUrl != null && baseUrl.isNotEmpty) {
      unawaited(_loadRemote(locale, baseUrl));
    }
  }

  static Future<void> ensureLocale(String locale) async {
    await _loadBundledCached(locale);
    final baseUrl = _baseUrl;
    if (baseUrl != null && baseUrl.isNotEmpty) {
      unawaited(_loadRemote(locale, baseUrl));
    }
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

  static Future<void> _loadBundledCached(String locale) async {
    if (_cache.containsKey(locale)) return;
    final result = await _loadBundled(locale);
    _cache['|$locale'] = result;
    _cache[locale] = result;
  }

  static Future<void> _loadRemote(String locale, String baseUrl) async {
    final cacheKey = '$baseUrl|$locale';
    if (_cache.containsKey(cacheKey)) return;
    try {
      final uri = Uri.parse('$baseUrl/i18n/$locale.json');
      final resp = await http.get(uri).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final result = Map<String, String>.from(json.decode(resp.body));
        _cache[cacheKey] = result;
        _cache[locale] = result;
      }
    } catch (_) {}
  }

  static Future<Map<String, String>> _loadBundled(String locale) async {
    final data = await rootBundle.loadString('i18n/$locale.json');
    return Map<String, String>.from(json.decode(data));
  }
}
