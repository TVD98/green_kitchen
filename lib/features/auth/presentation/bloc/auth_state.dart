part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.session,
    this.message,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(AuthSession session)
      : this._(status: AuthStatus.authenticated, session: session);

  const AuthState.unauthenticated({String? message})
      : this._(status: AuthStatus.unauthenticated, message: message);

  final AuthStatus status;
  final AuthSession? session;
  final String? message;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, session, message];
}
