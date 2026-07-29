import '../../../../core/error/result.dart';
import '../entities/ingredient.dart';
import '../entities/pantry_filters.dart';
import '../entities/recipe.dart';
import '../repositories/recipes_repository.dart';

class SearchRecipes {
  SearchRecipes(this._repository);

  final RecipesRepository _repository;

  Future<Result<List<Recipe>>> call(RecipeSearchQuery query) =>
      _repository.search(query);
}

class GetRecipeById {
  GetRecipeById(this._repository);

  final RecipesRepository _repository;

  Future<Result<Recipe>> call(String id) => _repository.getById(id);
}

class GetRecipesByIds {
  GetRecipesByIds(this._repository);

  final RecipesRepository _repository;

  Future<Result<List<Recipe>>> call(List<String> ids) =>
      _repository.getByIds(ids);
}

class SearchIngredients {
  SearchIngredients(this._repository);

  final IngredientsRepository _repository;

  Future<Result<List<Ingredient>>> call(String query, {String lang = 'vi'}) =>
      _repository.search(query, lang: lang);
}

class SearchPantry {
  SearchPantry(this._repository);

  final PantryRepository _repository;

  Future<Result<List<Recipe>>> call({
    required List<String> ingredients,
    PantryFilters? filters,
  }) =>
      _repository.search(ingredients: ingredients, filters: filters);
}
