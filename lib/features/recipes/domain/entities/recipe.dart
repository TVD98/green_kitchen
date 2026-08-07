import 'package:equatable/equatable.dart';

class RecipeIngredient extends Equatable {
  const RecipeIngredient({required this.name, required this.quantity});

  final String name;
  final String quantity;

  @override
  List<Object?> get props => [name, quantity];
}

class RecipeStep extends Equatable {
  const RecipeStep({required this.order, required this.text});

  final int order;
  final String text;

  @override
  List<Object?> get props => [order, text];
}

class RecipeNutrition extends Equatable {
  const RecipeNutrition({
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
  });

  final int? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;

  @override
  List<Object?> get props => [calories, proteinG, carbsG, fatG];
}

class Recipe extends Equatable {
  const Recipe({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.timeMinutes,
    required this.difficulty,
    required this.servings,
    required this.tags,
    required this.steps,
    required this.ingredients,
    required this.source,
    required this.createdAt,
    this.nutrition,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String slug;
  final String description;
  final int timeMinutes;
  final String difficulty;
  final int servings;
  final List<String> tags;
  final List<RecipeStep> steps;
  final List<RecipeIngredient> ingredients;
  final RecipeNutrition? nutrition;
  final String source;
  final DateTime createdAt;
  /// Optional cover / intro image (API `image_url` when present).
  final String? imageUrl;

  @override
  List<Object?> get props => [id, title, slug, imageUrl];
}
