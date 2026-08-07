import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/usecases/log_in_with_password.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';
import '../utils/auth_failure_messages.dart';
import '../widgets/auth_scroll_body.dart';
import '../widgets/social_auth_row.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        logInWithPassword: getIt<LogInWithPassword>(),
        logInWithSocial: getIt<LogInWithSocial>(),
        socialAuthService: getIt<SocialAuthService>(),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success && state.session != null) {
          context
              .read<AuthBloc>()
              .add(AuthSessionEstablished(state.session!));
        } else if (state.status == LoginStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(messageForFailure(state.failure!, l10n)),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppNavigationHeader(
          onBack: () => context.pop(),
        ),
        body: SafeArea(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              final loading = state.status == LoginStatus.loading;
              return AuthScrollBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      l10n.authLoginTitle,
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.authLoginSubtitle,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: l10n.authEmail,
                      hint: l10n.authEmail,
                      errorText:
                          localizeValidationError(state.emailError, l10n),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(LoginEmailChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.authPassword,
                      hint: l10n.authPassword,
                      obscureText: true,
                      errorText:
                          localizeValidationError(state.passwordError, l10n),
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppCheckbox(
                            value: state.rememberMe,
                            onChanged: (value) => context
                                .read<LoginBloc>()
                                .add(LoginRememberMeChanged(value)),
                            child: AppText(
                              l10n.authRememberMe,
                              variant: AppTextVariant.caption,
                            ),
                          ),
                        ),
                        AppLinkText(
                          style: AppTextVariant.caption,
                          spans: [
                            AppTextSpan(
                              text: l10n.authForgotPassword,
                              onTap: () => context.push('/forgot-password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppLinkText(
                      align: TextAlign.center,
                      style: AppTextVariant.caption,
                      spans: [
                        AppTextSpan(text: l10n.authNoAccountPrompt),
                        AppTextSpan(
                          text: l10n.authSignUp,
                          onTap: () => context.go('/signup'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SocialAuthRow(
                      enabled: !loading,
                      onGoogle: () => context.read<LoginBloc>().add(
                            const LoginSocialRequested(SocialProvider.google),
                          ),
                      onFacebook: () => context.read<LoginBloc>().add(
                            const LoginSocialRequested(
                              SocialProvider.facebook,
                            ),
                          ),
                    ),
                    const Spacer(),
                    AppButton(
                      label: l10n.authSignIn,
                      isLoading: loading,
                      onPressed: state.canSubmit
                          ? () => context
                              .read<LoginBloc>()
                              .add(const LoginSubmitted())
                          : null,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
