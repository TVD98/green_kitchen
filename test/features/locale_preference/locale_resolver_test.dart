import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/locale_preference/domain/entities/locale_preference.dart';
import 'package:green_kitchen/features/locale_preference/domain/locale_resolver.dart';
import 'package:green_kitchen/features/locale_preference/presentation/locale_resolution.dart';

void main() {
  const resolver = LocaleResolver();

  group('LocaleResolver', () {
    test('system follows vi/en device language', () {
      expect(
        resolver.resolveLanguageCode(
          preference: LocalePreference.system,
          deviceLanguageCode: 'en',
        ),
        'en',
      );
      expect(
        resolver.resolveLanguageCode(
          preference: LocalePreference.system,
          deviceLanguageCode: 'vi',
        ),
        'vi',
      );
    });

    test('system falls back to vi for unsupported device language', () {
      expect(
        resolver.resolveLanguageCode(
          preference: LocalePreference.system,
          deviceLanguageCode: 'ja',
        ),
        'vi',
      );
    });

    test('explicit overrides ignore device language', () {
      expect(
        resolver.resolveLanguageCode(
          preference: LocalePreference.en,
          deviceLanguageCode: 'vi',
        ),
        'en',
      );
      expect(
        resolver.resolveLanguageCode(
          preference: LocalePreference.vi,
          deviceLanguageCode: 'en',
        ),
        'vi',
      );
    });
  });

  group('resolveAppLocale', () {
    test('picks first supported device locale', () {
      expect(
        resolveAppLocale(
          const [Locale('fr'), Locale('en')],
          AppLocalizationsSupported.locales,
        ),
        const Locale('en'),
      );
    });

    test('falls back to vi when none supported', () {
      expect(
        resolveAppLocale(
          const [Locale('ja'), Locale('fr')],
          AppLocalizationsSupported.locales,
        ),
        const Locale('vi'),
      );
    });
  });
}

/// Local stand-in so the test does not depend on generated l10n import shape.
abstract final class AppLocalizationsSupported {
  static const locales = [Locale('en'), Locale('vi')];
}
