import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/profile/data/models/profile_models.dart';
import 'package:green_kitchen/features/profile/domain/entities/user_profile_settings.dart';
import 'package:green_kitchen/features/profile/domain/repositories/profile_repository.dart';
import 'package:green_kitchen/features/profile/domain/usecases/profile_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  group('UserPreferencesModel', () {
    test('fromJson maps snake_case fields', () {
      final model = UserPreferencesModel.fromJson({
        'dietary_style': 'vegan',
        'spice_level': 'hot',
        'cuisine_preferences': ['vietnamese', 'japanese'],
        'disliked_ingredients': ['cilantro'],
        'health_goals': ['high_protein'],
      });

      expect(model.dietaryStyle, 'vegan');
      expect(model.spiceLevel, 'hot');
      expect(model.cuisinePreferences, ['vietnamese', 'japanese']);
      expect(model.dislikedIngredients, ['cilantro']);
      expect(model.healthGoals, ['high_protein']);
    });

    test('toEntity and fromEntity roundtrip', () {
      const entity = UserPreferences(
        dietaryStyle: 'vegetarian',
        spiceLevel: 'mild',
        cuisinePreferences: ['thai'],
        dislikedIngredients: ['onion'],
        healthGoals: ['balanced'],
      );
      final model = UserPreferencesModel.fromEntity(entity);
      expect(model.toEntity(), entity);
      expect(model.toJson()['dietary_style'], 'vegetarian');
    });

    test('allergy fromJson prefers name_en when lang is en', () {
      final model = UserAllergyModel.fromJson(
        {
          'ingredient_id': 'ing1',
          'name': 'thịt gà',
          'name_vi': 'thịt gà',
          'name_en': 'chicken',
        },
        lang: 'en',
      );
      expect(
        model.toEntity(),
        const UserAllergy(ingredientId: 'ing1', name: 'chicken'),
      );
    });
  });

  group('profile use cases', () {
    late _MockProfileRepository repository;

    setUpAll(() {
      registerFallbackValue(const UserPreferences());
    });

    setUp(() {
      repository = _MockProfileRepository();
    });

    test('GetUserPreferences delegates to repository', () async {
      const prefs = UserPreferences(dietaryStyle: 'omnivore');
      when(() => repository.getPreferences())
          .thenAnswer((_) async => const Success(prefs));

      final result = await GetUserPreferences(repository)();
      expect(result.isSuccess, isTrue);
      verify(() => repository.getPreferences()).called(1);
    });

    test('ReplaceUserAllergies delegates ingredient ids', () async {
      when(() => repository.replaceAllergies(['a', 'b'])).thenAnswer(
        (_) async => const Success([
          UserAllergy(ingredientId: 'a', name: 'A'),
          UserAllergy(ingredientId: 'b', name: 'B'),
        ]),
      );

      final result = await ReplaceUserAllergies(repository)(['a', 'b']);
      expect(result.isSuccess, isTrue);
      result.fold((_) => fail('expected success'), (list) {
        expect(list.length, 2);
      });
    });

    test('UpdateUserPreferences surfaces failure', () async {
      when(() => repository.updatePreferences(any())).thenAnswer(
        (_) async => const Err(NetworkFailure()),
      );

      final result = await UpdateUserPreferences(repository)(
        const UserPreferences(spiceLevel: 'hot'),
      );
      expect(result.isFailure, isTrue);
    });
  });
}
