## 1. Dependencies and project setup

- [x] 1.1 Add `dio`, `flutter_bloc`, `equatable`, `get_it`, `flutter_secure_storage`, `go_router`, and `device_info_plus` to `pubspec.yaml`
- [x] 1.2 Add Google and Facebook auth SDK packages required for native social login
- [x] 1.3 Add `bloc_test` and `mocktail` to `dev_dependencies`
- [x] 1.4 Run `flutter pub get` and confirm `flutter analyze` is clean

## 2. Core foundations

- [x] 2.1 Create `lib/core/error/failures.dart` with the `Failure` base type and `AuthFailure` variants for invalid credentials, invalid/expired OTP, user exists, account locked, rate limited, social auth failed, invalid/expired reset token, network, and server errors
- [x] 2.2 Create `lib/core/network/api_exception.dart` mapping HTTP status plus server `code` strings to exceptions
- [x] 2.3 Create `lib/core/network/dio_client.dart` with base URL, timeouts, and JSON defaults over HTTPS
- [x] 2.4 Create `lib/core/device/device_info_provider.dart` exposing a stable `device_id`, platform, OS version, and app version
- [x] 2.5 Create `lib/core/di/injection.dart` with `get_it` registrations for core services
- [x] 2.6 Write unit tests for the exception-to-failure mapping

## 3. Auth domain layer

- [x] 3.1 Create entities `AuthUser`, `AuthTokens`, `OtpSession`, and `SocialProvider` (`google` | `facebook`) in `lib/features/auth/domain/entities/`
- [x] 3.2 Create validators for email, password, and 4-digit OTP in `lib/features/auth/domain/validation/` (no phone validators)
- [x] 3.3 Define the `AuthRepository` contract covering signup, login, socialLogin, forgotPassword, verifyOtp, resetPassword, refreshSession, logout, and readCachedSession
- [x] 3.4 Implement use cases `SignUp`, `LogInWithPassword`, `LogInWithSocial`, `ForgotPassword`, `VerifyOtp`, `ResetPassword`, `LogOut`, and `GetCachedSession`
- [x] 3.5 Write unit tests for every validator, covering the failing examples in the specs

## 4. Auth data layer

- [x] 4.1 Create DTOs for signup, login, social-login, forgot/verify/reset password, refresh, user, and tokens with JSON mapping to entities
- [x] 4.2 Implement `AuthRemoteDataSource` against `POST /api/v1/auth/{signup,login,social-login,forgot-password,verify-otp,reset-password,refresh-token,logout}`
- [x] 4.3 Implement `SecureTokenStore` on `flutter_secure_storage` for reading, writing, and clearing tokens
- [x] 4.4 Implement `AuthRepositoryImpl` translating exceptions into `Failure` values and persisting tokens on success
- [x] 4.5 Implement `AuthInterceptor` attaching the bearer token, skipping unauthenticated endpoints, and performing single-flight refresh on 401 with retry of pending requests
- [x] 4.6 Emit a session-expired signal and clear storage when refresh fails
- [x] 4.7 Add a `FakeAuthRemoteDataSource` (including fake social success) so UI work can proceed before the backend exists
- [x] 4.8 Write unit tests for the repository and for the interceptor's concurrent-401 and refresh-failure behavior

## 5. Session state and routing

- [x] 5.1 Implement `AuthBloc` with `unknown`, `authenticated`, and `unauthenticated` states plus session-expired and logout events
- [x] 5.2 Configure `go_router` with routes for Welcome, Signup, Login, Forgot Password, Enter OTP, New Password, Password Updated, and Home
- [x] 5.3 Add redirect logic that sends unauthenticated users to Welcome and authenticated users away from auth routes
- [x] 5.4 Show `AppLoading` while session state is `unknown` on startup
- [x] 5.5 Replace the placeholder counter screen in `lib/main.dart` with the router, DI bootstrap, and `AppTheme` wiring
- [x] 5.6 Write bloc tests for startup resolution, force logout, and explicit logout

