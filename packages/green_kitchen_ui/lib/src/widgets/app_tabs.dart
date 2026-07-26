import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppTabsLayout { fill, hug, scrollable }

/// Controlled segmented selector (reports [onChanged] only).
class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.layout = AppTabsLayout.fill,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final AppTabsLayout layout;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final track = AppColors.elevated(brightness);

    Widget segment(int index) {
      final selected = index == selectedIndex;
      return GestureDetector(
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gap16,
            vertical: AppSpacing.gap10,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.tab),
            boxShadow: selected && brightness == Brightness.light
                ? [
                    BoxShadow(
                      color: AppColors.brand.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            tabs[index],
            textAlign: TextAlign.center,
            style: AppTypography.label(
              color: selected
                  ? AppColors.absoluteWhite
                  : AppColors.mutedStrong(brightness),
            ).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    final children = [
      for (var i = 0; i < tabs.length; i++)
        if (layout == AppTabsLayout.fill)
          Expanded(child: segment(i))
        else
          segment(i),
    ];

    final row = Container(
      padding: const EdgeInsets.all(AppSpacing.gap4),
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(AppRadius.tab + 2),
      ),
      child: Row(
        mainAxisSize:
            layout == AppTabsLayout.fill ? MainAxisSize.max : MainAxisSize.min,
        children: children,
      ),
    );

    if (layout == AppTabsLayout.scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: row,
      );
    }
    return row;
  }
}
