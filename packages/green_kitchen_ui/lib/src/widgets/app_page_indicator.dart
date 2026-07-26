import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Controlled page dots: active brand pill, inactive greyscale circles.
class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.count,
    required this.index,
    this.onChanged,
  });

  final int count;
  final int index;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final muted = AppColors.muted(Theme.of(context).brightness);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.gap6),
          GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: i == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? AppColors.brand : muted,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
