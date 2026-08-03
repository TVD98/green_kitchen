/// Curated allow-lists for preferences UI (API accepts free strings).
abstract final class PreferenceAllowLists {
  static const dietaryStyles = [
    'omnivore',
    'vegetarian',
    'vegan',
    'pescatarian',
  ];

  static const spiceLevels = [
    'mild',
    'medium',
    'hot',
  ];

  static const cuisines = [
    'vietnamese',
    'japanese',
    'korean',
    'chinese',
    'thai',
    'western',
    'indian',
  ];

  static const healthGoals = [
    'low_carb',
    'high_protein',
    'low_fat',
    'balanced',
    'weight_loss',
  ];
}
