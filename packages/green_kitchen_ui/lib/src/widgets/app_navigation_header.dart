import 'package:flutter/material.dart';

import '../tokens/app_typography.dart';

/// Flat toolbar: optional back · centered H4 title · optional actions.
class AppNavigationHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const AppNavigationHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.leading,
  });

  final String? title;
  final Widget? titleWidget;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? leading;

  static const double height = 48;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final hasLeading = leading != null || showBack;
    final hasActions = actions != null && actions!.isNotEmpty;

    final leadingWidget = leading ??
        (showBack
            ? IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: onSurface,
                  size: 20,
                ),
              )
            : null);

    // Mirror Material AppBar: Scaffold allocates preferredSize + status-bar
    // inset, and the toolbar itself must sit below the safe area.
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: hasLeading ? leadingWidget : null,
              ),
              Expanded(
                child: titleWidget ??
                    (title == null
                        ? const SizedBox.shrink()
                        : Text(
                            title!,
                            textAlign: TextAlign.center,
                            style: AppTypography.h4(color: onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
              ),
              SizedBox(
                width: hasActions ? null : 48,
                child: hasActions
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions!,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
