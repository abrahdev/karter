import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

ThemeModeNotifier createThemeModeNotifier(ThemeMode initial) {
  return ThemeModeNotifier(initial);
}

class ThemeModeNotifier extends Notifier<ThemeMode> {
  ThemeModeNotifier([this._initial = ThemeMode.system]);
  final ThemeMode _initial;

  static const _key = 'theme_mode';

  @override
  ThemeMode build() => _initial;

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
    state = mode;
  }

  static ThemeMode fromName(String? name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
