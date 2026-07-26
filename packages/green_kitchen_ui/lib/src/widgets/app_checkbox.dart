import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Brand checkbox; only the box toggles (child gestures stay independent).
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.child,
    this.size = 24,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onChanged == null ? null : () => onChanged!(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: value ? AppColors.brand : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.brand, width: 1.5),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: AppColors.absoluteWhite,
                  )
                : null,
          ),
        ),
        if (child != null) ...[
          const SizedBox(width: AppSpacing.gap10),
          Expanded(child: child!),
        ],
      ],
    );
  }
}
