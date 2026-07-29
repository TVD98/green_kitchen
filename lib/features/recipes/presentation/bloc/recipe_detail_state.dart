part of 'recipe_detail_bloc.dart';

enum RecipeDetailStatus { initial, loading, success, notFound, failure }

final class RecipeDetailState extends Equatable {
  const RecipeDetailState({
    this.status = RecipeDetailStatus.initial,
    this.recipe,
    this.isSaved = false,
    this.failure,
  });

  final RecipeDetailStatus status;
  final Recipe? recipe;
  final bool isSaved;
  final Failure? failure;

  RecipeDetailState copyWith({
    RecipeDetailStatus? status,
    Recipe? recipe,
    bool? isSaved,
    Failure? failure,
  }) {
    return RecipeDetailState(
      status: status ?? this.status,
      recipe: recipe ?? this.recipe,
      isSaved: isSaved ?? this.isSaved,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, recipe, isSaved, failure];
}
