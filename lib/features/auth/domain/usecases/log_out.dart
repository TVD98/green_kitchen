import '../../../../core/error/result.dart';
import '../repositories/auth_repository.dart';

class LogOut {
  const LogOut(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logOut();
}
