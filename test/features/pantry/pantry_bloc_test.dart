import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/pantry/presentation/bloc/pantry_bloc.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/entities/recipe_interaction.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchPantry extends Mock implements SearchPantry {}

class _MockSavePantrySession extends Mock implements SavePantrySession {}

Recipe _sampleRecipe() {
  return Recipe(
    id: 'r1',
    title: 'Test',
    slug: 'test',
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
  late _MockSearchPantry searchPantry;
  late _MockSavePantrySession savePantrySession;

  setUpAll(() {
    registerFallbackValue(
      PantrySession(
        ingredients: const ['trứng'],
        recipeIds: const ['r1'],
        searchedAt: DateTime.utc(2026),
      ),
    );
  });

  setUp(() {
    searchPantry = _MockSearchPantry();
    savePantrySession = _MockSavePantrySession();
  });

  blocTest<PantryBloc, PantryState>(
    'persists pantry session on success',
    build: () {
      when(
        () => searchPantry(
          ingredients: any(named: 'ingredients'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) async => Success([_sampleRecipe()]));
      when(() => savePantrySession(any())).thenAnswer((_) async {});
      return PantryBloc(
        searchPantry: searchPantry,
        savePantrySession: savePantrySession,
        ingredients: const ['trứng'],
      );
    },
    act: (bloc) => bloc.add(const PantryStarted()),
    verify: (_) {
      verify(() => savePantrySession(any())).called(1);
    },
  );

  blocTest<PantryBloc, PantryState>(
    'retry event re-runs search after failure',
    build: () {
      var calls = 0;
      when(
        () => searchPantry(
          ingredients: any(named: 'ingredients'),
          filters: any(named: 'filters'),
        ),
      ).thenAnswer((_) async {
        calls += 1;
        if (calls == 1) {
          return const Err(NetworkFailure());
        }
        return Success([_sampleRecipe()]);
      });
      when(() => savePantrySession(any())).thenAnswer((_) async {});
      return PantryBloc(
        searchPantry: searchPantry,
        savePantrySession: savePantrySession,
        ingredients: const ['trứng'],
      );
    },
    act: (bloc) => bloc
      ..add(const PantryStarted())
      ..add(const PantryRetried()),
    verify: (bloc) {
      expect(bloc.state.status, PantryStatus.success);
    },
  );
}
