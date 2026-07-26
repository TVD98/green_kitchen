import 'entities/locale_preference.dart';

/// Resolves an app language code from preference + device language.
///
/// Pure Dart — no Flutter imports. Supported codes: `vi`, `en`.
/// Unsupported device languages fall back to `vi` when preference is system.
class LocaleResolver {
  const LocaleResolver();

  static const supportedLanguageCodes = {'vi', 'en'};
  static const fallbackLanguageCode = 'vi';

  /// Returns the effective language code for the given [preference].
  String resolveLanguageCode({
    required LocalePreference preference,
    required String? deviceLanguageCode,
  }) {
    switch (preference) {
      case LocalePreference.vi:
        return 'vi';
      case LocalePreference.en:
        return 'en';
      case LocalePreference.system:
        final code = deviceLanguageCode?.toLowerCase();
        if (code != null && supportedLanguageCodes.contains(code)) {
          return code;
        }
        return fallbackLanguageCode;
    }
  }
}
