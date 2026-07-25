import 'package:flutter/material.dart';

/// Typography scale using Nunito (loaded via Google Fonts in [AppTheme]).
enum AppTextVariant { display, headline, title, body, label, caption }

abstract final class AppTypography {
  static const String fontFamily = 'Nunito';

  static TextStyle display({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle title({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle label({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle forVariant(AppTextVariant variant, {Color? color}) {
    return switch (variant) {
      AppTextVariant.display => display(color: color),
      AppTextVariant.headline => headline(color: color),
      AppTextVariant.title => title(color: color),
      AppTextVariant.body => body(color: color),
      AppTextVariant.label => label(color: color),
      AppTextVariant.caption => caption(color: color),
    };
  }

  static TextTheme textTheme([TextTheme? base]) {
    final seed = base ?? ThemeData.light().textTheme;
    return seed.copyWith(
      displayLarge: display(),
      displayMedium: display(),
      displaySmall: headline(),
      headlineLarge: headline(),
      headlineMedium: headline(),
      headlineSmall: title(),
      titleLarge: title(),
      titleMedium: label(),
      titleSmall: label(),
      bodyLarge: body(),
      bodyMedium: body(),
      bodySmall: caption(),
      labelLarge: label(),
      labelMedium: label(),
      labelSmall: caption(),
    );
  }
}
