import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

enum AppChipsLayout { scroll, wrap }

/// Controlled multi-select pill chip group.
class AppChips extends StatelessWidget {
  const AppChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.layout = AppChipsLayout.scroll,
  });

  final List<String> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final AppChipsLayout layout;

  void _toggle(String option) {
    final next = Set<String>.from(selected);
    if (!next.add(option)) {
      next.remove(option);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final chips = [
      for (final option in options)
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.gap8),
          child: _Chip(
            label: option,
            selected: selected.contains(option),
            onTap: () => _toggle(option),
            brightness: brightness,
          ),
        ),
    ];

    if (layout == AppChipsLayout.wrap) {
      return Wrap(
        runSpacing: AppSpacing.gap8,
        children: chips,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.brightness,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.gap16,
          vertical: AppSpacing.gap10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.brand
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: selected
              ? null
              : Border.all(color: AppColors.stroke(brightness)),
        ),
        child: Text(
          label,
          style: AppTypography.label(
            color: selected
                ? AppColors.absoluteWhite
                : Theme.of(context).colorScheme.onSurface,
          ).copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
