import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
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

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView();

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == ResetPasswordStatus.success) {
          context.go('/password-updated');
        } else if (state.status == ResetPasswordStatus.failure &&
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
            child: BlocBuilder<ResetPasswordBloc, ResetPasswordState>(
              builder: (context, state) {
                final loading = state.status == ResetPasswordStatus.loading;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppText(
                      'Secure Your Account',
                      variant: AppTextVariant.headline,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppText(
                      'Your new password must be at least 8 characters long. Avoid using the same one as before.',
                      variant: AppTextVariant.body,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppTextField(
                      label: 'Create new password',
                      hint: 'Password',
                      obscureText: _obscurePassword,
                      errorText: state.passwordError,
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetPasswordChanged(value)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    AppTextField(
                      label: 'Confirm new password',
                      hint: 'Password',
                      obscureText: _obscureConfirm,
                      errorText: state.confirmError,
                      onChanged: (value) => context
                          .read<ResetPasswordBloc>()
                          .add(ResetConfirmPasswordChanged(value)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    if (state.failure is InvalidResetTokenFailure ||
                        state.failure is ResetTokenExpiredFailure)
                      TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: const Text('Request a new reset code'),
                      ),
                    const Spacer(),
                    AppButton(
                      label: 'Save New Password',
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
