import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../pantry/presentation/models/pantry_search_args.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../bloc/discover_bloc.dart';
import '../widgets/selected_ingredient_chips.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Timer? _debounce;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(BuildContext context, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<DiscoverBloc>().add(DiscoverQueryChanged(value));
      }
    });
  }

  Future<void> _openFilters(BuildContext context, PantryFilters filters) async {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<DiscoverBloc>();
    final maxTimeController =
        TextEditingController(text: filters.maxTime?.toString() ?? '');
    var difficulty = filters.difficulty;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppText(l10n.filterTitle, variant: AppTextVariant.title),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: maxTimeController,
                    label: l10n.filterMaxTime,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppText(l10n.filterDifficulty, variant: AppTextVariant.label),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.gap8,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.filterAny),
                        selected: difficulty == null,
                        onSelected: (_) =>
                            setSheetState(() => difficulty = null),
                      ),
                      ChoiceChip(
                        label: Text(l10n.filterEasy),
                        selected: difficulty == 'easy',
                        onSelected: (_) =>
                            setSheetState(() => difficulty = 'easy'),
                      ),
                      ChoiceChip(
                        label: Text(l10n.filterMedium),
                        selected: difficulty == 'medium',
                        onSelected: (_) =>
                            setSheetState(() => difficulty = 'medium'),
                      ),
                      ChoiceChip(
                        label: Text(l10n.filterHard),
                        selected: difficulty == 'hard',
                        onSelected: (_) =>
                            setSheetState(() => difficulty = 'hard'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: l10n.filterApply,
                    onPressed: () {
                      final parsed = int.tryParse(maxTimeController.text.trim());
                      bloc.add(
                        DiscoverFiltersUpdated(
                          PantryFilters(
                            maxTime: parsed,
                            difficulty: difficulty,
                          ),
                        ),
                      );
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    maxTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<DiscoverBloc>()..add(const DiscoverStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: AppText(l10n.tabDiscover, variant: AppTextVariant.title),
        ),
        body: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                AppText(l10n.discoverTitle, variant: AppTextVariant.headline),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  l10n.discoverSubtitle,
                  variant: AppTextVariant.body,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _controller,
                  label: l10n.discoverIngredientHint,
                  onChanged: (value) => _onQueryChanged(context, value),
                ),
                if (state.isLoadingSuggestions)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: AppLoading(),
                  )
                else if (state.suggestions.isNotEmpty)
                  ...state.suggestions.map(
                    (item) => ListTile(
                      title: Text(item.canonicalName),
                      subtitle: Text(item.category),
                      onTap: () {
                        context.read<DiscoverBloc>().add(
                              DiscoverIngredientAdded(item.canonicalName),
                            );
                        _controller.clear();
                      },
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                AppText(
                  l10n.discoverSelectedIngredients,
                  variant: AppTextVariant.label,
                ),
                const SizedBox(height: AppSpacing.sm),
                SelectedIngredientChips(
                  ingredients: state.selectedIngredients,
                  onRemove: (name) => context
                      .read<DiscoverBloc>()
                      .add(DiscoverIngredientRemoved(name)),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: l10n.discoverSuggestDishes,
                        onPressed: state.canSearch
                            ? () {
                                context.push(
                                  '/pantry/results',
                                  extra: PantrySearchArgs(
                                    ingredients: state.selectedIngredients,
                                    filters: state.filters,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton(
                      onPressed: () => _openFilters(context, state.filters),
                      icon: const Icon(Icons.tune),
                      tooltip: l10n.discoverFilters,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                AppText(
                  l10n.discoverRecentSearches,
                  variant: AppTextVariant.title,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (state.recentIngredientSets.isEmpty)
                  AppText(
                    l10n.discoverNoRecent,
                    variant: AppTextVariant.body,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )
                else
                  ...state.recentIngredientSets.map(
                    (set) => ListTile(
                      title: Text(set.join(', ')),
                      trailing: const Icon(Icons.history),
                      onTap: () => context.read<DiscoverBloc>().add(
                            DiscoverRecentSelected(set),
                          ),
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
