import 'package:equatable/equatable.dart';

class RecipeInteractionRecord extends Equatable {
  const RecipeInteractionRecord({
    required this.recipeId,
    required this.timestamp,
  });

  final String recipeId;
  final DateTime timestamp;

  @override
  List<Object?> get props => [recipeId, timestamp];
}

class PantrySession extends Equatable {
  const PantrySession({
    required this.ingredients,
    required this.recipeIds,
    required this.searchedAt,
  });

  final List<String> ingredients;
  final List<String> recipeIds;
  final DateTime searchedAt;

  @override
  List<Object?> get props => [ingredients, recipeIds, searchedAt];
}

class DiscoverySession extends Equatable {
  const DiscoverySession({
    required this.prompt,
    required this.recipeIds,
    required this.searchedAt,
  });

  final String prompt;
  final List<String> recipeIds;
  final DateTime searchedAt;

  @override
  List<Object?> get props => [prompt, recipeIds, searchedAt];
}
