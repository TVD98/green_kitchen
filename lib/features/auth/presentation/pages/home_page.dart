import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<AuthBloc>().state.session;
    return Scaffold(
      appBar: AppBar(
        title: const AppText('Green Kitchen', variant: AppTextVariant.title),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Welcome${session?.user.fullName != null ? ', ${session!.user.fullName}' : ''}!',
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
