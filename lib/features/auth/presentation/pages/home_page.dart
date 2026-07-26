import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = context.watch<AuthBloc>().state.session;
    final name = session?.user.fullName;
    return Scaffold(
      appBar: AppBar(
        title: AppText(l10n.appTitle, variant: AppTextVariant.title),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings/language'),
            icon: const Icon(Icons.language),
            tooltip: l10n.openLanguageSettings,
          ),
          IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout),
            tooltip: l10n.authLogOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              name == null || name.isEmpty
                  ? l10n.authHomeWelcome
                  : l10n.authHomeWelcomeNamed(name),
              variant: AppTextVariant.headline,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppText(
              session?.user.email ?? '',
              variant: AppTextVariant.body,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
