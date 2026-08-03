import '../../../../l10n/app_localizations.dart';

String discoverIngredientCategoryLabel(
  AppLocalizations l10n,
  String category,
) {
  switch (category.toLowerCase()) {
    case 'vegetable':
    case 'vegetables':
      return l10n.discoverIngredientCategoryVegetable;
    case 'protein':
      return l10n.discoverIngredientCategoryProtein;
    case 'dairy':
      return l10n.discoverIngredientCategoryDairy;
    case 'grain':
    case 'grains':
      return l10n.discoverIngredientCategoryGrain;
    case 'carb':
    case 'carbs':
      return l10n.discoverIngredientCategoryCarb;
    case 'aromatic':
    case 'aromatics':
      return l10n.discoverIngredientCategoryAromatic;
    case 'spice':
    case 'spices':
      return l10n.discoverIngredientCategorySpice;
    case 'seasoning':
    case 'seasonings':
      return l10n.discoverIngredientCategorySeasoning;
    case 'herb':
    case 'herbs':
      return l10n.discoverIngredientCategoryHerb;
    default:
      return l10n.discoverIngredientCategoryOther;
  }
}
