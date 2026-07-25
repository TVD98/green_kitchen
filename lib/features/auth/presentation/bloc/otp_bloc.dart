import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/validation/auth_validators.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc({
    required VerifyOtp verifyOtp,
    required ForgotPassword forgotPassword,
    required String sessionId,
    required String email,
    required int expireInSeconds,
    required int resendAfterSeconds,
  })  : _verifyOtp = verifyOtp,
        _forgotPassword = forgotPassword,
        super(
          OtpState(
            sessionId: sessionId,
            email: email,
            resendSecondsLeft: resendAfterSeconds,
            expireSecondsLeft: expireInSeconds,
          ),
        ) {
    on<OtpCodeChanged>(_onCodeChanged);
    on<OtpTick>(_onTick);
    on<OtpSubmitted>(_onSubmitted);
    on<OtpResendRequested>(_onResendRequested);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const OtpTick());
    });
  }

  final VerifyOtp _verifyOtp;
  final ForgotPassword _forgotPassword;
  Timer? _timer;

  void _onCodeChanged(OtpCodeChanged event, Emitter<OtpState> emit) {
    final digits = event.code.replaceAll(RegExp(r'\D'), '');
    final code = digits.length > 4 ? digits.substring(0, 4) : digits;
    emit(
      state.copyWith(
        code: code,
        codeError: code.length == 4 ? AuthValidators.otp(code) : null,
        clearFailure: true,
      ),
    );
    if (code.length == 4 && AuthValidators.otp(code) == null) {
      add(const OtpSubmitted());
    }
  }

  void _onTick(OtpTick event, Emitter<OtpState> emit) {
    emit(
      state.copyWith(
        resendSecondsLeft:
            state.resendSecondsLeft > 0 ? state.resendSecondsLeft - 1 : 0,
        expireSecondsLeft:
            state.expireSecondsLeft > 0 ? state.expireSecondsLeft - 1 : 0,
      ),
    );
  }

  Future<void> _onSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    final codeError = AuthValidators.otp(state.code);
    if (codeError != null) {
      emit(state.copyWith(codeError: codeError));
      return;
    }
    emit(state.copyWith(status: OtpStatus.loading, clearFailure: true));
    final result = await _verifyOtp(
      sessionId: state.sessionId,
      otpCode: state.code,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: OtpStatus.failure, failure: failure),
      ),
      (resetToken) => emit(
        state.copyWith(
          status: OtpStatus.success,
          resetToken: resetToken,
        ),
      ),
    );
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (state.resendSecondsLeft > 0) {
      return;
    }
    emit(state.copyWith(status: OtpStatus.loading, clearFailure: true));
    final result = await _forgotPassword(email: state.email);
    result.fold(
      (failure) => emit(
        state.copyWith(status: OtpStatus.failure, failure: failure),
      ),
      (session) => emit(
        state.copyWith(
          status: OtpStatus.initial,
          sessionId: session.sessionId,
          resendSecondsLeft: session.resendAfterSeconds,
          expireSecondsLeft: session.expireInSeconds,
          code: '',
          clearCodeError: true,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
