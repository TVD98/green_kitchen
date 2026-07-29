import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../recipes/presentation/utils/discovery_messages.dart';
import '../../../recipes/presentation/widgets/recipe_list_tile.dart';
import '../bloc/pantry_bloc.dart';
import '../models/pantry_search_args.dart';

class PantryResultsPage extends StatelessWidget {
  const PantryResultsPage({super.key, required this.args});

  final PantrySearchArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<PantryBloc>(
        param1: args.ingredients,
        param2: args.filters,
      )..add(const PantryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.pantryResultsTitle, variant: AppTextVariant.title),
        ),
        body: BlocBuilder<PantryBloc, PantryState>(
          builder: (context, state) {
            if (state.status == PantryStatus.loading) {
              return const Center(child: AppLoading());
            }
            if (state.status == PantryStatus.failure) {
              final message = discoveryFailureMessage(
                l10n,
                state.failure ?? const ServerFailure(),
              );
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(message, variant: AppTextVariant.body),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.pantryRetry,
                        onPressed: () => context
                            .read<PantryBloc>()
                            .add(const PantryRetried()),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.status == PantryStatus.empty) {
              return Center(
                child: AppText(l10n.pantryEmpty, variant: AppTextVariant.body),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: state.recipes.length,
              itemBuilder: (context, index) {
                final recipe = state.recipes[index];
                return RecipeListTile(
                  recipe: recipe,
                  onTap: () => context.push('/recipes/${recipe.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
