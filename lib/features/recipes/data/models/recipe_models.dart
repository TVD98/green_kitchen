import '../../domain/entities/ingredient.dart';
import '../../domain/entities/recipe.dart';

class RecipeModel {
  RecipeModel({
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
  final List<Map<String, dynamic>> steps;
  final List<Map<String, dynamic>> ingredients;
  final Map<String, dynamic>? nutrition;
  final String source;
  final DateTime createdAt;
  final String? imageUrl;

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String? ?? '',
      timeMinutes: json['time_minutes'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'easy',
      servings: json['servings'] as int? ?? 1,
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(growable: false),
      steps: (json['steps'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .toList(growable: false),
      nutrition: json['nutrition'] as Map<String, dynamic>?,
      source: json['source'] as String? ?? 'gemini',
      createdAt: DateTime.parse(json['created_at'] as String),
      imageUrl: json['image_url'] as String?,
    );
  }

  Recipe toEntity() {
    return Recipe(
      id: id,
      title: title,
      slug: slug,
      description: description,
      timeMinutes: timeMinutes,
      difficulty: difficulty,
      servings: servings,
      tags: tags,
      steps: steps
          .map(
            (step) => RecipeStep(
              order: step['order'] as int? ?? 0,
              text: step['text'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      ingredients: ingredients
          .map(
            (item) => RecipeIngredient(
              name: item['name'] as String? ?? '',
              quantity: item['quantity'] as String? ?? '',
            ),
          )
          .toList(growable: false),
      nutrition: nutrition == null
          ? null
          : RecipeNutrition(
              calories: nutrition!['calories'] as int?,
              proteinG: (nutrition!['protein_g'] as num?)?.toDouble(),
              carbsG: (nutrition!['carbs_g'] as num?)?.toDouble(),
              fatG: (nutrition!['fat_g'] as num?)?.toDouble(),
            ),
      source: source,
      createdAt: createdAt,
      imageUrl: imageUrl,
    );
  }
}

class IngredientModel {
  IngredientModel({
    required this.id,
    required this.canonicalName,
    required this.category,
    required this.aliases,
  });

  final String id;
  final String canonicalName;
  final String category;
  final List<String> aliases;

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] as String,
      canonicalName: json['canonical_name'] as String,
      category: json['category'] as String? ?? '',
      aliases: (json['aliases'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(growable: false),
    );
  }

  Ingredient toEntity() {
    return Ingredient(
      id: id,
      canonicalName: canonicalName,
      category: category,
      aliases: aliases,
    );
  }
}
