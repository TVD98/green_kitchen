import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/recipe_detail_bloc.dart';
import '../utils/discovery_messages.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<RecipeDetailBloc>(param1: recipeId)
        ..add(const RecipeDetailStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.tabRecipes, variant: AppTextVariant.title),
          actions: [
            BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
              builder: (context, state) {
                if (state.status != RecipeDetailStatus.success) {
                  return const SizedBox.shrink();
                }
                return TextButton(
                  onPressed: () => context
                      .read<RecipeDetailBloc>()
                      .add(const RecipeDetailSaveToggled()),
                  child: Text(
                    state.isSaved
                        ? l10n.recipeDetailUnsave
                        : l10n.recipeDetailSave,
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
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
                AppText(recipe.title, variant: AppTextVariant.headline),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  '${l10n.recipeDetailMinutes(recipe.timeMinutes)} · ${recipeDifficultyLabel(l10n, recipe.difficulty)} · ${l10n.recipeDetailServings(recipe.servings)}',
                  variant: AppTextVariant.body,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                if (recipe.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppText(recipe.description, variant: AppTextVariant.body),
                ],
                const SizedBox(height: AppSpacing.lg),
                AppText(
                  l10n.recipeDetailIngredients,
                  variant: AppTextVariant.title,
                ),
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
                  AppText(
                    l10n.recipeDetailNutrition,
                    variant: AppTextVariant.title,
                  ),
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
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
