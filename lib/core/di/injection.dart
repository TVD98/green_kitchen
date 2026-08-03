import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/network/auth_interceptor.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/fake_auth_remote_data_source.dart';
import '../../features/auth/data/datasources/secure_token_store.dart';
import '../../features/auth/data/datasources/social_auth_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password.dart';
import '../../features/auth/domain/usecases/get_cached_session.dart';
import '../../features/auth/domain/usecases/log_in_with_password.dart';
import '../../features/auth/domain/usecases/log_in_with_social.dart';
import '../../features/auth/domain/usecases/log_out.dart';
import '../../features/auth/domain/usecases/reset_password.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/discover/presentation/bloc/discover_bloc.dart';
import '../../features/locale_preference/data/datasources/locale_preference_local_data_source.dart';
import '../../features/locale_preference/data/repositories/locale_preference_repository_impl.dart';
import '../../features/locale_preference/domain/repositories/locale_preference_repository.dart';
import '../../features/locale_preference/domain/usecases/get_locale_preference.dart';
import '../../features/locale_preference/domain/usecases/set_locale_preference.dart';
import '../../features/locale_preference/presentation/cubit/locale_preference_cubit.dart';
import '../../features/pantry/presentation/bloc/pantry_bloc.dart';
import '../../features/recipe_interactions/data/datasources/recipe_interactions_local_data_source.dart';
import '../../features/recipe_interactions/data/repositories/recipe_interactions_repository_impl.dart';
import '../../features/recipe_interactions/domain/repositories/recipe_interactions_repository.dart';
import '../../features/recipe_interactions/domain/usecases/recipe_interaction_usecases.dart';
import '../../features/recipe_library/presentation/bloc/recipe_library_bloc.dart';
import '../../features/recipes/data/datasources/discovery_remote_data_sources.dart';
import '../../features/recipes/data/repositories/recipes_repository_impl.dart';
import '../../features/recipes/domain/entities/pantry_filters.dart';
import '../../features/recipes/domain/repositories/recipes_repository.dart';
import '../../features/recipes/domain/usecases/recipe_usecases.dart';
import '../../features/recipes/presentation/bloc/recipe_detail_bloc.dart';
import '../../features/suggestions/presentation/bloc/suggestions_bloc.dart';
import '../device/device_info_provider.dart';
import '../network/dio_client.dart';
import '../network/logging_interceptor.dart';
import '../storage/key_value_store.dart';

final getIt = GetIt.instance;

/// When true, uses [FakeAuthRemoteDataSource] (offline UI). Default is real API.
const useFakeAuthBackend = bool.fromEnvironment(
  'USE_FAKE_AUTH',
  defaultValue: false,
);

