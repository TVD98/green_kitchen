import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.user.fullName;
    final email = session?.user.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: AppText(l10n.profileTitle, variant: AppTextVariant.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppText(
            name == null || name.isEmpty ? email : name,
            variant: AppTextVariant.headline,
          ),
          if (name != null && name.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            AppText(
              email,
              variant: AppTextVariant.body,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.profileLanguage),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings/language'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(l10n.profileLogout),
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
