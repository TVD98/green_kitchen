import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Flat AppBar matching Discover / Profile nested screens.
PreferredSizeWidget discoverThemedAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
  Color? backgroundColor,
}) {
  return AppBar(
    backgroundColor:
        backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Theme.of(context).colorScheme.onSurface,
    ),
    title: AppText(title, variant: AppTextVariant.title),
    actions: actions,
  );
}
