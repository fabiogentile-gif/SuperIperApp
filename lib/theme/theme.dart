import 'package:flutter/material.dart';

const _lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFB4532A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFF6D9C9),
  onPrimaryContainer: Color(0xFF3E1A09),
  secondary: Color(0xFF3B332D),
  onSecondary: Color(0xFFFFFFFF),
  tertiary: Color(0xFFC99A2E),
  onTertiary: Color(0xFF2B1F03),
  error: Color(0xFFB3203A),
  onError: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFBF5),
  onSurface: Color(0xFF1F1B18),
  surfaceContainerHighest: Color(0xFFECE4D8),
  onSurfaceVariant: Color(0xFF6A5F55),
  outline: Color(0xFFD8CCBB),
);

const _darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFE8855A),
  onPrimary: Color(0xFF3B1405),
  primaryContainer: Color(0xFF5C2A12),
  onPrimaryContainer: Color(0xFFF6D9C9),
  secondary: Color(0xFFD9CBB8),
  onSecondary: Color(0xFF2A2218),
  tertiary: Color(0xFFD9B15A),
  onTertiary: Color(0xFF2B1F03),
  error: Color(0xFFF06A7A),
  onError: Color(0xFF3B0B14),
  surface: Color(0xFF1E1A17),
  onSurface: Color(0xFFF3EBE0),
  surfaceContainerHighest: Color(0xFF2A2521),
  onSurfaceVariant: Color(0xFFB5A899),
  outline: Color(0xFF40382F),
);

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: _lightScheme,
    scaffoldBackgroundColor: const Color(0xFFF6F1E9),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    colorScheme: _darkScheme,
    scaffoldBackgroundColor: const Color(0xFF14110F),
  );
}