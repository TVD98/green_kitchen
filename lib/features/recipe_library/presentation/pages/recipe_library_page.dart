import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../recipes/presentation/utils/discovery_messages.dart';
import '../../../recipes/presentation/widgets/recipe_list_tile.dart';
import '../bloc/recipe_library_bloc.dart';

class RecipeLibraryPage extends StatelessWidget {
  const RecipeLibraryPage({super.key});

  String _segmentLabel(AppLocalizations l10n, LibrarySegment segment) {
    return switch (segment) {
      LibrarySegment.all => l10n.librarySegmentAll,
      LibrarySegment.viewed => l10n.librarySegmentViewed,
      LibrarySegment.saved => l10n.librarySegmentSaved,
      LibrarySegment.fromPantry => l10n.librarySegmentFromPantry,
    };
  }

  String _emptyLabel(AppLocalizations l10n, LibrarySegment segment) {
    return switch (segment) {
      LibrarySegment.all => l10n.libraryEmptyAll,
      LibrarySegment.viewed => l10n.libraryEmptyViewed,
      LibrarySegment.saved => l10n.libraryEmptySaved,
      LibrarySegment.fromPantry => l10n.libraryEmptyFromPantry,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const segments = LibrarySegment.values;

    return BlocProvider(
      create: (_) => getIt<RecipeLibraryBloc>()..add(const RecipeLibraryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.tabRecipes, variant: AppTextVariant.title),
        ),
        body: BlocBuilder<RecipeLibraryBloc, RecipeLibraryState>(
          builder: (context, state) {
            final selectedIndex = segments.indexOf(state.segment);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppTabs(
                    layout: AppTabsLayout.scrollable,
                    tabs: segments
                        .map((segment) => _segmentLabel(l10n, segment))
                        .toList(growable: false),
                    selectedIndex: selectedIndex,
                    onChanged: (index) => context.read<RecipeLibraryBloc>().add(
                          RecipeLibrarySegmentChanged(segments[index]),
                        ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == RecipeLibraryStatus.loading) {
                        return const Center(child: AppLoading());
                      }
                      if (state.status == RecipeLibraryStatus.failure) {
                        return Center(
                          child: AppText(
                            discoveryFailureMessage(l10n, state.failure!),
                            variant: AppTextVariant.body,
                          ),
                        );
                      }
                      if (state.status == RecipeLibraryStatus.empty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: AppText(
                              _emptyLabel(l10n, state.segment),
                              variant: AppTextVariant.body,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<RecipeLibraryBloc>()
                              .add(const RecipeLibraryRefreshed());
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          itemCount: state.recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = state.recipes[index];
                            return RecipeListTile(
                              recipe: recipe,
                              onTap: () => context.push('/recipes/${recipe.id}'),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
