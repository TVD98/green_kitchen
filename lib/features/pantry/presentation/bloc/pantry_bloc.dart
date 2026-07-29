import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../recipe_interactions/domain/entities/recipe_interaction.dart';
import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../../core/error/failures.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';

part 'pantry_event.dart';
part 'pantry_state.dart';

class PantryBloc extends Bloc<PantryEvent, PantryState> {
  PantryBloc({
    required SearchPantry searchPantry,
    required SavePantrySession savePantrySession,
    required List<String> ingredients,
    PantryFilters filters = const PantryFilters(),
  })  : _searchPantry = searchPantry,
        _savePantrySession = savePantrySession,
        _ingredients = List<String>.from(ingredients),
        _filters = filters,
        super(const PantryState()) {
    on<PantryStarted>(_onStarted);
    on<PantryRetried>(_onRetried);
  }

  final SearchPantry _searchPantry;
  final SavePantrySession _savePantrySession;
  final List<String> _ingredients;
  final PantryFilters _filters;

  Future<void> _onStarted(
    PantryStarted event,
    Emitter<PantryState> emit,
  ) =>
      _search(emit);

  Future<void> _onRetried(
    PantryRetried event,
    Emitter<PantryState> emit,
  ) =>
      _search(emit);

  Future<void> _search(Emitter<PantryState> emit) async {
    emit(state.copyWith(status: PantryStatus.loading, failure: null));
    final result = await _searchPantry(
      ingredients: _ingredients,
      filters: _filters,
    );
    await result.fold(
      (failure) async {
        emit(state.copyWith(status: PantryStatus.failure, failure: failure));
      },
      (recipes) async {
        if (recipes.isEmpty) {
          emit(state.copyWith(status: PantryStatus.empty, recipes: recipes));
          return;
        }
        await _savePantrySession(
          PantrySession(
            ingredients: _ingredients,
            recipeIds: recipes.map((r) => r.id).toList(growable: false),
            searchedAt: DateTime.now().toUtc(),
          ),
        );
        emit(state.copyWith(status: PantryStatus.success, recipes: recipes));
      },
    );
  }
}
