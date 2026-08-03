import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

PreferredSizeWidget profileThemedAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Theme.of(context).colorScheme.onSurface,
    ),
    title: AppText(title, variant: AppTextVariant.title),
  );
}

/// Sticky bottom action surface matching Profile preferences save bar.
class ProfileStickyActions extends StatelessWidget {
  const ProfileStickyActions({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      color: Theme.of(context).colorScheme.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.stroke(brightness)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
