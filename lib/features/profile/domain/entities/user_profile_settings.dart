import 'package:equatable/equatable.dart';

class UserPreferences extends Equatable {
  const UserPreferences({
    this.dietaryStyle,
    this.spiceLevel,
    this.cuisinePreferences = const [],
    this.dislikedIngredients = const [],
    this.healthGoals = const [],
  });

  final String? dietaryStyle;
  final String? spiceLevel;
  final List<String> cuisinePreferences;
  final List<String> dislikedIngredients;
  final List<String> healthGoals;

  UserPreferences copyWith({
    String? dietaryStyle,
    String? spiceLevel,
    List<String>? cuisinePreferences,
    List<String>? dislikedIngredients,
    List<String>? healthGoals,
    bool clearDietaryStyle = false,
    bool clearSpiceLevel = false,
  }) {
    return UserPreferences(
      dietaryStyle:
          clearDietaryStyle ? null : (dietaryStyle ?? this.dietaryStyle),
      spiceLevel: clearSpiceLevel ? null : (spiceLevel ?? this.spiceLevel),
      cuisinePreferences: cuisinePreferences ?? this.cuisinePreferences,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      healthGoals: healthGoals ?? this.healthGoals,
    );
  }

  @override
  List<Object?> get props => [
        dietaryStyle,
        spiceLevel,
        cuisinePreferences,
        dislikedIngredients,
        healthGoals,
      ];
}

class UserAllergy extends Equatable {
  const UserAllergy({
    required this.ingredientId,
    required this.name,
  });

  final String ingredientId;
  final String name;

  @override
  List<Object?> get props => [ingredientId, name];
}
