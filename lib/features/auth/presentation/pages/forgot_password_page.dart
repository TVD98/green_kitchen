import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/forgot_password.dart';
import '../bloc/forgot_password_bloc.dart';
import '../utils/auth_failure_messages.dart';
import '../widgets/auth_scroll_body.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordBloc(
        forgotPassword: getIt<ForgotPassword>(),
      ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.success &&
            state.otpSession != null) {
          final session = state.otpSession!;
          context.push(
            '/otp',
            extra: {
              'sessionId': session.sessionId,
              'email': session.email ?? state.email,
              'expireInSeconds': session.expireInSeconds,
              'resendAfterSeconds': session.resendAfterSeconds,
            },
          );
        } else if (state.status == ForgotPasswordStatus.failure &&
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
          child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
            builder: (context, state) {
              final loading = state.status == ForgotPasswordStatus.loading;
              return AuthScrollBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      l10n.authForgotTitle,
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.authForgotSubtitle,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: l10n.authRegisteredEmail,
                      hint: l10n.authEmail,
                      errorText:
                          localizeValidationError(state.emailError, l10n),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context
                          .read<ForgotPasswordBloc>()
                          .add(ForgotPasswordEmailChanged(value)),
                    ),
                    const Spacer(),
                    AppButton(
                      label: l10n.authSendOtp,
                      isLoading: loading,
                      onPressed: state.canSubmit
                          ? () => context
                              .read<ForgotPasswordBloc>()
                              .add(const ForgotPasswordSubmitted())
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
