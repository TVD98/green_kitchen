import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import '../tokens/app_typography.dart';

class AppDropdownItem<T> {
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.leading,
  });

  final T value;
  final String label;
  final Widget? leading;
}

/// Controlled select with filled trigger and overlay menu below the field.
class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hint = 'Select',
    this.maxMenuHeight = 260,
  });

  final List<AppDropdownItem<T>> items;
  final T? value;
  final String hint;
  final ValueChanged<T> onChanged;
  final double maxMenuHeight;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final _layerLink = LayerLink();
  final _triggerKey = GlobalKey();
  OverlayEntry? _entry;
  var _open = false;

  AppDropdownItem<T>? get _selected {
    if (widget.value == null) return null;
    for (final item in widget.items) {
      if (item.value == widget.value) return item;
    }
    return null;
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _close() {
    _entry?.remove();
    _entry = null;
    if (_open) setState(() => _open = false);
  }

  void _openMenu() {
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final width = box?.size.width ?? MediaQuery.sizeOf(context).width;

    _entry = OverlayEntry(
      builder: (context) {
        final brightness = Theme.of(context).brightness;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _close,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, (box?.size.height ?? 48) + 4),
              child: Material(
                elevation: 4,
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxMenuHeight,
                    maxWidth: width,
                    minWidth: width,
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: AppColors.stroke(brightness),
                    ),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return InkWell(
                        onTap: () {
                          widget.onChanged(item.value);
                          _close();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.gap16,
                            vertical: AppSpacing.gap14,
                          ),
                          child: Row(
                            children: [
                              if (item.leading != null) ...[
                                item.leading!,
                                const SizedBox(width: AppSpacing.gap12),
                              ],
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: AppTypography.body(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_entry!);
    setState(() => _open = true);
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final selected = _selected;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = AppColors.muted(brightness);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _triggerKey,
        onTap: _toggle,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.gap16,
            vertical: AppSpacing.gap14,
          ),
          decoration: BoxDecoration(
            color: AppColors.elevated(brightness),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              if (selected?.leading != null) ...[
                selected!.leading!,
                const SizedBox(width: AppSpacing.gap12),
              ],
              Expanded(
                child: Text(
                  selected?.label ?? widget.hint,
                  style: AppTypography.body(
                    color: selected == null ? muted : onSurface,
                  ),
                ),
              ),
              Icon(
                _open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
