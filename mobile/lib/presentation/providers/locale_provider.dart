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
  LocaleNotifier([this._initialCode = 'es']);
  final String _initialCode;

  static const _key = 'locale';

  @override
  Locale build() {
    return Locale(_initialCode);
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
    state = Locale(languageCode);
  }
}
