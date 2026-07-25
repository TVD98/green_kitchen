part of 'signup_bloc.dart';

const Object _unset = Object();

enum SignupStatus { initial, loading, success, failure }

final class SignupState extends Equatable {
  const SignupState({
    this.email = '',
    this.password = '',
    this.acceptedTerms = false,
    this.emailError,
    this.passwordError,
    this.status = SignupStatus.initial,
    this.failure,
    this.session,
  });

  final String email;
  final String password;
  final bool acceptedTerms;
  final String? emailError;
  final String? passwordError;
  final SignupStatus status;
  final Failure? failure;
  final AuthSession? session;

  bool get canSubmit =>
      emailError == null &&
      passwordError == null &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      acceptedTerms &&
      status != SignupStatus.loading;

  SignupState copyWith({
    String? email,
    String? password,
    bool? acceptedTerms,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    SignupStatus? status,
    Failure? failure,
    AuthSession? session,
    bool clearFailure = false,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
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
        acceptedTerms,
        emailError,
        passwordError,
        status,
        failure,
        session,
      ];
}
