import '../entities/locale_preference.dart';
import '../repositories/locale_preference_repository.dart';

class SetLocalePreference {
  const SetLocalePreference(this._repository);

  final LocalePreferenceRepository _repository;

  Future<void> call(LocalePreference preference) =>
      _repository.setPreference(preference);
}
