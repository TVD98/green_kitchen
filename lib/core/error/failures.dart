import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Không có kết nối mạng. Vui lòng thử lại.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Đã có lỗi xảy ra. Vui lòng thử lại sau ít phút.',
  ]);
}

sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure([
    super.message = 'Email hoặc mật khẩu không chính xác.',
  ]);
}

class InvalidOtpFailure extends AuthFailure {
  const InvalidOtpFailure([
    super.message = 'Mã OTP không chính xác. Vui lòng thử lại.',
  ]);
}

class OtpExpiredFailure extends AuthFailure {
  const OtpExpiredFailure([
    super.message = 'Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã.',
  ]);
}

class UserExistsFailure extends AuthFailure {
  const UserExistsFailure([
    super.message = 'Email này đã được đăng ký.',
  ]);
}

class AccountLockedFailure extends AuthFailure {
  const AccountLockedFailure([
    super.message =
        'Tài khoản của bạn tạm thời bị khóa do nhập sai quá nhiều lần.',
  ]);
}

class RateLimitedFailure extends AuthFailure {
  const RateLimitedFailure([
    super.message = 'Bạn đã thao tác quá nhanh. Vui lòng thử lại sau 1 phút.',
  ]);
}

class SocialAuthFailure extends AuthFailure {
  const SocialAuthFailure([
    super.message = 'Đăng nhập mạng xã hội thất bại. Vui lòng thử lại.',
  ]);
}

class InvalidResetTokenFailure extends AuthFailure {
  const InvalidResetTokenFailure([
    super.message = 'Liên kết đặt lại mật khẩu không còn hợp lệ.',
  ]);
}

class ResetTokenExpiredFailure extends AuthFailure {
  const ResetTokenExpiredFailure([
    super.message = 'Phiên đặt lại mật khẩu đã hết hạn. Vui lòng thử lại.',
  ]);
}

class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure([
    super.message = 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.',
  ]);
}

class InvalidInputFailure extends AuthFailure {
  const InvalidInputFailure([
    super.message = 'Thông tin nhập vào không hợp lệ. Vui lòng kiểm tra lại.',
  ]);
}
