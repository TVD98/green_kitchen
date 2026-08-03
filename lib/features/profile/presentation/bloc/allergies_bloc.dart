import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../recipes/domain/entities/ingredient.dart';
import '../../../recipes/domain/usecases/recipe_usecases.dart';
import '../../domain/entities/user_profile_settings.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'allergies_event.dart';
part 'allergies_state.dart';

class AllergiesBloc extends Bloc<AllergiesEvent, AllergiesState> {
  AllergiesBloc({
    required GetUserAllergies getUserAllergies,
    required ReplaceUserAllergies replaceUserAllergies,
    required SearchIngredients searchIngredients,
  })  : _getUserAllergies = getUserAllergies,
        _replaceUserAllergies = replaceUserAllergies,
        _searchIngredients = searchIngredients,
        super(const AllergiesState()) {
    on<AllergiesStarted>(_onStarted);
    on<AllergiesRetried>(_onStarted);
    on<AllergiesQueryChanged>(_onQueryChanged);
    on<AllergiesSearchRequested>(_onSearchRequested);
    on<AllergiesToggled>(_onToggled);
    on<AllergiesCleared>(_onCleared);
    on<AllergiesSaveRequested>(_onSave);
  }

  final GetUserAllergies _getUserAllergies;
  final ReplaceUserAllergies _replaceUserAllergies;
  final SearchIngredients _searchIngredients;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    AllergiesEvent event,
    Emitter<AllergiesState> emit,
  ) async {
    final lang = switch (event) {
      AllergiesStarted(:final lang) => lang,
      AllergiesRetried(:final lang) => lang,
      _ => 'vi',
    };
    emit(
      state.copyWith(
        status: AllergiesStatus.loading,
        lang: lang,
        clearFailure: true,
      ),
    );
    final result = await _getUserAllergies(lang: lang);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AllergiesStatus.failure,
          failure: failure,
        ),
      ),
      (allergies) => emit(
        state.copyWith(
          status: AllergiesStatus.ready,
          selected: allergies,
          baseline: allergies,
          clearFailure: true,
          clearSaveMessage: true,
        ),
      ),
    );
  }

  void _onQueryChanged(
    AllergiesQueryChanged event,
    Emitter<AllergiesState> emit,
  ) {
    emit(state.copyWith(query: event.query, lang: event.lang));
    _debounce?.cancel();
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(results: const [], searching: false));
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () {
      add(AllergiesSearchRequested(query, lang: event.lang));
    });
  }

  Future<void> _onSearchRequested(
    AllergiesSearchRequested event,
    Emitter<AllergiesState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(state.copyWith(results: const [], searching: false));
      return;
    }
    emit(state.copyWith(searching: true, lang: event.lang));
    final result = await _searchIngredients(
      event.query.trim(),
      lang: event.lang,
    );
    result.fold(
      (_) => emit(state.copyWith(searching: false, results: const [])),
      (ingredients) => emit(
        state.copyWith(
          searching: false,
          results: ingredients,
        ),
      ),
    );
  }

  void _onToggled(
    AllergiesToggled event,
    Emitter<AllergiesState> emit,
  ) {
    final allergy = event.allergy;
    final exists =
        state.selected.any((a) => a.ingredientId == allergy.ingredientId);
    final next = exists
        ? state.selected
            .where((a) => a.ingredientId != allergy.ingredientId)
            .toList(growable: false)
        : [...state.selected, allergy];
    emit(state.copyWith(selected: next, clearSaveMessage: true));
  }

  void _onCleared(
    AllergiesCleared event,
    Emitter<AllergiesState> emit,
  ) {
    emit(state.copyWith(selected: const [], clearSaveMessage: true));
  }

  Future<void> _onSave(
    AllergiesSaveRequested event,
    Emitter<AllergiesState> emit,
  ) async {
    if (!state.canSave) return;
    emit(state.copyWith(saving: true, clearFailure: true, clearSaveMessage: true));
    final ids =
        state.selected.map((a) => a.ingredientId).toList(growable: false);
    final result = await _replaceUserAllergies(ids, lang: state.lang);
    result.fold(
      (failure) => emit(
        state.copyWith(
          saving: false,
          failure: failure,
          saveFailed: true,
        ),
      ),
      (allergies) => emit(
        state.copyWith(
          saving: false,
          selected: allergies,
          baseline: allergies,
          savedAck: true,
          clearFailure: true,
        ),
      ),
    );
  }
}
