import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_session.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_tokens.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_user.dart';
import 'package:green_kitchen/features/auth/domain/usecases/get_cached_session.dart';
import 'package:green_kitchen/features/auth/domain/usecases/log_out.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCachedSession extends Mock implements GetCachedSession {}

class _MockLogOut extends Mock implements LogOut {}

void main() {
  late _MockGetCachedSession getCachedSession;
  late _MockLogOut logOut;

  const session = AuthSession(
    user: AuthUser(id: '1', email: 'a@b.com'),
    tokens: AuthTokens(
      accessToken: 'a',
      refreshToken: 'r',
      expiresIn: 3600,
    ),
  );

  setUp(() {
    getCachedSession = _MockGetCachedSession();
    logOut = _MockLogOut();
  });

  AuthBloc buildBloc() => AuthBloc(
        getCachedSession: getCachedSession,
        logOut: logOut,
      );

  blocTest<AuthBloc, AuthState>(
    'emits unauthenticated when no cached session',
    build: () {
      when(() => getCachedSession()).thenAnswer((_) async => null);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [const AuthState.unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits authenticated when cached session exists',
    build: () {
      when(() => getCachedSession()).thenAnswer((_) async => session);
      return buildBloc();
    },
    act: (bloc) => bloc.add(const AuthStarted()),
    expect: () => [const AuthState.authenticated(session)],
  );

  blocTest<AuthBloc, AuthState>(
    'logout clears session',
    build: () {
      when(() => logOut()).thenAnswer((_) async => const Success(null));
      return buildBloc();
    },
    seed: () => const AuthState.authenticated(session),
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    expect: () => [const AuthState.unauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'session expired forces logout with message',
    build: () {
      when(() => logOut()).thenAnswer((_) async => const Success(null));
      return buildBloc();
    },
    seed: () => const AuthState.authenticated(session),
    act: (bloc) => bloc.add(const AuthSessionExpired()),
    expect: () => [
      const AuthState.unauthenticated(
        message: FailureCodes.sessionExpired,
      ),
    ],
  );
}
