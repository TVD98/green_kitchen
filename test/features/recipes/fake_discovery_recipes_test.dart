import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/recipes/data/datasources/fake_discovery_recipes.dart';
import 'package:green_kitchen/features/recipes/data/models/recipe_models.dart';

void main() {
  test('fake discovery recipes parse into RecipeModel', () {
    final models = fakeDiscoveryRecipeModels();
    expect(models, hasLength(3));
    expect(models.first.title, 'Đậu hũ sốt tiêu xanh');
    expect(models.first.timeMinutes, 25);
    expect(models.first.difficulty, 'easy');
    expect(
      fakeDiscoveryRecipeById('fake_rec_mushroom_soup')?.slug,
      'canh-nam-rau-cu',
    );
  });

  test('RecipeModel.fromJson matches API wire fields', () {
    final recipe = RecipeModel.fromJson(fakeDiscoveryRecipeJson.first);
    final entity = recipe.toEntity();
    expect(entity.ingredients, isNotEmpty);
    expect(entity.steps.first.order, 1);
    expect(entity.nutrition?.calories, 280);
    expect(entity.imageUrl, isNotNull);
    expect(entity.imageUrl, contains('unsplash.com'));
  });
}
