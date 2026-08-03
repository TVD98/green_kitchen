import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_profile_settings.dart';
import 'preference_labels.dart';

/// Compact hub subtitle for the preferences row (mirrors allergies summary style).
String preferencesHubSubtitle(
  AppLocalizations l10n,
  UserPreferences? preferences, {
  required bool loaded,
}) {
  if (!loaded) {
    return l10n.profilePreferencesSubtitle;
  }
  if (preferences == null) {
    return l10n.profilePreferencesSubtitleEmpty;
  }

  final parts = <String>[];
  final style = preferences.dietaryStyle;
  if (style != null && style.isNotEmpty) {
    parts.add(dietaryStyleLabel(l10n, style));
  }
  final spice = preferences.spiceLevel;
  if (spice != null && spice.isNotEmpty) {
    parts.add(spiceLevelLabel(l10n, spice));
  }
  if (preferences.cuisinePreferences.isNotEmpty) {
    parts.add(
      l10n.profilePreferencesSubtitleCuisineCount(
        preferences.cuisinePreferences.length,
      ),
    );
  }
  if (preferences.healthGoals.isNotEmpty) {
    parts.add(
      l10n.profilePreferencesSubtitleGoalCount(preferences.healthGoals.length),
    );
  }
  if (preferences.dislikedIngredients.isNotEmpty) {
    parts.add(
      l10n.profilePreferencesSubtitleDislikedCount(
        preferences.dislikedIngredients.length,
      ),
    );
  }

  if (parts.isEmpty) {
    return l10n.profilePreferencesSubtitleEmpty;
  }
  return l10n.profilePreferencesSubtitleParts(parts.join(' · '));
}
