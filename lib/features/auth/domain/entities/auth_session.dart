import 'package:equatable/equatable.dart';

import 'auth_tokens.dart';
import 'auth_user.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.tokens,
  });

  final AuthUser user;
  final AuthTokens tokens;

  @override
  List<Object?> get props => [user, tokens];
}
