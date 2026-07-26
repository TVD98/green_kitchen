import 'package:flutter/material.dart';

import '../domain/locale_resolver.dart';

/// MaterialApp locale resolution: prefer vi/en from device list, else vi.
Locale resolveAppLocale(
  List<Locale>? deviceLocales,
  Iterable<Locale> supportedLocales,
) {
  final preferred = deviceLocales?.map((l) => l.languageCode).toList() ??
      const <String>[];
  for (final code in preferred) {
    if (LocaleResolver.supportedLanguageCodes.contains(code.toLowerCase())) {
      return Locale(code.toLowerCase());
    }
  }
  return const Locale(LocaleResolver.fallbackLanguageCode);
}
