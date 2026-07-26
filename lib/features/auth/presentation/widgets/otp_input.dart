import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant OtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
      _controller.selection = TextSelection.collapsed(
        offset: widget.value.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digits = List<String>.generate(
      4,
      (index) => index < widget.value.length ? widget.value[index] : '',
    );

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          Opacity(
            opacity: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              keyboardType: TextInputType.number,
              maxLength: 4,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: widget.onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              final isFocused = widget.value.length == index ||
                  (widget.value.length == 4 && index == 3);
              return Container(
                width: 72,
                height: 66,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isFocused
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isFocused ? AppColors.primary : Colors.transparent,
                  ),
                ),
                child: AppText(
                  digits[index],
                  variant: AppTextVariant.title,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
