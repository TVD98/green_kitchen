import 'package:equatable/equatable.dart';

/// Stable message codes for default (client-owned) failures.
/// Custom / API messages may still be passed as free-form [message].
abstract final class FailureCodes {
  static const network = 'auth.error.network';
  static const server = 'auth.error.server';
  static const invalidCredentials = 'auth.error.invalidCredentials';
  static const invalidOtp = 'auth.error.invalidOtp';
  static const otpExpired = 'auth.error.otpExpired';
  static const userExists = 'auth.error.userExists';
  static const accountLocked = 'auth.error.accountLocked';
  static const rateLimited = 'auth.error.rateLimited';
  static const social = 'auth.error.social';
  static const invalidResetToken = 'auth.error.invalidResetToken';
  static const resetTokenExpired = 'auth.error.resetTokenExpired';
  static const sessionExpired = 'auth.error.sessionExpired';
  static const invalidInput = 'auth.error.invalidInput';
}

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = FailureCodes.network]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = FailureCodes.server]);
}

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([
    super.message = FailureCodes.invalidCredentials,
  ]);
}

class InvalidOtpFailure extends AuthFailure {
  const InvalidOtpFailure([super.message = FailureCodes.invalidOtp]);
}

class OtpExpiredFailure extends AuthFailure {
  const OtpExpiredFailure([super.message = FailureCodes.otpExpired]);
}

class UserExistsFailure extends AuthFailure {
  const UserExistsFailure([super.message = FailureCodes.userExists]);
}

class AccountLockedFailure extends AuthFailure {
  const AccountLockedFailure([super.message = FailureCodes.accountLocked]);
}

class RateLimitedFailure extends AuthFailure {
  const RateLimitedFailure([super.message = FailureCodes.rateLimited]);
}

class SocialAuthFailure extends AuthFailure {
  const SocialAuthFailure([super.message = FailureCodes.social]);
}

class InvalidResetTokenFailure extends AuthFailure {
  const InvalidResetTokenFailure([
    super.message = FailureCodes.invalidResetToken,
  ]);
}

class ResetTokenExpiredFailure extends AuthFailure {
  const ResetTokenExpiredFailure([
    super.message = FailureCodes.resetTokenExpired,
  ]);
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([super.message = FailureCodes.sessionExpired]);
}

class InvalidInputFailure extends AuthFailure {
  const InvalidInputFailure([super.message = FailureCodes.invalidInput]);
}

abstract final class DiscoveryFailureCodes {
  static const notFound = 'discovery.error.notFound';
  static const server = 'discovery.error.server';
  static const rateLimited = 'discovery.error.rateLimited';
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = DiscoveryFailureCodes.notFound]);
}
