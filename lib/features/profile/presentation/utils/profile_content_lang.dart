import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locale_preference/domain/locale_resolver.dart';
import '../../../locale_preference/presentation/cubit/locale_preference_cubit.dart';

/// Effective ingredient/allergy language code (`vi` | `en`) for Profile flows.
String profileContentLang(BuildContext context) {
  try {
    final preference = context.read<LocalePreferenceCubit>().state.preference;
    final deviceCode = Localizations.localeOf(context).languageCode;
    return const LocaleResolver().resolveLanguageCode(
      preference: preference,
      deviceLanguageCode: deviceCode,
    );
  } catch (_) {
    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    return code == 'en' ? 'en' : 'vi';
  }
}
