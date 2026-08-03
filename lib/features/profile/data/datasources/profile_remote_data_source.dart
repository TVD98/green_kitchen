import 'package:dio/dio.dart';

import '../../../../core/network/api_envelope.dart';
import '../models/profile_models.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<UserPreferencesModel> getPreferences() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/me/preferences',
    );
    return parseApiData(response, UserPreferencesModel.fromJson);
  }

  Future<UserPreferencesModel> updatePreferences(
    UserPreferencesModel body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/users/me/preferences',
      data: body.toJson(),
    );
    return parseApiData(response, UserPreferencesModel.fromJson);
  }

  Future<List<UserAllergyModel>> getAllergies({String lang = 'vi'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/users/me/allergies',
      queryParameters: {'lang': lang},
    );
    return parseApiData(response, (data) => _parseAllergies(data, lang: lang));
  }

  Future<List<UserAllergyModel>> replaceAllergies(
    List<String> ingredientIds, {
    String lang = 'vi',
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '/users/me/allergies',
      queryParameters: {'lang': lang},
      data: {'ingredient_ids': ingredientIds},
    );
    return parseApiData(response, (data) => _parseAllergies(data, lang: lang));
  }

  static List<UserAllergyModel> _parseAllergies(
    Map<String, dynamic> data, {
    required String lang,
  }) {
    final list = data['allergies'];
    if (list is! List) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map((item) => UserAllergyModel.fromJson(item, lang: lang))
        .toList(growable: false);
  }
}
