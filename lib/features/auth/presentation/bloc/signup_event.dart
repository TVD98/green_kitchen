part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

final class SignupEmailChanged extends SignupEvent {
  const SignupEmailChanged(this.email);
  final String email;
  @override
  List<Object?> get props => [email];
}

final class SignupPasswordChanged extends SignupEvent {
  const SignupPasswordChanged(this.password);
  final String password;
  @override
  List<Object?> get props => [password];
}

final class SignupTermsChanged extends SignupEvent {
  const SignupTermsChanged(this.accepted);
  final bool accepted;
  @override
  List<Object?> get props => [accepted];
}

final class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}

final class SignupSocialRequested extends SignupEvent {
  const SignupSocialRequested(this.provider);
  final SocialProvider provider;
  @override
  List<Object?> get props => [provider];
}
