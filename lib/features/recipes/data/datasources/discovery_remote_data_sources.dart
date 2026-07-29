import 'package:dio/dio.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/recipe_models.dart';

class RecipesRemoteDataSource {
  RecipesRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<RecipeModel>> search({
    String? q,
    int? maxTime,
    String? difficulty,
    List<String> tags = const [],
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/recipes',
      queryParameters: {
        if (q != null && q.isNotEmpty) 'q': q,
        if (maxTime != null) 'max_time': maxTime,
        if (difficulty != null && difficulty.isNotEmpty) 'difficulty': difficulty,
        if (tags.isNotEmpty) 'tags': tags.join(','),
      },
    );
    return parseApiDataList(response, RecipeModel.fromJson);
  }

  Future<RecipeModel> getById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/recipes/$id');
    return parseApiData(response, RecipeModel.fromJson);
  }
}

class IngredientsRemoteDataSource {
  IngredientsRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<IngredientModel>> search(
    String query, {
    String lang = 'vi',
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/ingredients',
      queryParameters: {
        'q': query,
        'lang': lang,
      },
    );
    return parseApiDataList(response, IngredientModel.fromJson);
  }
}

class PantryRemoteDataSource {
  PantryRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<RecipeModel>> search({
    required List<String> ingredients,
    int? maxTime,
    String? difficulty,
    List<String> tags = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/pantry/search',
      data: {
        'ingredients': ingredients,
        if (maxTime != null || difficulty != null || tags.isNotEmpty)
          'filters': {
            if (maxTime != null) 'max_time': maxTime,
            if (difficulty != null && difficulty.isNotEmpty)
              'difficulty': difficulty,
            if (tags.isNotEmpty) 'tags': tags,
          },
      },
    );
    return parseApiDataList(response, RecipeModel.fromJson);
  }
}

class DiscoveryRemoteDataSource {
  DiscoveryRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<RecipeModel>> search({
    required String prompt,
    bool usePreferences = false,
    bool excludeAllergies = false,
    int? maxTime,
    String? difficulty,
    List<String> tags = const [],
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/discovery/search',
      data: {
        'prompt': prompt,
        'options': {
          'use_preferences': usePreferences,
          'exclude_allergies': excludeAllergies,
        },
        if (maxTime != null || difficulty != null || tags.isNotEmpty)
          'filters': {
            if (maxTime != null) 'max_time': maxTime,
            if (difficulty != null && difficulty.isNotEmpty)
              'difficulty': difficulty,
            if (tags.isNotEmpty) 'tags': tags,
          },
      },
    );
    return parseApiDataList(response, RecipeModel.fromJson);
  }
}
