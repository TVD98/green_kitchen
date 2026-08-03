import 'package:flutter/material.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../utils/discover_constants.dart';

class DiscoverPromptCard extends StatefulWidget {
  const DiscoverPromptCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onVoiceTap,
    this.isListening = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onVoiceTap;
  final bool isListening;

  @override
  State<DiscoverPromptCard> createState() => _DiscoverPromptCardState();
}

class _DiscoverPromptCardState extends State<DiscoverPromptCard> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final count = widget.controller.text.characters.length;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            maxLines: 4,
            minLines: 3,
            maxLength: DiscoverConstants.maxPromptLength,
            decoration: InputDecoration(
              hintText: l10n.discoverPromptHint,
              border: InputBorder.none,
              counterText: '',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.discoverVoiceSuggestion,
                  variant: AppButtonVariant.text,
                  leading: Icon(
                    widget.isListening ? Icons.mic : Icons.mic_none_outlined,
                  ),
                  onPressed: widget.onVoiceTap,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppText(
                '$count/${DiscoverConstants.maxPromptLength}',
                variant: AppTextVariant.caption,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              IconButton(
                onPressed:
                    widget.controller.text.isEmpty ? null : widget.onClear,
                icon: const Icon(Icons.close),
                tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
