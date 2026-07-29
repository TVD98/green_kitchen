part of 'discover_bloc.dart';

sealed class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

final class DiscoverStarted extends DiscoverEvent {
  const DiscoverStarted();
}

final class DiscoverQueryChanged extends DiscoverEvent {
  const DiscoverQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class DiscoverIngredientAdded extends DiscoverEvent {
  const DiscoverIngredientAdded(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class DiscoverIngredientRemoved extends DiscoverEvent {
  const DiscoverIngredientRemoved(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class DiscoverRecentSelected extends DiscoverEvent {
  const DiscoverRecentSelected(this.ingredients);

  final List<String> ingredients;

  @override
  List<Object?> get props => [ingredients];
}

final class DiscoverFiltersUpdated extends DiscoverEvent {
  const DiscoverFiltersUpdated(this.filters);

  final PantryFilters filters;

  @override
  List<Object?> get props => [filters];
}
