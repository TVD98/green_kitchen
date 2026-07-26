import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

class AppSelectionItem<T> {
  const AppSelectionItem({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

enum AppSelectionMode { single, multi }

/// Standalone vertical selection list with brand checkmarks.
class AppSelectionList<T> extends StatelessWidget {
  const AppSelectionList({
    super.key,
    required this.items,
    required this.onChanged,
    this.selected = const {},
    this.mode = AppSelectionMode.single,
    this.maxHeight = 280,
  });

  final List<AppSelectionItem<T>> items;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final AppSelectionMode mode;
  final double maxHeight;

  void _tap(T value) {
    if (mode == AppSelectionMode.single) {
      onChanged({value});
      return;
    }
    final next = Set<T>.from(selected);
    if (!next.add(value)) {
      next.remove(value);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final stroke = AppColors.stroke(brightness);

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, _) => Divider(height: 1, color: stroke),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selected.contains(item.value);
            return InkWell(
              onTap: () => _tap(item.value),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gap16,
                  vertical: AppSpacing.gap14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppTypography.body(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        color: AppColors.brand,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
