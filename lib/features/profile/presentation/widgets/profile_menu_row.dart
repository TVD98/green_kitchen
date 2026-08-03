import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Profile hub menu row styled with design-system tokens (Urbanist + brand).
class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = true,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.muted(brightness);
    final accent = destructive ? AppColors.error : AppColors.brand;
    final titleColor = destructive ? AppColors.error : onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.gap14,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: destructive
                      ? AppColors.error.withValues(alpha: 0.12)
                      : AppColors.softBrand(brightness),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, size: 22, color: accent),
              ),
              const SizedBox(width: AppSpacing.gap12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body(
                        weight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.gap2),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption(color: muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (showChevron) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.chevron_right, color: muted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
