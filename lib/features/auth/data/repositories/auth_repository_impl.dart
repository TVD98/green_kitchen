import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/otp_session.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/secure_token_store.dart';
import '../../../../core/device/device_info_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureTokenStore tokenStore,
    required DeviceInfoProvider deviceInfoProvider,
  })  : _remote = remoteDataSource,
        _tokenStore = tokenStore,
        _deviceInfoProvider = deviceInfoProvider;

  final AuthRemoteDataSource _remote;
  final SecureTokenStore _tokenStore;
  final DeviceInfoProvider _deviceInfoProvider;

  @override
  Future<Result<AuthSession>> signUp({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final session = await _remote.signUp(email: email, password: password);
      final entity = session.toEntity();
      await _tokenStore.saveSession(entity, rememberMe: true);
      return entity;
    });
  }

  @override
  Future<Result<AuthSession>> logIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return _guard(() async {
      final session = await _remote.logIn(email: email, password: password);
      final entity = session.toEntity();
      await _tokenStore.saveSession(entity, rememberMe: rememberMe);
      return entity;
    });
  }

  @override
  Future<Result<AuthSession>> socialLogin({
    required SocialProvider provider,
    required String idToken,
  }) {
    return _guard(() async {
      final session =
          await _remote.socialLogin(provider: provider, idToken: idToken);
      final entity = session.toEntity();
      await _tokenStore.saveSession(entity, rememberMe: true);
      return entity;
    });
  }

  @override
  Future<Result<OtpSession>> forgotPassword({required String email}) {
    return _guard(() async {
      final session = await _remote.forgotPassword(email: email);
      return session.toEntity();
    });
  }

  @override
  Future<Result<String>> verifyOtp({
    required String sessionId,
    required String otpCode,
    required String purpose,
  }) {
    return _guard(
      () => _remote.verifyOtp(
        sessionId: sessionId,
        otpCode: otpCode,
        purpose: purpose,
      ),
    );
  }

  @override
  Future<Result<void>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) {
    return _guard(() async {
      await _remote.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );
      await _tokenStore.clear();
    });
  }

  @override
  Future<Result<AuthTokens>> refreshSession() {
    return _guard(() async {
      final refresh = await _tokenStore.readRefreshToken();
      if (refresh == null) {
        throw const ApiException(statusCode: 401, code: 'ERR_TOKEN_EXPIRED');
      }
      final device = await _deviceInfoProvider.getDeviceInfo();
      final tokens = await _remote.refreshToken(
        refreshToken: refresh,
        deviceId: device.deviceId,
      );
      await _tokenStore.saveTokens(tokens.toEntity());
      return tokens.toEntity();
    });
  }

  @override
  Future<Result<void>> logOut() {
    return _guard(() async {
      final refresh = await _tokenStore.readRefreshToken();
      try {
        if (refresh != null) {
          await _remote.logOut(refreshToken: refresh);
        }
      } finally {
        await _tokenStore.clear();
      }
    });
  }

  @override
  Future<AuthSession?> readCachedSession() async {
    final rememberMe = await _tokenStore.readRememberMe();
    final session = await _tokenStore.readSession();
    if (session == null) {
      return null;
    }
    if (!rememberMe) {
      // Session exists for the current process; still return it.
      return session;
    }
    return session;
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on ApiException catch (error) {
      return Err(error.toFailure());
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['code'] is String) {
        return Err(
          ApiException(
            statusCode: error.response?.statusCode ?? 500,
            code: data['code'] as String,
            message: data['message'] as String?,
          ).toFailure(),
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return const Err(NetworkFailure());
      }
      return const Err(ServerFailure());
    } catch (_) {
      return const Err(ServerFailure());
    }
  }
}
