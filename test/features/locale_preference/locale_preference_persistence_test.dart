import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/features/locale_preference/data/datasources/locale_preference_local_data_source.dart';
import 'package:green_kitchen/features/locale_preference/data/repositories/locale_preference_repository_impl.dart';
import 'package:green_kitchen/features/locale_preference/domain/entities/locale_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('locale preference persists across repository instances', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final writer = LocalePreferenceRepositoryImpl(
      LocalePreferenceLocalDataSource(prefs),
    );
    await writer.setPreference(LocalePreference.en);

    final reader = LocalePreferenceRepositoryImpl(
      LocalePreferenceLocalDataSource(prefs),
    );
    expect(await reader.getPreference(), LocalePreference.en);
  });
}
