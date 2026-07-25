import '../../../../core/error/result.dart';
import '../entities/otp_session.dart';
import '../repositories/auth_repository.dart';

class ForgotPassword {
  const ForgotPassword(this._repository);

  final AuthRepository _repository;

  Future<Result<OtpSession>> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
