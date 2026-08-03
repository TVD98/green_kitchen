import '../../domain/entities/user_profile_settings.dart';

class UserPreferencesModel {
  UserPreferencesModel({
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

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      dietaryStyle: json['dietary_style'] as String?,
      spiceLevel: json['spice_level'] as String?,
      cuisinePreferences: _stringList(json['cuisine_preferences']),
      dislikedIngredients: _stringList(json['disliked_ingredients']),
      healthGoals: _stringList(json['health_goals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dietary_style': dietaryStyle,
      'spice_level': spiceLevel,
      'cuisine_preferences': cuisinePreferences,
      'disliked_ingredients': dislikedIngredients,
      'health_goals': healthGoals,
    };
  }

  UserPreferences toEntity() {
    return UserPreferences(
      dietaryStyle: dietaryStyle,
      spiceLevel: spiceLevel,
      cuisinePreferences: cuisinePreferences,
      dislikedIngredients: dislikedIngredients,
      healthGoals: healthGoals,
    );
  }

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      dietaryStyle: entity.dietaryStyle,
      spiceLevel: entity.spiceLevel,
      cuisinePreferences: entity.cuisinePreferences,
      dislikedIngredients: entity.dislikedIngredients,
      healthGoals: entity.healthGoals,
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList(growable: false);
  }
}

class UserAllergyModel {
  UserAllergyModel({
    required this.ingredientId,
    required this.name,
    this.nameVi,
    this.nameEn,
  });

  final String ingredientId;
  final String name;
  final String? nameVi;
  final String? nameEn;

  factory UserAllergyModel.fromJson(
    Map<String, dynamic> json, {
    String lang = 'vi',
  }) {
    final nameVi = json['name_vi'] as String?;
    final nameEn = json['name_en'] as String?;
    final fallback = json['name'] as String? ?? '';
    final localized = lang == 'en'
        ? (nameEn != null && nameEn.trim().isNotEmpty ? nameEn.trim() : fallback)
        : (nameVi != null && nameVi.trim().isNotEmpty ? nameVi.trim() : fallback);
    return UserAllergyModel(
      ingredientId: json['ingredient_id'] as String,
      name: localized,
      nameVi: nameVi,
      nameEn: nameEn,
    );
  }

  UserAllergy toEntity() {
    return UserAllergy(
      ingredientId: ingredientId,
      name: name,
    );
  }
}
