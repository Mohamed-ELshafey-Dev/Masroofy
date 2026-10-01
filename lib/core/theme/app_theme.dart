import 'package:flutter/material.dart';

/// Masroofy theme configuration — light and dark modes.
///
/// WHY define themes in one place?
/// - Consistency: every screen uses the same colors, typography, spacing.
/// - Dark mode support: users expect it, especially in MENA markets
///   where phone screens are used at night.
/// - Maintainability: change the primary color once → entire app updates.
/// - Interviewers check for this — ad-hoc colors in widgets = junior code.
///
/// Color tokens are mirrored from `DESIGN-apple.md`, which is the single
/// source of truth for color in this project. Change a value there first,
/// then mirror it here.
///
/// WHY an explicit [ColorScheme] instead of only `colorSchemeSeed`:
/// Material 3 *generates* tonal values from a seed, so a seed alone can never
/// produce the exact tokens the design system specifies (`#000000` canvas,
/// `#1c1c1e` elevated surface). `fromSeed` supplies a sensible full palette
/// and `copyWith` then pins the tokens that must match exactly.
abstract final class AppTheme {
  // ── Brand tokens (DESIGN-apple.md) ──────────────────────────────────────

  /// Action blue — the primary on light surfaces.
  static const Color _primaryLight = Color(0xFF0066CC);

  /// Primary on dark surfaces. Reuses the design system's
  /// `primary-on-dark` token — do not introduce a second accent.
  static const Color _primaryDark = Color(0xFF2997FF);

  /// Canvas behind all dark content.
  static const Color _canvasDark = Color(0xFF000000);

  /// Cards, list rows and sheets — one elevation step above the dark canvas.
  static const Color _surfaceElevatedDark = Color(0xFF1C1C1E);

  /// Secondary text and captions on light surfaces (~5.1:1 on white).
  static const Color _inkSecondaryLight = Color(0xFF6E6E73);

  /// Secondary text and captions on the dark canvas (~6.3:1 on black).
  static const Color _inkSecondaryDark = Color(0xFF98989D);

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: _primaryLight,
    brightness: Brightness.light,
  ).copyWith(
    primary: _primaryLight,
    onSurfaceVariant: _inkSecondaryLight,
  );

  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: _primaryDark,
    brightness: Brightness.dark,
  ).copyWith(
    primary: _primaryDark,
    surface: _canvasDark,
    onSurfaceVariant: _inkSecondaryDark,
  );

  // ── Light Theme ────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightScheme,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      );

  // ── Dark Theme ─────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _darkScheme,
        scaffoldBackgroundColor: _canvasDark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: _surfaceElevatedDark,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
      );
}
