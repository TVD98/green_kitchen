import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Compact token chip group with localized labels (single or multi).
class PreferenceTokenChips extends StatelessWidget {
  const PreferenceTokenChips({
    super.key,
    required this.tokens,
    required this.labelOf,
    required this.selected,
    required this.onChanged,
    this.singleSelect = false,
  });

  final List<String> tokens;
  final String Function(String token) labelOf;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final bool singleSelect;

  void _toggle(String token) {
    if (singleSelect) {
      if (selected.contains(token)) {
        onChanged({});
      } else {
        onChanged({token});
      }
      return;
    }
    final next = Set<String>.from(selected);
    if (!next.add(token)) {
      next.remove(token);
    }
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Wrap(
      spacing: AppSpacing.gap8,
      runSpacing: AppSpacing.gap8,
      children: [
        for (final token in tokens)
          _PreferenceChip(
            label: labelOf(token),
            selected: selected.contains(token),
            onTap: () => _toggle(token),
            brightness: brightness,
          ),
      ],
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
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
      ),
    );
  }
}
