part of 'discover_bloc.dart';

final class DiscoverState extends Equatable {
  const DiscoverState({
    this.prompt = '',
    this.usePreferences = true,
    this.excludeAllergies = false,
    this.filters = const PantryFilters(),
    this.sheetQuery = '',
    this.sheetSelectedIngredients = const [],
    this.sheetSuggestions = const [],
    this.recentIngredientSets = const [],
    this.isLoadingSheetSuggestions = false,
  });

  final String prompt;
  final bool usePreferences;
  final bool excludeAllergies;
  final PantryFilters filters;
  final String sheetQuery;
  final List<String> sheetSelectedIngredients;
  final List<Ingredient> sheetSuggestions;
  final List<List<String>> recentIngredientSets;
  final bool isLoadingSheetSuggestions;

  bool get canSearch => prompt.trim().isNotEmpty;

  bool get canApplyFridgeSelection => sheetSelectedIngredients.isNotEmpty;

  bool isSheetIngredientSelected(String name) =>
      sheetSelectedIngredients.contains(name);

  bool get isSheetSelectionFull =>
      sheetSelectedIngredients.length >= DiscoverConstants.maxFridgeIngredients;

  DiscoverState copyWith({
    String? prompt,
    bool? usePreferences,
    bool? excludeAllergies,
    PantryFilters? filters,
    String? sheetQuery,
    List<String>? sheetSelectedIngredients,
    List<Ingredient>? sheetSuggestions,
    List<List<String>>? recentIngredientSets,
    bool? isLoadingSheetSuggestions,
  }) {
    return DiscoverState(
      prompt: prompt ?? this.prompt,
      usePreferences: usePreferences ?? this.usePreferences,
      excludeAllergies: excludeAllergies ?? this.excludeAllergies,
      filters: filters ?? this.filters,
      sheetQuery: sheetQuery ?? this.sheetQuery,
      sheetSelectedIngredients:
          sheetSelectedIngredients ?? this.sheetSelectedIngredients,
      sheetSuggestions: sheetSuggestions ?? this.sheetSuggestions,
      recentIngredientSets:
          recentIngredientSets ?? this.recentIngredientSets,
      isLoadingSheetSuggestions:
          isLoadingSheetSuggestions ?? this.isLoadingSheetSuggestions,
    );
  }

  @override
  List<Object?> get props => [
        prompt,
        usePreferences,
        excludeAllergies,
        filters,
        sheetQuery,
        sheetSelectedIngredients,
        sheetSuggestions,
        recentIngredientSets,
        isLoadingSheetSuggestions,
      ];
}
