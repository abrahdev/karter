import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final shakeToOdometerProvider =
    NotifierProvider<ShakeToOdometerNotifier, bool>(ShakeToOdometerNotifier.new);

class ShakeToOdometerNotifier extends Notifier<bool> {
  static const _key = 'shake_to_odometer_enabled';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> toggle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    state = value;
  }
}
