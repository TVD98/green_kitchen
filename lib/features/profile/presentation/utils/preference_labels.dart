import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/preference_allow_lists.dart';

String dietaryStyleLabel(AppLocalizations l10n, String token) {
  return switch (token) {
    'omnivore' => l10n.profileDietaryOmnivore,
    'vegetarian' => l10n.profileDietaryVegetarian,
    'vegan' => l10n.profileDietaryVegan,
    'pescatarian' => l10n.profileDietaryPescatarian,
    _ => token,
  };
}

String spiceLevelLabel(AppLocalizations l10n, String token) {
  return switch (token) {
    'mild' => l10n.profileSpiceMild,
    'medium' => l10n.profileSpiceMedium,
    'hot' => l10n.profileSpiceHot,
    _ => token,
  };
}

String cuisineLabel(AppLocalizations l10n, String token) {
  return switch (token) {
    'vietnamese' => l10n.profileCuisineVietnamese,
    'japanese' => l10n.profileCuisineJapanese,
    'korean' => l10n.profileCuisineKorean,
    'chinese' => l10n.profileCuisineChinese,
    'thai' => l10n.profileCuisineThai,
    'western' => l10n.profileCuisineWestern,
    'indian' => l10n.profileCuisineIndian,
    _ => token,
  };
}

String healthGoalLabel(AppLocalizations l10n, String token) {
  return switch (token) {
    'low_carb' => l10n.profileGoalLowCarb,
    'high_protein' => l10n.profileGoalHighProtein,
    'low_fat' => l10n.profileGoalLowFat,
    'balanced' => l10n.profileGoalBalanced,
    'weight_loss' => l10n.profileGoalWeightLoss,
    _ => token,
  };
}

List<String> knownCuisineTokens() => PreferenceAllowLists.cuisines;

List<String> knownHealthGoalTokens() => PreferenceAllowLists.healthGoals;
