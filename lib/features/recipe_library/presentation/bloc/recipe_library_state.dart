part of 'recipe_library_bloc.dart';

enum RecipeLibraryStatus { initial, loading, success, empty, failure }

final class RecipeLibraryState extends Equatable {
  const RecipeLibraryState({
    this.segment = LibrarySegment.all,
    this.status = RecipeLibraryStatus.initial,
    this.recipes = const [],
    this.failure,
  });

  final LibrarySegment segment;
  final RecipeLibraryStatus status;
  final List<Recipe> recipes;
  final Failure? failure;

  RecipeLibraryState copyWith({
    LibrarySegment? segment,
    RecipeLibraryStatus? status,
    List<Recipe>? recipes,
    Failure? failure,
  }) {
    return RecipeLibraryState(
      segment: segment ?? this.segment,
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [segment, status, recipes, failure];
}
