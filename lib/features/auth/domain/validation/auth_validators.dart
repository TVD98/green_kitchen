/// Stable codes returned by [AuthValidators] — map to l10n in presentation.
abstract final class AuthValidationCodes {
  static const emailInvalid = 'auth.validation.emailInvalid';
  static const passwordWeak = 'auth.validation.passwordWeak';
  static const passwordRequired = 'auth.validation.passwordRequired';
  static const passwordMismatch = 'auth.validation.passwordMismatch';
  static const otpInvalid = 'auth.validation.otpInvalid';
}

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
      return AuthValidationCodes.emailInvalid;
    }
    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (!_passwordRegex.hasMatch(password)) {
      return AuthValidationCodes.passwordWeak;
    }
    return null;
  }

  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthValidationCodes.passwordRequired;
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirmation) {
    if (password != confirmation) {
      return AuthValidationCodes.passwordMismatch;
    }
    return null;
  }

  static String? otp(String? value) {
    final code = value ?? '';
    if (!_otpRegex.hasMatch(code)) {
      return AuthValidationCodes.otpInvalid;
    }
    return null;
  }
}
