import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../utils/discover_theme.dart';

class QuickStartPill extends StatelessWidget {
  const QuickStartPill({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: DiscoverTheme.pillBackground(brightness, selected: false),
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: DiscoverTheme.accent, size: 28),
              const SizedBox(height: AppSpacing.sm),
              AppText(
                label,
                variant: AppTextVariant.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
