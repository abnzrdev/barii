import 'package:flutter/material.dart';

enum ReaderFont {
  serif('Book serif', [
    'Georgia',
    'Noto Serif',
    'Liberation Serif',
    'DejaVu Serif',
  ]),
  sans('Clean sans', ['Arial', 'Roboto', 'Noto Sans', 'DejaVu Sans']),
  mono('Monospace', [
    'Consolas',
    'Courier New',
    'Noto Sans Mono',
    'Liberation Mono',
    'monospace',
  ]);

  const ReaderFont(this.label, this.families);
  final String label;
  final List<String> families;

  String get css =>
      '${families.map((font) => '"$font"').join(', ')}, ${switch (this) {
        serif => 'serif',
        sans => 'sans-serif',
        mono => 'monospace',
      }}';

  static ReaderFont parse(String value) =>
      values.firstWhere((font) => font.name == value, orElse: () => serif);
}

enum ReaderBackground {
  theme('App theme'),
  paper('Paper'),
  sepia('Sepia'),
  night('Night');

  const ReaderBackground(this.label);
  final String label;

  static ReaderBackground parse(String value) => values.firstWhere(
    (background) => background.name == value,
    orElse: () => theme,
  );

  ThemeData apply(ThemeData base) {
    if (this == theme) return base;
    final (canvas, ink, brightness) = switch (this) {
      paper => (
        const Color(0xfff4f1ea),
        const Color(0xff2d3321),
        Brightness.light,
      ),
      sepia => (
        const Color(0xffeee2c8),
        const Color(0xff433422),
        Brightness.light,
      ),
      night => (
        const Color(0xff181c20),
        const Color(0xffe7e4dc),
        Brightness.dark,
      ),
      theme => throw StateError('App theme was already handled'),
    };
    final scheme = ColorScheme.fromSeed(
      seedColor: base.colorScheme.primary,
      brightness: brightness,
      surface: canvas,
      onSurface: ink,
    );
    return base.copyWith(
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      iconTheme: base.iconTheme.copyWith(color: ink),
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: canvas,
        foregroundColor: ink,
        titleTextStyle: base.appBarTheme.titleTextStyle?.copyWith(color: ink),
      ),
    );
  }
}
