part of 'login_bloc.dart';

const Object _unset = Object();

enum LoginStatus { initial, loading, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = true,
    this.emailError,
    this.passwordError,
    this.status = LoginStatus.initial,
    this.failure,
    this.session,
  });

  final String email;
  final String password;
  final bool rememberMe;
  final String? emailError;
  final String? passwordError;
  final LoginStatus status;
  final Failure? failure;
  final AuthSession? session;

  bool get canSubmit =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      status != LoginStatus.loading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? rememberMe,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    LoginStatus? status,
    Failure? failure,
    AuthSession? session,
    bool clearFailure = false,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      emailError: identical(emailError, _unset)
          ? this.emailError
          : emailError as String?,
      passwordError: identical(passwordError, _unset)
          ? this.passwordError
          : passwordError as String?,
      status: status ?? this.status,
      failure: clearFailure ? null : failure ?? this.failure,
      session: session ?? this.session,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        rememberMe,
        emailError,
        passwordError,
        status,
        failure,
        session,
      ];
}
