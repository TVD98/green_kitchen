## ADDED Requirements

### Requirement: Auth screens use app localization
Auth presentation screens and widgets (Welcome, Login, Signup, Forgot password, OTP, Reset password, Password updated, Home auth-owned copy, social auth row) SHALL resolve user-facing labels, titles, hints, buttons, and helper text via `AppLocalizations` for `vi` and `en`, and SHALL pass those strings into `green_kitchen_ui` widgets.

#### Scenario: Login labels follow locale
- **WHEN** the active app locale is `vi` and the user opens Login
- **THEN** Login user-facing copy SHALL appear in Vietnamese from the app localization layer

#### Scenario: Login labels in English
- **WHEN** the active app locale is `en` and the user opens Login
- **THEN** Login user-facing copy SHALL appear in English from the app localization layer

#### Scenario: No hardcoded auth product copy
- **WHEN** an auth presentation screen renders user-facing text
- **THEN** that text MUST NOT be a hardcoded product string literal in the widget tree

### Requirement: Client validation messages are localized
Client-side auth validation messages (email, password, confirm password, OTP, and similar) SHALL be shown in the active app locale via the app localization layer, without embedding locale-specific copy in the Domain layer.

#### Scenario: Invalid email under Vietnamese locale
- **WHEN** the locale is `vi` and the user submits an invalid email on an auth form
- **THEN** the validation message SHALL be Vietnamese from `AppLocalizations`

#### Scenario: Invalid email under English locale
- **WHEN** the locale is `en` and the user submits an invalid email on an auth form
- **THEN** the validation message SHALL be English from `AppLocalizations`

### Requirement: Dynamic auth strings use localized placeholders
Auth strings that include dynamic values (e.g. OTP resend countdown, welcome with display name) SHALL use localization placeholders so the full sentence follows the active locale.

#### Scenario: OTP resend countdown
- **WHEN** OTP resend is cooling down and the locale is `vi` or `en`
- **THEN** the countdown message SHALL come from a localized template with the remaining seconds substituted
