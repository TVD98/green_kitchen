import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/auth/data/datasources/social_auth_service.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_session.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_tokens.dart';
import 'package:green_kitchen/features/auth/domain/entities/auth_user.dart';
import 'package:green_kitchen/features/auth/domain/entities/social_provider.dart';
import 'package:green_kitchen/features/auth/domain/usecases/log_in_with_social.dart';
import 'package:green_kitchen/features/auth/domain/usecases/sign_up.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockSignUp extends Mock implements SignUp {}

class _MockSocial extends Mock implements LogInWithSocial {}

class _MockSocialAuth extends Mock implements SocialAuthService {}

void main() {
  late _MockSignUp signUp;
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
    signUp = _MockSignUp();
    social = _MockSocial();
    socialAuth = _MockSocialAuth();
    registerFallbackValue(SocialProvider.google);
  });

  SignupBloc build() => SignupBloc(
        signUp: signUp,
        logInWithSocial: social,
        socialAuthService: socialAuth,
      );

  blocTest<SignupBloc, SignupState>(
    'blocks submit when terms not accepted',
    build: build,
    act: (bloc) async {
      bloc
        ..add(const SignupEmailChanged('a@b.com'))
        ..add(const SignupPasswordChanged('Password123!'))
        ..add(const SignupSubmitted());
    },
    verify: (bloc) {
      expect(bloc.state.acceptedTerms, isFalse);
      expect(bloc.state.status, SignupStatus.initial);
      verifyNever(
        () => signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<SignupBloc, SignupState>(
    'emits success when signup succeeds',
    build: () {
      when(
        () => signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success(session));
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const SignupEmailChanged('a@b.com'))
        ..add(const SignupPasswordChanged('Password123!'))
        ..add(const SignupTermsChanged(true))
        ..add(const SignupSubmitted());
    },
    expect: () => [
      isA<SignupState>(),
      isA<SignupState>(),
      isA<SignupState>(),
      isA<SignupState>().having((s) => s.status, 'status', SignupStatus.loading),
      isA<SignupState>()
          .having((s) => s.status, 'status', SignupStatus.success)
          .having((s) => s.session, 'session', session),
    ],
  );

  blocTest<SignupBloc, SignupState>(
    'maps user exists failure',
    build: () {
      when(
        () => signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Err(UserExistsFailure()));
      return build();
    },
    act: (bloc) async {
      bloc
        ..add(const SignupEmailChanged('a@b.com'))
        ..add(const SignupPasswordChanged('Password123!'))
        ..add(const SignupTermsChanged(true))
        ..add(const SignupSubmitted());
    },
    expect: () => [
      isA<SignupState>(),
      isA<SignupState>(),
      isA<SignupState>(),
      isA<SignupState>().having((s) => s.status, 'status', SignupStatus.loading),
      isA<SignupState>()
          .having((s) => s.status, 'status', SignupStatus.failure)
          .having((s) => s.failure, 'failure', isA<UserExistsFailure>()),
    ],
  );
}
