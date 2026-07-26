part of 'otp_bloc.dart';

enum OtpStatus { initial, loading, success, failure }

final class OtpState extends Equatable {
  const OtpState({
    required this.sessionId,
    required this.email,
    this.code = '',
    this.codeError,
    this.resendSecondsLeft = 0,
    this.expireSecondsLeft = 0,
    this.status = OtpStatus.initial,
    this.failure,
    this.resetToken,
  });

  final String sessionId;
  final String email;
  final String code;
  final String? codeError;
  final int resendSecondsLeft;
  final int expireSecondsLeft;
  final OtpStatus status;
  final Failure? failure;
  final String? resetToken;

  bool get canResend => resendSecondsLeft <= 0 && status != OtpStatus.loading;

  OtpState copyWith({
    String? sessionId,
    String? email,
    String? code,
    String? codeError,
    int? resendSecondsLeft,
    int? expireSecondsLeft,
    OtpStatus? status,
    Failure? failure,
    String? resetToken,
    bool clearFailure = false,
    bool clearCodeError = false,
  }) {
    return OtpState(
      sessionId: sessionId ?? this.sessionId,
      email: email ?? this.email,
      code: code ?? this.code,
      codeError: clearCodeError ? null : codeError ?? this.codeError,
      resendSecondsLeft: resendSecondsLeft ?? this.resendSecondsLeft,
      expireSecondsLeft: expireSecondsLeft ?? this.expireSecondsLeft,
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
      resetToken: resetToken ?? this.resetToken,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        email,
        code,
        codeError,
        resendSecondsLeft,
        expireSecondsLeft,
        status,
        failure,
        resetToken,
      ];
}
