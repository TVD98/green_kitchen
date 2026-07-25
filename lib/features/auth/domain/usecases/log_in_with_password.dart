import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LogInWithPassword {
  const LogInWithPassword(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return _repository.logIn(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
