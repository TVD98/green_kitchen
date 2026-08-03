import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/profile_hub_cubit.dart';
import '../utils/preferences_hub_subtitle.dart';
import '../widgets/profile_menu_row.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.hubCubit});

  /// Optional override for tests; production uses DI.
  final ProfileHubCubit? hubCubit;

  @override
  Widget build(BuildContext context) {
    final override = hubCubit;
    if (override != null) {
      return BlocProvider.value(
        value: override,
        child: const _ProfileView(),
      );
    }
    return BlocProvider(
      create: (_) => getIt<ProfileHubCubit>()..loadSummaries(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final brightness = Theme.of(context).brightness;
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.user.fullName;
    final email = session?.user.email ?? '';
    final hub = context.watch<ProfileHubCubit>().state;

    final preferencesSubtitle = preferencesHubSubtitle(
      l10n,
      hub.preferences,
      loaded: hub.preferencesLoaded,
    );

    final allergiesSubtitle = !hub.allergiesLoaded
        ? null
        : (hub.allergyCount == null || hub.allergyCount == 0)
            ? l10n.profileAllergiesSubtitleEmpty
            : l10n.profileAllergiesSubtitleCount(hub.allergyCount!);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: AppText(l10n.profileTitle, variant: AppTextVariant.title),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppText(
            name == null || name.isEmpty ? email : name,
            variant: AppTextVariant.headline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          if (name != null && name.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            AppText(
              email,
              variant: AppTextVariant.body,
              color: AppColors.muted(brightness),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ProfileMenuRow(
                  icon: Icons.restaurant_menu,
                  title: l10n.profilePreferences,
                  subtitle: preferencesSubtitle,
                  onTap: () async {
                    await context.push('/home/profile/preferences');
                    if (context.mounted) {
                      context.read<ProfileHubCubit>().loadSummaries();
                    }
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.stroke(brightness),
                ),
                ProfileMenuRow(
                  icon: Icons.health_and_safety_outlined,
                  title: l10n.profileAllergies,
                  subtitle: allergiesSubtitle,
                  onTap: () async {
                    await context.push('/home/profile/allergies');
                    if (context.mounted) {
                      context.read<ProfileHubCubit>().loadSummaries();
                    }
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.stroke(brightness),
                ),
                ProfileMenuRow(
                  icon: Icons.language,
                  title: l10n.profileLanguage,
                  onTap: () => context.push('/settings/language'),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.stroke(brightness),
                ),
                ProfileMenuRow(
                  icon: Icons.logout,
                  title: l10n.profileLogout,
                  showChevron: false,
                  destructive: true,
                  onTap: () => context
                      .read<AuthBloc>()
                      .add(const AuthLogoutRequested()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
