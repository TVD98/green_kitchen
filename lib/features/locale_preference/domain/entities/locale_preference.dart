/// User language preference: follow system, or force Vietnamese / English.
enum LocalePreference {
  system,
  vi,
  en;

  static LocalePreference fromStorage(String? value) {
    switch (value) {
      case 'vi':
        return LocalePreference.vi;
      case 'en':
        return LocalePreference.en;
      case 'system':
      default:
        return LocalePreference.system;
    }
  }

  String toStorage() {
    switch (this) {
      case LocalePreference.system:
        return 'system';
      case LocalePreference.vi:
        return 'vi';
      case LocalePreference.en:
        return 'en';
    }
  }
}
