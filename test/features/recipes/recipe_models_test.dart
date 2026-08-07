import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/recipes/data/models/recipe_models.dart';

void main() {
  test('RecipeModel maps snake_case API payload to entity', () {
    final model = RecipeModel.fromJson({
      'id': 'r1',
      'title': 'Trứng chiên',
      'slug': 'trung-chien',
      'description': 'Món đơn giản',
      'time_minutes': 15,
      'difficulty': 'easy',
      'servings': 2,
      'tags': ['viet'],
      'steps': [
        {'order': 1, 'text': 'Đập trứng'},
      ],
      'ingredients': [
        {'name': 'trứng', 'quantity': '2 quả'},
      ],
      'nutrition': {
        'calories': 200,
        'protein_g': 12,
        'carbs_g': 2,
        'fat_g': 14,
      },
      'image_url': 'https://example.com/trung-chien.jpg',
      'source': 'gemini',
      'created_at': '2026-07-26T10:00:00.000Z',
    });

    final entity = model.toEntity();

    expect(entity.id, 'r1');
    expect(entity.timeMinutes, 15);
    expect(entity.ingredients.first.name, 'trứng');
    expect(entity.nutrition?.calories, 200);
    expect(entity.imageUrl, 'https://example.com/trung-chien.jpg');
  });

  test('IngredientModel maps canonical_name', () {
    final model = IngredientModel.fromJson({
      'id': 'i1',
      'canonical_name': 'trứng gà',
      'category': 'protein',
      'aliases': ['trung ga'],
    });

    expect(model.toEntity().canonicalName, 'trứng gà');
  });
}
