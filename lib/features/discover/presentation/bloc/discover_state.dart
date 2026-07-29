part of 'discover_bloc.dart';

final class DiscoverState extends Equatable {
  const DiscoverState({
    this.query = '',
    this.selectedIngredients = const [],
    this.suggestions = const [],
    this.recentIngredientSets = const [],
    this.filters = const PantryFilters(),
    this.isLoadingSuggestions = false,
  });

  final String query;
  final List<String> selectedIngredients;
  final List<Ingredient> suggestions;
  final List<List<String>> recentIngredientSets;
  final PantryFilters filters;
  final bool isLoadingSuggestions;

  bool get canSearch => selectedIngredients.isNotEmpty;

  DiscoverState copyWith({
    String? query,
    List<String>? selectedIngredients,
    List<Ingredient>? suggestions,
    List<List<String>>? recentIngredientSets,
    PantryFilters? filters,
    bool? isLoadingSuggestions,
  }) {
    return DiscoverState(
      query: query ?? this.query,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      suggestions: suggestions ?? this.suggestions,
      recentIngredientSets:
          recentIngredientSets ?? this.recentIngredientSets,
      filters: filters ?? this.filters,
      isLoadingSuggestions:
          isLoadingSuggestions ?? this.isLoadingSuggestions,
    );
  }

  @override
  List<Object?> get props => [
        query,
        selectedIngredients,
        suggestions,
        recentIngredientSets,
        filters,
        isLoadingSuggestions,
      ];
}
