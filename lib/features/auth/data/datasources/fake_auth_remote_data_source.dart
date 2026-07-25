import '../../domain/entities/social_provider.dart';
import '../models/auth_session_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/auth_user_model.dart';
import '../models/otp_session_model.dart';
import 'auth_remote_data_source.dart';
import '../../../../core/network/api_exception.dart';

/// In-memory auth backend for UI development before the real API exists.
class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  final Map<String, String> _passwords = {
    'demo@greenkitchen.app': 'Password123!',
  };
  final Map<String, String> _otpBySession = {};
  int _sessionCounter = 0;

  AuthSessionModel _sessionFor(String email) {
    return AuthSessionModel(
      user: AuthUserModel(
        id: 'usr_${email.hashCode.abs()}',
        email: email,
        fullName: email.split('@').first,
      ),
      tokens: AuthTokensModel(
        accessToken: 'access_${email.hashCode.abs()}',
        refreshToken: 'refresh_${email.hashCode.abs()}',
        expiresIn: 3600,
        refreshTokenExpiresIn: 2592000,
      ),
    );
  }

  @override
  Future<AuthSessionModel> signUp({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_passwords.containsKey(email)) {
      throw const ApiException(statusCode: 400, code: 'ERR_USER_EXISTS');
    }
    _passwords[email] = password;
    return _sessionFor(email);
  }

  @override
  Future<AuthSessionModel> logIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final stored = _passwords[email];
    if (stored == null || stored != password) {
      throw const ApiException(
        statusCode: 401,
        code: 'ERR_INVALID_CREDENTIALS',
      );
    }
    return _sessionFor(email);
  }

  @override
  Future<AuthSessionModel> socialLogin({
    required SocialProvider provider,
    required String idToken,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (idToken == 'fail') {
      throw const ApiException(statusCode: 401, code: 'ERR_SOCIAL_AUTH_FAILED');
    }
    final email = '${provider.apiValue}@social.greenkitchen.app';
    _passwords.putIfAbsent(email, () => 'SocialLogin1!');
    return _sessionFor(email);
  }

  @override
  Future<OtpSessionModel> forgotPassword({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final sessionId = 'sess_${++_sessionCounter}';
    _otpBySession[sessionId] = '1234';
    return OtpSessionModel(
      sessionId: sessionId,
      expireInSeconds: 180,
      resendAfterSeconds: 60,
      email: email,
    );
  }

  @override
  Future<String> verifyOtp({
    required String sessionId,
    required String otpCode,
    required String purpose,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final expected = _otpBySession[sessionId];
    if (expected == null) {
      throw const ApiException(statusCode: 400, code: 'ERR_OTP_EXPIRED');
    }
    if (expected != otpCode) {
      throw const ApiException(statusCode: 400, code: 'ERR_INVALID_OTP');
    }
    return 'reset_$sessionId';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!resetToken.startsWith('reset_')) {
      throw const ApiException(
        statusCode: 400,
        code: 'ERR_INVALID_RESET_TOKEN',
      );
    }
  }

  @override
  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
    required String deviceId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (refreshToken.startsWith('refresh_')) {
      return AuthTokensModel(
        accessToken: 'access_refreshed_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: refreshToken,
        expiresIn: 3600,
      );
    }
    throw const ApiException(statusCode: 401, code: 'ERR_TOKEN_EXPIRED');
  }

  @override
  Future<void> logOut({required String refreshToken}) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}
