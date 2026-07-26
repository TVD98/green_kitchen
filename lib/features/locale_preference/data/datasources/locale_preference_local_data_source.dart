import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/locale_preference.dart';

class LocalePreferenceLocalDataSource {
  LocalePreferenceLocalDataSource(this._prefs);

  static const storageKey = 'locale_preference';

  final SharedPreferences _prefs;

  LocalePreference read() {
    return LocalePreference.fromStorage(_prefs.getString(storageKey));
  }

  Future<void> write(LocalePreference preference) {
    return _prefs.setString(storageKey, preference.toStorage());
  }
}
