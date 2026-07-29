import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../../recipes/domain/entities/ingredient.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';
import '../utils/discover_constants.dart';
import '../utils/quick_start_preset.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc({
    required SearchIngredients searchIngredients,
    required GetRecentIngredientSets getRecentIngredientSets,
    required SaveRecentIngredientSet saveRecentIngredientSet,
  })  : _searchIngredients = searchIngredients,
        _getRecentIngredientSets = getRecentIngredientSets,
        _saveRecentIngredientSet = saveRecentIngredientSet,
        super(const DiscoverState()) {
    on<DiscoverStarted>(_onStarted);
    on<DiscoverPromptChanged>(_onPromptChanged);
    on<DiscoverPromptCleared>(_onPromptCleared);
    on<DiscoverUsePreferencesToggled>(_onUsePreferencesToggled);
    on<DiscoverExcludeAllergiesToggled>(_onExcludeAllergiesToggled);
    on<DiscoverFiltersUpdated>(_onFiltersUpdated);
    on<DiscoverQuickStartSelected>(_onQuickStartSelected);
    on<DiscoverVoiceTranscriptAppended>(_onVoiceTranscriptAppended);
    on<DiscoverSheetQueryChanged>(_onSheetQueryChanged);
    on<DiscoverSheetIngredientToggled>(_onSheetIngredientToggled);
    on<DiscoverSheetSelectionCleared>(_onSheetSelectionCleared);
    on<DiscoverSheetRecentSelected>(_onSheetRecentSelected);
    on<DiscoverFridgeApplied>(_onFridgeApplied);
  }

  final SearchIngredients _searchIngredients;
  final GetRecentIngredientSets _getRecentIngredientSets;
  final SaveRecentIngredientSet _saveRecentIngredientSet;

  Future<void> _onStarted(
    DiscoverStarted event,
    Emitter<DiscoverState> emit,
  ) async {
    final recent = await _getRecentIngredientSets();
    emit(state.copyWith(recentIngredientSets: recent));
  }

  void _onPromptChanged(
    DiscoverPromptChanged event,
    Emitter<DiscoverState> emit,
  ) {
    final trimmed = event.prompt.length > DiscoverConstants.maxPromptLength
        ? event.prompt.substring(0, DiscoverConstants.maxPromptLength)
        : event.prompt;
    emit(state.copyWith(prompt: trimmed));
  }

  void _onPromptCleared(
    DiscoverPromptCleared event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(prompt: ''));
  }

  void _onUsePreferencesToggled(
    DiscoverUsePreferencesToggled event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(usePreferences: event.enabled));
  }

  void _onExcludeAllergiesToggled(
    DiscoverExcludeAllergiesToggled event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(excludeAllergies: event.enabled));
  }

  void _onFiltersUpdated(
    DiscoverFiltersUpdated event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(filters: event.filters));
  }

  void _onQuickStartSelected(
    DiscoverQuickStartSelected event,
    Emitter<DiscoverState> emit,
  ) {
    emit(
      state.copyWith(
        prompt: event.prompt,
        filters: event.filters ?? const PantryFilters(),
      ),
    );
  }

  void _onVoiceTranscriptAppended(
    DiscoverVoiceTranscriptAppended event,
    Emitter<DiscoverState> emit,
  ) {
    final transcript = event.transcript.trim();
    if (transcript.isEmpty) {
      return;
    }
    final combined = '${state.prompt} $transcript'.trim();
    final capped = combined.length > DiscoverConstants.maxPromptLength
        ? combined.substring(0, DiscoverConstants.maxPromptLength)
        : combined;
    emit(state.copyWith(prompt: capped));
  }

  Future<void> _onSheetQueryChanged(
    DiscoverSheetQueryChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(
      state.copyWith(
        sheetQuery: event.query,
        isLoadingSheetSuggestions: true,
      ),
    );
    if (event.query.trim().isEmpty) {
      emit(
        state.copyWith(
          sheetSuggestions: const [],
          isLoadingSheetSuggestions: false,
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
        state.copyWith(
          sheetSuggestions: const [],
          isLoadingSheetSuggestions: false,
        ),
      ),
      (items) => emit(
        state.copyWith(
          sheetSuggestions: items,
          isLoadingSheetSuggestions: false,
        ),
      ),
    );
  }

  void _onSheetIngredientToggled(
    DiscoverSheetIngredientToggled event,
    Emitter<DiscoverState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) {
      return;
    }
    final selected = List<String>.from(state.sheetSelectedIngredients);
    if (selected.contains(name)) {
      selected.remove(name);
    } else {
      if (selected.length >= DiscoverConstants.maxFridgeIngredients) {
        return;
      }
      selected.add(name);
    }
    emit(state.copyWith(sheetSelectedIngredients: selected));
  }

  void _onSheetSelectionCleared(
    DiscoverSheetSelectionCleared event,
    Emitter<DiscoverState> emit,
  ) {
    emit(state.copyWith(sheetSelectedIngredients: const []));
  }

  void _onSheetRecentSelected(
    DiscoverSheetRecentSelected event,
    Emitter<DiscoverState> emit,
  ) {
    emit(
      state.copyWith(
        sheetSelectedIngredients: List<String>.from(event.ingredients),
        sheetQuery: '',
        sheetSuggestions: const [],
      ),
    );
  }

  Future<void> _onFridgeApplied(
    DiscoverFridgeApplied event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(state.copyWith(prompt: event.prompt));
    await _saveRecentIngredientSet(event.ingredients);
    final recent = await _getRecentIngredientSets();
    emit(state.copyWith(recentIngredientSets: recent));
  }
}
