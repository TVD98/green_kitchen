import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppButtonVariant { social, primary, soft, outline, text }

/// Brand button with Focuso variants, loading, and disabled states.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leading;
  final bool isLoading;
  final bool isExpanded;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final VoidCallback? handler = _enabled ? onPressed : null;

    final labelStyle = AppTypography.body(
      weight: FontWeight.w600,
      color: _foreground(brightness),
    );

    final content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _foreground(brightness),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: _foreground(brightness),
                    size: 20,
                  ),
                  child: leading!,
                ),
                const SizedBox(width: AppSpacing.gap10),
              ],
              Flexible(child: Text(label, style: labelStyle)),
            ],
          );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: handler,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.brand,
            foregroundColor: AppColors.absoluteWhite,
            disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.4),
            shape: shape,
            padding: padding,
            elevation: brightness == Brightness.light ? 1 : 0,
          ),
          child: content,
        ),
      AppButtonVariant.soft => FilledButton(
          onPressed: handler,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.softBrand(brightness),
            foregroundColor: brightness == Brightness.light
                ? AppColors.brand
                : AppColors.absoluteWhite,
            disabledBackgroundColor:
                AppColors.softBrand(brightness).withValues(alpha: 0.4),
            shape: shape,
            padding: padding,
            elevation: 0,
          ),
          child: content,
        ),
      AppButtonVariant.social => OutlinedButton(
          onPressed: handler,
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: BorderSide(color: AppColors.stroke(brightness)),
            shape: shape,
            padding: padding,
          ),
          child: content,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: handler,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.brand,
            backgroundColor: Theme.of(context).colorScheme.surface,
            side: const BorderSide(color: AppColors.brand),
            shape: shape,
            padding: padding,
          ),
          child: content,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: handler,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.brand,
            shape: shape,
            padding: padding,
          ),
          child: content,
        ),
    };

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Color _foreground(Brightness brightness) {
    return switch (variant) {
      AppButtonVariant.primary => AppColors.absoluteWhite,
      AppButtonVariant.soft => brightness == Brightness.light
          ? AppColors.brand
          : AppColors.absoluteWhite,
      AppButtonVariant.social =>
        brightness == Brightness.light
            ? AppColors.lightOnSurface
            : AppColors.darkOnSurface,
      AppButtonVariant.outline || AppButtonVariant.text => AppColors.brand,
    };
  }
}
