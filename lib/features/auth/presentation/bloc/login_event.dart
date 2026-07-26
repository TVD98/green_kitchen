part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);
  final String email;
  @override
  List<Object?> get props => [email];
}

final class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);
  final String password;
  @override
  List<Object?> get props => [password];
}

final class LoginRememberMeChanged extends LoginEvent {
  const LoginRememberMeChanged(this.rememberMe);
  final bool rememberMe;
  @override
  List<Object?> get props => [rememberMe];
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

final class LoginSocialRequested extends LoginEvent {
  const LoginSocialRequested(this.provider);
  final SocialProvider provider;
  @override
  List<Object?> get props => [provider];
}
