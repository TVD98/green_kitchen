import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/locale_preference.dart';
import '../cubit/locale_preference_cubit.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppNavigationHeader(
                title: l10n.languageSettingsTitle,
              ),
              const SizedBox(height: AppSpacing.gap20),
              AppText(
                l10n.languageSampleHint,
                variant: AppTextVariant.body,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.gap20),
              BlocBuilder<LocalePreferenceCubit, LocalePreferenceState>(
                builder: (context, state) {
                  return AppRadioGroup<LocalePreference>(
                    value: state.preference,
                    onChanged: (value) =>
                        context.read<LocalePreferenceCubit>().select(value),
                    items: [
                      AppRadioGroupItem(
                        value: LocalePreference.system,
                        label: l10n.languageSystem,
                      ),
                      AppRadioGroupItem(
                        value: LocalePreference.vi,
                        label: l10n.languageVietnamese,
                      ),
                      AppRadioGroupItem(
                        value: LocalePreference.en,
                        label: l10n.languageEnglish,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
