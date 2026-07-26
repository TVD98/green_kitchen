import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// Single radio control with optional [child] label.
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.child,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final Widget? child;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final ring = _selected ? AppColors.brand : AppColors.muted(brightness);

    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(value),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: ring, width: 2),
            ),
            child: _selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.brand,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          if (child != null) ...[
            const SizedBox(width: AppSpacing.gap12),
            Expanded(child: child!),
          ],
        ],
      ),
    );
  }
}

/// Controlled single-select vertical radio list (no dividers).
class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final List<AppRadioGroupItem<T>> items;
  final T? value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items) ...[
          AppRadio<T>(
            value: item.value,
            groupValue: value,
            onChanged: onChanged,
            child: item.child ??
                Text(
                  item.label ?? '',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.gap16),
        ],
      ],
    );
  }
}

class AppRadioGroupItem<T> {
  const AppRadioGroupItem({
    required this.value,
    this.label,
    this.child,
  });

  final T value;
  final String? label;
  final Widget? child;
}
