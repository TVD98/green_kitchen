import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/usecases/get_cached_session.dart';
import '../../domain/usecases/log_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCachedSession getCachedSession,
    required LogOut logOut,
  })  : _getCachedSession = getCachedSession,
        _logOut = logOut,
        super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthSessionEstablished>(_onSessionEstablished);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final GetCachedSession _getCachedSession;
  final LogOut _logOut;

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    final session = await _getCachedSession();
    if (session == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(session));
    }
  }

  void _onSessionEstablished(
    AuthSessionEstablished event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthState.authenticated(event.session));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logOut();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    await _logOut();
    emit(
      const AuthState.unauthenticated(
        message: FailureCodes.sessionExpired,
      ),
    );
  }
}
