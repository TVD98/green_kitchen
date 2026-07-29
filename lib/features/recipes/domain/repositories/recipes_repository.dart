import '../../../../core/error/result.dart';
import '../entities/ingredient.dart';
import '../entities/pantry_filters.dart';
import '../entities/recipe.dart';

abstract class RecipesRepository {
  Future<Result<List<Recipe>>> search(RecipeSearchQuery query);

  Future<Result<Recipe>> getById(String id);

  Future<Result<List<Recipe>>> getByIds(List<String> ids);
}

abstract class IngredientsRepository {
  Future<Result<List<Ingredient>>> search(String query);
}

abstract class PantryRepository {
  Future<Result<List<Recipe>>> search({
    required List<String> ingredients,
    PantryFilters? filters,
  });
}

abstract class DiscoveryRepository {
  Future<Result<List<Recipe>>> search(DiscoverySearchQuery query);
}
