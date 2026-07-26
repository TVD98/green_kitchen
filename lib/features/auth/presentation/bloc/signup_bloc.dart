import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/validation/auth_validators.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc({
    required SignUp signUp,
    required LogInWithSocial logInWithSocial,
    required SocialAuthService socialAuthService,
  })  : _signUp = signUp,
        _logInWithSocial = logInWithSocial,
        _socialAuthService = socialAuthService,
        super(const SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupTermsChanged>(_onTermsChanged);
    on<SignupSubmitted>(_onSubmitted);
    on<SignupSocialRequested>(_onSocialRequested);
  }

  final SignUp _signUp;
  final LogInWithSocial _logInWithSocial;
  final SocialAuthService _socialAuthService;

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    final email = event.email;
    emit(
      state.copyWith(
        email: email,
        emailError: AuthValidators.email(email),
        clearFailure: true,
      ),
    );
  }

  void _onPasswordChanged(
    SignupPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    final password = event.password;
    emit(
      state.copyWith(
        password: password,
        passwordError: AuthValidators.password(password),
        clearFailure: true,
      ),
    );
  }

  void _onTermsChanged(SignupTermsChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(acceptedTerms: event.accepted));
  }

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    final emailError = AuthValidators.email(state.email);
    final passwordError = AuthValidators.password(state.password);
    emit(
      state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
      ),
    );
    if (!state.canSubmit) {
      return;
    }

    emit(state.copyWith(status: SignupStatus.loading, clearFailure: true));
    final result = await _signUp(
      email: state.email.trim(),
      password: state.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: SignupStatus.failure, failure: failure),
      ),
      (session) => emit(
        state.copyWith(status: SignupStatus.success, session: session),
      ),
    );
  }

  Future<void> _onSocialRequested(
    SignupSocialRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading, clearFailure: true));
    final token = await _socialAuthService.signIn(event.provider);
    if (token == null) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
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
      (failure) => emit(
        state.copyWith(status: SignupStatus.failure, failure: failure),
      ),
      (session) => emit(
        state.copyWith(status: SignupStatus.success, session: session),
      ),
    );
  }
}
