abstract final class AuthValidators {
  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,32}$',
  );

  static final _otpRegex = RegExp(r'^\d{4}$');

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || !_emailRegex.hasMatch(trimmed)) {
      return 'Email không hợp lệ. Vui lòng kiểm tra lại.';
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (!_passwordRegex.hasMatch(password)) {
      return 'Mật khẩu từ 8-32 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt.';
    }
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirmation) {
    if (password != confirmation) {
      return 'Mật khẩu xác nhận không khớp.';
    }
    return null;
  }

  static String? otp(String? value) {
    final code = value ?? '';
    if (!_otpRegex.hasMatch(code)) {
      return 'Mã OTP gồm 4 chữ số.';
    }
    return null;
  }
}
