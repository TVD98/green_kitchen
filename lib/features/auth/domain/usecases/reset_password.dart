import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class ResetPassword {
  const ResetPassword(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({
    required String resetToken,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      resetToken: resetToken,
      newPassword: newPassword,
    );
  }
}
