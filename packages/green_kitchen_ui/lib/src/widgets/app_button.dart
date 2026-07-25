import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, text }

/// Brand button with variants, loading, and disabled states.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;

  bool get _enabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary ||
                      variant == AppButtonVariant.secondary
                  ? Colors.white
                  : AppColors.primary,
            ),
          )
        : Text(label);

    final VoidCallback? handler = _enabled ? onPressed : null;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: handler,
          child: child,
        ),
      AppButtonVariant.secondary => FilledButton(
          onPressed: handler,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.lightOnSurface,
            disabledBackgroundColor:
                AppColors.secondary.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 14,
            ),
          ),
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: handler,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: handler,
          child: child,
        ),
    };

    if (!isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
