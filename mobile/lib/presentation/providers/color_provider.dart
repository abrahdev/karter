import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _colorPresets = <String, Color>{
  'dynamic': Colors.transparent,
  'amber': Colors.amber,
  'teal': Colors.teal,
  'blue': Colors.blue,
  'purple': Colors.purple,
  'green': Colors.green,
};

class SeedColorState {
  const SeedColorState(this.name, [this.customArgb]);
  final String name;
  final int? customArgb;

  Color resolve(Color systemAccent) {
    if (name == SeedColorNotifier.customKey && customArgb != null) {
      return Color(customArgb!);
    }
    if (name == 'dynamic') return systemAccent;
    return _colorPresets[name] ?? Colors.amber;
  }
}

final seedColorProvider =
    NotifierProvider<SeedColorNotifier, SeedColorState>(SeedColorNotifier.new);

class SeedColorNotifier extends Notifier<SeedColorState> {
  static const _key = 'seed_color';
  static const customKey = 'custom';

  @override
  SeedColorState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final name = prefs.getString(_key) ?? 'dynamic';
    final customArgb = prefs.getInt('${_key}_custom');
    return SeedColorState(name, customArgb);
  }

  static List<String> get presetNames => _colorPresets.keys.toList();

  static String labelFor(String name) => name[0].toUpperCase() + name.substring(1);

  Future<void> setColor(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, name);
    state = SeedColorState(name, state.customArgb);
  }

  Future<void> setCustomColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, customKey);
    await prefs.setInt('${_key}_custom', color.toARGB32());
    state = SeedColorState(customKey, color.toARGB32());
  }
}
