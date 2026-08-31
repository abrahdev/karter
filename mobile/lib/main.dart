import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/app.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/services/background_service.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/data/services/template_translations.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/linux_title_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

String resolveTemplateLocale(String code) {
  if (code != 'system' && const ['en', 'es', 'et'].contains(code)) return code;
  final platform = Platform.localeName.split('_').first;
  return const ['en', 'es', 'et'].contains(platform) ? platform : 'en';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 720),
      minimumSize: Size(480, 400),
      center: true,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  SystemTheme.fallbackColor = AppTheme.fallbackSeed;
  await SystemTheme.accentColor.load();
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('locale') ?? 'system';
  final savedThemeMode = ThemeModeNotifier.fromName(prefs.getString('theme_mode'));

  if (Platform.isAndroid || Platform.isIOS) {
    await initBackgroundTasks();
  }

  final notificationService = NotificationService();
  await notificationService.init();

  final templateSource = TemplateSourceConfig.fromPrefs(prefs);
  final baseUrl = templateSource.enabled
      ? await CatalogService.resolveBaseUrl(
          templateSource.repoUrl,
          timeout: const Duration(seconds: 5),
        )
      : null;
  await TemplateTranslations.preload(
    locale: resolveTemplateLocale(savedLocale),
    baseUrl: baseUrl,
  );

  final catalogService = CatalogService();
  await catalogService.catalogFile();

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith(() => createLocaleNotifier(savedLocale)),
        themeModeProvider.overrideWith(() => createThemeModeNotifier(savedThemeMode)),
        sharedPreferencesProvider.overrideWithValue(prefs),
        notificationServiceProvider.overrideWith((ref) {
          notificationService.init();
          return notificationService;
        }),
        catalogServiceProvider.overrideWithValue(catalogService),
      ],
      child: KarterApp(initialAccent: SystemTheme.accentColor.accent),
    ),
  );

  if (templateSource.enabled) {
    unawaited(catalogService.refreshFromRelease().catchError((_) {}));
  }
}
