import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/validation/auth_validators.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    required ResetPassword resetPassword,
    required String resetToken,
  })  : _resetPassword = resetPassword,
        super(ResetPasswordState(resetToken: resetToken)) {
    on<ResetPasswordChanged>(_onPasswordChanged);
    on<ResetConfirmPasswordChanged>(_onConfirmChanged);
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final ResetPassword _resetPassword;

  void _onPasswordChanged(
    ResetPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        passwordError: AuthValidators.password(event.password),
        confirmError: AuthValidators.confirmPassword(
          event.password,
          state.confirmPassword,
        ),
        clearFailure: true,
      ),
    );
  }

  void _onConfirmChanged(
    ResetConfirmPasswordChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        confirmError: AuthValidators.confirmPassword(
          state.password,
          event.confirmPassword,
        ),
        clearFailure: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    final passwordError = AuthValidators.password(state.password);
    final confirmError = AuthValidators.confirmPassword(
      state.password,
      state.confirmPassword,
    );
    emit(
      state.copyWith(
        passwordError: passwordError,
        confirmError: confirmError,
      ),
    );
    if (!state.canSubmit) {
      return;
    }

    emit(
      state.copyWith(status: ResetPasswordStatus.loading, clearFailure: true),
    );
    final result = await _resetPassword(
      resetToken: state.resetToken,
      newPassword: state.password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: ResetPasswordStatus.failure, failure: failure),
      ),
      (_) => emit(state.copyWith(status: ResetPasswordStatus.success)),
    );
  }
}
