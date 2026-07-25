import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/auth/domain/validation/auth_validators.dart';

void main() {
  group('AuthValidators.email', () {
    test('rejects malformed email', () {
      expect(
        AuthValidators.email('not-an-email'),
        'Email không hợp lệ. Vui lòng kiểm tra lại.',
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
        'Mật khẩu từ 8-32 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.',
      );
    });

    test('accepts strong password', () {
      expect(AuthValidators.password('Password123!'), isNull);
    });
  });

  group('AuthValidators.otp', () {
    test('rejects non four-digit codes', () {
      expect(AuthValidators.otp('123'), 'Mã OTP gồm 4 chữ số.');
      expect(AuthValidators.otp('12345'), 'Mã OTP gồm 4 chữ số.');
      expect(AuthValidators.otp('12ab'), 'Mã OTP gồm 4 chữ số.');
    });

    test('accepts four digits', () {
      expect(AuthValidators.otp('5741'), isNull);
    });
  });

  group('AuthValidators.confirmPassword', () {
    test('rejects mismatch', () {
      expect(
        AuthValidators.confirmPassword('Password123!', 'Password123@'),
        'Mật khẩu xác nhận không khớp.',
      );
    });
  });
}
