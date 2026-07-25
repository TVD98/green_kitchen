import 'package:dio/dio.dart';

import '../../../../core/device/device_info_provider.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/social_provider.dart';
import '../models/auth_session_model.dart';
import '../models/auth_tokens_model.dart';
import '../models/otp_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> signUp({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> logIn({
    required String email,
    required String password,
  });

  Future<AuthSessionModel> socialLogin({
    required SocialProvider provider,
    required String idToken,
  });

  Future<OtpSessionModel> forgotPassword({required String email});

  Future<String> verifyOtp({
    required String sessionId,
    required String otpCode,
    required String purpose,
  });

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
    required String deviceId,
  });

  Future<void> logOut({required String refreshToken});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required Dio dio,
    required DeviceInfoProvider deviceInfoProvider,
  })  : _dio = dio,
        _deviceInfoProvider = deviceInfoProvider;

  final Dio _dio;
  final DeviceInfoProvider _deviceInfoProvider;

  @override
  Future<AuthSessionModel> signUp({
    required String email,
    required String password,
  }) async {
    final device = await _deviceInfoProvider.getDeviceInfo();
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'email': email,
        'password': password,
        'device_info': device.toJson(),
      },
    );
    return _sessionFromResponse(response);
  }

  @override
  Future<AuthSessionModel> logIn({
    required String email,
    required String password,
  }) async {
    final device = await _deviceInfoProvider.getDeviceInfo();
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'device_id': device.deviceId,
      },
    );
    return _sessionFromResponse(response);
  }

  @override
  Future<AuthSessionModel> socialLogin({
    required SocialProvider provider,
    required String idToken,
  }) async {
    final device = await _deviceInfoProvider.getDeviceInfo();
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/social-login',
      data: {
        'provider': provider.apiValue,
        'id_token': idToken,
        'device_info': device.toJson(),
      },
    );
    return _sessionFromResponse(response);
  }

  @override
  Future<OtpSessionModel> forgotPassword({required String email}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/forgot-password',
      data: {'email': email},
    );
    _ensureSuccess(response);
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return OtpSessionModel.fromJson(data, email: email);
  }

  @override
  Future<String> verifyOtp({
    required String sessionId,
    required String otpCode,
    required String purpose,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/verify-otp',
      data: {
        'session_id': sessionId,
        'otp_code': otpCode,
        'purpose': purpose,
      },
    );
    _ensureSuccess(response);
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return data['reset_token'] as String;
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/reset-password',
      data: {
        'reset_token': resetToken,
        'new_password': newPassword,
      },
    );
    _ensureSuccess(response);
  }

  @override
  Future<AuthTokensModel> refreshToken({
    required String refreshToken,
    required String deviceId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh-token',
      data: {
        'refresh_token': refreshToken,
        'device_id': deviceId,
      },
      options: Options(extra: {'skipAuth': true}),
    );
    _ensureSuccess(response);
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AuthTokensModel(
      accessToken: data['access_token'] as String,
      refreshToken: refreshToken,
      expiresIn: data['expires_in'] as int,
      tokenType: (data['token_type'] as String?) ?? 'Bearer',
    );
  }

  @override
  Future<void> logOut({required String refreshToken}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/logout',
      data: {'refresh_token': refreshToken},
    );
    _ensureSuccess(response);
  }

  AuthSessionModel _sessionFromResponse(
    Response<Map<String, dynamic>> response,
  ) {
    _ensureSuccess(response);
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return AuthSessionModel.fromJson(data);
  }

  void _ensureSuccess(Response<Map<String, dynamic>> response) {
    final body = response.data;
    if (body == null) {
      throw const ApiException(statusCode: 500, code: 'ERR_INTERNAL_SERVER');
    }
    final success = body['success'] as bool? ?? true;
    if (!success) {
      throw ApiException(
        statusCode: response.statusCode ?? 400,
        code: (body['code'] as String?) ?? 'ERR_INTERNAL_SERVER',
        message: body['message'] as String?,
      );
    }
  }
}
