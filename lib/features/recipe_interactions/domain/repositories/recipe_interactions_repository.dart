import '../entities/recipe_interaction.dart';

abstract class RecipeInteractionsRepository {
  Future<void> recordViewed(String recipeId);

  Future<bool> toggleSaved(String recipeId);

  Future<bool> isSaved(String recipeId);

  Future<List<RecipeInteractionRecord>> getViewedRecords();

  Future<List<RecipeInteractionRecord>> getSavedRecords();

  Future<List<PantrySession>> getPantrySessions();

  Future<void> savePantrySession(PantrySession session);

  Future<List<DiscoverySession>> getDiscoverySessions();

  Future<void> saveDiscoverySession(DiscoverySession session);

  Future<List<List<String>>> getRecentIngredientSets();

  Future<void> saveRecentIngredientSet(List<String> ingredients);

  Future<void> clearRecentIngredientSets();
}
