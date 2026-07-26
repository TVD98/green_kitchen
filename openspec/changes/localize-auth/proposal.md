## Why

Auth screens still hardcode English (and a few Vietnamese) user-facing strings even though app localization (`vi`/`en`) is wired. Switching language in Settings does not change Welcome/Login/Signup/OTP flows, so the auth experience remains monolingual.

## What Changes

- Add ARB keys (`en` + `vi`) for all auth presentation copy: welcome, login, signup, forgot password, OTP, reset password, password updated, home (remaining strings), and social auth row
- Replace hardcoded user-facing strings in auth pages/widgets with `AppLocalizations`
- Localize client-side validation messages currently hardcoded in `AuthValidators` (and any presentation-only auth feedback such as session-expired UI copy) via localization-friendly codes or presentation-layer mapping
- Keep using `green_kitchen_ui` widgets; pass localized `String`s into labels/hints/titles

### Non-goals

- Translating raw backend/API error message bodies (still out of scope unless mapped to known client codes)
- Localizing non-auth features
- Changing auth business logic, routes, or API contracts
- Putting auth copy inside `green_kitchen_ui`

## Capabilities

### New Capabilities
- `auth-localization`: Auth feature screens and widgets resolve user-facing copy (and client validation messages) through the app localization layer for `vi` and `en`

### Modified Capabilities
- (none — `app-localization` is not yet archived into main specs; this change consumes the existing gen-l10n wiring)

## Impact

- `lib/l10n/app_en.arb`, `lib/l10n/app_vi.arb` (+ regenerated `AppLocalizations`)
- Auth presentation: pages, `social_auth_row`, home remaining strings
- Domain validators: stop returning locale-specific literals; return codes or use presentation mapping with `AppLocalizations`
- Tests that assert English auth UI strings may need bilingual or key-based updates
- No new packages; reuses existing gen-l10n + locale preference
