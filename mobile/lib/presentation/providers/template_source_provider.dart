import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('override sharedPreferencesProvider in main');
});

class TemplateSourceConfig {
  final bool enabled;
  final String repoUrl;

  const TemplateSourceConfig({
    this.enabled = true,
    this.repoUrl = TemplateSourceConfig.defaultRepoUrl,
  });

  static const defaultRepoUrl =
      'https://raw.githubusercontent.com/abrahdev/karter/main/templates';
  static const _enabledKey = 'template_source_enabled';
  static const _urlKey = 'template_source_url';

  TemplateSourceConfig copyWith({bool? enabled, String? repoUrl}) {
    return TemplateSourceConfig(
      enabled: enabled ?? this.enabled,
      repoUrl: repoUrl ?? this.repoUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        _enabledKey: enabled,
        _urlKey: repoUrl,
      };

  factory TemplateSourceConfig.fromPrefs(SharedPreferences prefs) {
    return TemplateSourceConfig(
      enabled: prefs.getBool(_enabledKey) ?? true,
      repoUrl: prefs.getString(_urlKey) ?? defaultRepoUrl,
    );
  }
}

final templateSourceProvider =
    NotifierProvider<TemplateSourceNotifier, TemplateSourceConfig>(
  TemplateSourceNotifier.new,
);

class TemplateSourceNotifier extends Notifier<TemplateSourceConfig> {
  @override
  TemplateSourceConfig build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return TemplateSourceConfig.fromPrefs(prefs);
  }

  Future<void> _save(TemplateSourceConfig cfg) async {
    final p = ref.read(sharedPreferencesProvider);
    await p.setBool(TemplateSourceConfig._enabledKey, cfg.enabled);
    await p.setString(TemplateSourceConfig._urlKey, cfg.repoUrl);
    state = cfg;
  }

  Future<void> setEnabled(bool value) async {
    await _save(state.copyWith(enabled: value));
  }

  Future<void> setRepoUrl(String url) async {
    await _save(state.copyWith(repoUrl: url));
  }

  Future<void> resetToDefault() async {
    await _save(
      state.copyWith(repoUrl: TemplateSourceConfig.defaultRepoUrl),
    );
  }
}
