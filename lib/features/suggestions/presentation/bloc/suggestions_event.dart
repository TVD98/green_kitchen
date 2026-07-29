part of 'suggestions_bloc.dart';

sealed class SuggestionsEvent extends Equatable {
  const SuggestionsEvent();

  @override
  List<Object?> get props => [];
}

final class SuggestionsStarted extends SuggestionsEvent {
  const SuggestionsStarted();
}
