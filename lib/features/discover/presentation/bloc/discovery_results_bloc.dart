import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../recipe_interactions/domain/entities/recipe_interaction.dart';
import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../../../recipes/domain/entities/recipe.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';

part 'discovery_results_event.dart';
part 'discovery_results_state.dart';

class DiscoveryResultsBloc
    extends Bloc<DiscoveryResultsEvent, DiscoveryResultsState> {
  DiscoveryResultsBloc({
    required SearchDiscovery searchDiscovery,
    required SaveDiscoverySession saveDiscoverySession,
    required String prompt,
    bool usePreferences = true,
    bool excludeAllergies = false,
    PantryFilters filters = const PantryFilters(),
  })  : _searchDiscovery = searchDiscovery,
        _saveDiscoverySession = saveDiscoverySession,
        _prompt = prompt,
        _usePreferences = usePreferences,
        _excludeAllergies = excludeAllergies,
        _filters = filters,
        super(const DiscoveryResultsState()) {
    on<DiscoveryResultsStarted>(_onStarted);
    on<DiscoveryResultsRetried>(_onRetried);
  }

  final SearchDiscovery _searchDiscovery;
  final SaveDiscoverySession _saveDiscoverySession;
  final String _prompt;
  final bool _usePreferences;
  final bool _excludeAllergies;
  final PantryFilters _filters;

  Future<void> _onStarted(
    DiscoveryResultsStarted event,
    Emitter<DiscoveryResultsState> emit,
  ) =>
      _search(emit);

  Future<void> _onRetried(
    DiscoveryResultsRetried event,
    Emitter<DiscoveryResultsState> emit,
  ) =>
      _search(emit);

  Future<void> _search(Emitter<DiscoveryResultsState> emit) async {
    emit(state.copyWith(status: DiscoveryResultsStatus.loading, failure: null));
    final result = await _searchDiscovery(
      DiscoverySearchQuery(
        prompt: _prompt,
        usePreferences: _usePreferences,
        excludeAllergies: _excludeAllergies,
        filters: _filters,
      ),
    );
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: DiscoveryResultsStatus.failure,
            failure: failure,
          ),
        );
      },
      (recipes) async {
        if (recipes.isEmpty) {
          emit(
            state.copyWith(
              status: DiscoveryResultsStatus.empty,
              recipes: recipes,
            ),
          );
          return;
        }
        await _saveDiscoverySession(
          DiscoverySession(
            prompt: _prompt,
            recipeIds: recipes.map((r) => r.id).toList(growable: false),
            searchedAt: DateTime.now().toUtc(),
          ),
        );
        emit(
          state.copyWith(
            status: DiscoveryResultsStatus.success,
            recipes: recipes,
          ),
        );
      },
    );
  }
}
