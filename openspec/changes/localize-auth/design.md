## Context

App localization foundation exists (`AppLocalizations`, `vi`/`en`, Settings language preference). Auth presentation still hardcodes English UI strings; domain `AuthValidators` returns Vietnamese literals. `green_kitchen_ui` remains locale-agnostic. Clean Architecture requires Domain to stay free of Flutter/`AppLocalizations`.

## Goals / Non-Goals

**Goals:**
- Localize all auth presentation user-facing copy via ARB + `AppLocalizations`
- Localize client-side validation / session-expired style messages without putting Flutter in Domain
- Keep auth UI on `green_kitchen_ui` widgets with localized `String` args
- Support placeholders where needed (e.g. OTP resend countdown, welcome with name)

**Non-Goals:**
- Mapping/translating arbitrary backend error message bodies
- Non-auth feature copy
- Auth flow / API / routing changes
- Product strings inside `green_kitchen_ui`

## Decisions

### 1. Extend existing ARB catalogs (not a separate package)

- Add auth keys to `lib/l10n/app_en.arb` and `app_vi.arb` with a clear `auth*` / screen-prefixed naming convention
- Regenerate `AppLocalizations`; screens call `AppLocalizations.of(context)!`

### 2. Domain validators return codes, presentation maps to l10n

- **Choice:** Change `AuthValidators` to return stable string codes (e.g. `auth.validation.emailInvalid`) or a small sealed/enum error type; presentation maps codes → `AppLocalizations` getters
- **Why:** Domain stays pure Dart; messages follow active locale
- **Alternatives:** Inject `AppLocalizations` into validators (breaks CA); keep Vietnamese literals (violates i18n)

### 3. API failures stay pass-through

- `messageForFailure` continues to surface `Failure.message` for remote errors
- Only known client-owned messages (validation, session expired UI) go through l10n

### 4. Screens in scope

Welcome, Login, Signup, Forgot password, OTP, Reset password, Password updated, Home remaining strings, `social_auth_row`, plus any auth snackbar/dialog copy owned by the client

### 5. Tests

- Update widget tests that assert fixed English auth copy to either pump with a fixed locale or assert via localized strings for that locale
- Prefer `locale: Locale('en')` in tests for stable expectations unless covering `vi` explicitly

## Risks / Trade-offs

- **[Risk] Missed hardcoded strings** → Mitigation: grep auth presentation for quotes; checklist per screen in tasks
- **[Risk] Validator API change breaks callers** → Mitigation: update all call sites in the same change; keep code list small and documented
- **[Risk] Placeholder / plural mistakes** → Mitigation: use ARB placeholders (`{seconds}`, `{name}`) with gen-l10n
- **[Trade-off] Untranslated API messages remain** → Accepted per non-goals

## Migration Plan

1. Add ARB keys (en + vi) for auth UI + validation
2. Refactor validators to codes + presentation mapper
3. Replace strings screen-by-screen
4. Fix tests + `flutter gen-l10n` / analyze

Rollback: revert ARB + auth presentation/validator changes; localization foundation unchanged.

## Open Questions

None — reuse existing `vi`/`en` and Settings locale override.
