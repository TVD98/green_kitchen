import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:green_kitchen/features/suggestions/domain/utils/mock_popularity.dart';

Recipe _recipe(String id, String title) {
  return Recipe(
    id: id,
    title: title,
    slug: id,
    description: '',
    timeMinutes: 10,
    difficulty: 'easy',
    servings: 1,
    tags: const [],
    steps: const [],
    ingredients: const [],
    source: 'gemini',
    createdAt: DateTime.utc(2026),
  );
}

void main() {
  test('mock view count is stable per recipe id', () {
    final recipe = _recipe('abc-123', 'Stable');
    expect(mockViewCountForRecipe(recipe), mockViewCountForRecipe(recipe));
  });

  test('mock view count differs across ids', () {
    final a = mockViewCountForRecipe(_recipe('a', 'A'));
    final b = mockViewCountForRecipe(_recipe('b', 'B'));
    expect(a, isNot(equals(b)));
  });

  test('formatMockViewCount renders thousands', () {
    expect(formatMockViewCount(1200), '1.2k');
  });
}
