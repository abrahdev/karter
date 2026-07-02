import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData from(ColorScheme? colorScheme, Brightness brightness) {
    final scheme = colorScheme ??
        ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: brightness,
        );

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true),
      cardTheme: const CardThemeData(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}