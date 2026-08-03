import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_profile_settings.dart';
import '../bloc/allergies_bloc.dart';
import '../../../discover/presentation/utils/ingredient_category_label.dart';
import '../utils/profile_content_lang.dart';
import '../widgets/profile_chrome.dart';
import '../widgets/profile_removable_chip.dart';

class AllergiesPage extends StatelessWidget {
  const AllergiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;

    return BlocListener<AllergiesBloc, AllergiesState>(
      listenWhen: (previous, current) =>
          previous.savedAck != current.savedAck ||
          previous.saveFailed != current.saveFailed,
      listener: (context, state) {
        if (state.savedAck) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.profileAllergiesSaved,
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
                l10n.profileAllergiesSaveError,
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
          title: l10n.profileAllergiesTitle,
        ),
        body: BlocBuilder<AllergiesBloc, AllergiesState>(
          builder: (context, state) {
            if (state.status == AllergiesStatus.loading ||
                state.status == AllergiesStatus.initial) {
              return const Center(child: AppLoading());
            }
            if (state.status == AllergiesStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        l10n.profileAllergiesError,
                        variant: AppTextVariant.body,
                        color: AppColors.muted(brightness),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: l10n.profileAllergiesRetry,
                        onPressed: () {
                          context.read<AllergiesBloc>().add(
                                AllergiesRetried(
                                  lang: profileContentLang(context),
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      AppTextField(
                        hint: l10n.profileAllergiesSearchHint,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.muted(brightness),
                        ),
                        onChanged: (value) {
                          context.read<AllergiesBloc>().add(
                                AllergiesQueryChanged(
                                  value,
                                  lang: profileContentLang(context),
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              l10n.profileAllergiesSelected,
                              variant: AppTextVariant.title,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            if (state.selected.isEmpty)
                              AppText(
                                l10n.profileAllergiesEmpty,
                                variant: AppTextVariant.caption,
                                color: AppColors.muted(brightness),
                              )
                            else
                              Wrap(
                                spacing: AppSpacing.gap8,
                                runSpacing: AppSpacing.gap8,
                                children: [
                                  for (final allergy in state.selected)
                                    ProfileRemovableChip(
                                      label: allergy.name,
                                      onDeleted: () => context
                                          .read<AllergiesBloc>()
                                          .add(AllergiesToggled(allergy)),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      if (state.query.trim().isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.md,
                                  AppSpacing.md,
                                  AppSpacing.md,
                                  AppSpacing.sm,
                                ),
                                child: AppText(
                                  l10n.profileAllergiesResults,
                                  variant: AppTextVariant.title,
                                ),
                              ),
                              if (state.searching)
                                const Padding(
                                  padding: EdgeInsets.all(AppSpacing.lg),
                                  child: Center(child: AppLoading()),
                                )
                              else if (state.results.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSpacing.md,
                                    0,
                                    AppSpacing.md,
                                    AppSpacing.md,
                                  ),
                                  child: AppText(
                                    l10n.profileAllergiesEmpty,
                                    variant: AppTextVariant.caption,
                                    color: AppColors.muted(brightness),
                                  ),
                                )
                              else
                                for (var i = 0;
                                    i < state.results.length;
                                    i++) ...[
                                  if (i > 0)
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AppColors.stroke(brightness),
                                    ),
                                  _AllergyResultRow(
                                    name: state.results[i].canonicalName,
                                    categoryLabel:
                                        discoverIngredientCategoryLabel(
                                      l10n,
                                      state.results[i].category,
                                    ),
                                    selected: state.selected.any(
                                      (a) =>
                                          a.ingredientId ==
                                          state.results[i].id,
                                    ),
                                    onTap: () =>
                                        context.read<AllergiesBloc>().add(
                                              AllergiesToggled(
                                                UserAllergy(
                                                  ingredientId:
                                                      state.results[i].id,
                                                  name: state.results[i]
                                                      .canonicalName,
                                                ),
                                              ),
                                            ),
                                  ),
                                ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ProfileStickyActions(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton(
                        label: l10n.profileAllergiesClearAll,
                        variant: AppButtonVariant.text,
                        onPressed: state.selected.isEmpty
                            ? null
                            : () => context
                                .read<AllergiesBloc>()
                                .add(const AllergiesCleared()),
                      ),
                      AppButton(
                        label: l10n.profileAllergiesSave,
                        isLoading: state.saving,
                        onPressed: state.canSave
                            ? () => context
                                .read<AllergiesBloc>()
                                .add(const AllergiesSaveRequested())
                            : null,
                      ),
                    ],
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

class _AllergyResultRow extends StatelessWidget {
  const _AllergyResultRow({
    required this.name,
    required this.categoryLabel,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String categoryLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final muted = AppColors.muted(brightness);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.gap14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.body(
                        weight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.gap2),
                    Text(
                      categoryLabel,
                      style: AppTypography.caption(color: muted),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.add_circle_outline,
                color: selected ? AppColors.brand : muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
