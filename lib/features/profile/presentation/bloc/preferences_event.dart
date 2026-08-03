part of 'preferences_bloc.dart';

sealed class PreferencesEvent extends Equatable {
  const PreferencesEvent();

  @override
  List<Object?> get props => [];
}

final class PreferencesStarted extends PreferencesEvent {
  const PreferencesStarted();
}

final class PreferencesRetried extends PreferencesEvent {
  const PreferencesRetried();
}

final class PreferencesDietaryStyleChanged extends PreferencesEvent {
  const PreferencesDietaryStyleChanged(this.value);

  final String? value;

  @override
  List<Object?> get props => [value];
}

final class PreferencesSpiceLevelChanged extends PreferencesEvent {
  const PreferencesSpiceLevelChanged(this.value);

  final String? value;

  @override
  List<Object?> get props => [value];
}

final class PreferencesCuisinesChanged extends PreferencesEvent {
  const PreferencesCuisinesChanged(this.values);

  final Set<String> values;

  @override
  List<Object?> get props => [values];
}

final class PreferencesHealthGoalsChanged extends PreferencesEvent {
  const PreferencesHealthGoalsChanged(this.values);

  final Set<String> values;

  @override
  List<Object?> get props => [values];
}

final class PreferencesDislikedAdded extends PreferencesEvent {
  const PreferencesDislikedAdded(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class PreferencesDislikedRemoved extends PreferencesEvent {
  const PreferencesDislikedRemoved(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class PreferencesSaveRequested extends PreferencesEvent {
  const PreferencesSaveRequested();
}