## 6. Welcome, Signup, and social entry

- [x] 6.1 Build the Welcome screen from Focuso Welcome layout using `AppButton` / `AppText` and Green Kitchen tokens (no Focuso coral)
- [x] 6.2 Implement `SignupBloc` with email/password validation, terms gating, and submission states
- [x] 6.3 Build the Signup screen from Focuso Sign up layout with `AppTextField`, terms checkbox, Google/Facebook row (no Apple/X), and bottom CTA
- [x] 6.4 Wire email signup to persist tokens and navigate to Home
- [x] 6.5 Wire Google and Facebook on Welcome/Signup through `LogInWithSocial` → `AuthBloc`
- [x] 6.6 Map `ERR_USER_EXISTS` and `ERR_SOCIAL_AUTH_FAILED` to user-facing messages while preserving form values
- [x] 6.7 Write bloc and widget tests for validation gating, signup success, and social entry points

## 7. Login flow

- [x] 7.1 Implement `LoginBloc` with email/password validation, Remember me, and submission states (no phone mode)
- [x] 7.2 Build the Login screen from Focuso Sign in layout with password toggle, Remember me, Forgot Password link, Sign up link, and Google/Facebook row
- [x] 7.3 Wire email login to persist tokens and navigate to Home
- [x] 7.4 Wire Google and Facebook login through `LogInWithSocial`
- [x] 7.5 Map `ERR_INVALID_CREDENTIALS`, `ERR_ACCOUNT_LOCKED`, `ERR_TOO_MANY_REQUESTS`, `ERR_SOCIAL_AUTH_FAILED`, and `ERR_INTERNAL_SERVER` to their user-facing messages
- [x] 7.6 Write bloc and widget tests for login success and each error mapping

## 8. Password reset with 4-digit email OTP

- [x] 8.1 Implement `ForgotPasswordBloc` and build the Forgot Password screen from Focuso layout
- [x] 8.2 On `OTP_SENT`, navigate to Enter OTP with `session_id` without revealing whether the email exists
- [x] 8.3 Build the 4-box OTP input widget with auto-advance, digit-only input, and paste support
- [x] 8.4 Implement `OtpBloc` with `purpose` `password_reset`, expiry/resend cooldown, and session replacement on resend
- [x] 8.5 Build the Enter OTP screen from Focuso OTP layout and map `ERR_INVALID_OTP` / `ERR_OTP_EXPIRED`
- [x] 8.6 Implement `ResetPasswordBloc` and build the New Password screen from Focuso Secure Account layout
- [x] 8.7 On successful reset, clear stored tokens and navigate to the Password Updated success screen
- [x] 8.8 Build the Password Updated screen from Focuso success layout; Sign in clears the reset stack into Login
- [x] 8.9 Handle `ERR_INVALID_RESET_TOKEN` and `ERR_RESET_TOKEN_EXPIRED` with an option to restart forgot password
- [x] 8.10 Write bloc and widget tests for the full reset flow including 4-digit OTP behavior

## 9. Verification

- [x] 9.1 Confirm no auth screen defines Focuso coral or other ad-hoc colors/typography/spacing outside `green_kitchen_ui`
- [x] 9.2 Confirm Apple and X social buttons are absent and phone fields/modes are absent
- [x] 9.3 Confirm tokens never appear in logs and are never written outside secure storage
- [x] 9.4 Confirm OTP UI uses exactly four digits and no magic-link / deep-link reset path remains
- [x] 9.5 Run `flutter analyze` and resolve all issues
- [x] 9.6 Run `flutter test` and confirm the full suite passes
- [ ] 9.7 Manually verify Welcome, Signup, Sign in, Google/Facebook (fake), and reset OTP flows against the fake datasource on Android and iOS
- [ ] 9.8 Publish the `/api/v1/auth/*` contract from the specs to the backend team
