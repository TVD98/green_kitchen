import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../../domain/usecases/sign_up.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/signup_bloc.dart';
import '../utils/auth_failure_messages.dart';
import '../widgets/social_auth_row.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(
        signUp: getIt<SignUp>(),
        logInWithSocial: getIt<LogInWithSocial>(),
        socialAuthService: getIt<SocialAuthService>(),
      ),
      child: const _SignupView(),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.status == SignupStatus.success && state.session != null) {
          context
              .read<AuthBloc>()
              .add(AuthSessionEstablished(state.session!));
        } else if (state.status == SignupStatus.failure &&
            state.failure != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(messageForFailure(state.failure!))),
          );
        }
      },
      child: Scaffold(
        appBar: AppNavigationHeader(
          onBack: () => context.pop(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                final loading = state.status == SignupStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppText(
                      'Join Green Kitchen Today!',
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      'Create your account to start cooking healthier meals.',
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: 'Email',
                      hint: 'Email',
                      errorText: state.emailError,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context
                          .read<SignupBloc>()
                          .add(SignupEmailChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Password',
                      hint: 'Password',
                      obscureText: true,
                      errorText: state.passwordError,
                      onChanged: (value) => context
                          .read<SignupBloc>()
                          .add(SignupPasswordChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppCheckbox(
                      value: state.acceptedTerms,
                      onChanged: (value) => context
                          .read<SignupBloc>()
                          .add(SignupTermsChanged(value)),
                      child: const AppText(
                        'I agree to Terms & Conditions',
                        variant: AppTextVariant.caption,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppLinkText(
                      align: TextAlign.center,
                      style: AppTextVariant.caption,
                      spans: [
                        const AppTextSpan(text: 'Already have an account? '),
                        AppTextSpan(
                          text: 'Sign in',
                          onTap: () => context.go('/login'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SocialAuthRow(
                      enabled: !loading,
                      onGoogle: () => context.read<SignupBloc>().add(
                            const SignupSocialRequested(
                              SocialProvider.google,
                            ),
                          ),
                      onFacebook: () => context.read<SignupBloc>().add(
                            const SignupSocialRequested(
                              SocialProvider.facebook,
                            ),
                          ),
                    ),
                    const Spacer(),
                    AppButton(
                      label: 'Sign up',
                      isLoading: loading,
                      onPressed: state.canSubmit
                          ? () => context
                              .read<SignupBloc>()
                              .add(const SignupSubmitted())
                          : null,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
