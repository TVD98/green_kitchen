import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';
import '../utils/auth_failure_messages.dart';
import '../widgets/social_auth_row.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        logInWithPassword: getIt(),
        logInWithSocial: getIt<LogInWithSocial>(),
        socialAuthService: getIt<SocialAuthService>(),
      ),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success && state.session != null) {
          context
              .read<AuthBloc>()
              .add(AuthSessionEstablished(state.session!));
        } else if (state.status == LoginStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(messageForFailure(state.failure!))),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.softBrand(Theme.of(context).brightness),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const AppText(
                  "Let's Get Started!",
                  variant: AppTextVariant.headline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  "Let's dive in into your account",
                  variant: AppTextVariant.body,
                  textAlign: TextAlign.center,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const Spacer(),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    final loading = state.status == LoginStatus.loading;
                    return SocialAuthButtons(
                      enabled: !loading,
                      onProvider: (provider) {
                        context
                            .read<LoginBloc>()
                            .add(LoginSocialRequested(provider));
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Sign up',
                  onPressed: () => context.push('/signup'),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Sign in',
                  variant: AppButtonVariant.outline,
                  onPressed: () => context.push('/login'),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppLinkText(
                  align: TextAlign.center,
                  style: AppTextVariant.caption,
                  spans: const [
                    AppTextSpan(text: 'Privacy Policy'),
                    AppTextSpan(text: '  ·  '),
                    AppTextSpan(text: 'Terms of Service'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
