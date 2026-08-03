import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/preference_allow_lists.dart';
import '../bloc/preferences_bloc.dart';
import '../utils/preference_labels.dart';
import '../widgets/preference_token_chips.dart';
import '../widgets/profile_chrome.dart';
import '../widgets/profile_removable_chip.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final _dislikedController = TextEditingController();

  @override
  void dispose() {
    _dislikedController.dispose();
    super.dispose();
  }

  void _addDisliked(BuildContext context) {
    context.read<PreferencesBloc>().add(
          PreferencesDislikedAdded(_dislikedController.text),
        );
    _dislikedController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;

    return BlocListener<PreferencesBloc, PreferencesState>(
      listenWhen: (previous, current) =>
          previous.savedAck != current.savedAck ||
          previous.saveFailed != current.saveFailed,
      listener: (context, state) {
        if (state.savedAck) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.profilePreferencesSaved,
                style: AppTypography.body(color: AppColors.absoluteWhite),
              ),
              backgroundColor: AppColors.brand,
            ),
          );
          context.pop();
        } else if (state.saveFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.profilePreferencesSaveError,
                style: AppTypography.body(color: AppColors.absoluteWhite),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: profileThemedAppBar(
          context: context,
          title: l10n.profilePreferencesTitle,
        ),
        body: BlocBuilder<PreferencesBloc, PreferencesState>(
          builder: (context, state) {
            if (state.status == PreferencesStatus.loading ||
                state.status == PreferencesStatus.initial) {
              return const Center(child: AppLoading());
            }
            if (state.status == PreferencesStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        l10n.profilePreferencesError,
                        variant: AppTextVariant.body,
                        color: AppColors.muted(brightness),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.profilePreferencesRetry,
                        onPressed: () => context
                            .read<PreferencesBloc>()
                            .add(const PreferencesRetried()),
                      ),
                    ],
                  ),
                ),
              );
            }

            final draft = state.draft!;
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    children: [
                      _PreferenceSection(
                        title: l10n.profileDietaryStyle,
                        hint: l10n.profilePreferencesPickOne,
                        child: PreferenceTokenChips(
                          singleSelect: true,
                          tokens: PreferenceAllowLists.dietaryStyles,
                          labelOf: (t) => dietaryStyleLabel(l10n, t),
                          selected: {
                            if (draft.dietaryStyle != null) draft.dietaryStyle!,
                          },
                          onChanged: (values) =>
                              context.read<PreferencesBloc>().add(
                                    PreferencesDietaryStyleChanged(
                                      values.isEmpty ? null : values.first,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PreferenceSection(
                        title: l10n.profileSpiceLevel,
                        hint: l10n.profilePreferencesPickOne,
                        child: PreferenceTokenChips(
                          singleSelect: true,
                          tokens: PreferenceAllowLists.spiceLevels,
                          labelOf: (t) => spiceLevelLabel(l10n, t),
                          selected: {
                            if (draft.spiceLevel != null) draft.spiceLevel!,
                          },
                          onChanged: (values) =>
                              context.read<PreferencesBloc>().add(
                                    PreferencesSpiceLevelChanged(
                                      values.isEmpty ? null : values.first,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PreferenceSection(
                        title: l10n.profileCuisines,
                        hint: draft.cuisinePreferences.isEmpty
                            ? l10n.profilePreferencesPickMany
                            : l10n.profilePreferencesCountSelected(
                                draft.cuisinePreferences.length,
                              ),
                        child: PreferenceTokenChips(
                          tokens: PreferenceAllowLists.cuisines,
                          labelOf: (t) => cuisineLabel(l10n, t),
                          selected: draft.cuisinePreferences.toSet(),
                          onChanged: (values) => context
                              .read<PreferencesBloc>()
                              .add(PreferencesCuisinesChanged(values)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PreferenceSection(
                        title: l10n.profileHealthGoals,
                        hint: draft.healthGoals.isEmpty
                            ? l10n.profilePreferencesPickMany
                            : l10n.profilePreferencesCountSelected(
                                draft.healthGoals.length,
                              ),
                        child: PreferenceTokenChips(
                          tokens: PreferenceAllowLists.healthGoals,
                          labelOf: (t) => healthGoalLabel(l10n, t),
                          selected: draft.healthGoals.toSet(),
                          onChanged: (values) => context
                              .read<PreferencesBloc>()
                              .add(PreferencesHealthGoalsChanged(values)),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _PreferenceSection(
                        title: l10n.profileDislikedIngredients,
                        hint: draft.dislikedIngredients.isEmpty
                            ? l10n.profileDislikedEmpty
                            : l10n.profilePreferencesCountSelected(
                                draft.dislikedIngredients.length,
                              ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (draft.dislikedIngredients.isNotEmpty) ...[
                              Wrap(
                                spacing: AppSpacing.gap8,
                                runSpacing: AppSpacing.gap8,
                                children: [
                                  for (final item
                                      in draft.dislikedIngredients)
                                    ProfileRemovableChip(
                                      label: item,
                                      onDeleted: () => context
                                          .read<PreferencesBloc>()
                                          .add(
                                            PreferencesDislikedRemoved(item),
                                          ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _dislikedController,
                                    hint: l10n.profileDislikedHint,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppSpacing.xs,
                                  ),
                                  child: AppButton(
                                    label: l10n.profileDislikedAdd,
                                    variant: AppButtonVariant.outline,
                                    isExpanded: false,
                                    onPressed: () => _addDisliked(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ProfileStickyActions(
                  child: AppButton(
                    label: l10n.profilePreferencesSave,
                    isLoading: state.saving,
                    onPressed: state.canSave
                        ? () => context
                            .read<PreferencesBloc>()
                            .add(const PreferencesSaveRequested())
                        : null,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreferenceSection extends StatelessWidget {
  const _PreferenceSection({
    required this.title,
    required this.hint,
    required this.child,
  });

  final String title;
  final String hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, variant: AppTextVariant.title),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            hint,
            variant: AppTextVariant.caption,
            color: AppColors.muted(brightness),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
