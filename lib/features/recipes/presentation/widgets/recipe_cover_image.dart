import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Cover image for a recipe. Renders nothing when [imageUrl] is null/empty.
class RecipeCoverImage extends StatelessWidget {
  const RecipeCoverImage({
    super.key,
    required this.imageUrl,
    this.height = 160,
    this.borderRadius,
  });

  final String? imageUrl;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    if (url == null || url.isEmpty) {
      return const SizedBox.shrink();
    }

    final radius = borderRadius ?? BorderRadius.circular(AppRadius.md);
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: radius,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: height,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: const Center(child: AppLoading()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: scheme.surfaceContainerHighest,
              child: Icon(
                Icons.restaurant_outlined,
                size: 40,
                color: scheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
    );
  }
}
