## ADDED Requirements

### Requirement: Welcome entry point
The app SHALL present a Welcome screen to unauthenticated users whose layout follows the Focuso Welcome frame (logo, title, subtitle, social actions, Sign up / Sign in CTAs, legal links) and whose visuals use `AppTheme` and `green_kitchen_ui` widgets (`AppButton`, `AppText`). Primary accent color SHALL be Green Kitchen primary, not Focuso coral.

#### Scenario: Unauthenticated user opens the app
- **WHEN** the app starts and no valid session exists
- **THEN** the Welcome screen SHALL be shown with Google and Facebook actions plus Sign up and Sign in CTAs

#### Scenario: User chooses to create an account
- **WHEN** the user taps Sign up
- **THEN** the app SHALL navigate to the Signup screen

#### Scenario: User chooses to sign in
- **WHEN** the user taps Sign in
- **THEN** the app SHALL navigate to the Login screen

### Requirement: Signup is email and password only
The Signup screen SHALL collect email and password only (no phone identifier, no identifier-type switcher). Layout SHALL follow the Focuso Sign up frame (back, title, email field, password field with visibility toggle, terms checkbox, Sign in link, social row, bottom Sign up CTA) using `green_kitchen_ui` components.

#### Scenario: Signup form fields
- **WHEN** the Signup screen is displayed
- **THEN** it SHALL show email and password fields and SHALL NOT show a phone number field

### Requirement: Client-side signup validation
The app SHALL validate signup input before submission: email conforming to RFC 5322; password 8–32 characters containing at least one uppercase letter, one lowercase letter, one digit, and one special character from `!@#$%^&*`. Invalid fields SHALL display the error through `AppTextField` error state.

#### Scenario: Password missing a required character class
- **WHEN** the user enters `password123` as the password
- **THEN** the password field SHALL show "Mật khẩu từ 8-32 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt." and the submit button SHALL remain disabled

#### Scenario: Malformed email
- **WHEN** the user enters an email that fails format validation
- **THEN** the email field SHALL show "Email không hợp lệ. Vui lòng kiểm tra lại."

### Requirement: Terms acceptance gates submission
The Signup screen SHALL include a checkbox for accepting Terms & Conditions. The submit button SHALL be enabled only when all validation passes and the checkbox is checked.

#### Scenario: Valid form without terms accepted
- **WHEN** every field is valid but the terms checkbox is unchecked
- **THEN** the submit button SHALL be disabled

### Requirement: Signup request contract
The app SHALL create accounts via `POST /api/v1/auth/signup` with a JSON body containing `email`, `password`, and `device_info` with `device_id`, `platform`, `os_version`, and `app_version`.

#### Scenario: Successful email signup
- **WHEN** the server responds 200 with `code` `SIGNUP_SUCCESS` and a token pair
- **THEN** the app SHALL store the tokens securely and navigate to the Home screen

### Requirement: Duplicate account is reported to the user
When the server rejects signup with `ERR_USER_EXISTS`, the app SHALL display "Số điện thoại hoặc Email này đã được đăng ký." (or an email-specific equivalent message) and keep the user on the Signup screen with entered values preserved.

#### Scenario: Email already registered
- **WHEN** the server responds 400 with `ERR_USER_EXISTS`
- **THEN** the app SHALL show the duplicate-account message and remain on the Signup screen

### Requirement: Google and Facebook signup entry points
The Welcome and Signup screens SHALL expose Google and Facebook social actions. Apple and X/Twitter social actions SHALL NOT be shown. Successful social auth SHALL call `POST /api/v1/auth/social-login` and persist the returned session.

#### Scenario: Google signup succeeds
- **WHEN** the user completes Google auth and the server returns tokens
- **THEN** the app SHALL store the tokens securely and navigate to Home

#### Scenario: Facebook signup fails
- **WHEN** the server responds with `ERR_SOCIAL_AUTH_FAILED`
- **THEN** the app SHALL show a Vietnamese failure message and remain on the current screen

### Requirement: Signup submission shows loading and blocks double submit
While a signup or social request is in flight, the triggering `AppButton` SHALL render its loading state and further submissions SHALL be ignored.

#### Scenario: User taps submit twice
- **WHEN** the user taps the submit button while a request is already in flight
- **THEN** the app SHALL NOT send a second request

### Requirement: Navigation between signup and login
The Signup screen SHALL provide a Sign in link to the Login screen.

#### Scenario: Existing account link
- **WHEN** the user taps Sign in on the Signup screen
- **THEN** the app SHALL navigate to the Login screen
