import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../discover/presentation/widgets/discover_chrome.dart';
import '../bloc/recipe_detail_bloc.dart';
import '../utils/discovery_messages.dart';
import '../widgets/recipe_cover_image.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<RecipeDetailBloc>(param1: recipeId)
        ..add(const RecipeDetailStarted()),
      child: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: discoverThemedAppBar(
              context: context,
              title: l10n.tabRecipes,
              actions: [
                if (state.status == RecipeDetailStatus.success)
                  TextButton(
                    onPressed: () => context
                        .read<RecipeDetailBloc>()
                        .add(const RecipeDetailSaveToggled()),
                    child: Text(
                      state.isSaved
                          ? l10n.recipeDetailUnsave
                          : l10n.recipeDetailSave,
                    ),
                  ),
              ],
            ),
            body: _RecipeDetailBody(state: state),
          );
        },
      ),
    );
  }
}

class _RecipeDetailBody extends StatelessWidget {
  const _RecipeDetailBody({required this.state});

  final RecipeDetailState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    if (state.status == RecipeDetailStatus.loading) {
      return const Center(child: AppLoading());
    }
    if (state.status == RecipeDetailStatus.notFound) {
      return Center(
        child: AppText(
          l10n.recipeDetailNotFound,
          variant: AppTextVariant.body,
        ),
      );
    }
    if (state.status == RecipeDetailStatus.failure) {
      return Center(
        child: AppText(
          discoveryFailureMessage(l10n, state.failure!),
          variant: AppTextVariant.body,
        ),
      );
    }

    final recipe = state.recipe!;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (recipe.imageUrl != null && recipe.imageUrl!.trim().isNotEmpty) ...[
          RecipeCoverImage(imageUrl: recipe.imageUrl, height: 220),
          const SizedBox(height: AppSpacing.md),
        ],
        AppText(recipe.title, variant: AppTextVariant.headline),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            _DetailMetaChip(
              icon: Icons.schedule_outlined,
              label: l10n.recipeDetailMinutes(recipe.timeMinutes),
              brightness: brightness,
            ),
            _DetailMetaChip(
              icon: Icons.local_fire_department_outlined,
              label: recipeDifficultyLabel(l10n, recipe.difficulty),
              brightness: brightness,
            ),
            _DetailMetaChip(
              icon: Icons.people_outline,
              label: l10n.recipeDetailServings(recipe.servings),
              brightness: brightness,
            ),
          ],
        ),
        if (recipe.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          AppText(recipe.description, variant: AppTextVariant.body),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppText(l10n.recipeDetailIngredients, variant: AppTextVariant.title),
        const SizedBox(height: AppSpacing.sm),
        ...recipe.ingredients.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: AppText(
              '• ${item.name} — ${item.quantity}',
              variant: AppTextVariant.body,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppText(l10n.recipeDetailSteps, variant: AppTextVariant.title),
        const SizedBox(height: AppSpacing.sm),
        ...recipe.steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppText(
              '${step.order}. ${step.text}',
              variant: AppTextVariant.body,
            ),
          ),
        ),
        if (recipe.nutrition != null) ...[
          const SizedBox(height: AppSpacing.lg),
          AppText(l10n.recipeDetailNutrition, variant: AppTextVariant.title),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            [
              if (recipe.nutrition!.calories != null)
                '${recipe.nutrition!.calories} kcal',
              if (recipe.nutrition!.proteinG != null)
                'P ${recipe.nutrition!.proteinG}g',
              if (recipe.nutrition!.carbsG != null)
                'C ${recipe.nutrition!.carbsG}g',
              if (recipe.nutrition!.fatG != null)
                'F ${recipe.nutrition!.fatG}g',
            ].join(' · '),
            variant: AppTextVariant.body,
            color: muted,
          ),
        ],
      ],
    );
  }
}

class _DetailMetaChip extends StatelessWidget {
  const _DetailMetaChip({
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
