import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_typography.dart';

/// A text span that may carry an optional tap callback (brand link).
class AppTextSpan {
  const AppTextSpan({
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;
}

/// Inline text with optional brand-colored tappable spans.
class AppLinkText extends StatelessWidget {
  const AppLinkText({
    super.key,
    required this.spans,
    this.align = TextAlign.start,
    this.style = AppTextVariant.body,
  });

  final List<AppTextSpan> spans;
  final TextAlign align;
  final AppTextVariant style;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final base = AppTypography.forVariant(style, color: onSurface);
    final link = base.copyWith(
      color: AppColors.brand,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
    );

    return Text.rich(
      TextSpan(
        children: [
          for (final span in spans)
            if (span.onTap == null)
              TextSpan(text: span.text, style: base)
            else
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: span.onTap,
                  child: Text(span.text, style: link),
                ),
              ),
        ],
      ),
      textAlign: align,
    );
  }
}
