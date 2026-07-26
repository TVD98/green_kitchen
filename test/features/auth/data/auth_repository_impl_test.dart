import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/device/device_info_provider.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/network/api_exception.dart';
import 'package:green_kitchen/core/storage/key_value_store.dart';
import 'package:green_kitchen/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:green_kitchen/features/auth/data/datasources/secure_token_store.dart';
import 'package:green_kitchen/features/auth/data/models/auth_session_model.dart';
import 'package:green_kitchen/features/auth/data/models/auth_tokens_model.dart';
import 'package:green_kitchen/features/auth/data/models/auth_user_model.dart';
import 'package:green_kitchen/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockDeviceInfo extends Mock implements DeviceInfoProvider {}

void main() {
  late _MockRemote remote;
  late SecureTokenStore store;
  late _MockDeviceInfo deviceInfo;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    store = SecureTokenStore(MemoryKeyValueStore());
    deviceInfo = _MockDeviceInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: remote,
      tokenStore: store,
      deviceInfoProvider: deviceInfo,
    );
  });

  test('signUp persists session on success', () async {
    when(
      () => remote.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer(
      (_) async => AuthSessionModel(
        user: const AuthUserModel(id: '1', email: 'a@b.com'),
        tokens: const AuthTokensModel(
          accessToken: 'access',
          refreshToken: 'refresh',
          expiresIn: 3600,
        ),
      ),
    );

    final result = await repository.signUp(
      email: 'a@b.com',
      password: 'Password123!',
    );

    expect(result.isSuccess, isTrue);
    expect(await store.readAccessToken(), 'access');
  });

  test('logIn maps ApiException to failure', () async {
    when(
      () => remote.logIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(
      const ApiException(statusCode: 401, code: 'ERR_INVALID_CREDENTIALS'),
    );

    final result = await repository.logIn(
      email: 'a@b.com',
      password: 'bad',
      rememberMe: true,
    );

    expect(result.isFailure, isTrue);
    result.fold(
      (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
      (_) => fail('expected failure'),
    );
  });
}
