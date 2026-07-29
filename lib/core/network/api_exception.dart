import '../error/failures.dart';

class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.code,
    this.message,
  });

  final int statusCode;
  final String code;
  final String? message;

  Failure toFailure() {
    return switch (code) {
      'ERR_INVALID_CREDENTIALS' => const InvalidCredentialsFailure(),
      'ERR_INVALID_OTP' => const InvalidOtpFailure(),
      'ERR_OTP_EXPIRED' => const OtpExpiredFailure(),
      'ERR_USER_EXISTS' => const UserExistsFailure(),
      'ERR_ACCOUNT_LOCKED' => const AccountLockedFailure(),
      'ERR_TOO_MANY_REQUESTS' => const RateLimitedFailure(),
      'ERR_SOCIAL_AUTH_FAILED' => const SocialAuthFailure(),
      'ERR_INVALID_RESET_TOKEN' => const InvalidResetTokenFailure(),
      'ERR_RESET_TOKEN_EXPIRED' => const ResetTokenExpiredFailure(),
      'ERR_TOKEN_EXPIRED' => const SessionExpiredFailure(),
      'ERR_INVALID_INPUT' when statusCode == 404 => const NotFoundFailure(),
      'ERR_INVALID_INPUT' => const InvalidInputFailure(),
      _ => const ServerFailure(),
    };
  }

  @override
  String toString() => 'ApiException($statusCode, $code)';
}
