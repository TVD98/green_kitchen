## ADDED Requirements

### Requirement: Login screen is email and password only
The Login screen SHALL collect email and password only (no phone mode). Layout SHALL follow the Focuso Sign in frame (back, title, email, password with visibility toggle, Remember me, Forgot Password link, Sign up link, Google/Facebook social row, bottom Sign in CTA) using `green_kitchen_ui` widgets and `AppTheme`.

#### Scenario: Login form fields
- **WHEN** the Login screen is displayed
- **THEN** it SHALL show email and password fields and SHALL NOT show a phone number field or phone login mode

### Requirement: Password field masking and toggle
The password field SHALL mask its value by default and SHALL provide a visibility toggle that reveals or hides the value.

#### Scenario: User reveals the password
- **WHEN** the user taps the visibility toggle
- **THEN** the password characters SHALL become visible and the toggle icon SHALL reflect the revealed state

### Requirement: Login input validation
The app SHALL validate login input before submission: the email must conform to RFC 5322 and the password must be non-empty. The submit button SHALL be disabled until both fields are valid.

#### Scenario: Malformed email
- **WHEN** the user enters an email that fails format validation
- **THEN** the field SHALL show "Email không hợp lệ. Vui lòng kiểm tra lại." and submission SHALL be blocked

### Requirement: Email login request contract
The app SHALL authenticate via `POST /api/v1/auth/login` with a body containing `email`, `password`, and `device_id`. On success the server SHALL return `code` `LOGIN_SUCCESS` with `data.user` and `data.tokens`.

#### Scenario: Successful email login
- **WHEN** the server responds 200 with `LOGIN_SUCCESS`
- **THEN** the app SHALL persist the returned tokens securely and navigate to the Home screen

### Requirement: Remember me preference
The Login screen SHALL offer a Remember me checkbox. When checked, the app SHALL keep the refresh token available across app restarts; when unchecked, the app SHALL clear the session when the app process ends (or on next cold start per platform secure-storage policy documented in implementation).

#### Scenario: Remember me checked
- **WHEN** the user signs in with Remember me checked
- **THEN** a subsequent cold start with a still-valid refresh token SHALL route to Home without requiring credentials again

### Requirement: Forgot Password entry
The Login screen SHALL show a Forgot Password link that navigates to the Forgot Password screen.

#### Scenario: User opens forgot password
- **WHEN** the user taps Forgot Password
- **THEN** the app SHALL navigate to the Forgot Password screen

### Requirement: Google and Facebook login entry points
The Login and Welcome screens SHALL expose Google and Facebook social actions and SHALL NOT expose Apple or X/Twitter. Successful social auth SHALL call `POST /api/v1/auth/social-login` with `provider` `google` or `facebook` and persist the returned session.

#### Scenario: Facebook login succeeds
- **WHEN** the user completes Facebook auth and the server returns tokens
- **THEN** the app SHALL store the tokens securely and navigate to Home

### Requirement: Login error mapping
The app SHALL map authentication failures to Vietnamese user-facing messages: `ERR_INVALID_CREDENTIALS` (401) to "Email/SĐT hoặc mật khẩu không chính xác." (or email-specific equivalent), `ERR_ACCOUNT_LOCKED` (403) to "Tài khoản của bạn tạm thời bị khóa do nhập sai quá nhiều lần.", `ERR_TOO_MANY_REQUESTS` (429) to "Bạn đã thao tác quá nhanh. Vui lòng thử lại sau 1 phút.", `ERR_SOCIAL_AUTH_FAILED` to a social-failure message, and `ERR_INTERNAL_SERVER` (500) to "Đã có lỗi xảy ra. Vui lòng thử lại sau ít phút.". Raw server messages SHALL NOT be displayed directly.

#### Scenario: Wrong password
- **WHEN** the server responds 401 with `ERR_INVALID_CREDENTIALS`
- **THEN** the app SHALL show the invalid-credentials message and keep the entered email

#### Scenario: Account temporarily locked
- **WHEN** the server responds 403 with `ERR_ACCOUNT_LOCKED`
- **THEN** the app SHALL show the locked-account message and SHALL NOT retry automatically

### Requirement: Login submission shows loading and blocks double submit
While a login or social request is in flight, the submit `AppButton` SHALL render its loading state and additional taps SHALL be ignored.

#### Scenario: Repeated taps during a request
- **WHEN** the user taps submit while a login request is pending
- **THEN** the app SHALL NOT send a duplicate request

### Requirement: Navigation between login and signup
The Login screen SHALL provide a Sign up link to the Signup screen.

#### Scenario: User without an account
- **WHEN** the user taps Sign up on the Login screen
- **THEN** the app SHALL navigate to the Signup screen
