import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/entities/recipe_interaction.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipe_library/presentation/bloc/recipe_library_bloc.dart';
import 'package:green_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetViewedRecords extends Mock implements GetViewedRecords {}

class _MockGetSavedRecords extends Mock implements GetSavedRecords {}

class _MockGetPantrySessions extends Mock implements GetPantrySessions {}

class _MockGetRecipesByIds extends Mock implements GetRecipesByIds {}

Recipe _recipe(String id) {
  return Recipe(
    id: id,
    title: 'Recipe $id',
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
  late _MockGetViewedRecords getViewedRecords;
  late _MockGetSavedRecords getSavedRecords;
  late _MockGetPantrySessions getPantrySessions;
  late _MockGetRecipesByIds getRecipesByIds;

  setUp(() {
    getViewedRecords = _MockGetViewedRecords();
    getSavedRecords = _MockGetSavedRecords();
    getPantrySessions = _MockGetPantrySessions();
    getRecipesByIds = _MockGetRecipesByIds();

    when(() => getViewedRecords()).thenAnswer(
      (_) async => [
        RecipeInteractionRecord(
          recipeId: 'a',
          timestamp: DateTime.utc(2026, 1, 2),
        ),
      ],
    );
    when(() => getSavedRecords()).thenAnswer(
      (_) async => [
        RecipeInteractionRecord(
          recipeId: 'b',
          timestamp: DateTime.utc(2026, 1, 3),
        ),
      ],
    );
    when(() => getPantrySessions()).thenAnswer((_) async => []);
    when(() => getRecipesByIds(any())).thenAnswer(
      (invocation) async {
        final ids = invocation.positionalArguments.first as List<String>;
        return Success(ids.map(_recipe).toList(growable: false));
      },
    );
  });

  blocTest<RecipeLibraryBloc, RecipeLibraryState>(
    'All segment dedupes viewed and saved ids',
    build: () => RecipeLibraryBloc(
      getViewedRecords: getViewedRecords,
      getSavedRecords: getSavedRecords,
      getPantrySessions: getPantrySessions,
      getRecipesByIds: getRecipesByIds,
    ),
    act: (bloc) => bloc.add(const RecipeLibraryStarted()),
    verify: (bloc) {
      expect(bloc.state.recipes.map((r) => r.id), ['b', 'a']);
    },
  );

  blocTest<RecipeLibraryBloc, RecipeLibraryState>(
    'Saved segment loads saved recipes',
    build: () => RecipeLibraryBloc(
      getViewedRecords: getViewedRecords,
      getSavedRecords: getSavedRecords,
      getPantrySessions: getPantrySessions,
      getRecipesByIds: getRecipesByIds,
    ),
    act: (bloc) => bloc.add(
      const RecipeLibrarySegmentChanged(LibrarySegment.saved),
    ),
    verify: (bloc) {
      expect(bloc.state.recipes.single.id, 'b');
    },
  );
}
