import 'package:flutter/material.dart';

abstract final class BariiTheme {
  static const ink = Color(0xff2d3321);
  static const paper = Color(0xfff4f1ea);
  static const surface = Color(0xffffffff);
  static const muted = Color(0xffe9e4d9);
  static const accent = Color(0xff7fa86a);
  static const highlight = Color(0xfff9e8b3);
  static const danger = Color(0xffa63a2e);

  static const inkDark = Color(0xffeceadf);
  static const paperDark = Color(0xff1c2116);
  static const surfaceDark = Color(0xff242b1d);
  static const highlightDark = Color(0xff6c6330);
  static const primaryDark = Color(0xffd8e3cc);

  static const readingFonts = <String>[
    'Georgia',
    'Noto Serif',
    'Liberation Serif',
    'DejaVu Serif',
  ];

  static ThemeData light() => _theme(
    brightness: Brightness.light,
    ink: ink,
    paper: paper,
    surface: surface,
    muted: muted,
    primary: ink,
    onPrimary: paper,
    highlight: highlight,
  );

  static ThemeData dark() => _theme(
    brightness: Brightness.dark,
    ink: inkDark,
    paper: paperDark,
    surface: surfaceDark,
    muted: const Color(0xff2d3624),
    primary: primaryDark,
    onPrimary: paperDark,
    highlight: highlightDark,
  );

  static ThemeData _theme({
    required Brightness brightness,
    required Color ink,
    required Color paper,
    required Color surface,
    required Color muted,
    required Color primary,
    required Color onPrimary,
    required Color highlight,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      surface: paper,
      onSurface: ink,
      secondary: accent,
      error: danger,
      tertiaryContainer: highlight,
      onTertiaryContainer: ink,
      surfaceContainerHighest: muted,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: ink.withValues(alpha: 0.16)),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: paper,
      canvasColor: paper,
      cardColor: surface,
      dividerColor: ink.withValues(alpha: 0.12),
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: readingFonts.first,
          fontFamilyFallback: readingFonts.skip(1).toList(),
          fontSize: 28,
          height: 1.1,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape,
        shadowColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            fontSize: 11,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: ink, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
            fontSize: 11,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontFamily: readingFonts.first,
          fontFamilyFallback: readingFonts.skip(1).toList(),
          fontSize: 24,
          height: 1.1,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontFamily: readingFonts.first,
          fontFamilyFallback: readingFonts.skip(1).toList(),
          fontSize: 18,
          height: 1.2,
          color: ink,
        ),
        bodyLarge: TextStyle(
          fontFamily: readingFonts.first,
          fontFamilyFallback: readingFonts.skip(1).toList(),
          fontSize: 20,
          height: 1.8,
          color: ink,
        ),
        bodyMedium: TextStyle(fontSize: 16, height: 1.55, color: ink),
      ),
    );
  }
}
