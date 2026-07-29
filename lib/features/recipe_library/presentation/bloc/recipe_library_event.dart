part of 'recipe_library_bloc.dart';

sealed class RecipeLibraryEvent extends Equatable {
  const RecipeLibraryEvent();

  @override
  List<Object?> get props => [];
}

final class RecipeLibraryStarted extends RecipeLibraryEvent {
  const RecipeLibraryStarted();
}

final class RecipeLibrarySegmentChanged extends RecipeLibraryEvent {
  const RecipeLibrarySegmentChanged(this.segment);

  final LibrarySegment segment;

  @override
  List<Object?> get props => [segment];
}

final class RecipeLibraryRefreshed extends RecipeLibraryEvent {
  const RecipeLibraryRefreshed();
}
