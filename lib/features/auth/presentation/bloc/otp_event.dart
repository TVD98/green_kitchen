part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

final class OtpCodeChanged extends OtpEvent {
  const OtpCodeChanged(this.code);
  final String code;
  @override
  List<Object?> get props => [code];
}

final class OtpTick extends OtpEvent {
  const OtpTick();
}

final class OtpSubmitted extends OtpEvent {
  const OtpSubmitted();
}

final class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}
