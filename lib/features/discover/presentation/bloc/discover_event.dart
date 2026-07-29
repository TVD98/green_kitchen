part of 'discover_bloc.dart';

sealed class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

final class DiscoverStarted extends DiscoverEvent {
  const DiscoverStarted();
}

final class DiscoverPromptChanged extends DiscoverEvent {
  const DiscoverPromptChanged(this.prompt);

  final String prompt;

  @override
  List<Object?> get props => [prompt];
}

final class DiscoverPromptCleared extends DiscoverEvent {
  const DiscoverPromptCleared();
}

final class DiscoverUsePreferencesToggled extends DiscoverEvent {
  const DiscoverUsePreferencesToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class DiscoverExcludeAllergiesToggled extends DiscoverEvent {
  const DiscoverExcludeAllergiesToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class DiscoverFiltersUpdated extends DiscoverEvent {
  const DiscoverFiltersUpdated(this.filters);

  final PantryFilters filters;

  @override
  List<Object?> get props => [filters];
}

final class DiscoverQuickStartSelected extends DiscoverEvent {
  const DiscoverQuickStartSelected(this.preset, this.prompt, {this.filters});

  final QuickStartPreset preset;
  final String prompt;
  final PantryFilters? filters;

  @override
  List<Object?> get props => [preset, prompt, filters];
}

final class DiscoverVoiceTranscriptAppended extends DiscoverEvent {
  const DiscoverVoiceTranscriptAppended(this.transcript);

  final String transcript;

  @override
  List<Object?> get props => [transcript];
}

final class DiscoverSheetQueryChanged extends DiscoverEvent {
  const DiscoverSheetQueryChanged(this.query, {this.lang = 'vi'});

  final String query;
  final String lang;

  @override
  List<Object?> get props => [query, lang];
}

final class DiscoverSheetIngredientToggled extends DiscoverEvent {
  const DiscoverSheetIngredientToggled(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class DiscoverSheetSelectionCleared extends DiscoverEvent {
  const DiscoverSheetSelectionCleared();
}

final class DiscoverSheetRecentSelected extends DiscoverEvent {
  const DiscoverSheetRecentSelected(this.ingredients);

  final List<String> ingredients;

  @override
  List<Object?> get props => [ingredients];
}

final class DiscoverFridgeApplied extends DiscoverEvent {
  const DiscoverFridgeApplied(this.prompt, this.ingredients);

  final String prompt;
  final List<String> ingredients;

  @override
  List<Object?> get props => [prompt, ingredients];
}
