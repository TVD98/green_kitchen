import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Removable pill chip using design-system colors/typography.
class ProfileRemovableChip extends StatelessWidget {
  const ProfileRemovableChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(
          left: AppSpacing.gap12,
          right: AppSpacing.gap6,
          top: AppSpacing.gap6,
          bottom: AppSpacing.gap6,
        ),
        decoration: BoxDecoration(
          color: AppColors.softBrand(brightness),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.stroke(brightness)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.label(
                color: AppColors.brand,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: AppSpacing.gap4),
            InkWell(
              onTap: onDeleted,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.gap2),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.muted(brightness),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
