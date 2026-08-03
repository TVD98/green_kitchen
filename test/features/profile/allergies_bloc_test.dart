import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/profile/domain/entities/user_profile_settings.dart';
import 'package:green_kitchen/features/profile/domain/usecases/profile_usecases.dart';
import 'package:green_kitchen/features/profile/presentation/bloc/allergies_bloc.dart';
import 'package:green_kitchen/features/recipes/domain/entities/ingredient.dart';
import 'package:green_kitchen/features/recipes/domain/usecases/recipe_usecases.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetUserAllergies extends Mock implements GetUserAllergies {}

class _MockReplaceUserAllergies extends Mock implements ReplaceUserAllergies {}

class _MockSearchIngredients extends Mock implements SearchIngredients {}

void main() {
  late _MockGetUserAllergies getAllergies;
  late _MockReplaceUserAllergies replaceAllergies;
  late _MockSearchIngredients searchIngredients;

  setUp(() {
    getAllergies = _MockGetUserAllergies();
    replaceAllergies = _MockReplaceUserAllergies();
    searchIngredients = _MockSearchIngredients();
    registerFallbackValue(<String>[]);
  });

  AllergiesBloc buildBloc() => AllergiesBloc(
        getUserAllergies: getAllergies,
        replaceUserAllergies: replaceAllergies,
        searchIngredients: searchIngredients,
      );

  const peanut = UserAllergy(ingredientId: 'p1', name: 'Peanut');
  const milk = UserAllergy(ingredientId: 'm1', name: 'Milk');

  blocTest<AllergiesBloc, AllergiesState>(
    'hydrates selected and baseline from GET with locale lang',
    build: () {
      when(() => getAllergies(lang: any(named: 'lang'))).thenAnswer(
        (_) async => const Success([peanut]),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AllergiesStarted(lang: 'en')),
    verify: (_) {
      verify(() => getAllergies(lang: 'en')).called(1);
    },
    expect: () => [
      isA<AllergiesState>()
          .having((s) => s.status, 'status', AllergiesStatus.loading)
          .having((s) => s.lang, 'lang', 'en'),
      isA<AllergiesState>()
          .having((s) => s.status, 'status', AllergiesStatus.ready)
          .having((s) => s.selected, 'selected', [peanut])
          .having((s) => s.isDirty, 'isDirty', false),
    ],
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'toggle adds and removes from working set',
    build: buildBloc,
    seed: () => const AllergiesState(
      status: AllergiesStatus.ready,
      selected: [peanut],
      baseline: [peanut],
    ),
    act: (bloc) {
      bloc
        ..add(const AllergiesToggled(milk))
        ..add(const AllergiesToggled(peanut));
    },
    expect: () => [
      isA<AllergiesState>()
          .having(
            (s) => s.selected.map((e) => e.ingredientId).toList(),
            'ids',
            ['p1', 'm1'],
          )
          .having((s) => s.isDirty, 'isDirty', true),
      isA<AllergiesState>()
          .having(
            (s) => s.selected.map((e) => e.ingredientId).toList(),
            'ids',
            ['m1'],
          )
          .having((s) => s.isDirty, 'isDirty', true),
    ],
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'save no-ops when unchanged',
    build: () {
      when(
        () => replaceAllergies(any(), lang: any(named: 'lang')),
      ).thenAnswer((_) async => const Success([peanut]));
      return buildBloc();
    },
    seed: () => const AllergiesState(
      status: AllergiesStatus.ready,
      selected: [peanut],
      baseline: [peanut],
    ),
    act: (bloc) => bloc.add(const AllergiesSaveRequested()),
    expect: () => <AllergiesState>[],
    verify: (_) {
      verifyNever(() => replaceAllergies(any(), lang: any(named: 'lang')));
    },
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'save PUTs selected ids',
    build: () {
      when(
        () => replaceAllergies(any(), lang: any(named: 'lang')),
      ).thenAnswer((_) async => const Success([peanut, milk]));
      return buildBloc();
    },
    seed: () => const AllergiesState(
      status: AllergiesStatus.ready,
      lang: 'en',
      selected: [peanut, milk],
      baseline: [peanut],
    ),
    act: (bloc) => bloc.add(const AllergiesSaveRequested()),
    verify: (_) {
      verify(() => replaceAllergies(['p1', 'm1'], lang: 'en')).called(1);
    },
    expect: () => [
      isA<AllergiesState>().having((s) => s.saving, 'saving', true),
      isA<AllergiesState>()
          .having((s) => s.saving, 'saving', false)
          .having((s) => s.savedAck, 'savedAck', true)
          .having((s) => s.isDirty, 'isDirty', false),
    ],
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'empty save clears allergies',
    build: () {
      when(
        () => replaceAllergies(any(), lang: any(named: 'lang')),
      ).thenAnswer((_) async => const Success([]));
      return buildBloc();
    },
    seed: () => const AllergiesState(
      status: AllergiesStatus.ready,
      selected: [],
      baseline: [peanut],
    ),
    act: (bloc) => bloc.add(const AllergiesSaveRequested()),
    verify: (_) {
      verify(() => replaceAllergies(const [], lang: 'vi')).called(1);
    },
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'search debounce eventually loads results with lang',
    build: () {
      when(
        () => searchIngredients(any(), lang: any(named: 'lang')),
      ).thenAnswer(
        (_) async => const Success([
          Ingredient(
            id: 'i1',
            canonicalName: 'Peanut',
            category: 'protein',
            aliases: [],
          ),
        ]),
      );
      return buildBloc();
    },
    act: (bloc) =>
        bloc.add(const AllergiesQueryChanged('pea', lang: 'en')),
    wait: const Duration(milliseconds: 350),
    verify: (_) {
      verify(() => searchIngredients('pea', lang: 'en')).called(1);
    },
    expect: () => [
      isA<AllergiesState>()
          .having((s) => s.query, 'query', 'pea')
          .having((s) => s.lang, 'lang', 'en'),
      isA<AllergiesState>().having((s) => s.searching, 'searching', true),
      isA<AllergiesState>()
          .having((s) => s.searching, 'searching', false)
          .having((s) => s.results.first.id, 'id', 'i1'),
    ],
  );

  blocTest<AllergiesBloc, AllergiesState>(
    'save failure keeps working set',
    build: () {
      when(
        () => replaceAllergies(any(), lang: any(named: 'lang')),
      ).thenAnswer((_) async => const Err(NetworkFailure()));
      return buildBloc();
    },
    seed: () => const AllergiesState(
      status: AllergiesStatus.ready,
      selected: [peanut],
      baseline: [],
    ),
    act: (bloc) => bloc.add(const AllergiesSaveRequested()),
    expect: () => [
      isA<AllergiesState>().having((s) => s.saving, 'saving', true),
      isA<AllergiesState>()
          .having((s) => s.saveFailed, 'saveFailed', true)
          .having((s) => s.selected, 'selected', [peanut])
          .having((s) => s.isDirty, 'isDirty', true),
    ],
  );
}
