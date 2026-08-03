import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../domain/entities/locale_preference.dart';
import '../../domain/usecases/get_locale_preference.dart';
import '../../domain/usecases/set_locale_preference.dart';

class LocalePreferenceState extends Equatable {
  const LocalePreferenceState({
    this.preference = LocalePreference.system,
  });

  final LocalePreference preference;

  /// `null` means follow the device locale (MaterialApp system mode).
  Locale? get materialLocale {
    switch (preference) {
      case LocalePreference.system:
        return null;
      case LocalePreference.vi:
        return const Locale('vi');
      case LocalePreference.en:
        return const Locale('en');
    }
  }

  @override
  List<Object?> get props => [preference];
}

class LocalePreferenceCubit extends Cubit<LocalePreferenceState> {
  LocalePreferenceCubit({
    required GetLocalePreference getLocalePreference,
    required SetLocalePreference setLocalePreference,
    required ClearRecentIngredientSets clearRecentIngredientSets,
    LocalePreference? initialPreference,
  })  : _getLocalePreference = getLocalePreference,
        _setLocalePreference = setLocalePreference,
        _clearRecentIngredientSets = clearRecentIngredientSets,
        super(
          LocalePreferenceState(
            preference: initialPreference ?? LocalePreference.system,
          ),
        );

  final GetLocalePreference _getLocalePreference;
  final SetLocalePreference _setLocalePreference;
  final ClearRecentIngredientSets _clearRecentIngredientSets;

  Future<void> load() async {
    final preference = await _getLocalePreference();
    emit(LocalePreferenceState(preference: preference));
  }

  Future<void> select(LocalePreference preference) async {
    if (preference == state.preference) {
      return;
    }
    emit(LocalePreferenceState(preference: preference));
    await _setLocalePreference(preference);
    await _clearRecentIngredientSets();
  }
}
