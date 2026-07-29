import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/entities/pantry_filters.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipes_repository.dart';
import '../datasources/discovery_remote_data_sources.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  RecipesRepositoryImpl({required RecipesRemoteDataSource remote})
      : _remote = remote;

  final RecipesRemoteDataSource _remote;

  @override
  Future<Result<List<Recipe>>> search(RecipeSearchQuery query) {
    return _guard(() async {
      final models = await _remote.search(
        q: query.q,
        maxTime: query.maxTime,
        difficulty: query.difficulty,
        tags: query.tags,
      );
      return models.map((m) => m.toEntity()).toList(growable: false);
    });
  }

  @override
  Future<Result<Recipe>> getById(String id) {
    return _guard(() async {
      final model = await _remote.getById(id);
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<Recipe>>> getByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const Success([]);
    }
    final recipes = <Recipe>[];
    for (final id in ids) {
      final result = await getById(id);
      result.fold(
        (_) {},
        recipes.add,
      );
    }
    return Success(recipes);
  }

  Future<Result<T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Success(await run());
    } on ApiException catch (e) {
      return Err(e.toFailure());
    } on DioException catch (_) {
      return const Err(NetworkFailure());
    } catch (_) {
      return const Err(ServerFailure());
    }
  }
}

class IngredientsRepositoryImpl implements IngredientsRepository {
  IngredientsRepositoryImpl({required IngredientsRemoteDataSource remote})
      : _remote = remote;

  final IngredientsRemoteDataSource _remote;

  @override
  Future<Result<List<Ingredient>>> search(String query) async {
    try {
      final models = await _remote.search(query);
      return Success(models.map((m) => m.toEntity()).toList(growable: false));
    } on ApiException catch (e) {
      return Err(e.toFailure());
    } on DioException catch (_) {
      return const Err(NetworkFailure());
    } catch (_) {
      return const Err(ServerFailure());
    }
  }
}

class PantryRepositoryImpl implements PantryRepository {
  PantryRepositoryImpl({required PantryRemoteDataSource remote}) : _remote = remote;

  final PantryRemoteDataSource _remote;

  @override
  Future<Result<List<Recipe>>> search({
    required List<String> ingredients,
    PantryFilters? filters,
  }) async {
    try {
      final models = await _remote.search(
        ingredients: ingredients,
        maxTime: filters?.maxTime,
        difficulty: filters?.difficulty,
        tags: filters?.tags ?? const [],
      );
      return Success(models.map((m) => m.toEntity()).toList(growable: false));
    } on ApiException catch (e) {
      return Err(e.toFailure());
    } on DioException catch (_) {
      return const Err(NetworkFailure());
    } catch (_) {
      return const Err(ServerFailure());
    }
  }
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  DiscoveryRepositoryImpl({required DiscoveryRemoteDataSource remote})
      : _remote = remote;

  final DiscoveryRemoteDataSource _remote;

  @override
  Future<Result<List<Recipe>>> search(DiscoverySearchQuery query) async {
    try {
      final models = await _remote.search(
        prompt: query.prompt,
        usePreferences: query.usePreferences,
        excludeAllergies: query.excludeAllergies,
        maxTime: query.filters.maxTime,
        difficulty: query.filters.difficulty,
        tags: query.filters.tags,
      );
      return Success(models.map((m) => m.toEntity()).toList(growable: false));
    } on ApiException catch (e) {
      return Err(e.toFailure());
    } on DioException catch (_) {
      return const Err(NetworkFailure());
    } catch (_) {
      return const Err(ServerFailure());
    }
  }
}
