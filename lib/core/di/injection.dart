import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/fake_auth_remote_data_source.dart';
import '../../features/auth/data/datasources/secure_token_store.dart';
import '../../features/auth/data/datasources/social_auth_service.dart';
import '../../features/auth/data/network/auth_interceptor.dart';
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
import '../device/device_info_provider.dart';
import '../network/dio_client.dart';
import '../storage/key_value_store.dart';

final getIt = GetIt.instance;

/// When true (default), uses [FakeAuthRemoteDataSource] so UI works offline.
const useFakeAuthBackend = bool.fromEnvironment(
  'USE_FAKE_AUTH',
  defaultValue: true,
);

Future<void> configureDependencies({
  void Function()? onSessionExpired,
  KeyValueStore? keyValueStore,
}) async {
  if (getIt.isRegistered<AuthBloc>()) {
    return;
  }

  getIt
    ..registerLazySingleton<KeyValueStore>(
      () => keyValueStore ??
          SecureKeyValueStore(const FlutterSecureStorage()),
    )
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
    );

  final dio = getIt<DioClient>().dio;
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
