import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final hapticProvider = NotifierProvider<HapticNotifier, bool>(HapticNotifier.new);

class HapticNotifier extends Notifier<bool> {
  static const _key = 'haptic_enabled';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? true;

  Future<void> toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    state = value;
  }

  void vibrate() {
    if (state) HapticFeedback.lightImpact();
  }
}
