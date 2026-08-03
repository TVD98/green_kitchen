import '../../../../core/error/result.dart';
import '../entities/user_profile_settings.dart';
import '../repositories/profile_repository.dart';

class GetUserPreferences {
  GetUserPreferences(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserPreferences>> call() => _repository.getPreferences();
}

class UpdateUserPreferences {
  UpdateUserPreferences(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserPreferences>> call(UserPreferences preferences) =>
      _repository.updatePreferences(preferences);
}

class GetUserAllergies {
  GetUserAllergies(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<UserAllergy>>> call({String lang = 'vi'}) =>
      _repository.getAllergies(lang: lang);
}

class ReplaceUserAllergies {
  ReplaceUserAllergies(this._repository);

  final ProfileRepository _repository;

  Future<Result<List<UserAllergy>>> call(
    List<String> ingredientIds, {
    String lang = 'vi',
  }) =>
      _repository.replaceAllergies(ingredientIds, lang: lang);
}
