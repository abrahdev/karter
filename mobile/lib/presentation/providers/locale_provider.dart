import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

LocaleNotifier createLocaleNotifier(String initialCode) {
  return LocaleNotifier(initialCode);
}

class LocaleNotifier extends Notifier<Locale> {
  LocaleNotifier([this._rawCode = 'system']);
  String _rawCode;

  static const _key = 'locale';
  static const systemCode = 'system';

  @override
  Locale build() => _resolve(_rawCode);

  bool get isSystem => _rawCode == systemCode;

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
    _rawCode = languageCode;
    state = _resolve(languageCode);
  }

  Locale _resolve(String code) {
    if (code == systemCode) {
      final tag = Platform.localeName;
      return Locale(tag.split('_').first);
    }
    return Locale(code);
  }
}
