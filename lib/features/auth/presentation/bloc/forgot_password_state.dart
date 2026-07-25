part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus { initial, loading, success, failure }

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.status = ForgotPasswordStatus.initial,
    this.failure,
    this.otpSession,
  });

  final String email;
  final String? emailError;
  final ForgotPasswordStatus status;
  final Failure? failure;
  final OtpSession? otpSession;

  bool get canSubmit =>
      emailError == null &&
      email.isNotEmpty &&
      status != ForgotPasswordStatus.loading;

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    ForgotPasswordStatus? status,
    Failure? failure,
    OtpSession? otpSession,
    bool clearFailure = false,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
      otpSession: otpSession ?? this.otpSession,
    );
  }

  @override
  List<Object?> get props => [email, emailError, status, failure, otpSession];
}
