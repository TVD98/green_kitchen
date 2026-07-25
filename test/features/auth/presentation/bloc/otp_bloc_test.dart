import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_kitchen/core/error/failures.dart';
import 'package:green_kitchen/core/error/result.dart';
import 'package:green_kitchen/features/auth/domain/entities/otp_session.dart';
import 'package:green_kitchen/features/auth/domain/usecases/forgot_password.dart';
import 'package:green_kitchen/features/auth/domain/usecases/verify_otp.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/otp_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockVerify extends Mock implements VerifyOtp {}

class _MockForgot extends Mock implements ForgotPassword {}

void main() {
  late _MockVerify verify;
  late _MockForgot forgot;

  setUp(() {
    verify = _MockVerify();
    forgot = _MockForgot();
  });

  OtpBloc build() => OtpBloc(
        verifyOtp: verify,
        forgotPassword: forgot,
        sessionId: 'sess_1',
        email: 'a@b.com',
        expireInSeconds: 180,
        resendAfterSeconds: 0,
      );

  blocTest<OtpBloc, OtpState>(
    'accepts four digit otp and returns reset token',
    build: () {
      when(
        () => verify(
          sessionId: any(named: 'sessionId'),
          otpCode: any(named: 'otpCode'),
          purpose: any(named: 'purpose'),
        ),
      ).thenAnswer((_) async => const Success('reset_token'));
      return build();
    },
    act: (bloc) => bloc.add(const OtpCodeChanged('1234')),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<OtpState>().having((s) => s.code, 'code', '1234'),
      isA<OtpState>().having((s) => s.status, 'status', OtpStatus.loading),
      isA<OtpState>()
          .having((s) => s.status, 'status', OtpStatus.success)
          .having((s) => s.resetToken, 'resetToken', 'reset_token'),
    ],
  );

  blocTest<OtpBloc, OtpState>(
    'maps invalid otp failure',
    build: () {
      when(
        () => verify(
          sessionId: any(named: 'sessionId'),
          otpCode: any(named: 'otpCode'),
          purpose: any(named: 'purpose'),
        ),
      ).thenAnswer((_) async => const Err(InvalidOtpFailure()));
      return build();
    },
    act: (bloc) => bloc.add(const OtpCodeChanged('0000')),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      isA<OtpState>(),
      isA<OtpState>().having((s) => s.status, 'status', OtpStatus.loading),
      isA<OtpState>()
          .having((s) => s.failure, 'failure', isA<InvalidOtpFailure>()),
    ],
  );

  blocTest<OtpBloc, OtpState>(
    'resend replaces session id',
    build: () {
      when(() => forgot(email: any(named: 'email'))).thenAnswer(
        (_) async => const Success(
          OtpSession(
            sessionId: 'sess_2',
            expireInSeconds: 180,
            resendAfterSeconds: 60,
            email: 'a@b.com',
          ),
        ),
      );
      return build();
    },
    act: (bloc) => bloc.add(const OtpResendRequested()),
    expect: () => [
      isA<OtpState>().having((s) => s.status, 'status', OtpStatus.loading),
      isA<OtpState>()
          .having((s) => s.sessionId, 'sessionId', 'sess_2')
          .having((s) => s.resendSecondsLeft, 'cooldown', 60),
    ],
  );
}
