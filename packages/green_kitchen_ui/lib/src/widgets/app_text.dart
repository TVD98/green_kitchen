import 'package:flutter/material.dart';

import '../tokens/app_typography.dart';

/// Text widget bound to the design-system typography scale.
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.variant = AppTextVariant.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: AppTypography.forVariant(
        variant,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
