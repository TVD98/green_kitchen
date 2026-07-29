import '../../../../l10n/app_localizations.dart';
import '../../../recipes/domain/entities/pantry_filters.dart';

enum QuickStartPreset {
  fridge,
  cravings,
  fastHealthy,
  vegetarian,
}

extension QuickStartPresetX on QuickStartPreset {
  ({String prompt, PantryFilters? filters}) build(
    AppLocalizations l10n, {
    String? userInput,
  }) {
    switch (this) {
      case QuickStartPreset.fridge:
        final input = userInput?.trim();
        return (
          prompt: input != null && input.isNotEmpty
              ? l10n.discoverPromptFridgeWithIngredients(input)
              : l10n.discoverPromptFridgeEmpty,
          filters: null,
        );
      case QuickStartPreset.cravings:
        final craving = userInput?.trim();
        return (
          prompt: craving != null && craving.isNotEmpty
              ? l10n.discoverPromptCravingsWithInput(craving)
              : l10n.discoverPromptCravingsTemplate,
          filters: null,
        );
      case QuickStartPreset.fastHealthy:
        return (
          prompt: l10n.discoverPromptFastHealthy,
          filters: const PantryFilters(maxTime: 30, tags: ['healthy']),
        );
      case QuickStartPreset.vegetarian:
        return (
          prompt: l10n.discoverPromptVegetarian,
          filters: const PantryFilters(tags: ['vegetarian']),
        );
    }
  }
}
