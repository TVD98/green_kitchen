import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';

/// Light and dark [ThemeData] built from Focuso tokens + Urbanist.
abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        elevated: AppColors.lightElevated,
        stroke: AppColors.lightStroke,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        elevated: AppColors.darkElevated,
        stroke: AppColors.darkStroke,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color elevated,
    required Color stroke,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.brand,
      onPrimary: AppColors.absoluteWhite,
      secondary: AppColors.softBrand(brightness),
      onSecondary: brightness == Brightness.light
          ? AppColors.brand
          : AppColors.absoluteWhite,
      error: AppColors.error,
      onError: AppColors.absoluteWhite,
      surface: surface,
      onSurface: onSurface,
      outline: stroke,
      surfaceContainerHighest: elevated,
    );

    final pill = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide.none,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: _textTheme(brightness),
      primaryColor: AppColors.brand,
      dividerColor: stroke,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: AppColors.absoluteWhite,
          disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.4),
          shape: pill,
          elevation: brightness == Brightness.light ? 1 : 0,
          shadowColor: AppColors.brand.withValues(alpha: 0.25),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: AppColors.absoluteWhite,
          shape: pill,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brand,
          side: const BorderSide(color: AppColors.brand),
          shape: pill,
          backgroundColor: surface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand,
          shape: pill,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.body(
          color: AppColors.muted(brightness),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: brightness == Brightness.light ? 2 : 0,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        showDragHandle: true,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brand;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.absoluteWhite),
        side: const BorderSide(color: AppColors.brand, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.absoluteWhite),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brand;
          return AppColors.muted(brightness);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.brand,
        inactiveTrackColor: AppColors.muted(brightness),
        thumbColor: AppColors.brand,
        overlayColor: AppColors.brand.withValues(alpha: 0.12),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.brand;
          return AppColors.muted(brightness);
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.absoluteWhite,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brand,
        foregroundColor: AppColors.absoluteWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h4(color: onSurface),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final base = AppTypography.textTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    if (!GoogleFonts.config.allowRuntimeFetching) {
      return base;
    }
    return GoogleFonts.urbanistTextTheme(base).copyWith(
      displayLarge: AppTypography.display(),
      displayMedium: AppTypography.display(),
      displaySmall: AppTypography.headline(),
      headlineLarge: AppTypography.headline(),
      headlineMedium: AppTypography.h4(),
      headlineSmall: AppTypography.title(),
      titleLarge: AppTypography.title(),
      titleMedium: AppTypography.h6(),
      titleSmall: AppTypography.label(),
      bodyLarge: AppTypography.body(),
      bodyMedium: AppTypography.body(),
      bodySmall: AppTypography.caption(),
      labelLarge: AppTypography.label(),
      labelMedium: AppTypography.label(),
      labelSmall: AppTypography.xSmall(),
    );
  }
}
