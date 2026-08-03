import '../../../../core/error/result.dart';
import '../entities/user_profile_settings.dart';

abstract class ProfileRepository {
  Future<Result<UserPreferences>> getPreferences();

  Future<Result<UserPreferences>> updatePreferences(UserPreferences preferences);

  Future<Result<List<UserAllergy>>> getAllergies({String lang = 'vi'});

  Future<Result<List<UserAllergy>>> replaceAllergies(
    List<String> ingredientIds, {
    String lang = 'vi',
  });
}
