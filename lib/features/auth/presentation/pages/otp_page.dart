import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/verify_otp.dart';
import '../bloc/otp_bloc.dart';
import '../utils/auth_failure_messages.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({
    super.key,
    required this.sessionId,
    required this.email,
    required this.expireInSeconds,
    required this.resendAfterSeconds,
  });

  final String sessionId;
  final String email;
  final int expireInSeconds;
  final int resendAfterSeconds;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpBloc(
        verifyOtp: getIt<VerifyOtp>(),
        forgotPassword: getIt<ForgotPassword>(),
        sessionId: sessionId,
        email: email,
        expireInSeconds: expireInSeconds,
        resendAfterSeconds: resendAfterSeconds,
      ),
      child: const _OtpView(),
    );
  }
}

class _OtpView extends StatelessWidget {
  const _OtpView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
        if (state.status == OtpStatus.success && state.resetToken != null) {
          context.push(
            '/reset-password',
            extra: {'resetToken': state.resetToken},
          );
        } else if (state.status == OtpStatus.failure && state.failure != null) {
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
            child: BlocBuilder<OtpBloc, OtpState>(
              builder: (context, state) {
                final loading = state.status == OtpStatus.loading;
                final codeError =
                    localizeValidationError(state.codeError, l10n);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      l10n.authOtpTitle,
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      l10n.authOtpSubtitle,
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    OtpInput(
                      value: state.code,
                      enabled: !loading,
                      onChanged: (value) =>
                          context.read<OtpBloc>().add(OtpCodeChanged(value)),
                    ),
                    if (codeError != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      AppText(
                        codeError,
                        variant: AppTextVariant.caption,
                        color: AppColors.error,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AppText(
                      state.resendSecondsLeft > 0
                          ? l10n.authOtpResendInSeconds(
                              state.resendSecondsLeft,
                            )
                          : l10n.authOtpResendNow,
                      variant: AppTextVariant.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppLinkText(
                      align: TextAlign.center,
                      spans: [
                        AppTextSpan(
                          text: l10n.authResendCode,
                          onTap: state.canResend
                              ? () => context
                                  .read<OtpBloc>()
                                  .add(const OtpResendRequested())
                              : null,
                        ),
                      ],
                    ),
                    if (state.failure is InvalidResetTokenFailure ||
                        state.failure is ResetTokenExpiredFailure)
                      AppLinkText(
                        align: TextAlign.center,
                        spans: [
                          AppTextSpan(
                            text: l10n.authRequestNewCode,
                            onTap: () => context.go('/forgot-password'),
                          ),
                        ],
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
