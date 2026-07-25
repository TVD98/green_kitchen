import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/usecases/log_in_with_password.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../../domain/validation/auth_validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LogInWithPassword logInWithPassword,
    required LogInWithSocial logInWithSocial,
    required SocialAuthService socialAuthService,
  })  : _logInWithPassword = logInWithPassword,
        _logInWithSocial = logInWithSocial,
        _socialAuthService = socialAuthService,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginRememberMeChanged>(_onRememberMeChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginSocialRequested>(_onSocialRequested);
  }

  final LogInWithPassword _logInWithPassword;
  final LogInWithSocial _logInWithSocial;
  final SocialAuthService _socialAuthService;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        emailError: AuthValidators.email(event.email),
        clearFailure: true,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        passwordError: AuthValidators.loginPassword(event.password),
        clearFailure: true,
      ),
    );
  }

  void _onRememberMeChanged(
    LoginRememberMeChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(rememberMe: event.rememberMe));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final emailError = AuthValidators.email(state.email);
    final passwordError = AuthValidators.loginPassword(state.password);
    emit(state.copyWith(emailError: emailError, passwordError: passwordError));
    if (!state.canSubmit) {
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, clearFailure: true));
    final result = await _logInWithPassword(
      email: state.email.trim(),
      password: state.password,
      rememberMe: state.rememberMe,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoginStatus.failure, failure: failure)),
      (session) =>
          emit(state.copyWith(status: LoginStatus.success, session: session)),
    );
  }

  Future<void> _onSocialRequested(
    LoginSocialRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearFailure: true));
    final token = await _socialAuthService.signIn(event.provider);
    if (token == null) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          failure: const SocialAuthFailure(),
        ),
      );
      return;
    }
    final result = await _logInWithSocial(
      provider: event.provider,
      idToken: token,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoginStatus.failure, failure: failure)),
      (session) =>
          emit(state.copyWith(status: LoginStatus.success, session: session)),
    );
  }
}
