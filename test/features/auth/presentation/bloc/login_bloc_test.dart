import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/auth/data/datasources/social_auth_service.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_session.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_tokens.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_user.dart';
import 'package:green_kitchen/features/auth/domain/entities/social_provider.dart';
import 'package:green_kitchen/features/auth/domain/usecases/log_in_with_password.dart';
import 'package:green_kitchen/features/auth/domain/usecases/log_in_with_social.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/login_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogin extends Mock implements LogInWithPassword {}

class _MockSocial extends Mock implements LogInWithSocial {}

class _MockSocialAuth extends Mock implements SocialAuthService {}

void main() {
  late _MockLogin login;
  late _MockSocial social;
  late _MockSocialAuth socialAuth;

  const session = AuthSession(
    user: AuthUser(id: '1', email: 'a@b.com'),
    tokens: AuthTokens(
      accessToken: 'a',
      refreshToken: 'r',
      expiresIn: 3600,
    ),
  );

  setUp(() {
    login = _MockLogin();
    social = _MockSocial();
    socialAuth = _MockSocialAuth();
    registerFallbackValue(SocialProvider.google);
  });

  LoginBloc build() => LoginBloc(
        logInWithPassword: login,
        logInWithSocial: social,
        socialAuthService: socialAuth,
      );

  blocTest<LoginBloc, LoginState>(
    'emits success on valid credentials',
    build: () {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          rememberMe: any(named: 'rememberMe'),
        ),
      ).thenAnswer((_) async => const Success(session));
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const LoginEmailChanged('a@b.com'))
        ..add(const LoginPasswordChanged('Password123!'))
        ..add(const LoginSubmitted());
    },
    expect: () => [
      isA<LoginState>(),
      isA<LoginState>(),
      isA<LoginState>().having((s) => s.status, 'status', LoginStatus.loading),
      isA<LoginState>().having((s) => s.status, 'status', LoginStatus.success),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'maps invalid credentials',
    build: () {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          rememberMe: any(named: 'rememberMe'),
        ),
      ).thenAnswer((_) async => const Err(InvalidCredentialsFailure()));
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const LoginEmailChanged('a@b.com'))
        ..add(const LoginPasswordChanged('bad'))
        ..add(const LoginSubmitted());
    },
    expect: () => [
      isA<LoginState>(),
      isA<LoginState>(),
      isA<LoginState>().having((s) => s.status, 'status', LoginStatus.loading),
      isA<LoginState>()
          .having((s) => s.failure, 'failure', isA<InvalidCredentialsFailure>()),
    ],
  );
}
