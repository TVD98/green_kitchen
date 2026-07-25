import 'package:flutter/material.dart';

import '../tokens/app_typography.dart';
import 'app_button.dart';
import 'app_text.dart';

/// Helper to show a standard title/body/actions dialog.
abstract final class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String body,
    String? confirmLabel,
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: AppText(title, variant: AppTextVariant.title),
          content: AppText(body, variant: AppTextVariant.body),
          actions: [
            if (cancelLabel != null)
              AppButton(
                label: cancelLabel,
                variant: AppButtonVariant.text,
                isExpanded: false,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onCancel?.call();
                },
              ),
            if (confirmLabel != null)
              AppButton(
                label: confirmLabel,
                variant: AppButtonVariant.primary,
                isExpanded: false,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onConfirm?.call();
                },
              ),
          ],
        );
      },
    );
  }
}
