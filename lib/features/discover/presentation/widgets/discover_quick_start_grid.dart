import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../utils/quick_start_preset.dart';
import 'quick_start_pill.dart';

class DiscoverQuickStartGrid extends StatelessWidget {
  const DiscoverQuickStartGrid({
    super.key,
    required this.onPresetSelected,
  });

  final ValueChanged<QuickStartPreset> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(l10n.discoverQuickStartLabel, variant: AppTextVariant.title),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.35,
          children: [
            QuickStartPill(
              label: l10n.discoverQuickStartFridge,
              icon: Icons.kitchen_outlined,
              onTap: () => onPresetSelected(QuickStartPreset.fridge),
            ),
            QuickStartPill(
              label: l10n.discoverQuickStartCravings,
              icon: Icons.favorite_border,
              onTap: () => onPresetSelected(QuickStartPreset.cravings),
            ),
            QuickStartPill(
              label: l10n.discoverQuickStartFastHealthy,
              icon: Icons.timer_outlined,
              onTap: () => onPresetSelected(QuickStartPreset.fastHealthy),
            ),
            QuickStartPill(
              label: l10n.discoverQuickStartVegetarian,
              icon: Icons.eco_outlined,
              onTap: () => onPresetSelected(QuickStartPreset.vegetarian),
            ),
          ],
        ),
      ],
    );
  }
}
