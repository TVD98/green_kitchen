import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../recipes/domain/entities/ingredient.dart';
import '../bloc/discover_bloc.dart';
import '../utils/discover_constants.dart';
import '../utils/discover_theme.dart';
import '../utils/ingredient_category_label.dart';
import 'ingredient_pick_card.dart';

class FridgeIngredientsSheet extends StatefulWidget {
  const FridgeIngredientsSheet({super.key});

  @override
  State<FridgeIngredientsSheet> createState() => _FridgeIngredientsSheetState();
}

class _FridgeIngredientsSheetState extends State<FridgeIngredientsSheet> {
  Timer? _debounce;
  late final TextEditingController _searchController;
  var _syncedFromBloc = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_syncedFromBloc) {
      _syncedFromBloc = true;
      final query = context.read<DiscoverBloc>().state.sheetQuery;
      _searchController.text = query;
    }
  }

  void _onSearchControllerChanged() => setState(() {});

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController
      ..removeListener(_onSearchControllerChanged)
      ..dispose();
    super.dispose();
  }

  void _onQueryChanged(BuildContext context, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<DiscoverBloc>().add(DiscoverSheetQueryChanged(value));
      }
    });
  }

  void _clearSearch(BuildContext context) {
    _debounce?.cancel();
    _searchController.clear();
    context.read<DiscoverBloc>().add(const DiscoverSheetQueryChanged(''));
  }

  Map<String, List<Ingredient>> _groupByCategory(List<Ingredient> items) {
    final grouped = <String, List<Ingredient>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final height = MediaQuery.sizeOf(context).height *
        DiscoverConstants.sheetHeightFactor;

    return SizedBox(
      height: height,
      child: BlocListener<DiscoverBloc, DiscoverState>(
        listenWhen: (prev, next) => prev.sheetQuery != next.sheetQuery,
        listener: (context, state) {
          if (_searchController.text != state.sheetQuery) {
            _searchController.text = state.sheetQuery;
          }
        },
        child: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            final grouped = _groupByCategory(state.sheetSuggestions);

            return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            l10n.discoverFridgeSheetTitle,
                            variant: AppTextVariant.title,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppText(
                            l10n.discoverFridgeSheetSubtitle,
                            variant: AppTextVariant.caption,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: AppTextField(
                  controller: _searchController,
                  label: l10n.discoverFridgeSearchHint,
                  onChanged: (value) => _onQueryChanged(context, value),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () => _clearSearch(context),
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: state.sheetQuery.trim().isEmpty
                    ? _RecentSection(
                        recentSets: state.recentIngredientSets,
                        onRecentTap: (set) => context.read<DiscoverBloc>().add(
                              DiscoverSheetRecentSelected(set),
                            ),
                        emptyHint: l10n.discoverFridgeSearchEmpty,
                      )
                    : state.isLoadingSheetSuggestions
                        ? const Center(child: AppLoading())
                        : grouped.isEmpty
                            ? Center(
                                child: AppText(
                                  l10n.discoverFridgeSearchEmpty,
                                  variant: AppTextVariant.body,
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                children: [
                                  for (final entry in grouped.entries) ...[
                                    AppText(
                                      discoverIngredientCategoryLabel(
                                        l10n,
                                        entry.key,
                                      ),
                                      variant: AppTextVariant.label,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent:
                                            IngredientPickCard.cardHeight,
                                        mainAxisSpacing: AppSpacing.sm,
                                        crossAxisSpacing: AppSpacing.sm,
                                      ),
                                      itemCount: entry.value.length,
                                      itemBuilder: (context, index) {
                                        final item = entry.value[index];
                                        final selected = state
                                            .isSheetIngredientSelected(
                                          item.canonicalName,
                                        );
                                        return IngredientPickCard(
                                          name: item.canonicalName,
                                          selected: selected,
                                          enabled: selected ||
                                              !state.isSheetSelectionFull,
                                          onTap: () => context
                                              .read<DiscoverBloc>()
                                              .add(
                                                DiscoverSheetIngredientToggled(
                                                  item.canonicalName,
                                                ),
                                              ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: AppSpacing.lg),
                                  ],
                                ],
                              ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: state.canApplyFridgeSelection
                          ? () => Navigator.of(context).pop(true)
                          : null,
                      style: DiscoverTheme.primaryButtonStyle(
                        Theme.of(context).brightness,
                      ),
                      child: Text(
                        l10n.discoverFridgeAddIngredients(
                          state.sheetSelectedIngredients.length,
                          DiscoverConstants.maxFridgeIngredients,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: state.sheetSelectedIngredients.isEmpty
                          ? null
                          : () => context.read<DiscoverBloc>().add(
                                const DiscoverSheetSelectionCleared(),
                              ),
                      child: Text(l10n.discoverFridgeClearSelection),
                    ),
                  ],
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

class _RecentSection extends StatelessWidget {
  const _RecentSection({
    required this.recentSets,
    required this.onRecentTap,
    required this.emptyHint,
  });

  final List<List<String>> recentSets;
  final ValueChanged<List<String>> onRecentTap;
  final String emptyHint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (recentSets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppText(emptyHint, variant: AppTextVariant.body),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      children: [
        AppText(l10n.discoverRecentSearches, variant: AppTextVariant.label),
        const SizedBox(height: AppSpacing.sm),
        ...recentSets.map(
          (set) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(set.join(', ')),
            trailing: const Icon(Icons.history),
            onTap: () => onRecentTap(set),
          ),
        ),
      ],
    );
  }
}
