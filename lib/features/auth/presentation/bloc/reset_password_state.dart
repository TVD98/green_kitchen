part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { initial, loading, success, failure }

final class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    required this.resetToken,
    this.password = '',
    this.confirmPassword = '',
    this.passwordError,
    this.confirmError,
    this.status = ResetPasswordStatus.initial,
    this.failure,
  });

  final String resetToken;
  final String password;
  final String confirmPassword;
  final String? passwordError;
  final String? confirmError;
  final ResetPasswordStatus status;
  final Failure? failure;

  bool get canSubmit =>
      passwordError == null &&
      confirmError == null &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      status != ResetPasswordStatus.loading;

  ResetPasswordState copyWith({
    String? resetToken,
    String? password,
    String? confirmPassword,
    String? passwordError,
    String? confirmError,
    ResetPasswordStatus? status,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ResetPasswordState(
      resetToken: resetToken ?? this.resetToken,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      passwordError: passwordError ?? this.passwordError,
      confirmError: confirmError ?? this.confirmError,
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        resetToken,
        password,
        confirmPassword,
        passwordError,
        confirmError,
        status,
        failure,
      ];
}
