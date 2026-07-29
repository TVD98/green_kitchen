import '../entities/recipe_interaction.dart';
import '../repositories/recipe_interactions_repository.dart';

class RecordRecipeViewed {
  RecordRecipeViewed(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<void> call(String recipeId) => _repository.recordViewed(recipeId);
}

class ToggleRecipeSaved {
  ToggleRecipeSaved(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<bool> call(String recipeId) => _repository.toggleSaved(recipeId);
}

class IsRecipeSaved {
  IsRecipeSaved(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<bool> call(String recipeId) => _repository.isSaved(recipeId);
}

class GetViewedRecords {
  GetViewedRecords(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<List<RecipeInteractionRecord>> call() =>
      _repository.getViewedRecords();
}

class GetSavedRecords {
  GetSavedRecords(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<List<RecipeInteractionRecord>> call() =>
      _repository.getSavedRecords();
}

class GetPantrySessions {
  GetPantrySessions(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<List<PantrySession>> call() => _repository.getPantrySessions();
}

class SavePantrySession {
  SavePantrySession(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<void> call(PantrySession session) =>
      _repository.savePantrySession(session);
}

class GetRecentIngredientSets {
  GetRecentIngredientSets(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<List<List<String>>> call() => _repository.getRecentIngredientSets();
}

class SaveRecentIngredientSet {
  SaveRecentIngredientSet(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<void> call(List<String> ingredients) =>
      _repository.saveRecentIngredientSet(ingredients);
}

class SaveDiscoverySession {
  SaveDiscoverySession(this._repository);

  final RecipeInteractionsRepository _repository;

  Future<void> call(DiscoverySession session) =>
      _repository.saveDiscoverySession(session);
}
