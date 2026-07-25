## ADDED Requirements

### Requirement: Forgot password collects registered email
The Forgot Password screen SHALL follow the Focuso Forgot Password frame (back, title, instructional copy, registered email field, bottom "Send OTP Code" CTA) using `green_kitchen_ui` widgets. It SHALL collect a single email address, validate it against RFC 5322, and call `POST /api/v1/auth/forgot-password` with an `email` field.

#### Scenario: User submits a valid email
- **WHEN** the user enters a valid email and submits
- **THEN** the app SHALL call the forgot-password endpoint and, on `OTP_SENT`, navigate to the Enter OTP screen with the returned `session_id`

#### Scenario: Malformed email blocks submission
- **WHEN** the entered email fails format validation
- **THEN** the field SHALL show "Email không hợp lệ. Vui lòng kiểm tra lại." and the submit button SHALL be disabled

### Requirement: Forgot password does not reveal account existence
The server SHALL return the same generic `OTP_SENT` success response whether or not the email belongs to an account, and the app SHALL proceed to the OTP screen with the same UX in both cases (no "email not found" message on this step).

#### Scenario: Email is not registered
- **WHEN** the submitted email has no associated account
- **THEN** the app SHALL still navigate to the OTP screen without disclosing that the email is unknown

### Requirement: Enter OTP uses four digit boxes
The Enter OTP screen SHALL follow the Focuso OTP frame: title, email-OTP instructional copy, **exactly four** single-digit boxes with auto-advance and digit-only input, a resend countdown, a disabled Resend action during cooldown, using `green_kitchen_ui` styling (primary focus border from Green Kitchen tokens).

#### Scenario: OTP accepts only four digits
- **WHEN** the user enters OTP digits
- **THEN** the UI SHALL accept only characters `0-9` across four boxes and SHALL NOT show six boxes

#### Scenario: Resend is locked during cooldown
- **WHEN** the OTP screen is displayed and the resend cooldown has not elapsed
- **THEN** the Resend action SHALL be disabled and the remaining seconds SHALL be shown

### Requirement: OTP verification for password reset
The app SHALL verify codes via `POST /api/v1/auth/verify-otp` with `session_id`, `otp_code` (4 digits), and `purpose` set to `password_reset`. On success the server SHALL return a short-lived `reset_token`, and the app SHALL navigate to the New Password screen carrying that token.

#### Scenario: Correct OTP
- **WHEN** the user submits a valid, unexpired 4-digit code
- **THEN** the app SHALL navigate to the New Password screen with the returned `reset_token`

#### Scenario: Incorrect OTP
- **WHEN** the server responds 400 with `ERR_INVALID_OTP`
- **THEN** the app SHALL show "Mã OTP không chính xác. Vui lòng thử lại." and allow the user to retry

#### Scenario: Expired OTP
- **WHEN** the server responds 400 with `ERR_OTP_EXPIRED`
- **THEN** the app SHALL show "Mã OTP đã hết hạn. Vui lòng yêu cầu gửi lại mã." and enable the resend action

### Requirement: Resending a reset OTP replaces the session
Resending SHALL call `POST /api/v1/auth/forgot-password` again with the same email (or a dedicated resend endpoint returning a new session), and the app SHALL replace the stored `session_id` and restart the resend cooldown.

#### Scenario: User requests a new code
- **WHEN** the user taps Resend after the cooldown elapses
- **THEN** the app SHALL use the newly returned `session_id` for subsequent verification and SHALL discard the previous one

### Requirement: New password screen and validation
The New Password screen SHALL follow the Focuso Secure Your Account frame (create + confirm password with visibility toggles, bottom "Save New Password" CTA). Password rules SHALL match signup (8–32 characters with upper, lower, digit, special). The two fields MUST match. The `reset_token` SHALL NOT be persisted to secure storage.

#### Scenario: New password fails complexity rules
- **WHEN** the entered new password does not satisfy the complexity rules
- **THEN** the field SHALL show "Mật khẩu từ 8-32 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt." and submission SHALL be blocked

#### Scenario: Confirmation does not match
- **WHEN** the confirmation value differs from the new password
- **THEN** the confirmation field SHALL show a mismatch error and submission SHALL be blocked

### Requirement: Reset password request contract
The app SHALL complete the reset via `POST /api/v1/auth/reset-password` with a body containing `reset_token` and `new_password`.

#### Scenario: Successful reset
- **WHEN** the server responds 200 with `code` `PASSWORD_RESET_SUCCESS`
- **THEN** the app SHALL navigate to the Password Updated success screen

#### Scenario: Token already used or expired
- **WHEN** the server responds 400 with `ERR_INVALID_RESET_TOKEN` or `ERR_RESET_TOKEN_EXPIRED`
- **THEN** the app SHALL show a message that the reset session is no longer valid and offer to restart forgot password

### Requirement: Password updated success screen
The Password Updated screen SHALL follow the Focuso success frame (illustration, "You're all set!" / updated copy, bottom Sign in CTA) using `green_kitchen_ui`. The Sign in CTA SHALL clear the reset navigation stack and open the Login screen.

#### Scenario: User continues after success
- **WHEN** the user taps Sign in on the success screen
- **THEN** the app SHALL open Login and SHALL NOT allow back-navigation into the completed reset flow

### Requirement: Reset invalidates existing sessions
After a successful password reset the server SHALL revoke all refresh tokens for that account, and the app SHALL clear any locally stored tokens before requiring a fresh login.

#### Scenario: Session after reset
- **WHEN** a password reset succeeds
- **THEN** the app SHALL clear any locally stored tokens and require a fresh login

### Requirement: Reset flows show loading and block double submit
While a forgot-password, verify-otp, or reset-password request is in flight, the submit `AppButton` SHALL render its loading state and further taps SHALL be ignored.

#### Scenario: Repeated taps during a request
- **WHEN** the user taps submit while a reset request is pending
- **THEN** the app SHALL NOT send a duplicate request
