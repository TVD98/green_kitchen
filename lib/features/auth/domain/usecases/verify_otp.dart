import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call({
    required String sessionId,
    required String otpCode,
    String purpose = 'password_reset',
  }) {
    return _repository.verifyOtp(
      sessionId: sessionId,
      otpCode: otpCode,
      purpose: purpose,
    );
  }
}
