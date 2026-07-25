import '../../domain/entities/auth_tokens.dart';

class AuthTokensModel extends AuthTokens {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresIn,
    super.refreshTokenExpiresIn,
    super.tokenType,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
      refreshTokenExpiresIn: json['refresh_token_expires_in'] as int?,
      tokenType: (json['token_type'] as String?) ?? 'Bearer',
    );
  }

  AuthTokens toEntity() => AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        refreshTokenExpiresIn: refreshTokenExpiresIn,
        tokenType: tokenType,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'expires_in': expiresIn,
        'refresh_token_expires_in': refreshTokenExpiresIn,
        'token_type': tokenType,
      };
}
