import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';

class DiscoverHeroSection extends StatelessWidget {
  const DiscoverHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(l10n.discoverTitle, variant: AppTextVariant.headline),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          l10n.discoverSubtitle,
          variant: AppTextVariant.body,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}
