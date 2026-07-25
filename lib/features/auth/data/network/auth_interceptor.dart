import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/device/device_info_provider.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/secure_token_store.dart';

typedef SessionExpiredCallback = void Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required SecureTokenStore tokenStore,
    required AuthRemoteDataSource remoteDataSource,
    required DeviceInfoProvider deviceInfoProvider,
    required Dio dio,
    this.onSessionExpired,
  })  : _tokenStore = tokenStore,
        _remoteDataSource = remoteDataSource,
        _deviceInfoProvider = deviceInfoProvider,
        _dio = dio;

  static const _unauthenticatedPaths = {
    '/auth/signup',
    '/auth/login',
    '/auth/social-login',
    '/auth/forgot-password',
    '/auth/verify-otp',
    '/auth/reset-password',
    '/auth/refresh-token',
  };

  final SecureTokenStore _tokenStore;
  final AuthRemoteDataSource _remoteDataSource;
  final DeviceInfoProvider _deviceInfoProvider;
  final Dio _dio;
  final SessionExpiredCallback? onSessionExpired;

  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = options.path;
    final skipAuth = options.extra['skipAuth'] == true ||
        _unauthenticatedPaths.any(path.contains);
    if (!skipAuth) {
      final token = await _tokenStore.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final code = err.response?.data is Map
        ? (err.response!.data as Map)['code'] as String?
        : null;
    final path = err.requestOptions.path;
    final isRefresh = path.contains('/auth/refresh-token');

    if (status != 401 || isRefresh || err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }

    if (code != null && code != 'ERR_TOKEN_EXPIRED') {
      return handler.next(err);
    }

    try {
      await _refreshOnce();
      final token = await _tokenStore.readAccessToken();
      final request = err.requestOptions;
      request.headers['Authorization'] = 'Bearer $token';
      request.extra['retried'] = true;
      final response = await _dio.fetch<dynamic>(request);
      return handler.resolve(response);
    } catch (_) {
      await _tokenStore.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }
  }

  Future<void> _refreshOnce() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;
    try {
      final refresh = await _tokenStore.readRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        throw StateError('missing refresh token');
      }
      final device = await _deviceInfoProvider.getDeviceInfo();
      final tokens = await _remoteDataSource.refreshToken(
        refreshToken: refresh,
        deviceId: device.deviceId,
      );
      await _tokenStore.saveTokens(tokens);
      completer.complete();
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }
}
