import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../entities/auth_tokens.dart';
import '../entities/otp_session.dart';
import '../entities/social_provider.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> signUp({
    required String email,
    required String password,
  });

  Future<Result<AuthSession>> logIn({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<Result<AuthSession>> socialLogin({
    required SocialProvider provider,
    required String idToken,
  });

  Future<Result<OtpSession>> forgotPassword({required String email});

  Future<Result<String>> verifyOtp({
    required String sessionId,
    required String otpCode,
    required String purpose,
  });

  Future<Result<void>> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  Future<Result<AuthTokens>> refreshSession();

  Future<Result<void>> logOut();

  Future<AuthSession?> readCachedSession();
}
