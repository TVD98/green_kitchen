import '../models/recipe_models.dart';
import 'discovery_remote_data_sources.dart';
import 'fake_discovery_recipes.dart';

/// Offline discovery search for UI work on the results screen.
///
/// Enable with `--dart-define=USE_FAKE_DISCOVERY=true`.
class FakeDiscoveryRemoteDataSource extends DiscoveryRemoteDataSource {
  FakeDiscoveryRemoteDataSource({required super.dio});

  @override
  Future<List<RecipeModel>> search({
    required String prompt,
    bool usePreferences = false,
    bool excludeAllergies = false,
    int? maxTime,
    String? difficulty,
    List<String> tags = const [],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    var recipes = fakeDiscoveryRecipeModels();
    if (maxTime != null) {
      recipes = recipes
          .where((r) => r.timeMinutes <= maxTime)
          .toList(growable: false);
    }
    if (difficulty != null && difficulty.isNotEmpty) {
      recipes = recipes
          .where((r) => r.difficulty == difficulty)
          .toList(growable: false);
    }
    if (tags.isNotEmpty) {
      recipes = recipes
          .where((r) => tags.every(r.tags.contains))
          .toList(growable: false);
    }
    return recipes;
  }
}
