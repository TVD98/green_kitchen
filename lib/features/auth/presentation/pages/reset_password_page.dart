import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/reset_password.dart';
import '../bloc/reset_password_bloc.dart';
import '../utils/auth_failure_messages.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key, required this.resetToken});

  final String resetToken;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(
        resetPassword: getIt<ResetPassword>(),
        resetToken: resetToken,
      ),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          context.go('/password-updated');
        } else if (state.status == ResetPasswordStatus.failure &&
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
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              builder: (context, state) {
                final loading = state.status == ResetPasswordStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      l10n.authResetTitle,
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.authResetSubtitle,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: l10n.authCreateNewPassword,
                      hint: l10n.authPassword,
                      obscureText: true,
                      errorText:
                          localizeValidationError(state.passwordError, l10n),
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetPasswordChanged(value)),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: l10n.authConfirmNewPassword,
                      hint: l10n.authPassword,
                      obscureText: true,
                      errorText:
                          localizeValidationError(state.confirmError, l10n),
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetConfirmPasswordChanged(value)),
                    ),
                    if (state.failure is InvalidResetTokenFailure ||
                        state.failure is ResetTokenExpiredFailure) ...[
                      const SizedBox(height: AppSpacing.md),
                      AppLinkText(
                        align: TextAlign.center,
                        spans: [
                          AppTextSpan(
                            text: l10n.authRequestNewResetCode,
                            onTap: () => context.go('/forgot-password'),
                          ),
                        ],
                      ),
                    ],
                    const Spacer(),
                    AppButton(
                      label: l10n.authSaveNewPassword,
                      isLoading: loading,
                      onPressed: state.canSubmit
                          ? () => context
                              .read<ResetPasswordBloc>()
                              .add(const ResetPasswordSubmitted())
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
