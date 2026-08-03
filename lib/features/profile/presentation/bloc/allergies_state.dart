part of 'allergies_bloc.dart';

enum AllergiesStatus { initial, loading, ready, failure }

final class AllergiesState extends Equatable {
  const AllergiesState({
    this.status = AllergiesStatus.initial,
    this.selected = const [],
    this.baseline = const [],
    this.query = '',
    this.lang = 'vi',
    this.results = const [],
    this.searching = false,
    this.failure,
    this.saving = false,
    this.savedAck = false,
    this.saveFailed = false,
  });

  final AllergiesStatus status;
  final List<UserAllergy> selected;
  /// Last loaded or successfully saved set; Save is enabled when IDs differ.
  final List<UserAllergy> baseline;
  final String query;
  final String lang;
  final List<Ingredient> results;
  final bool searching;
  final Failure? failure;
  final bool saving;
  final bool savedAck;
  final bool saveFailed;

  bool get isDirty {
    final current =
        selected.map((a) => a.ingredientId).toSet();
    final saved = baseline.map((a) => a.ingredientId).toSet();
    return current.length != saved.length ||
        !current.containsAll(saved);
  }

  bool get canSave => isDirty && !saving;

  AllergiesState copyWith({
    AllergiesStatus? status,
    List<UserAllergy>? selected,
    List<UserAllergy>? baseline,
    String? query,
    String? lang,
    List<Ingredient>? results,
    bool? searching,
    Failure? failure,
    bool? saving,
    bool? savedAck,
    bool? saveFailed,
    bool clearFailure = false,
    bool clearSaveMessage = false,
  }) {
    return AllergiesState(
      status: status ?? this.status,
      selected: selected ?? this.selected,
      baseline: baseline ?? this.baseline,
      query: query ?? this.query,
      lang: lang ?? this.lang,
      results: results ?? this.results,
      searching: searching ?? this.searching,
      failure: clearFailure ? null : (failure ?? this.failure),
      saving: saving ?? this.saving,
      savedAck: clearSaveMessage ? false : (savedAck ?? this.savedAck),
      saveFailed: clearSaveMessage ? false : (saveFailed ?? this.saveFailed),
    );
  }

  @override
  List<Object?> get props => [
        status,
        selected,
        baseline,
        query,
        lang,
        results,
        searching,
        failure,
        saving,
        savedAck,
        saveFailed,
      ];
}
