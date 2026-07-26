import '../entities/locale_preference.dart';

abstract class LocalePreferenceRepository {
  Future<LocalePreference> getPreference();
  Future<void> setPreference(LocalePreference preference);
}
