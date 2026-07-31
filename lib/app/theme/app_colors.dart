import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6F4E37);
  static const Color primaryDark = Color(0xFF3E2723);
  static const Color background = Color(0xFFFAF6F1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}

/// Neutrals that actually flip between light/dark — brand colors above
/// (primary, primaryDark, error, success) stay constant in both modes, so
/// screens keep using AppColors.primary etc. directly; only backgrounds,
/// surfaces and text pick up a mode via these.
extension AppThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Page background (e.g. Scaffold backgroundColor)
  Color get appBackground => isDark ? const Color(0xFF121212) : AppColors.background;

  // Card / container surface sitting on top of the background
  Color get appSurface => isDark ? const Color(0xFF1E1E1E) : Colors.white;

  // A slightly different surface for subtle sections (e.g. toggle track bg)
  Color get appSurfaceMuted => isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100;

  Color get appBorder => isDark ? const Color(0xFF2E2E2E) : Colors.grey.shade200;

  Color get appTextPrimary => isDark ? Colors.white : Colors.black87;

  Color get appTextSecondary => isDark ? Colors.grey.shade400 : Colors.grey.shade600;

  Color get appTextMuted => isDark ? Colors.grey.shade600 : Colors.grey.shade400;
}