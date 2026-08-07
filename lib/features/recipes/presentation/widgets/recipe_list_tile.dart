import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/recipe.dart';
import '../utils/discovery_messages.dart';
import 'recipe_cover_image.dart';

class RecipeListTile extends StatelessWidget {
  const RecipeListTile({
    super.key,
    required this.recipe,
    required this.onTap,
    this.subtitle,
  });

  final Recipe recipe;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final hasImage =
        recipe.imageUrl != null && recipe.imageUrl!.trim().isNotEmpty;
    final difficulty = recipeDifficultyLabel(l10n, recipe.difficulty);
    final minutes = l10n.recipeDetailMinutes(recipe.timeMinutes);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: EdgeInsets.zero,
        onTap: onTap,
        color: brightness == Brightness.light
            ? AppColors.lightSurface
            : Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasImage)
              RecipeCoverImage(
                imageUrl: recipe.imageUrl,
                borderRadius: BorderRadius.zero,
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(recipe.title, variant: AppTextVariant.title),
                  if (recipe.description.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      recipe.description,
                      variant: AppTextVariant.body,
                      color: muted,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  if (subtitle != null)
                    AppText(subtitle!, variant: AppTextVariant.caption, color: muted)
                  else
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _MetaChip(
                          icon: Icons.schedule_outlined,
                          label: minutes,
                          brightness: brightness,
                        ),
                        _MetaChip(
                          icon: Icons.local_fire_department_outlined,
                          label: difficulty,
                          brightness: brightness,
                        ),
                        if (recipe.servings > 0)
                          _MetaChip(
                            icon: Icons.people_outline,
                            label: l10n.recipeDetailServings(recipe.servings),
                            brightness: brightness,
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.brightness,
  });

  final IconData icon;
  final String label;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.softBrand(brightness),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.brand),
          const SizedBox(width: AppSpacing.xs),
          AppText(
            label,
            variant: AppTextVariant.caption,
            color: AppColors.brand,
          ),
        ],
      ),
    );
  }
}
