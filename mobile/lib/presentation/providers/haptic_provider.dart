import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HapticMode { off, clear, rich }

final hapticProvider = NotifierProvider<HapticNotifier, HapticMode>(
  HapticNotifier.new,
);

class HapticNotifier extends Notifier<HapticMode> {
  static const _key = 'haptic_mode';

  @override
  HapticMode build() {
    final value = ref.watch(sharedPreferencesProvider).getString(_key);
    return HapticMode.values.asNameMap()[value] ?? HapticMode.clear;
  }

  Future<void> setMode(HapticMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
    state = mode;
  }

  bool get enabled => state != HapticMode.off;

  void lightTap() {
    if (state == HapticMode.off) return;
    HapticFeedback.lightImpact();
  }

  void mediumTap() {
    if (state == HapticMode.off) return;
    HapticFeedback.mediumImpact();
  }

  void heavyTap() {
    if (state == HapticMode.off) return;
    HapticFeedback.heavyImpact();
  }

  void success() {
    if (state == HapticMode.off) return;
    if (state == HapticMode.rich) {
      HapticFeedback.mediumImpact();
      Future.delayed(const Duration(milliseconds: 60), () => HapticFeedback.lightImpact());
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void warning() {
    if (state == HapticMode.off) return;
    if (state == HapticMode.rich) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 80), () => HapticFeedback.mediumImpact());
      Future.delayed(const Duration(milliseconds: 160), () => HapticFeedback.lightImpact());
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void delete() {
    if (state == HapticMode.off) return;
    if (state == HapticMode.rich) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 100), () => HapticFeedback.heavyImpact());
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void selectionTap() {
    if (state == HapticMode.off) return;
    HapticFeedback.selectionClick();
  }

  void vibrate() {
    if (state == HapticMode.off) return;
    HapticFeedback.lightImpact();
  }
}
