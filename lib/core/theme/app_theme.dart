import 'package:flutter/material.dart';

/// Masroofy theme configuration — light and dark modes.
///
/// WHY define themes in one place?
/// - Consistency: every screen uses the same colors, typography, spacing.
/// - Dark mode support: users expect it, especially in MENA markets
///   where phone screens are used at night.
/// - Maintainability: change the primary color once → entire app updates.
/// - Interviewers check for this — ad-hoc colors in widgets = junior code.
abstract final class AppTheme {
  // ── Brand Colors ──────────────────────────────────────────────────────
  static const Color _primaryGreen = Color(0xFF2E7D32);
  static const Color _primaryGreenDark = Color(0xFF66BB6A);
  static const Color _incomeGreen = Color(0xFF43A047);
  static const Color _expenseRed = Color(0xFFE53935);
  static const Color _surfaceDark = Color(0xFF1E1E1E);
  static const Color _backgroundDark = Color(0xFF121212);

  /// Color used for income amounts across the app.
  static const Color incomeColor = _incomeGreen;

  /// Color used for expense amounts across the app.
  static const Color expenseColor = _expenseRed;

  // ── Light Theme ───────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: _primaryGreen,
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

  // ── Dark Theme ────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: _primaryGreenDark,
        scaffoldBackgroundColor: _backgroundDark,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: _surfaceDark,
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
