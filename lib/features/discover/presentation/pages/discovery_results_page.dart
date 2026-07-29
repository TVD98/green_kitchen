import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../recipes/presentation/utils/discovery_messages.dart';
import '../../../recipes/presentation/widgets/recipe_list_tile.dart';
import '../bloc/discovery_results_bloc.dart';
import '../models/discovery_search_args.dart';

class DiscoveryResultsPage extends StatelessWidget {
  const DiscoveryResultsPage({super.key, required this.args});

  final DiscoverySearchArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => DiscoveryResultsBloc(
        searchDiscovery: getIt(),
        saveDiscoverySession: getIt(),
        prompt: args.prompt,
        usePreferences: args.usePreferences,
        excludeAllergies: args.excludeAllergies,
        filters: args.filters,
      )..add(const DiscoveryResultsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.discoveryResultsTitle, variant: AppTextVariant.title),
        ),
        body: BlocBuilder<DiscoveryResultsBloc, DiscoveryResultsState>(
          builder: (context, state) {
            if (state.status == DiscoveryResultsStatus.loading) {
              return const Center(child: AppLoading());
            }
            if (state.status == DiscoveryResultsStatus.failure) {
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
                        label: l10n.discoveryRetry,
                        onPressed: () => context
                            .read<DiscoveryResultsBloc>()
                            .add(const DiscoveryResultsRetried()),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state.status == DiscoveryResultsStatus.empty) {
              return Center(
                child: AppText(l10n.discoveryEmpty, variant: AppTextVariant.body),
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
