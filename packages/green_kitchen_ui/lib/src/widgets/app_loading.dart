import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Centered brand-colored loading indicator.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = 36,
    this.strokeWidth = 3,
  });

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
