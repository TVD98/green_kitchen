import 'package:flutter/material.dart';

/// Focuso brand palette and light/dark surfaces.
abstract final class AppColors {
  static const Color brand = Color(0xFFFF4749);
  static const Color primary = brand;
  static const Color absoluteWhite = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFF75555);

  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightElevated = Color(0xFFEEEEEE);
  static const Color lightStroke = Color(0xFFE0E0E0);
  static const Color lightOnSurface = Color(0xFF212121);
  static const Color lightSoftBrand = Color(0xFFFFF0F0);

  static const Color darkBackground = Color(0xFF181A20);
  static const Color darkSurface = Color(0xFF1F222A);
  static const Color darkElevated = Color(0xFF35383F);
  static const Color darkStroke = Color(0xFF35383F);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkSoftBrand = Color(0xFF35383F);

  /// Light greyscale ladder (muted → stronger).
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);

  /// Dark greyscale ladder (muted → stronger / lighter).
  static const Color darkGrey400 = Color(0xFF9E9E9E);
  static const Color darkGrey500 = Color(0xFFBDBDBD);
  static const Color darkGrey600 = Color(0xFFE0E0E0);
  static const Color darkGrey700 = Color(0xFFEEEEEE);

  static const Color accentOrange = Color(0xFFFF981F);
  static const Color accentBlue = Color(0xFF1A96F0);
  static const Color accentGreen = Color(0xFF4AAF57);
  static const Color accentPurple = Color(0xFF9D28AC);

  static Color softBrand(Brightness brightness) =>
      brightness == Brightness.light ? lightSoftBrand : darkSoftBrand;

  static Color muted(Brightness brightness) =>
      brightness == Brightness.light ? grey500 : darkGrey400;

  static Color mutedStrong(Brightness brightness) =>
      brightness == Brightness.light ? grey700 : darkGrey700;

  static Color stroke(Brightness brightness) =>
      brightness == Brightness.light ? lightStroke : darkStroke;

  static Color elevated(Brightness brightness) =>
      brightness == Brightness.light ? lightElevated : darkElevated;
}
