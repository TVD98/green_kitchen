import '../entities/locale_preference.dart';
import '../repositories/locale_preference_repository.dart';

class GetLocalePreference {
  const GetLocalePreference(this._repository);

  final LocalePreferenceRepository _repository;

  Future<LocalePreference> call() => _repository.getPreference();
}
