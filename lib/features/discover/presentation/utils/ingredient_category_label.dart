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
    default:
      return l10n.discoverIngredientCategoryOther;
  }
}
