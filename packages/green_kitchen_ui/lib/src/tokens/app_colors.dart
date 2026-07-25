import 'package:flutter/material.dart';

/// Duolingo-inspired brand palette and light/dark surfaces.
abstract final class AppColors {
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryDark = Color(0xFF46A302);
  static const Color secondary = Color(0xFFFFC800);
  static const Color error = Color(0xFFFF4B4B);
  static const Color warning = Color(0xFFFFC800);
  static const Color success = Color(0xFF58CC02);

  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7F7);
  static const Color lightOnSurface = Color(0xFF3C3C3C);

  static const Color darkBackground = Color(0xFF131F24);
  static const Color darkSurface = Color(0xFF202F36);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
}
