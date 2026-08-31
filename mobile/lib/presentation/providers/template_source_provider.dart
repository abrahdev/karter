import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('override sharedPreferencesProvider in main');
});

class TemplateSourceConfig {
  final bool enabled;
  final String repoUrl;
  final String version;

  const TemplateSourceConfig({
    this.enabled = true,
    this.repoUrl = TemplateSourceConfig.defaultRepoUrl,
    this.version = '',
  });

  static const defaultRepoUrl =
      'https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';
  static const _enabledKey = 'template_source_enabled';
  static const _urlKey = 'template_source_url';
  static const _versionKey = 'template_source_version';

  TemplateSourceConfig copyWith({
    bool? enabled,
    String? repoUrl,
    String? version,
  }) {
    return TemplateSourceConfig(
      enabled: enabled ?? this.enabled,
      repoUrl: repoUrl ?? this.repoUrl,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toJson() => {
        _enabledKey: enabled,
        _urlKey: repoUrl,
        _versionKey: version,
      };

  factory TemplateSourceConfig.fromPrefs(SharedPreferences prefs) {
    return TemplateSourceConfig(
      enabled: prefs.getBool(_enabledKey) ?? true,
      repoUrl: prefs.getString(_urlKey) ?? defaultRepoUrl,
      version: prefs.getString(_versionKey) ?? '',
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
    await p.setString(TemplateSourceConfig._versionKey, cfg.version);
    state = cfg;
  }

  Future<void> setEnabled(bool value) async {
    await _save(state.copyWith(enabled: value));
  }

  Future<void> setRepoUrl(String url) async {
    await _save(state.copyWith(repoUrl: url));
  }

  Future<void> setVersion(String version) async {
    await _save(state.copyWith(version: version));
  }

  Future<void> resetToDefault() async {
    await _save(
      state.copyWith(
        repoUrl: TemplateSourceConfig.defaultRepoUrl,
        version: '',
      ),
    );
  }
}
