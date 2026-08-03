import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile_settings.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'preferences_event.dart';
part 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  PreferencesBloc({
    required GetUserPreferences getUserPreferences,
    required UpdateUserPreferences updateUserPreferences,
  })  : _getUserPreferences = getUserPreferences,
        _updateUserPreferences = updateUserPreferences,
        super(const PreferencesState()) {
    on<PreferencesStarted>(_onStarted);
    on<PreferencesRetried>(_onStarted);
    on<PreferencesDietaryStyleChanged>(_onDietaryStyleChanged);
    on<PreferencesSpiceLevelChanged>(_onSpiceLevelChanged);
    on<PreferencesCuisinesChanged>(_onCuisinesChanged);
    on<PreferencesHealthGoalsChanged>(_onHealthGoalsChanged);
    on<PreferencesDislikedAdded>(_onDislikedAdded);
    on<PreferencesDislikedRemoved>(_onDislikedRemoved);
    on<PreferencesSaveRequested>(_onSave);
  }

  final GetUserPreferences _getUserPreferences;
  final UpdateUserPreferences _updateUserPreferences;

  Future<void> _onStarted(
    PreferencesEvent event,
    Emitter<PreferencesState> emit,
  ) async {
    emit(state.copyWith(status: PreferencesStatus.loading, clearFailure: true));
    final result = await _getUserPreferences();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PreferencesStatus.failure,
          failure: failure,
        ),
      ),
      (prefs) => emit(
        state.copyWith(
          status: PreferencesStatus.ready,
          draft: prefs,
          baseline: prefs,
          clearFailure: true,
          clearSaveMessage: true,
        ),
      ),
    );
  }

  void _onDietaryStyleChanged(
    PreferencesDietaryStyleChanged event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          dietaryStyle: event.value,
          clearDietaryStyle: event.value == null,
        ),
        clearSaveMessage: true,
      ),
    );
  }

  void _onSpiceLevelChanged(
    PreferencesSpiceLevelChanged event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          spiceLevel: event.value,
          clearSpiceLevel: event.value == null,
        ),
        clearSaveMessage: true,
      ),
    );
  }

  void _onCuisinesChanged(
    PreferencesCuisinesChanged event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          cuisinePreferences: event.values.toList(growable: false),
        ),
        clearSaveMessage: true,
      ),
    );
  }

  void _onHealthGoalsChanged(
    PreferencesHealthGoalsChanged event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          healthGoals: event.values.toList(growable: false),
        ),
        clearSaveMessage: true,
      ),
    );
  }

  void _onDislikedAdded(
    PreferencesDislikedAdded event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    final value = event.value.trim();
    if (value.isEmpty) return;
    if (draft.dislikedIngredients.contains(value)) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          dislikedIngredients: [...draft.dislikedIngredients, value],
        ),
        clearSaveMessage: true,
      ),
    );
  }

  void _onDislikedRemoved(
    PreferencesDislikedRemoved event,
    Emitter<PreferencesState> emit,
  ) {
    final draft = state.draft;
    if (draft == null) return;
    emit(
      state.copyWith(
        draft: draft.copyWith(
          dislikedIngredients: draft.dislikedIngredients
              .where((e) => e != event.value)
              .toList(growable: false),
        ),
        clearSaveMessage: true,
      ),
    );
  }

  Future<void> _onSave(
    PreferencesSaveRequested event,
    Emitter<PreferencesState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !state.canSave) return;
    emit(state.copyWith(saving: true, clearFailure: true, clearSaveMessage: true));
    final result = await _updateUserPreferences(draft);
    result.fold(
      (failure) => emit(
        state.copyWith(
          saving: false,
          failure: failure,
          saveFailed: true,
        ),
      ),
      (prefs) => emit(
        state.copyWith(
          saving: false,
          draft: prefs,
          baseline: prefs,
          savedAck: true,
          clearFailure: true,
        ),
      ),
    );
  }
}
