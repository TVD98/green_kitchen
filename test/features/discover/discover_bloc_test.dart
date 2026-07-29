import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/discover/presentation/bloc/discover_bloc.dart';
import 'package:green_kitchen/features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import 'package:green_kitchen/features/recipes/domain/entities/ingredient.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockSearchIngredients extends Mock implements SearchIngredients {}

class _MockGetRecentIngredientSets extends Mock
    implements GetRecentIngredientSets {}

void main() {
  late _MockSearchIngredients searchIngredients;
  late _MockGetRecentIngredientSets getRecentIngredientSets;

  setUp(() {
    searchIngredients = _MockSearchIngredients();
    getRecentIngredientSets = _MockGetRecentIngredientSets();
    when(() => getRecentIngredientSets()).thenAnswer((_) async => []);
  });

  blocTest<DiscoverBloc, DiscoverState>(
    'disables search when no ingredients selected',
    build: () => DiscoverBloc(
      searchIngredients: searchIngredients,
      getRecentIngredientSets: getRecentIngredientSets,
    ),
    act: (bloc) => bloc.add(const DiscoverStarted()),
    verify: (bloc) {
      expect(bloc.state.canSearch, isFalse);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'does not add duplicate ingredient chips',
    build: () => DiscoverBloc(
      searchIngredients: searchIngredients,
      getRecentIngredientSets: getRecentIngredientSets,
    ),
    act: (bloc) {
      bloc
        ..add(const DiscoverIngredientAdded('trứng'))
        ..add(const DiscoverIngredientAdded('trứng'));
    },
    verify: (bloc) {
      expect(bloc.state.selectedIngredients, ['trứng']);
      expect(bloc.state.canSearch, isTrue);
    },
  );

  blocTest<DiscoverBloc, DiscoverState>(
    'loads ingredient suggestions for query',
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
      return DiscoverBloc(
        searchIngredients: searchIngredients,
        getRecentIngredientSets: getRecentIngredientSets,
      );
    },
    act: (bloc) => bloc.add(const DiscoverQueryChanged('tr')),
    verify: (bloc) {
      expect(bloc.state.suggestions.single.canonicalName, 'trứng');
    },
  );
}
