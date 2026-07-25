import '../../../../core/error/result.dart';
import '../entities/auth_session.dart';
import '../entities/social_provider.dart';
import '../repositories/auth_repository.dart';

class LogInWithSocial {
  const LogInWithSocial(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required SocialProvider provider,
    required String idToken,
  }) {
    return _repository.socialLogin(provider: provider, idToken: idToken);
  }
}
