import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/user_profile_settings.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/profile_models.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required ProfileRemoteDataSource remote})
      : _remote = remote;

  final ProfileRemoteDataSource _remote;

  @override
  Future<Result<UserPreferences>> getPreferences() {
    return _guard(() async {
      final model = await _remote.getPreferences();
      return model.toEntity();
    });
  }

  @override
  Future<Result<UserPreferences>> updatePreferences(
    UserPreferences preferences,
  ) {
    return _guard(() async {
      final model = await _remote.updatePreferences(
        UserPreferencesModel.fromEntity(preferences),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Result<List<UserAllergy>>> getAllergies({String lang = 'vi'}) {
    return _guard(() async {
      final models = await _remote.getAllergies(lang: lang);
      return models.map((m) => m.toEntity()).toList(growable: false);
    });
  }

  @override
  Future<Result<List<UserAllergy>>> replaceAllergies(
    List<String> ingredientIds, {
    String lang = 'vi',
  }) {
    return _guard(() async {
      final models = await _remote.replaceAllergies(
        ingredientIds,
        lang: lang,
      );
      return models.map((m) => m.toEntity()).toList(growable: false);
    });
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
