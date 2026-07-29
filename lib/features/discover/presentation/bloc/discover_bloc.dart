import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../recipes/domain/entities/ingredient.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc({
    required SearchIngredients searchIngredients,
    required GetRecentIngredientSets getRecentIngredientSets,
  })  : _searchIngredients = searchIngredients,
        _getRecentIngredientSets = getRecentIngredientSets,
        super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverQueryChanged>(_onQueryChanged);
    on<DiscoverIngredientAdded>(_onIngredientAdded);
    on<DiscoverIngredientRemoved>(_onIngredientRemoved);
    on<DiscoverRecentSelected>(_onRecentSelected);
    on<DiscoverFiltersUpdated>(_onFiltersUpdated);
  }

  final SearchIngredients _searchIngredients;
  final GetRecentIngredientSets _getRecentIngredientSets;

  Future<void> _onStarted(
    DiscoverStarted event,
    Emitter<DiscoverState> emit,
  ) async {
    final recent = await _getRecentIngredientSets();
    emit(state.copyWith(recentIngredientSets: recent));
  }

  Future<void> _onQueryChanged(
    DiscoverQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(query: event.query, isLoadingSuggestions: true));
    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(
          suggestions: const [],
          isLoadingSuggestions: false,
        ),
      );
      return;
    }
    final result = await _searchIngredients(
      event.query.trim(),
      lang: event.lang,
    );
    result.fold(
      (_) => emit(
        state.copyWith(suggestions: const [], isLoadingSuggestions: false),
      ),
      (items) => emit(
        state.copyWith(suggestions: items, isLoadingSuggestions: false),
      ),
    );
  }

  void _onIngredientAdded(
    DiscoverIngredientAdded event,
    Emitter<DiscoverState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty || state.selectedIngredients.contains(name)) {
      return;
    }
    emit(
      state.copyWith(
        selectedIngredients: [...state.selectedIngredients, name],
        query: '',
        suggestions: const [],
      ),
    );
  }

  void _onIngredientRemoved(
    DiscoverIngredientRemoved event,
    Emitter<DiscoverState> emit,
  ) {
    emit(
      state.copyWith(
        selectedIngredients: state.selectedIngredients
            .where((item) => item != event.name)
            .toList(growable: false),
      ),
    );
  }

  void _onRecentSelected(
    DiscoverRecentSelected event,
    Emitter<DiscoverState> emit,
  ) {
    emit(
      state.copyWith(
        selectedIngredients: List<String>.from(event.ingredients),
        query: '',
        suggestions: const [],
      ),
    );
  }

  void _onFiltersUpdated(
    DiscoverFiltersUpdated event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(filters: event.filters));
  }
}
