import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile_settings.dart';
import '../../domain/usecases/profile_usecases.dart';

class ProfileHubCubit extends Cubit<ProfileHubState> {
  ProfileHubCubit({
    required GetUserPreferences getUserPreferences,
    required GetUserAllergies getUserAllergies,
  })  : _getUserPreferences = getUserPreferences,
        _getUserAllergies = getUserAllergies,
        super(const ProfileHubState());

  final GetUserPreferences _getUserPreferences;
  final GetUserAllergies _getUserAllergies;

  Future<void> loadSummaries() async {
    emit(state.copyWith(loading: true));
    final prefsResult = await _getUserPreferences();
    // Hub subtitle allergy count is language-agnostic; default vi is fine.
    final allergiesResult = await _getUserAllergies();

    UserPreferences? preferences;
    prefsResult.fold((_) {}, (prefs) => preferences = prefs);

    int? allergyCount;
    allergiesResult.fold((_) {}, (list) => allergyCount = list.length);

    emit(
      ProfileHubState(
        loading: false,
        preferences: preferences,
        allergyCount: allergyCount,
        preferencesLoaded: prefsResult.isSuccess,
        allergiesLoaded: allergiesResult.isSuccess,
      ),
    );
  }
}

final class ProfileHubState extends Equatable {
  const ProfileHubState({
    this.loading = false,
    this.preferences,
    this.allergyCount,
    this.preferencesLoaded = false,
    this.allergiesLoaded = false,
  });

  final bool loading;
  final UserPreferences? preferences;
  final int? allergyCount;
  final bool preferencesLoaded;
  final bool allergiesLoaded;

  /// Backward-compatible getter used by older tests / call sites.
  String? get dietaryStyle => preferences?.dietaryStyle;

  ProfileHubState copyWith({
    bool? loading,
    UserPreferences? preferences,
    int? allergyCount,
    bool? preferencesLoaded,
    bool? allergiesLoaded,
  }) {
    return ProfileHubState(
      loading: loading ?? this.loading,
      preferences: preferences ?? this.preferences,
      allergyCount: allergyCount ?? this.allergyCount,
      preferencesLoaded: preferencesLoaded ?? this.preferencesLoaded,
      allergiesLoaded: allergiesLoaded ?? this.allergiesLoaded,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        preferences,
        allergyCount,
        preferencesLoaded,
        allergiesLoaded,
      ];
}
