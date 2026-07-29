import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

abstract final class DiscoverTheme {
  static const Color accent = AppColors.accentGreen;

  static ButtonStyle primaryButtonStyle(Brightness brightness) {
    return FilledButton.styleFrom(
      backgroundColor: accent,
      foregroundColor: AppColors.absoluteWhite,
      disabledBackgroundColor: accent.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  static Color pillBackground(Brightness brightness, {required bool selected}) {
    if (selected) {
      return accent.withValues(alpha: brightness == Brightness.light ? 0.12 : 0.24);
    }
    return AppColors.elevated(brightness);
  }

  static Color pillBorder({required bool selected}) =>
      selected ? accent : Colors.transparent;
}
