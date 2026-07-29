part of 'suggestions_bloc.dart';

enum SuggestionsStatus { initial, loading, success, failure }

final class SuggestionsState extends Equatable {
  const SuggestionsState({
    this.status = SuggestionsStatus.initial,
    this.sections = const [],
    this.failure,
  });

  final SuggestionsStatus status;
  final List<SuggestionSection> sections;
  final Failure? failure;

  SuggestionsState copyWith({
    SuggestionsStatus? status,
    List<SuggestionSection>? sections,
    Failure? failure,
  }) {
    return SuggestionsState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, sections, failure];
}
