import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/profile/domain/entities/user_profile_settings.dart';
import 'package:green_kitchen/features/profile/domain/usecases/profile_usecases.dart';
import 'package:green_kitchen/features/profile/presentation/bloc/preferences_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetUserPreferences extends Mock implements GetUserPreferences {}

class _MockUpdateUserPreferences extends Mock
    implements UpdateUserPreferences {}

void main() {
  late _MockGetUserPreferences getPrefs;
  late _MockUpdateUserPreferences updatePrefs;

  setUp(() {
    getPrefs = _MockGetUserPreferences();
    updatePrefs = _MockUpdateUserPreferences();
    registerFallbackValue(const UserPreferences());
  });

  PreferencesBloc buildBloc() => PreferencesBloc(
        getUserPreferences: getPrefs,
        updateUserPreferences: updatePrefs,
      );

  blocTest<PreferencesBloc, PreferencesState>(
    'hydrates draft and baseline from GET',
    build: () {
      when(() => getPrefs()).thenAnswer(
        (_) async => const Success(
          UserPreferences(dietaryStyle: 'vegan', spiceLevel: 'mild'),
        ),
      );
      return buildBloc();
    },
    act: (bloc) => bloc.add(const PreferencesStarted()),
    expect: () => [
      isA<PreferencesState>()
          .having((s) => s.status, 'status', PreferencesStatus.loading),
      isA<PreferencesState>()
          .having((s) => s.status, 'status', PreferencesStatus.ready)
          .having((s) => s.draft?.dietaryStyle, 'style', 'vegan')
          .having((s) => s.isDirty, 'isDirty', false),
    ],
  );

  blocTest<PreferencesBloc, PreferencesState>(
    'edit marks dirty; save no-ops when unchanged',
    build: () {
      when(() => updatePrefs(any())).thenAnswer(
        (_) async => const Success(UserPreferences()),
      );
      return buildBloc();
    },
    seed: () => const PreferencesState(
      status: PreferencesStatus.ready,
      draft: UserPreferences(dietaryStyle: 'vegan'),
      baseline: UserPreferences(dietaryStyle: 'vegan'),
    ),
    act: (bloc) => bloc.add(const PreferencesSaveRequested()),
    expect: () => <PreferencesState>[],
    verify: (_) {
      verifyNever(() => updatePrefs(any()));
    },
  );

  blocTest<PreferencesBloc, PreferencesState>(
    'successful PUT updates draft/baseline and acks save',
    build: () {
      when(() => updatePrefs(any())).thenAnswer(
        (_) async => const Success(
          UserPreferences(dietaryStyle: 'vegetarian', spiceLevel: 'hot'),
        ),
      );
      return buildBloc();
    },
    seed: () => const PreferencesState(
      status: PreferencesStatus.ready,
      draft: UserPreferences(dietaryStyle: 'vegetarian', spiceLevel: 'hot'),
      baseline: UserPreferences(dietaryStyle: 'vegan', spiceLevel: 'mild'),
    ),
    act: (bloc) => bloc.add(const PreferencesSaveRequested()),
    expect: () => [
      isA<PreferencesState>().having((s) => s.saving, 'saving', true),
      isA<PreferencesState>()
          .having((s) => s.saving, 'saving', false)
          .having((s) => s.savedAck, 'savedAck', true)
          .having((s) => s.draft?.spiceLevel, 'spice', 'hot')
          .having((s) => s.isDirty, 'isDirty', false),
    ],
  );

  blocTest<PreferencesBloc, PreferencesState>(
    'failed PUT keeps draft and marks saveFailed',
    build: () {
      when(() => updatePrefs(any())).thenAnswer(
        (_) async => const Err(NetworkFailure()),
      );
      return buildBloc();
    },
    seed: () => const PreferencesState(
      status: PreferencesStatus.ready,
      draft: UserPreferences(dietaryStyle: 'omnivore'),
      baseline: UserPreferences(),
    ),
    act: (bloc) => bloc.add(const PreferencesSaveRequested()),
    expect: () => [
      isA<PreferencesState>().having((s) => s.saving, 'saving', true),
      isA<PreferencesState>()
          .having((s) => s.saving, 'saving', false)
          .having((s) => s.saveFailed, 'saveFailed', true)
          .having((s) => s.draft?.dietaryStyle, 'draft', 'omnivore')
          .having((s) => s.isDirty, 'isDirty', true),
    ],
  );
}
