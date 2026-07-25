import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../domain/entities/social_provider.dart';

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({
    super.key,
    required this.onGoogle,
    required this.onFacebook,
    this.enabled = true,
  });

  final VoidCallback onGoogle;
  final VoidCallback onFacebook;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: AppText(
                'or continue with',
                variant: AppTextVariant.caption,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconButton(
              label: 'Google',
              icon: Icons.g_mobiledata,
              onPressed: enabled ? onGoogle : null,
            ),
            const SizedBox(width: AppSpacing.md),
            _SocialIconButton(
              label: 'Facebook',
              icon: Icons.facebook,
              onPressed: enabled ? onFacebook : null,
            ),
          ],
        ),
      ],
    );
  }
}

class SocialAuthButtons extends StatelessWidget {
  const SocialAuthButtons({
    super.key,
    required this.onProvider,
    this.enabled = true,
  });

  final ValueChanged<SocialProvider> onProvider;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          label: 'Continue with Google',
          variant: AppButtonVariant.outline,
          onPressed: enabled ? () => onProvider(SocialProvider.google) : null,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Continue with Facebook',
          variant: AppButtonVariant.outline,
          onPressed:
              enabled ? () => onProvider(SocialProvider.facebook) : null,
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(AppSpacing.md),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
