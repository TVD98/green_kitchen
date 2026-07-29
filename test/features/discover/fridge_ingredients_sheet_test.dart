import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:green_kitchen/features/discover/presentation/widgets/fridge_ingredients_sheet.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/repositories/recipe_interactions_repository.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:green_kitchen/l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class _MockIngredientsRepository extends Mock implements IngredientsRepository {}

class _MockInteractionsRepository extends Mock
    implements RecipeInteractionsRepository {}

void main() {
  late _MockIngredientsRepository ingredientsRepository;
  late _MockInteractionsRepository interactionsRepository;

  setUp(() {
    ingredientsRepository = _MockIngredientsRepository();
    interactionsRepository = _MockInteractionsRepository();
    when(() => ingredientsRepository.search(any()))
        .thenAnswer((_) async => const Success([]));
    when(() => interactionsRepository.getRecentIngredientSets())
        .thenAnswer((_) async => []);
    when(() => interactionsRepository.saveRecentIngredientSet(any()))
        .thenAnswer((_) async {});
  });

  testWidgets('fridge sheet shows empty search hint initially', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider(
          create: (_) => DiscoverBloc(
            searchIngredients: SearchIngredients(ingredientsRepository),
            getRecentIngredientSets:
                GetRecentIngredientSets(interactionsRepository),
            saveRecentIngredientSet:
                SaveRecentIngredientSet(interactionsRepository),
          ),
          child: const Scaffold(body: FridgeIngredientsSheet()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Type an ingredient name to search'), findsOneWidget);
  });
}
