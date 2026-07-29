import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../utils/discover_theme.dart';

class DiscoverBottomBar extends StatelessWidget {
  const DiscoverBottomBar({
    super.key,
    required this.canSearch,
    required this.onSearch,
  });

  final bool canSearch;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            onPressed: canSearch ? onSearch : null,
            style: DiscoverTheme.primaryButtonStyle(
              Theme.of(context).brightness,
            ),
            child: Text(
              l10n.discoverFindRecipes,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            l10n.discoverAiDisclaimer,
            variant: AppTextVariant.caption,
            textAlign: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
