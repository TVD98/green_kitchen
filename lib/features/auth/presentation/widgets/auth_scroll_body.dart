import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

/// Keeps a [Column] with [Spacer] full-height when space allows, and scrolls
/// when the keyboard (or small screen) shrinks the viewport.
class AuthScrollBody extends StatelessWidget {
  const AuthScrollBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(0, constraints.maxHeight - AppSpacing.lg * 2),
            ),
            child: IntrinsicHeight(child: child),
          ),
        );
      },
    );
  }
}
