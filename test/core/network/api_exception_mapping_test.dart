import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/network/api_exception.dart';

void main() {
  group('ApiException.toFailure', () {
    test('maps ERR_INVALID_CREDENTIALS to InvalidCredentialsFailure', () {
      final failure = const ApiException(
        statusCode: 401,
        code: 'ERR_INVALID_CREDENTIALS',
      ).toFailure();

      expect(failure, isA<InvalidCredentialsFailure>());
    });

    test('maps ERR_INVALID_OTP to InvalidOtpFailure', () {
      final failure = const ApiException(
        statusCode: 400,
        code: 'ERR_INVALID_OTP',
      ).toFailure();

      expect(failure, isA<InvalidOtpFailure>());
    });

    test('maps ERR_OTP_EXPIRED to OtpExpiredFailure', () {
      final failure = const ApiException(
        statusCode: 400,
        code: 'ERR_OTP_EXPIRED',
      ).toFailure();

      expect(failure, isA<OtpExpiredFailure>());
    });

    test('maps ERR_USER_EXISTS to UserExistsFailure', () {
      final failure = const ApiException(
        statusCode: 400,
        code: 'ERR_USER_EXISTS',
      ).toFailure();

      expect(failure, isA<UserExistsFailure>());
    });

    test('maps ERR_ACCOUNT_LOCKED to AccountLockedFailure', () {
      final failure = const ApiException(
        statusCode: 403,
        code: 'ERR_ACCOUNT_LOCKED',
      ).toFailure();

      expect(failure, isA<AccountLockedFailure>());
    });

    test('maps ERR_TOO_MANY_REQUESTS to RateLimitedFailure', () {
      final failure = const ApiException(
        statusCode: 429,
        code: 'ERR_TOO_MANY_REQUESTS',
      ).toFailure();

      expect(failure, isA<RateLimitedFailure>());
    });

    test('maps ERR_SOCIAL_AUTH_FAILED to SocialAuthFailure', () {
      final failure = const ApiException(
        statusCode: 401,
        code: 'ERR_SOCIAL_AUTH_FAILED',
      ).toFailure();

      expect(failure, isA<SocialAuthFailure>());
    });

    test('maps ERR_INVALID_RESET_TOKEN to InvalidResetTokenFailure', () {
      final failure = const ApiException(
        statusCode: 400,
        code: 'ERR_INVALID_RESET_TOKEN',
      ).toFailure();

      expect(failure, isA<InvalidResetTokenFailure>());
    });

    test('maps ERR_RESET_TOKEN_EXPIRED to ResetTokenExpiredFailure', () {
      final failure = const ApiException(
        statusCode: 400,
        code: 'ERR_RESET_TOKEN_EXPIRED',
      ).toFailure();

      expect(failure, isA<ResetTokenExpiredFailure>());
    });

    test('maps unknown codes to ServerFailure', () {
      final failure = const ApiException(
        statusCode: 500,
        code: 'ERR_INTERNAL_SERVER',
      ).toFailure();

      expect(failure, isA<ServerFailure>());
    });
  });
}
