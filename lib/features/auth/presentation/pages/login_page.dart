import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../data/datasources/social_auth_service.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/usecases/log_in_with_password.dart';
import '../../domain/usecases/log_in_with_social.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/login_bloc.dart';
import '../utils/auth_failure_messages.dart';
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

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  bool _obscure = true;

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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                final loading = state.status == LoginStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppText(
                      'Welcome Back!',
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      'Sign in to continue your journey of healthier cooking.',
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
                          .read<LoginBloc>()
                          .add(LoginEmailChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Password',
                      hint: 'Password',
                      obscureText: _obscure,
                      errorText: state.passwordError,
                      onChanged: (value) => context
                          .read<LoginBloc>()
                          .add(LoginPasswordChanged(value)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: state.rememberMe,
                          activeColor: AppColors.primary,
                          onChanged: (value) => context
                              .read<LoginBloc>()
                              .add(LoginRememberMeChanged(value ?? false)),
                        ),
                        const Expanded(
                          child: AppText(
                            'Remember me',
                            variant: AppTextVariant.caption,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/forgot-password'),
                          child: const AppText(
                            'Forgot Password?',
                            variant: AppTextVariant.caption,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const AppText(
                          "Don't have an account? ",
                          variant: AppTextVariant.caption,
                        ),
                        GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: const AppText(
                            'Sign up',
                            variant: AppTextVariant.caption,
                            color: AppColors.primary,
                          ),
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
                      label: 'Sign in',
                      isLoading: loading,
                      onPressed: state.canSubmit
                          ? () => context
                              .read<LoginBloc>()
                              .add(const LoginSubmitted())
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
