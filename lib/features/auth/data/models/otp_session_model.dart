import '../../domain/entities/otp_session.dart';

class OtpSessionModel extends OtpSession {
  const OtpSessionModel({
    required super.sessionId,
    required super.expireInSeconds,
    required super.resendAfterSeconds,
    super.email,
  });

  factory OtpSessionModel.fromJson(
    Map<String, dynamic> json, {
    String? email,
  }) {
    return OtpSessionModel(
      sessionId: json['session_id'] as String,
      expireInSeconds: json['expire_in_seconds'] as int,
      resendAfterSeconds: json['resend_after_seconds'] as int,
      email: email,
    );
  }

  OtpSession toEntity() => OtpSession(
        sessionId: sessionId,
        expireInSeconds: expireInSeconds,
        resendAfterSeconds: resendAfterSeconds,
        email: email,
      );
}
