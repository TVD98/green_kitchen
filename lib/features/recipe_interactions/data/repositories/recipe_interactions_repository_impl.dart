import '../../domain/entities/recipe_interaction.dart';
import '../../domain/repositories/recipe_interactions_repository.dart';
import '../datasources/recipe_interactions_local_data_source.dart';

class RecipeInteractionsRepositoryImpl implements RecipeInteractionsRepository {
  RecipeInteractionsRepositoryImpl(this._local);

  final RecipeInteractionsLocalDataSource _local;

  @override
  Future<void> recordViewed(String recipeId) async {
    final items = await _local.readViewed();
    final now = DateTime.now().toUtc();
    items.removeWhere((item) => item['recipe_id'] == recipeId);
    items.insert(0, {
      'recipe_id': recipeId,
      'timestamp': now.toIso8601String(),
    });
    while (items.length > RecipeInteractionsLocalDataSource.maxViewed) {
      items.removeLast();
    }
    await _local.writeViewed(items);
  }

  @override
  Future<bool> toggleSaved(String recipeId) async {
    final items = await _local.readSaved();
    final index = items.indexWhere((item) => item['recipe_id'] == recipeId);
    if (index >= 0) {
      items.removeAt(index);
      await _local.writeSaved(items);
      return false;
    }
    items.insert(0, {
      'recipe_id': recipeId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
    while (items.length > RecipeInteractionsLocalDataSource.maxSaved) {
      items.removeLast();
    }
    await _local.writeSaved(items);
    return true;
  }

  @override
  Future<bool> isSaved(String recipeId) async {
    final items = await _local.readSaved();
    return items.any((item) => item['recipe_id'] == recipeId);
  }

  @override
  Future<List<RecipeInteractionRecord>> getViewedRecords() async {
    final items = await _local.readViewed();
    return items
        .map(RecipeInteractionsLocalDataSource.recordFromJson)
        .toList(growable: false);
  }

  @override
  Future<List<RecipeInteractionRecord>> getSavedRecords() async {
    final items = await _local.readSaved();
    return items
        .map(RecipeInteractionsLocalDataSource.recordFromJson)
        .toList(growable: false);
  }

  @override
  Future<List<PantrySession>> getPantrySessions() async {
    final items = await _local.readPantrySessions();
    return items
        .map(RecipeInteractionsLocalDataSource.sessionFromJson)
        .toList(growable: false);
  }

  @override
  Future<void> savePantrySession(PantrySession session) async {
    final items = await _local.readPantrySessions();
    items.insert(0, RecipeInteractionsLocalDataSource.sessionToJson(session));
    while (items.length > RecipeInteractionsLocalDataSource.maxPantrySessions) {
      items.removeLast();
    }
    await _local.writePantrySessions(items);

    final recent = await _local.readRecentIngredientSets();
    recent.removeWhere(
      (set) => _sameIngredientSet(set, session.ingredients),
    );
    recent.insert(0, session.ingredients);
    while (recent.length >
        RecipeInteractionsLocalDataSource.maxRecentIngredientSets) {
      recent.removeLast();
    }
    await _local.writeRecentIngredientSets(recent);
  }

  @override
  Future<List<List<String>>> getRecentIngredientSets() =>
      _local.readRecentIngredientSets();

  @override
  Future<void> saveRecentIngredientSet(List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return;
    }
    final recent = await _local.readRecentIngredientSets();
    recent.removeWhere((set) => _sameIngredientSet(set, ingredients));
    recent.insert(0, List<String>.from(ingredients));
    while (recent.length >
        RecipeInteractionsLocalDataSource.maxRecentIngredientSets) {
      recent.removeLast();
    }
    await _local.writeRecentIngredientSets(recent);
  }

  @override
  Future<List<DiscoverySession>> getDiscoverySessions() async {
    final items = await _local.readDiscoverySessions();
    return items
        .map(RecipeInteractionsLocalDataSource.discoverySessionFromJson)
        .toList(growable: false);
  }

  @override
  Future<void> saveDiscoverySession(DiscoverySession session) async {
    final items = await _local.readDiscoverySessions();
    items.insert(
      0,
      RecipeInteractionsLocalDataSource.discoverySessionToJson(session),
    );
    while (items.length >
        RecipeInteractionsLocalDataSource.maxDiscoverySessions) {
      items.removeLast();
    }
    await _local.writeDiscoverySessions(items);
  }

  bool _sameIngredientSet(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    final sortedA = [...a]..sort();
    final sortedB = [...b]..sort();
    for (var i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) {
        return false;
      }
    }
    return true;
  }
}
