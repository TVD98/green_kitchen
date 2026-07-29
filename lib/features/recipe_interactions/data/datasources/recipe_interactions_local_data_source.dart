import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/recipe_interaction.dart';

class RecipeInteractionsLocalDataSource {
  RecipeInteractionsLocalDataSource(this._prefs);

  static const viewedKey = 'recipe_interactions_viewed';
  static const savedKey = 'recipe_interactions_saved';
  static const pantrySessionsKey = 'recipe_interactions_pantry_sessions';
  static const discoverySessionsKey = 'recipe_interactions_discovery_sessions';
  static const recentIngredientsKey = 'recipe_interactions_recent_ingredients';

  static const maxViewed = 100;
  static const maxSaved = 100;
  static const maxPantrySessions = 50;
  static const maxDiscoverySessions = 50;
  static const maxRecentIngredientSets = 5;

  final SharedPreferences _prefs;

  Future<List<Map<String, dynamic>>> readViewed() async =>
      _readList(viewedKey);

  Future<List<Map<String, dynamic>>> readSaved() async => _readList(savedKey);

  Future<List<Map<String, dynamic>>> readPantrySessions() async =>
      _readList(pantrySessionsKey);

  Future<List<Map<String, dynamic>>> readDiscoverySessions() async =>
      _readList(discoverySessionsKey);

  Future<List<List<String>>> readRecentIngredientSets() async {
    final raw = _prefs.getString(recentIngredientsKey);
    if (raw == null) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (item) => (item as List<dynamic>).map((e) => e.toString()).toList(),
        )
        .toList(growable: false);
  }

  Future<void> writeViewed(List<Map<String, dynamic>> items) =>
      _writeList(viewedKey, items);

  Future<void> writeSaved(List<Map<String, dynamic>> items) =>
      _writeList(savedKey, items);

  Future<void> writePantrySessions(List<Map<String, dynamic>> items) =>
      _writeList(pantrySessionsKey, items);

  Future<void> writeDiscoverySessions(List<Map<String, dynamic>> items) =>
      _writeList(discoverySessionsKey, items);

  Future<void> writeRecentIngredientSets(List<List<String>> sets) {
    return _prefs.setString(recentIngredientsKey, jsonEncode(sets));
  }

  List<Map<String, dynamic>> _readList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.whereType<Map<String, dynamic>>().toList(growable: true);
  }

  Future<void> _writeList(String key, List<Map<String, dynamic>> items) {
    return _prefs.setString(key, jsonEncode(items));
  }

  static Map<String, dynamic> recordToJson(RecipeInteractionRecord record) {
    return {
      'recipe_id': record.recipeId,
      'timestamp': record.timestamp.toIso8601String(),
    };
  }

  static RecipeInteractionRecord recordFromJson(Map<String, dynamic> json) {
    return RecipeInteractionRecord(
      recipeId: json['recipe_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  static Map<String, dynamic> sessionToJson(PantrySession session) {
    return {
      'ingredients': session.ingredients,
      'recipe_ids': session.recipeIds,
      'searched_at': session.searchedAt.toIso8601String(),
    };
  }

  static PantrySession sessionFromJson(Map<String, dynamic> json) {
    return PantrySession(
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(growable: false),
      recipeIds: (json['recipe_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(growable: false),
      searchedAt: DateTime.parse(json['searched_at'] as String),
    );
  }

  static Map<String, dynamic> discoverySessionToJson(DiscoverySession session) {
    return {
      'prompt': session.prompt,
      'recipe_ids': session.recipeIds,
      'searched_at': session.searchedAt.toIso8601String(),
    };
  }

  static DiscoverySession discoverySessionFromJson(Map<String, dynamic> json) {
    return DiscoverySession(
      prompt: json['prompt'] as String,
      recipeIds: (json['recipe_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(growable: false),
      searchedAt: DateTime.parse(json['searched_at'] as String),
    );
  }
}
