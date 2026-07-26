import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Controlled boolean toggle with Focuso brand ON / greyscale OFF.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.brand,
      inactiveTrackColor: AppColors.muted(brightness),
      thumbColor: WidgetStateProperty.all(AppColors.absoluteWhite),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    );
  }
}
