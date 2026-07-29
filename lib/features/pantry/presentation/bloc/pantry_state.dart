part of 'pantry_bloc.dart';

enum PantryStatus { initial, loading, success, empty, failure }

final class PantryState extends Equatable {
  const PantryState({
    this.status = PantryStatus.initial,
    this.recipes = const [],
    this.failure,
  });

  final PantryStatus status;
  final List<Recipe> recipes;
  final Failure? failure;

  PantryState copyWith({
    PantryStatus? status,
    List<Recipe>? recipes,
    Failure? failure,
  }) {
    return PantryState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, recipes, failure];
}
