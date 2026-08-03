import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_session.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_tokens.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_user.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:green_kitchen/features/profile/domain/entities/user_profile_settings.dart';
import 'package:green_kitchen/features/profile/domain/usecases/profile_usecases.dart';
import 'package:green_kitchen/features/profile/presentation/cubit/profile_hub_cubit.dart';
import 'package:green_kitchen/features/profile/presentation/pages/profile_page.dart';
import 'package:green_kitchen/l10n/app_localizations.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthBloc extends Mock implements AuthBloc {}

class _MockGetUserPreferences extends Mock implements GetUserPreferences {}

class _MockGetUserAllergies extends Mock implements GetUserAllergies {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late _MockAuthBloc authBloc;
  late _MockGetUserPreferences getPrefs;
  late _MockGetUserAllergies getAllergies;
  late ProfileHubCubit hubCubit;

  setUp(() {
    authBloc = _MockAuthBloc();
    getPrefs = _MockGetUserPreferences();
    getAllergies = _MockGetUserAllergies();

    when(() => authBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        AuthSession(
          user: const AuthUser(
            id: 'u1',
            email: 'user@example.com',
            fullName: 'Ada',
          ),
          tokens: const AuthTokens(
            accessToken: 'a',
            refreshToken: 'r',
            expiresIn: 3600,
          ),
        ),
      ),
    );
    when(() => getPrefs()).thenAnswer(
      (_) async => const Success(
        UserPreferences(dietaryStyle: 'vegan', spiceLevel: 'hot'),
      ),
    );
    when(() => getAllergies()).thenAnswer(
      (_) async => const Success([
        UserAllergy(ingredientId: '1', name: 'Peanut'),
        UserAllergy(ingredientId: '2', name: 'Milk'),
      ]),
    );
    hubCubit = ProfileHubCubit(
      getUserPreferences: getPrefs,
      getUserAllergies: getAllergies,
    );
  });

  tearDown(() async {
    await hubCubit.close();
  });

  testWidgets('profile hub shows preferences and allergies rows',
      (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/home/profile',
          builder: (context, state) => ProfilePage(hubCubit: hubCubit),
          routes: [
            GoRoute(
              path: 'preferences',
              builder: (context, state) => const Scaffold(
                body: Text('Preferences editor'),
              ),
            ),
            GoRoute(
              path: 'allergies',
              builder: (context, state) => const Scaffold(
                body: Text('Allergies editor'),
              ),
            ),
          ],
        ),
      ],
      initialLocation: '/home/profile',
    );

    await hubCubit.loadSummaries();

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Eating preferences'), findsOneWidget);
    expect(find.text('Allergies'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('Vegan · Hot'), findsOneWidget);
    expect(find.text('2 ingredients'), findsOneWidget);

    await tester.tap(find.text('Eating preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Preferences editor'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allergies'));
    await tester.pumpAndSettle();
    expect(find.text('Allergies editor'), findsOneWidget);
  });
}
