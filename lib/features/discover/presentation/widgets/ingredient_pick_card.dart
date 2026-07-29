import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

class IngredientPickCard extends StatelessWidget {
  const IngredientPickCard({
    super.key,
    required this.name,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  static const cardHeight = 48.0;
  static const horizontalPadding = 8.0;
  static const addButtonSize = 24.0;

  final String name;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SizedBox(
      height: cardHeight,
      child: Material(
        color: selected
            ? AppColors.softBrand(brightness)
            : AppColors.elevated(brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: selected
              ? const BorderSide(color: AppColors.brand, width: 1.5)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled || selected ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.label(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.gap4),
                SizedBox(
                  width: addButtonSize,
                  height: addButtonSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.brand
                          : Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: selected
                          ? null
                          : Border.all(color: AppColors.stroke(brightness)),
                    ),
                    child: Icon(
                      selected ? Icons.check : Icons.add,
                      size: 16,
                      color: selected
                          ? AppColors.absoluteWhite
                          : AppColors.muted(brightness),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
