import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import '../../../../core/di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../locale_preference/presentation/cubit/locale_preference_cubit.dart';
import '../bloc/discover_bloc.dart';
import '../models/discovery_search_args.dart';
import '../services/discover_speech_service.dart';
import '../utils/quick_start_preset.dart';
import '../widgets/discover_bottom_bar.dart';
import '../widgets/discover_hero_section.dart';
import '../widgets/discover_option_tile.dart';
import '../widgets/discover_prompt_card.dart';
import '../widgets/discover_quick_start_grid.dart';
import '../widgets/fridge_ingredients_sheet.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _promptController = TextEditingController();
  final _speechService = DiscoverSpeechService();
  bool _isListening = false;

  @override
  void dispose() {
    _speechService.stopListening();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _openFridgeSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<DiscoverBloc>();
    final applied = await AppBottomSheet.show<bool>(
      context: context,
      child: BlocProvider.value(
        value: bloc,
        child: const FridgeIngredientsSheet(),
      ),
    );
    if (applied == true && context.mounted) {
      final state = bloc.state;
      final built = QuickStartPreset.fridge.build(
        l10n,
        userInput: state.sheetSelectedIngredients.join(', '),
      );
      bloc.add(
        DiscoverFridgeApplied(
          built.prompt,
          List<String>.from(state.sheetSelectedIngredients),
        ),
      );
      _promptController.text = built.prompt;
      _promptController.selection = TextSelection.collapsed(
        offset: built.prompt.length,
      );
    }
  }

  void _onQuickStartSelected(BuildContext context, QuickStartPreset preset) {
    if (preset == QuickStartPreset.fridge) {
      _openFridgeSheet(context);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    final built = preset.build(l10n);
    context.read<DiscoverBloc>().add(
          DiscoverQuickStartSelected(
            preset,
            built.prompt,
            filters: built.filters,
          ),
        );
    _promptController.text = built.prompt;
    _promptController.selection = TextSelection.collapsed(
      offset: built.prompt.length,
    );
  }

  Future<void> _startVoiceInput(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isListening = true);
    final started = await _speechService.startListening(
      onResult: (transcript) {
        if (mounted) {
          context.read<DiscoverBloc>().add(
                DiscoverVoiceTranscriptAppended(transcript),
              );
          final next = context.read<DiscoverBloc>().state.prompt;
          _promptController.text = next;
          _promptController.selection = TextSelection.collapsed(offset: next.length);
        }
      },
      onError: (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.discoverVoicePermissionDenied)),
          );
        }
      },
    );
    if (!started) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.discoverVoicePermissionDenied)),
      );
    }
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  void _navigateToResults(BuildContext context, DiscoverState state) {
    context.push(
      '/discovery/results',
      extra: DiscoverySearchArgs(
        prompt: state.prompt.trim(),
        usePreferences: state.usePreferences,
        excludeAllergies: state.excludeAllergies,
        filters: state.filters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<DiscoverBloc>()..add(const DiscoverStarted()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<LocalePreferenceCubit, LocalePreferenceState>(
            listenWhen: (prev, next) => prev.preference != next.preference,
            listener: (context, _) {
              context.read<DiscoverBloc>().add(const DiscoverContentReset());
              _promptController.clear();
            },
          ),
          BlocListener<DiscoverBloc, DiscoverState>(
            listenWhen: (prev, next) => prev.prompt != next.prompt,
            listener: (context, state) {
              if (_promptController.text != state.prompt) {
                _promptController.text = state.prompt;
              }
            },
          ),
        ],
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      return ListView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        children: [
                          const DiscoverHeroSection(),
                          const SizedBox(height: AppSpacing.lg),
                          DiscoverPromptCard(
                            controller: _promptController,
                            onChanged: (value) => context
                                .read<DiscoverBloc>()
                                .add(DiscoverPromptChanged(value)),
                            onClear: () {
                              context
                                  .read<DiscoverBloc>()
                                  .add(const DiscoverPromptCleared());
                              _promptController.clear();
                            },
                            onVoiceTap: () => _startVoiceInput(context),
                            isListening: _isListening,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DiscoverOptionTile(
                            icon: Icons.restaurant_menu_outlined,
                            title: l10n.discoverUsePreferencesTitle,
                            subtitle: l10n.discoverUsePreferencesSubtitle,
                            value: state.usePreferences,
                            onChanged: (value) => context
                                .read<DiscoverBloc>()
                                .add(DiscoverUsePreferencesToggled(value)),
                          ),
                          DiscoverOptionTile(
                            icon: Icons.health_and_safety_outlined,
                            title: l10n.discoverExcludeAllergiesTitle,
                            subtitle: l10n.discoverExcludeAllergiesSubtitle,
                            value: state.excludeAllergies,
                            onChanged: (value) => context
                                .read<DiscoverBloc>()
                                .add(DiscoverExcludeAllergiesToggled(value)),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DiscoverQuickStartGrid(
                            onPresetSelected: (preset) =>
                                _onQuickStartSelected(context, preset),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      );
                    },
                  ),
                ),
                BlocBuilder<DiscoverBloc, DiscoverState>(
                  builder: (context, state) {
                    return DiscoverBottomBar(
                      canSearch: state.canSearch,
                      onSearch: () => _navigateToResults(context, state),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
