import 'package:flutter/material.dart';

/// Typography scale using Urbanist (loaded via Google Fonts in [AppTheme]).
enum AppTextVariant {
  display,
  headline,
  h4,
  title,
  body,
  label,
  caption,
  xSmall,
}

abstract final class AppTypography {
  static const String fontFamily = 'Urbanist';

  static const double _headingHeight = 1.4;
  static const double _bodyHeight = 1.6;
  static const double _bodyLetterSpacing = 0.2;

  static TextStyle display({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: _headingHeight,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: _headingHeight,
        letterSpacing: 0,
        color: color,
      );

  /// Focuso H4 — navigation titles (24 bold / LH 1.4).
  static TextStyle h4({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: _headingHeight,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        height: _headingHeight,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle h6({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: _headingHeight,
        letterSpacing: 0,
        color: color,
      );

  static TextStyle body({Color? color, FontWeight weight = FontWeight.normal}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: weight,
        height: _bodyHeight,
        letterSpacing: _bodyLetterSpacing,
        color: color,
      );

  static TextStyle label({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: _bodyHeight,
        letterSpacing: _bodyLetterSpacing,
        color: color,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: _bodyHeight,
        letterSpacing: _bodyLetterSpacing,
        color: color,
      );

  static TextStyle xSmall({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: _bodyHeight,
        letterSpacing: _bodyLetterSpacing,
        color: color,
      );

  static TextStyle forVariant(AppTextVariant variant, {Color? color}) {
    return switch (variant) {
      AppTextVariant.display => display(color: color),
      AppTextVariant.headline => headline(color: color),
      AppTextVariant.h4 => h4(color: color),
      AppTextVariant.title => title(color: color),
      AppTextVariant.body => body(color: color),
      AppTextVariant.label => label(color: color),
      AppTextVariant.caption => caption(color: color),
      AppTextVariant.xSmall => xSmall(color: color),
    };
  }

  static TextTheme textTheme([TextTheme? base]) {
    final seed = base ?? ThemeData.light().textTheme;
    return seed.copyWith(
      displayLarge: display(),
      displayMedium: display(),
      displaySmall: headline(),
      headlineLarge: headline(),
      headlineMedium: h4(),
      headlineSmall: title(),
      titleLarge: title(),
      titleMedium: h6(),
      titleSmall: label(),
      bodyLarge: body(),
      bodyMedium: body(),
      bodySmall: caption(),
      labelLarge: label(),
      labelMedium: label(),
      labelSmall: xSmall(),
    );
  }
}
