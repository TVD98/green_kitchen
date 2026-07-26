import '../../domain/entities/auth_session.dart';
import 'auth_tokens_model.dart';
import 'auth_user_model.dart';

class AuthSessionModel extends AuthSession {
  AuthSessionModel({
    required AuthUserModel user,
    required AuthTokensModel tokens,
  }) : super(user: user, tokens: tokens);

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokensModel.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }

  AuthSession toEntity() => AuthSession(
        user: (user as AuthUserModel).toEntity(),
        tokens: (tokens as AuthTokensModel).toEntity(),
      );
}
