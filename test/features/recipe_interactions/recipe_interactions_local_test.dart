import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/recipe_interactions/data/datasources/recipe_interactions_local_data_source.dart';
import 'package:green_kitchen/features/recipe_interactions/data/repositories/recipe_interactions_repository_impl.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/entities/recipe_interaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late RecipeInteractionsRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = RecipeInteractionsRepositoryImpl(
      RecipeInteractionsLocalDataSource(prefs),
    );
  });

  test('record viewed dedupes and keeps newest first', () async {
    await repository.recordViewed('a');
    await Future<void>.delayed(const Duration(milliseconds: 2));
    await repository.recordViewed('b');
    await repository.recordViewed('a');

    final viewed = await repository.getViewedRecords();
    expect(viewed.first.recipeId, 'a');
    expect(viewed.map((r) => r.recipeId), ['a', 'b']);
  });

  test('toggle saved adds and removes', () async {
    expect(await repository.toggleSaved('x'), isTrue);
    expect(await repository.isSaved('x'), isTrue);
    expect(await repository.toggleSaved('x'), isFalse);
    expect(await repository.isSaved('x'), isFalse);
  });

  test('pantry session appends recent ingredient sets', () async {
    await repository.savePantrySession(
      PantrySession(
        ingredients: ['trứng', 'cà chua'],
        recipeIds: ['r1'],
        searchedAt: DateTime.utc(2026, 7, 26),
      ),
    );

    final recent = await repository.getRecentIngredientSets();
    expect(recent.first, ['trứng', 'cà chua']);
  });
}
