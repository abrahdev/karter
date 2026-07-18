import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _defaultColor = Colors.amber;

class SeedColorState {
  const SeedColorState(this.customArgb, {this.useCustom = false});

  final int? customArgb;
  final bool useCustom;

  Color get color => customArgb != null ? Color(customArgb!) : _defaultColor;
}

final seedColorProvider =
    NotifierProvider<SeedColorNotifier, SeedColorState>(SeedColorNotifier.new);

class SeedColorNotifier extends Notifier<SeedColorState> {
  static const _key = 'seed_color_custom';
  static const _keyUseCustom = 'seed_color_use_custom';

  @override
  SeedColorState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final customArgb = prefs.getInt(_key);
    final useCustom = prefs.getBool(_keyUseCustom) ?? false;
    return SeedColorState(customArgb, useCustom: useCustom);
  }

  Future<void> setColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, color.toARGB32());
    state = SeedColorState(color.toARGB32(), useCustom: true);
  }

  Future<void> resetColor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = const SeedColorState(null, useCustom: false);
  }

  Future<void> setUseCustom(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyUseCustom, value);
    state = SeedColorState(state.customArgb, useCustom: value);
  }
}
