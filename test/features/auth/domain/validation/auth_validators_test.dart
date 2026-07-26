import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/auth/domain/validation/auth_validators.dart';

void main() {
  group('AuthValidators.email', () {
    test('rejects malformed email', () {
      expect(
        AuthValidators.email('not-an-email'),
        AuthValidationCodes.emailInvalid,
      );
    });

    test('accepts valid email', () {
      expect(AuthValidators.email('user@example.com'), isNull);
    });
  });

  group('AuthValidators.password', () {
    test('rejects password missing required character class', () {
      expect(
        AuthValidators.password('password123'),
        AuthValidationCodes.passwordWeak,
      );
    });

    test('accepts strong password', () {
      expect(AuthValidators.password('Password123!'), isNull);
    });
  });

  group('AuthValidators.otp', () {
    test('rejects non four-digit codes', () {
      expect(AuthValidators.otp('123'), AuthValidationCodes.otpInvalid);
      expect(AuthValidators.otp('12345'), AuthValidationCodes.otpInvalid);
      expect(AuthValidators.otp('12ab'), AuthValidationCodes.otpInvalid);
    });

    test('accepts four digits', () {
      expect(AuthValidators.otp('5741'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('rejects mismatch', () {
      expect(
        AuthValidators.confirmPassword('Password123!', 'Password123@'),
        AuthValidationCodes.passwordMismatch,
      );
    });
  });
}
