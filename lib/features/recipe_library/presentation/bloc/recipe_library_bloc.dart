import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';

part 'recipe_library_event.dart';
part 'recipe_library_state.dart';

enum LibrarySegment { all, viewed, saved, fromPantry }

class RecipeLibraryBloc extends Bloc<RecipeLibraryEvent, RecipeLibraryState> {
  RecipeLibraryBloc({
    required GetViewedRecords getViewedRecords,
    required GetSavedRecords getSavedRecords,
    required GetPantrySessions getPantrySessions,
    required GetRecipesByIds getRecipesByIds,
  })  : _getViewedRecords = getViewedRecords,
        _getSavedRecords = getSavedRecords,
        _getPantrySessions = getPantrySessions,
        _getRecipesByIds = getRecipesByIds,
        super(const RecipeLibraryState()) {
    on<RecipeLibraryStarted>(_onStarted);
    on<RecipeLibrarySegmentChanged>(_onSegmentChanged);
    on<RecipeLibraryRefreshed>(_onRefreshed);
  }

  final GetViewedRecords _getViewedRecords;
  final GetSavedRecords _getSavedRecords;
  final GetPantrySessions _getPantrySessions;
  final GetRecipesByIds _getRecipesByIds;

  Future<void> _onStarted(
    RecipeLibraryStarted event,
    Emitter<RecipeLibraryState> emit,
  ) =>
      _load(emit, state.segment);

  Future<void> _onSegmentChanged(
    RecipeLibrarySegmentChanged event,
    Emitter<RecipeLibraryState> emit,
  ) async {
    emit(state.copyWith(segment: event.segment));
    await _load(emit, event.segment);
  }

  Future<void> _onRefreshed(
    RecipeLibraryRefreshed event,
    Emitter<RecipeLibraryState> emit,
  ) =>
      _load(emit, state.segment);

  Future<void> _load(
    Emitter<RecipeLibraryState> emit,
    LibrarySegment segment,
  ) async {
    emit(state.copyWith(status: RecipeLibraryStatus.loading, failure: null));
    final ids = await _idsForSegment(segment);
    if (ids.isEmpty) {
      emit(
        state.copyWith(
          status: RecipeLibraryStatus.empty,
          recipes: const [],
        ),
      );
      return;
    }
    final result = await _getRecipesByIds(ids);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RecipeLibraryStatus.failure,
          failure: failure,
        ),
      ),
      (recipes) {
        final ordered = _orderRecipes(ids, recipes);
        emit(
          state.copyWith(
            status:
                ordered.isEmpty ? RecipeLibraryStatus.empty : RecipeLibraryStatus.success,
            recipes: ordered,
          ),
        );
      },
    );
  }

  Future<List<String>> _idsForSegment(LibrarySegment segment) async {
    switch (segment) {
      case LibrarySegment.viewed:
        final records = await _getViewedRecords();
        return records.map((r) => r.recipeId).toList(growable: false);
      case LibrarySegment.saved:
        final records = await _getSavedRecords();
        return records.map((r) => r.recipeId).toList(growable: false);
      case LibrarySegment.fromPantry:
        final sessions = await _getPantrySessions();
        return sessions
            .expand((session) => session.recipeIds)
            .toSet()
            .toList(growable: false);
      case LibrarySegment.all:
        final viewed = await _getViewedRecords();
        final saved = await _getSavedRecords();
        final sessions = await _getPantrySessions();
        final ordered = <String, DateTime>{};
        for (final record in viewed) {
          ordered[record.recipeId] = record.timestamp;
        }
        for (final record in saved) {
          ordered.update(
            record.recipeId,
            (existing) =>
                record.timestamp.isAfter(existing) ? record.timestamp : existing,
            ifAbsent: () => record.timestamp,
          );
        }
        for (final session in sessions) {
          for (final id in session.recipeIds) {
            ordered.update(
              id,
              (existing) => session.searchedAt.isAfter(existing)
                  ? session.searchedAt
                  : existing,
              ifAbsent: () => session.searchedAt,
            );
          }
        }
        final entries = ordered.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        return entries.map((e) => e.key).toList(growable: false);
    }
  }

  List<Recipe> _orderRecipes(List<String> ids, List<Recipe> recipes) {
    final byId = {for (final recipe in recipes) recipe.id: recipe};
    return [
      for (final id in ids)
        if (byId.containsKey(id)) byId[id]!,
    ];
  }
}
