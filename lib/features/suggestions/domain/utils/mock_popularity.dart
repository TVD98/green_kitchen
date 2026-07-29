import '../../../recipes/domain/entities/recipe.dart';

int mockViewCountForRecipe(Recipe recipe) {
  var hash = 0;
  for (final unit in recipe.id.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  return 500 + (hash % 9500);
}

String formatMockViewCount(int count) {
  if (count >= 1000) {
    final thousands = count / 1000;
    return '${thousands.toStringAsFixed(1)}k';
  }
  return count.toString();
}
