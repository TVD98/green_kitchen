import 'dart:convert';

import '../../../../core/storage/key_value_store.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/auth_user.dart';

class SecureTokenStore {
  SecureTokenStore(this._storage);

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiresInKey = 'expires_in';
  static const _refreshExpiresInKey = 'refresh_token_expires_in';
  static const _tokenTypeKey = 'token_type';
  static const _userKey = 'auth_user';
  static const _rememberMeKey = 'remember_me';

  final KeyValueStore _storage;

  Future<void> saveSession(
    AuthSession session, {
    required bool rememberMe,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: session.tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: session.tokens.refreshToken),
      _storage.write(
        key: _expiresInKey,
        value: session.tokens.expiresIn.toString(),
      ),
      _storage.write(
        key: _refreshExpiresInKey,
        value: session.tokens.refreshTokenExpiresIn?.toString(),
      ),
      _storage.write(key: _tokenTypeKey, value: session.tokens.tokenType),
      _storage.write(
        key: _userKey,
        value: jsonEncode({
          'id': session.user.id,
          'email': session.user.email,
          'full_name': session.user.fullName,
          'avatar_url': session.user.avatarUrl,
        }),
      ),
      _storage.write(key: _rememberMeKey, value: rememberMe.toString()),
    ]);
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: tokens.refreshToken),
      _storage.write(key: _expiresInKey, value: tokens.expiresIn.toString()),
      _storage.write(
        key: _refreshExpiresInKey,
        value: tokens.refreshTokenExpiresIn?.toString(),
      ),
      _storage.write(key: _tokenTypeKey, value: tokens.tokenType),
    ]);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  Future<bool> readRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  Future<AuthSession?> readSession() async {
    final access = await _storage.read(key: _accessTokenKey);
    final refresh = await _storage.read(key: _refreshTokenKey);
    final userJson = await _storage.read(key: _userKey);
    final expiresIn = await _storage.read(key: _expiresInKey);
    if (access == null ||
        refresh == null ||
        userJson == null ||
        expiresIn == null) {
      return null;
    }

    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    final refreshExpires = await _storage.read(key: _refreshExpiresInKey);
    final tokenType = await _storage.read(key: _tokenTypeKey);

    return AuthSession(
      user: AuthUser(
        id: userMap['id'] as String,
        email: userMap['email'] as String,
        fullName: userMap['full_name'] as String?,
        avatarUrl: userMap['avatar_url'] as String?,
      ),
      tokens: AuthTokens(
        accessToken: access,
        refreshToken: refresh,
        expiresIn: int.parse(expiresIn),
        refreshTokenExpiresIn:
            refreshExpires == null ? null : int.tryParse(refreshExpires),
        tokenType: tokenType ?? 'Bearer',
      ),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _expiresInKey),
      _storage.delete(key: _refreshExpiresInKey),
      _storage.delete(key: _tokenTypeKey),
      _storage.delete(key: _userKey),
      _storage.delete(key: _rememberMeKey),
    ]);
  }
}
