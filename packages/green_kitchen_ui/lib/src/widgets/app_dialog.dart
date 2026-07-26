import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

/// Focuso-style centered popup shell with blur + dim barrier.
abstract final class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? illustration,
    String? title,
    String? body,
    Widget? actions,
    Widget? child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gap24),
                child: Material(
                  color: Theme.of(dialogContext).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gap24),
                    child: child ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (illustration != null) ...[
                              illustration,
                              const SizedBox(height: AppSpacing.gap20),
                            ],
                            if (title != null)
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: AppTypography.h4(
                                  color: Theme.of(dialogContext)
                                      .colorScheme
                                      .onSurface,
                                ),
                              ),
                            if (body != null) ...[
                              const SizedBox(height: AppSpacing.gap12),
                              Text(
                                body,
                                textAlign: TextAlign.center,
                                style: AppTypography.body(
                                  color: AppColors.muted(
                                    Theme.of(dialogContext).brightness,
                                  ),
                                ),
                              ),
                            ],
                            if (actions != null) ...[
                              const SizedBox(height: AppSpacing.gap24),
                              actions,
                            ],
                          ],
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
