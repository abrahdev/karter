import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/onboarding_helper.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/surface_tint_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
import 'package:mobile/presentation/widgets/linux_title_bar.dart';
import 'package:system_theme/system_theme.dart';

class KarterApp extends ConsumerStatefulWidget {
  final Color initialAccent;

  const KarterApp({super.key, required this.initialAccent});

  @override
  ConsumerState<KarterApp> createState() => _KarterAppState();
}

class _KarterAppState extends ConsumerState<KarterApp> {
  bool _checkedOnboarding = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final seedColorState = ref.watch(seedColorProvider);
    final applySurfaceTint = ref.watch(surfaceTintProvider);

    return StreamBuilder<SystemAccentColor>(
      stream: SystemTheme.onChange,
      builder: (context, snapshot) {
        final systemAccent = snapshot.data?.accent ?? widget.initialAccent;
        final seedColor =
            seedColorState.useCustom ? seedColorState.color : systemAccent;
        final lightScheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        );
        final darkScheme = ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        );

        return MaterialApp.router(
          title: 'Karter',
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: themeMode,
          theme: AppTheme.from(
            lightScheme,
            Brightness.light,
            applySurfaceTint: applySurfaceTint,
          ),
          darkTheme: AppTheme.from(
            darkScheme,
            Brightness.dark,
            applySurfaceTint: applySurfaceTint,
          ),
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          builder: (builderContext, child) {
            if (!_checkedOnboarding) {
              _checkedOnboarding = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;
                final seen = await hasSeenOnboarding();
                if (!seen && mounted) {
                  appRouter.push('/onboarding');
                }
              });
            }
            final content = child ?? const SizedBox.shrink();
            return isDesktop ? LinuxTitleBar(child: content) : content;
          },
        );
      },
    );
  }
}
