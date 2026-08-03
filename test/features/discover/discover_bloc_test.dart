import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:green_kitchen/features/discover/presentation/utils/quick_start_preset.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipes/domain/entities/ingredient.dart';
import 'package:green_kitchen/features/recipes/domain/entities/pantry_filters.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchIngredients extends Mock implements SearchIngredients {}

class _MockGetRecentIngredientSets extends Mock
    implements GetRecentIngredientSets {}

class _MockSaveRecentIngredientSet extends Mock
    implements SaveRecentIngredientSet {}

void main() {
  late _MockSearchIngredients searchIngredients;
  late _MockGetRecentIngredientSets getRecentIngredientSets;
  late _MockSaveRecentIngredientSet saveRecentIngredientSet;

  setUp(() {
    searchIngredients = _MockSearchIngredients();
    getRecentIngredientSets = _MockGetRecentIngredientSets();
    saveRecentIngredientSet = _MockSaveRecentIngredientSet();
    when(() => getRecentIngredientSets()).thenAnswer((_) async => []);
    when(() => saveRecentIngredientSet(any())).thenAnswer((_) async {});
  });

  DiscoverBloc buildBloc() => DiscoverBloc(
        searchIngredients: searchIngredients,
        getRecentIngredientSets: getRecentIngredientSets,
        saveRecentIngredientSet: saveRecentIngredientSet,
      );

  blocTest<DiscoverBloc, DiscoverState>(
    'disables search when prompt is empty',
    build: buildBloc,
    act: (bloc) => bloc.add(const DiscoverStarted()),
    verify: (bloc) {
      expect(bloc.state.canSearch, isFalse);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'enables search when prompt is non-empty',
    build: buildBloc,
    act: (bloc) => bloc.add(const DiscoverPromptChanged('món chay')),
    verify: (bloc) {
      expect(bloc.state.canSearch, isTrue);
      expect(bloc.state.prompt, 'món chay');
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'caps prompt at 500 characters',
    build: buildBloc,
    act: (bloc) => bloc.add(DiscoverPromptChanged('a' * 600)),
    verify: (bloc) {
      expect(bloc.state.prompt.length, 500);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'toggles sheet ingredient selection',
    build: buildBloc,
    act: (bloc) {
      bloc
        ..add(const DiscoverSheetIngredientToggled('cà chua'))
        ..add(const DiscoverSheetIngredientToggled('dưa leo'))
        ..add(const DiscoverSheetIngredientToggled('cà chua'));
    },
    verify: (bloc) {
      expect(bloc.state.sheetSelectedIngredients, ['dưa leo']);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'enforces max 7 sheet ingredients',
    build: buildBloc,
    act: (bloc) {
      for (var i = 0; i < 8; i++) {
        bloc.add(DiscoverSheetIngredientToggled('item $i'));
      }
    },
    verify: (bloc) {
      expect(bloc.state.sheetSelectedIngredients.length, 7);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'loads ingredient suggestions for sheet query',
    build: () {
      when(() => searchIngredients('tr', lang: any(named: 'lang'))).thenAnswer(
        (_) async => const Success([
          Ingredient(
            id: '1',
            canonicalName: 'trứng',
            category: 'protein',
            aliases: [],
          ),
        ]),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const DiscoverSheetQueryChanged('tr')),
    verify: (bloc) {
      expect(bloc.state.sheetSuggestions.single.canonicalName, 'trứng');
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'quick start sets prompt and filters',
    build: buildBloc,
    act: (bloc) => bloc.add(
      const DiscoverQuickStartSelected(
        QuickStartPreset.fastHealthy,
        'fast healthy',
        filters: PantryFilters(maxTime: 30, tags: ['healthy']),
      ),
    ),
    verify: (bloc) {
      expect(bloc.state.prompt, 'fast healthy');
      expect(bloc.state.filters.maxTime, 30);
      expect(bloc.state.filters.tags, ['healthy']);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'fridge apply saves recent set, prompt, and sheet state',
    build: () {
      when(() => searchIngredients('cà', lang: any(named: 'lang'))).thenAnswer(
        (_) async => const Success([
          Ingredient(
            id: '1',
            canonicalName: 'cà chua',
            category: 'vegetable',
            aliases: [],
          ),
        ]),
      );
      return buildBloc();
    },
    act: (bloc) async {
      bloc
        ..add(const DiscoverSheetQueryChanged('cà'))
        ..add(const DiscoverSheetIngredientToggled('cà chua'))
        ..add(
          const DiscoverFridgeApplied(
            'Tôi có: cà chua. Gợi ý món nấu.',
            ['cà chua'],
          ),
        );
    },
    verify: (bloc) {
      expect(bloc.state.prompt, contains('cà chua'));
      expect(bloc.state.sheetQuery, 'cà');
      expect(bloc.state.sheetSelectedIngredients, ['cà chua']);
      expect(bloc.state.sheetSuggestions.single.canonicalName, 'cà chua');
      verify(() => saveRecentIngredientSet(['cà chua'])).called(1);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'content reset clears prompt, ingredients, and recent searches',
    build: buildBloc,
    seed: () => const DiscoverState(
      prompt: 'Tôi có: cà chua. Gợi ý món nấu.',
      sheetQuery: 'cà',
      sheetSelectedIngredients: ['cà chua'],
      recentIngredientSets: [
        ['cà chua'],
        ['trứng', 'cà chua'],
      ],
      filters: PantryFilters(maxTime: 30, tags: ['healthy']),
    ),
    act: (bloc) => bloc.add(const DiscoverContentReset()),
    verify: (bloc) {
      expect(bloc.state.prompt, isEmpty);
      expect(bloc.state.sheetQuery, isEmpty);
      expect(bloc.state.sheetSelectedIngredients, isEmpty);
      expect(bloc.state.recentIngredientSets, isEmpty);
      expect(bloc.state.filters, const PantryFilters());
    },
  );
}
