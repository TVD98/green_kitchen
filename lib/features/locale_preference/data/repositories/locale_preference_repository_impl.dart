import '../../domain/entities/locale_preference.dart';
import '../../domain/repositories/locale_preference_repository.dart';
import '../datasources/locale_preference_local_data_source.dart';

class LocalePreferenceRepositoryImpl implements LocalePreferenceRepository {
  LocalePreferenceRepositoryImpl(this._localDataSource);

  final LocalePreferenceLocalDataSource _localDataSource;

  @override
  Future<LocalePreference> getPreference() async => _localDataSource.read();

  @override
  Future<void> setPreference(LocalePreference preference) =>
      _localDataSource.write(preference);
}
