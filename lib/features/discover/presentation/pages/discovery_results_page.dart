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
import '../widgets/discover_chrome.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: discoverThemedAppBar(
          context: context,
          title: l10n.discoveryResultsTitle,
        ),
        body: BlocBuilder<DiscoveryResultsBloc, DiscoveryResultsState>(
          builder: (context, state) {
            if (state.status == DiscoveryResultsStatus.loading) {
              return _DiscoveryStatusBody(
                prompt: args.prompt,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoading(),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      l10n.discoverySearching,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              );
            }

            if (state.status == DiscoveryResultsStatus.failure) {
              final message = discoveryFailureMessage(
                l10n,
                state.failure ?? const ServerFailure(),
              );
              return _DiscoveryStatusBody(
                prompt: args.prompt,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 40,
                      color: AppColors.brand,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      message,
                      variant: AppTextVariant.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: l10n.discoveryRetry,
                      onPressed: () => context
                          .read<DiscoveryResultsBloc>()
                          .add(const DiscoveryResultsRetried()),
                    ),
                  ],
                ),
              );
            }

            if (state.status == DiscoveryResultsStatus.empty) {
              return _DiscoveryStatusBody(
                prompt: args.prompt,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      size: 40,
                      color: AppColors.brand,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppText(
                      l10n.discoveryEmpty,
                      variant: AppTextVariant.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.discoveryEmptyHint,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              itemCount: state.recipes.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _DiscoveryResultsHero(
                      prompt: args.prompt,
                      resultCount: state.recipes.length,
                    ),
                  );
                }
                final recipe = state.recipes[index - 1];
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

class _DiscoveryResultsHero extends StatelessWidget {
  const _DiscoveryResultsHero({
    required this.prompt,
    this.resultCount,
  });

  final String prompt;
  final int? resultCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(l10n.discoveryResultsTitle, variant: AppTextVariant.headline),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          prompt,
          variant: AppTextVariant.body,
          color: muted,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (resultCount != null) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.softBrand(Theme.of(context).brightness),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: AppText(
              l10n.discoveryResultsCount(resultCount!),
              variant: AppTextVariant.caption,
              color: AppColors.brand,
            ),
          ),
        ],
      ],
    );
  }
}

class _DiscoveryStatusBody extends StatelessWidget {
  const _DiscoveryStatusBody({
    required this.prompt,
    required this.child,
  });

  final String prompt;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _DiscoveryResultsHero(prompt: prompt),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Center(child: child),
        ),
      ],
    );
  }
}
