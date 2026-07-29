import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:green_kitchen/features/recipes/presentation/bloc/recipe_detail_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetRecipeById extends Mock implements GetRecipeById {}

class _MockRecordRecipeViewed extends Mock implements RecordRecipeViewed {}

class _MockToggleRecipeSaved extends Mock implements ToggleRecipeSaved {}

class _MockIsRecipeSaved extends Mock implements IsRecipeSaved {}

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
  late _MockGetRecipeById getRecipeById;
  late _MockRecordRecipeViewed recordRecipeViewed;
  late _MockToggleRecipeSaved toggleRecipeSaved;
  late _MockIsRecipeSaved isRecipeSaved;

  setUp(() {
    getRecipeById = _MockGetRecipeById();
    recordRecipeViewed = _MockRecordRecipeViewed();
    toggleRecipeSaved = _MockToggleRecipeSaved();
    isRecipeSaved = _MockIsRecipeSaved();
    when(() => isRecipeSaved('r1')).thenAnswer((_) async => false);
    when(() => recordRecipeViewed('r1')).thenAnswer((_) async {});
    when(() => getRecipeById('r1')).thenAnswer((_) async => Success(_sampleRecipe()));
  });

  blocTest<RecipeDetailBloc, RecipeDetailState>(
    'records viewed and loads recipe',
    build: () => RecipeDetailBloc(
      getRecipeById: getRecipeById,
      recordRecipeViewed: recordRecipeViewed,
      toggleRecipeSaved: toggleRecipeSaved,
      isRecipeSaved: isRecipeSaved,
      recipeId: 'r1',
    ),
    act: (bloc) => bloc.add(const RecipeDetailStarted()),
    verify: (_) {
      verify(() => recordRecipeViewed('r1')).called(1);
    },
  );

  blocTest<RecipeDetailBloc, RecipeDetailState>(
    'toggle save updates saved state',
    build: () {
      when(() => toggleRecipeSaved('r1')).thenAnswer((_) async => true);
      return RecipeDetailBloc(
        getRecipeById: getRecipeById,
        recordRecipeViewed: recordRecipeViewed,
        toggleRecipeSaved: toggleRecipeSaved,
        isRecipeSaved: isRecipeSaved,
        recipeId: 'r1',
      );
    },
    seed: () => RecipeDetailState(
      status: RecipeDetailStatus.success,
      recipe: _sampleRecipe(),
    ),
    act: (bloc) => bloc.add(const RecipeDetailSaveToggled()),
    verify: (bloc) {
      expect(bloc.state.isSaved, isTrue);
    },
  );
}
