import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const fallbackSeed = Colors.amber;

  static ThemeData from(
    ColorScheme? colorScheme,
    Brightness brightness, {
    bool applySurfaceTint = true,
  }) {
    final scheme = colorScheme ??
        ColorScheme.fromSeed(
          seedColor: fallbackSeed,
          brightness: brightness,
        );

    final effectiveScheme = applySurfaceTint
        ? scheme
        : _neutralSurfaces(scheme, brightness);
    final dur = const Duration(milliseconds: 200);

    return ThemeData(
      colorScheme: effectiveScheme,
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: true,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.scaled,
          ),
          TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.scaled,
          ),
        },
      ),
      splashFactory: InkSparkle.splashFactory,
      applyElevationOverlayColor: true,
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          animationDuration: dur,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          animationDuration: dur,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          animationDuration: dur,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          animationDuration: dur,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        highlightElevation: 8,
      ),
      switchTheme: SwitchThemeData(
        trackOutlineWidth: WidgetStateProperty.resolveWith((_) => 0),
      ),
    );
  }

  static ColorScheme _neutralSurfaces(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFFFBFE);
    final surfaceContainer = isDark ? const Color(0xFF211F26) : const Color(0xFFF3EDF7);
    final surfaceContainerLow = isDark ? const Color(0xFF1D1B20) : const Color(0xFFF7F2FA);
    final surfaceContainerHigh = isDark ? const Color(0xFF2B2930) : const Color(0xFFECE6F0);
    final surfaceContainerHighest = isDark ? const Color(0xFF36343B) : const Color(0xFFE6E0E9);

    return scheme.copyWith(
      surface: surface,
      surfaceContainerLowest: isDark ? const Color(0xFF0F0D13) : const Color(0xFFFFFFFF),
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
    );
  }
}
