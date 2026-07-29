import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/recipe.dart';
import '../utils/discovery_messages.dart';

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
    final meta =
        '${l10n.recipeDetailMinutes(recipe.timeMinutes)} · ${recipeDifficultyLabel(l10n, recipe.difficulty)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(recipe.title, variant: AppTextVariant.title),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              subtitle ?? meta,
              variant: AppTextVariant.body,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
