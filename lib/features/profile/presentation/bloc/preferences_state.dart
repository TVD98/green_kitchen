part of 'preferences_bloc.dart';

enum PreferencesStatus { initial, loading, ready, failure }

final class PreferencesState extends Equatable {
  const PreferencesState({
    this.status = PreferencesStatus.initial,
    this.draft,
    this.baseline,
    this.failure,
    this.saving = false,
    this.savedAck = false,
    this.saveFailed = false,
  });

  final PreferencesStatus status;
  final UserPreferences? draft;
  /// Last loaded or successfully saved snapshot; Save is enabled when draft differs.
  final UserPreferences? baseline;
  final Failure? failure;
  final bool saving;
  final bool savedAck;
  final bool saveFailed;

  bool get isDirty =>
      draft != null && baseline != null && draft != baseline;

  bool get canSave => isDirty && !saving;

  PreferencesState copyWith({
    PreferencesStatus? status,
    UserPreferences? draft,
    UserPreferences? baseline,
    Failure? failure,
    bool? saving,
    bool? savedAck,
    bool? saveFailed,
    bool clearFailure = false,
    bool clearSaveMessage = false,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      baseline: baseline ?? this.baseline,
      failure: clearFailure ? null : (failure ?? this.failure),
      saving: saving ?? this.saving,
      savedAck: clearSaveMessage ? false : (savedAck ?? this.savedAck),
      saveFailed: clearSaveMessage ? false : (saveFailed ?? this.saveFailed),
    );
  }

  @override
  List<Object?> get props => [
        status,
        draft,
        baseline,
        failure,
        saving,
        savedAck,
        saveFailed,
      ];
}
