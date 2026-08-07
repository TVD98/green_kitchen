import '../models/recipe_models.dart';
import 'discovery_remote_data_sources.dart';
import 'fake_discovery_recipes.dart';

/// Serves fake discovery recipes for `GET /recipes/:id` when using fake discovery.
class FakeAwareRecipesRemoteDataSource extends RecipesRemoteDataSource {
  FakeAwareRecipesRemoteDataSource({required super.dio});

  @override
  Future<RecipeModel> getById(String id) async {
    final fake = fakeDiscoveryRecipeById(id);
    if (fake != null) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return fake;
    }
    return super.getById(id);
  }
}
