import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../recipes/presentation/utils/discovery_messages.dart';
import '../../../recipes/presentation/widgets/recipe_list_tile.dart';
import '../../../suggestions/domain/utils/mock_popularity.dart';
import '../bloc/suggestions_bloc.dart';

class SuggestionsPage extends StatelessWidget {
  const SuggestionsPage({super.key});

  String _sectionTitle(AppLocalizations l10n, String key) {
    return switch (key) {
      'featured' => l10n.suggestionsFeatured,
      'popular' => l10n.suggestionsPopular,
      'quick' => l10n.suggestionsQuick,
      'easy' => l10n.suggestionsEasy,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<SuggestionsBloc>()..add(const SuggestionsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.tabSuggestions, variant: AppTextVariant.title),
        ),
        body: BlocBuilder<SuggestionsBloc, SuggestionsState>(
          builder: (context, state) {
            if (state.status == SuggestionsStatus.loading) {
              return const Center(child: AppLoading());
            }
            if (state.status == SuggestionsStatus.failure) {
              return Center(
                child: AppText(
                  discoveryFailureMessage(l10n, state.failure!),
                  variant: AppTextVariant.body,
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                for (final section in state.sections) ...[
                  AppText(
                    _sectionTitle(l10n, section.key),
                    variant: AppTextVariant.title,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...section.recipes.map(
                    (recipe) {
                      final subtitle = section.showMockViews
                          ? l10n.suggestionsMockViews(
                              formatMockViewCount(
                                mockViewCountForRecipe(recipe),
                              ),
                            )
                          : null;
                      return RecipeListTile(
                        recipe: recipe,
                        subtitle: subtitle,
                        onTap: () => context.push('/recipes/${recipe.id}'),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
