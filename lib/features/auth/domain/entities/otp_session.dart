import 'package:equatable/equatable.dart';

class OtpSession extends Equatable {
  const OtpSession({
    required this.sessionId,
    required this.expireInSeconds,
    required this.resendAfterSeconds,
    this.email,
  });

  final String sessionId;
  final int expireInSeconds;
  final int resendAfterSeconds;
  final String? email;

  @override
  List<Object?> get props =>
      [sessionId, expireInSeconds, resendAfterSeconds, email];
}
