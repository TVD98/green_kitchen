import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/otp_session.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/validation/auth_validators.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({required ForgotPassword forgotPassword})
      : _forgotPassword = forgotPassword,
        super(const ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final ForgotPassword _forgotPassword;

  void _onEmailChanged(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        email: event.email,
        emailError: AuthValidators.email(event.email),
        clearFailure: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final emailError = AuthValidators.email(state.email);
    emit(state.copyWith(emailError: emailError));
    if (!state.canSubmit) {
      return;
    }

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _forgotPassword(email: state.email.trim());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          failure: failure,
        ),
      ),
      (session) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          otpSession: session,
        ),
      ),
    );
  }
}
