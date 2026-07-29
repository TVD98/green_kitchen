import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:green_kitchen/core/di/injection.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/core/storage/key_value_store.dart';
import 'package:green_kitchen/features/recipes/domain/entities/pantry_filters.dart';
import 'package:green_kitchen/features/recipes/domain/entities/recipe.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:green_kitchen/features/suggestions/presentation/pages/suggestions_page.dart';
import 'package:green_kitchen/l10n/app_localizations.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSearchRecipes extends Mock implements SearchRecipes {}

Recipe _recipe() {
  return Recipe(
    id: 'r1',
    title: 'Sample',
    slug: 'sample',
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
  late _MockSearchRecipes searchRecipes;

  setUpAll(() {
    registerFallbackValue(const RecipeSearchQuery());
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({'locale_preference': 'en'});
    await GetIt.I.reset();
    searchRecipes = _MockSearchRecipes();
    when(() => searchRecipes(any())).thenAnswer((_) async => Success([_recipe()]));
    await configureDependencies(keyValueStore: MemoryKeyValueStore());
    GetIt.I.unregister<SearchRecipes>();
    GetIt.I.registerFactory<SearchRecipes>(() => searchRecipes);
  });

  testWidgets('suggestions section headers are localized', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SuggestionsPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Featured today'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Quick meals'), findsOneWidget);
    expect(find.text('Easy recipes'), findsOneWidget);
  });
}