Future<void> configureDependencies({
  void Function()? onSessionExpired,
  KeyValueStore? keyValueStore,
}) async {
  if (getIt.isRegistered<AuthBloc>()) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();

  getIt
    ..registerLazySingleton<KeyValueStore>(
      () => keyValueStore ??
          SecureKeyValueStore(const FlutterSecureStorage()),
    )
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton(
      () => LocalePreferenceLocalDataSource(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton<LocalePreferenceRepository>(
      () => LocalePreferenceRepositoryImpl(
        getIt<LocalePreferenceLocalDataSource>(),
      ),
    )
    ..registerLazySingleton(() => GetLocalePreference(getIt()))
    ..registerLazySingleton(() => SetLocalePreference(getIt()))
    ..registerLazySingleton<DioClient>(DioClient.new)
    ..registerLazySingleton<DeviceInfoProvider>(
      () => DeviceInfoProvider(storage: getIt<KeyValueStore>()),
    )
    ..registerLazySingleton<SecureTokenStore>(
      () => SecureTokenStore(getIt<KeyValueStore>()),
    )
    ..registerLazySingleton<SocialAuthService>(FakeSocialAuthService.new)
    ..registerLazySingleton<AuthRemoteDataSource>(
      () {
        if (useFakeAuthBackend) {
          return FakeAuthRemoteDataSource();
        }
        return AuthRemoteDataSourceImpl(
          dio: getIt<DioClient>().dio,
          deviceInfoProvider: getIt<DeviceInfoProvider>(),
        );
      },
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        tokenStore: getIt<SecureTokenStore>(),
        deviceInfoProvider: getIt<DeviceInfoProvider>(),
      ),
    )
    ..registerLazySingleton(() => SignUp(getIt()))
    ..registerLazySingleton(() => LogInWithPassword(getIt()))
    ..registerLazySingleton(() => LogInWithSocial(getIt()))
    ..registerLazySingleton(() => ForgotPassword(getIt()))
    ..registerLazySingleton(() => VerifyOtp(getIt()))
    ..registerLazySingleton(() => ResetPassword(getIt()))
    ..registerLazySingleton(() => LogOut(getIt()))
    ..registerLazySingleton(() => GetCachedSession(getIt()))
    ..registerLazySingleton(
      () => AuthBloc(
        getCachedSession: getIt(),
        logOut: getIt(),
      ),
    )
    ..registerLazySingleton(
      () => RecipesRemoteDataSource(dio: getIt<DioClient>().dio),
    )
    ..registerLazySingleton(
      () => IngredientsRemoteDataSource(dio: getIt<DioClient>().dio),
    )
    ..registerLazySingleton(
      () => PantryRemoteDataSource(dio: getIt<DioClient>().dio),
    )
    ..registerLazySingleton(
      () => DiscoveryRemoteDataSource(dio: getIt<DioClient>().dio),
    )
    ..registerLazySingleton<RecipesRepository>(
      () => RecipesRepositoryImpl(remote: getIt<RecipesRemoteDataSource>()),
    )
    ..registerLazySingleton<IngredientsRepository>(
      () => IngredientsRepositoryImpl(remote: getIt<IngredientsRemoteDataSource>()),
    )
    ..registerLazySingleton<PantryRepository>(
      () => PantryRepositoryImpl(remote: getIt<PantryRemoteDataSource>()),
    )
    ..registerLazySingleton<DiscoveryRepository>(
      () => DiscoveryRepositoryImpl(remote: getIt<DiscoveryRemoteDataSource>()),
    )
    ..registerLazySingleton(
      () => RecipeInteractionsLocalDataSource(getIt<SharedPreferences>()),
    )
    ..registerLazySingleton<RecipeInteractionsRepository>(
      () => RecipeInteractionsRepositoryImpl(
        getIt<RecipeInteractionsLocalDataSource>(),
      ),
    )
    ..registerLazySingleton(() => SearchRecipes(getIt<RecipesRepository>()))
    ..registerLazySingleton(() => GetRecipeById(getIt<RecipesRepository>()))
    ..registerLazySingleton(() => GetRecipesByIds(getIt<RecipesRepository>()))
    ..registerLazySingleton(
      () => SearchIngredients(getIt<IngredientsRepository>()),
    )
    ..registerLazySingleton(() => SearchPantry(getIt<PantryRepository>()))
    ..registerLazySingleton(() => SearchDiscovery(getIt<DiscoveryRepository>()))
    ..registerLazySingleton(() => RecordRecipeViewed(getIt()))
    ..registerLazySingleton(() => ToggleRecipeSaved(getIt()))
    ..registerLazySingleton(() => IsRecipeSaved(getIt()))
    ..registerLazySingleton(() => GetViewedRecords(getIt()))
    ..registerLazySingleton(() => GetSavedRecords(getIt()))
    ..registerLazySingleton(() => GetPantrySessions(getIt()))
    ..registerLazySingleton(() => SavePantrySession(getIt()))
    ..registerLazySingleton(() => GetRecentIngredientSets(getIt()))
    ..registerLazySingleton(() => SaveRecentIngredientSet(getIt()))
    ..registerLazySingleton(() => ClearRecentIngredientSets(getIt()))
    ..registerLazySingleton(() => SaveDiscoverySession(getIt()))
    ..registerLazySingleton(
      () => LocalePreferenceCubit(
        getLocalePreference: getIt(),
        setLocalePreference: getIt(),
        clearRecentIngredientSets: getIt(),
        initialPreference: getIt<LocalePreferenceLocalDataSource>().read(),
      ),
    )
    ..registerFactory(
      () => DiscoverBloc(
        searchIngredients: getIt(),
        getRecentIngredientSets: getIt(),
        saveRecentIngredientSet: getIt(),
      ),
    )
    ..registerFactoryParam<PantryBloc, List<String>, PantryFilters>(
      (ingredients, filters) => PantryBloc(
        searchPantry: getIt(),
        savePantrySession: getIt(),
        ingredients: ingredients,
        filters: filters,
      ),
    )
    ..registerFactoryParam<RecipeDetailBloc, String, void>(
      (recipeId, _) => RecipeDetailBloc(
        getRecipeById: getIt(),
        recordRecipeViewed: getIt(),
        toggleRecipeSaved: getIt(),
        isRecipeSaved: getIt(),
        recipeId: recipeId,
      ),
    )
    ..registerFactory(
      () => RecipeLibraryBloc(
        getViewedRecords: getIt(),
        getSavedRecords: getIt(),
        getPantrySessions: getIt(),
        getRecipesByIds: getIt(),
      ),
    )
    ..registerFactory(
      () => SuggestionsBloc(searchRecipes: getIt()),
    );

  final dio = getIt<DioClient>().dio;

  dio.interceptors.add(LoggingInterceptor());

  dio.interceptors.add(
    AuthInterceptor(
      tokenStore: getIt<SecureTokenStore>(),
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      deviceInfoProvider: getIt<DeviceInfoProvider>(),
      dio: dio,
      onSessionExpired: onSessionExpired ??
          () => getIt<AuthBloc>().add(const AuthSessionExpired()),
    ),
  );
}
