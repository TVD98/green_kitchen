## 1. ARB keys for auth

- [x] 1.1 Inventory auth presentation strings (pages, social row, home remaining, session-expired UI) and list ARB keys
- [x] 1.2 Add English keys to `lib/l10n/app_en.arb` (including placeholders for OTP countdown / welcome name)
- [x] 1.3 Add matching Vietnamese keys to `lib/l10n/app_vi.arb`
- [x] 1.4 Run `flutter gen-l10n` / `flutter pub get` and confirm `AppLocalizations` regenerates

## 2. Validation message localization

- [x] 2.1 Refactor `AuthValidators` to return stable codes (or equivalent) instead of locale-specific literals
- [x] 2.2 Add presentation mapper from validation codes → `AppLocalizations` getters
- [x] 2.3 Update auth forms/blocs that surface validator messages to use the mapper
- [x] 2.4 Localize client-owned auth feedback (e.g. session expired) via `AppLocalizations`; leave raw API `Failure.message` pass-through

## 3. Replace auth UI copy

- [x] 3.1 Localize `welcome_page.dart` and `social_auth_row.dart`
- [x] 3.2 Localize `login_page.dart` and `signup_page.dart`
- [x] 3.3 Localize `forgot_password_page.dart` and `otp_page.dart`
- [x] 3.4 Localize `reset_password_page.dart` and `password_updated_page.dart`
- [x] 3.5 Localize remaining hardcoded strings on `home_page.dart` (welcome / log out)

## 4. Verification

- [x] 4.1 Grep auth presentation for leftover user-facing string literals; remove or justify
- [x] 4.2 Update widget/unit tests for localized auth copy (pin locale where needed)
- [x] 4.3 Run `flutter pub get` and `flutter analyze`; fix issues from this change
- [x] 4.4 Smoke-check Login/Signup under `vi` and `en` (Settings language override)
