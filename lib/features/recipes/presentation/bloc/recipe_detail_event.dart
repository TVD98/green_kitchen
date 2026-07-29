part of 'recipe_detail_bloc.dart';

sealed class RecipeDetailEvent extends Equatable {
  const RecipeDetailEvent();

  @override
  List<Object?> get props => [];
}

final class RecipeDetailStarted extends RecipeDetailEvent {
  const RecipeDetailStarted();
}

final class RecipeDetailSaveToggled extends RecipeDetailEvent {
  const RecipeDetailSaveToggled();
}
