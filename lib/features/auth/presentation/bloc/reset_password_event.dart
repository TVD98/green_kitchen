part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

final class ResetPasswordChanged extends ResetPasswordEvent {
  const ResetPasswordChanged(this.password);
  final String password;
  @override
  List<Object?> get props => [password];
}

final class ResetConfirmPasswordChanged extends ResetPasswordEvent {
  const ResetConfirmPasswordChanged(this.confirmPassword);
  final String confirmPassword;
  @override
  List<Object?> get props => [confirmPassword];
}

final class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted();
}
