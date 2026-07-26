## Context

`green_kitchen` today contains only the `green_kitchen_ui` design-system package and a placeholder counter screen in `lib/main.dart`. There is no feature module, no networking layer, no dependency injection, and no routing. The auth backend does not exist yet, so this design fixes both the client architecture and the HTTP contract the API team will build against.

Source material:
- A Vietnamese auth design doc (original product rules).
- Focuso Pomodoro UI Kit Figma frames for Welcome, Sign up, Sign in, Forgot password, Enter OTP, New password, and Password updated.

Scope after revision: email + password only, Google + Facebook social, password reset via 4-digit email OTP, Figma layout using Focuso tokens via `green_kitchen_ui` (`AppColors.primary` = `#FF4749`). Phone/SMS OTP, Apple/X social, magic links, biometrics, and MFA are out.

Constraints:
- Feature-first Clean Architecture + BLoC per `.cursor/skills/flutter-clean-architecture/SKILL.md`; domain layer stays pure Dart.
- All UI is composed from `package:green_kitchen_ui/green_kitchen_ui.dart` and `AppTheme`.
- This is the first feature module, so it sets the pattern (DI, error model, networking) for everything that follows.

## Goals / Non-Goals

**Goals:**
- Working email auth in the Flutter app: signup, sign-in, Google/Facebook social, forgot → 4-digit email OTP → reset → success, logout.
- Precise HTTP contract for `/api/v1/auth/*` that the backend team can build to.
- Secure token persistence and transparent session refresh, with force logout when the session is unrecoverable.
- Auth screens that match Focuso Figma layout/structure using Focuso tokens via `green_kitchen_ui` (`AppColors.primary` = `#FF4749`).
- Reusable foundations (Dio client, failure model, DI container, router) that later features inherit.
- Testable layering: validators, use cases, and BLoCs unit-testable without Flutter bindings or a live server.

**Non-Goals:**
- Phone number + SMS OTP signup/login.
- Apple and X/Twitter social login.
- Magic-link password reset and deep-link configuration for reset.
- Biometric login — a separate change that builds on `auth-session`.
- 2FA/MFA, guest mode, SSL pinning.
- Backend implementation; only the contract is specified here.

## Decisions

### 1. Email-only credential accounts

Accounts created with email and password are the only password-based accounts. There is no phone identifier, no SMS OTP for signup/login, and no identifier-type switcher on forms.

- Rationale: product decision after reviewing Focuso Figma (email forms only) and simplifying MVP scope.
- Consequence: forgot-password and OTP verification exist only for email password reset.

### 2. Google and Facebook social auth

Welcome, Sign up, and Sign In expose Google and Facebook buttons. The client obtains a provider `id_token` (or access token as required by the SDK), then calls `POST /api/v1/auth/social-login` with `provider` (`google` | `facebook`), the token, and `device_info`. Success returns the same `user` + `tokens` shape as password login.

- Rationale: product wants social on the Focuso-layout screens without shipping Apple/X yet.
- Alternative considered: social only on Welcome. Rejected — Figma places social on Sign up and Sign in as well; keeping parity reduces UX surprise.
- Trade-off: native Google/Facebook SDK setup is platform-specific and must be configured before E2E social works; a fake social path supports UI until credentials are ready.

### 3. Password reset via 4-digit email OTP

Flow mirrors Focuso frames:
1. Forgot password → submit email → `POST /api/v1/auth/forgot-password` returns `OTP_SENT` + `session_id` (generic success; no account enumeration).
2. Enter OTP (4 boxes) → `POST /api/v1/auth/verify-otp` with `purpose: password_reset`.
3. On valid OTP, navigate to New password with a short-lived `reset_token` from the verify response.
4. Save new password → `POST /api/v1/auth/reset-password` → Password updated success → Sign in.

- Rationale: product chose email OTP over magic link after Figma review; 4 digits match the Focuso OTP frame.
- Alternative considered: magic link. Rejected for this change.
- Security note: 4-digit space is small — server MUST rate-limit aggressively (`ERR_TOO_MANY_REQUESTS`, lock after N failures) and use short expiry; client disables resend during cooldown.

### 4. Figma layout → `green_kitchen_ui` mapping

Use Focuso frames as structural reference only:
- Screen composition (header + form + social row + bottom CTA).
- Field order, checkbox/link placement, OTP 4-box row, success illustration + single CTA.

Map visuals to package tokens and widgets:
- Primary / CTA / focused borders / link accents → `AppColors.primary` (`#FF4749`) and related tokens.
- Typography → `AppTypography` / `AppText` variants.
- Spacing / radius → `AppSpacing` / `AppRadius`.
- Controls → `AppTextField`, `AppButton`, `AppCheckbox`, `AppLinkText`, `AppNavigationHeader`, `AppLoading`, `AppDialog`.

- Rationale: brand consistency with the already-shipped design system while reusing a proven auth IA.

### 5. Session storage and silent refresh in the data layer

Tokens live in `flutter_secure_storage` (Keychain / EncryptedSharedPreferences). A Dio interceptor attaches the access token, and on `401` it pauses further requests, calls `refresh-token` exactly once (subsequent 401s await the same in-flight refresh), then retries the original requests. If refresh fails, storage is cleared and a session-expired event forces the app back to Welcome.

- Rationale: keeps refresh invisible to BLoCs and use cases; only one refresh call happens under concurrent 401s.
- Trade-off: the interceptor must not intercept the refresh call itself, or a failing refresh recurses.

### 6. Layering and error model

```
lib/
├── core/
│   ├── error/          Failure types + exception→failure mapping
│   ├── network/        Dio client, auth interceptor, ApiException
│   ├── di/             get_it registrations
│   └── router/         go_router config + auth redirect
└── features/auth/
    ├── domain/         entities, AuthRepository contract, use cases
    ├── data/           DTOs, remote datasource, secure token store, repository impl
    └── presentation/   AuthBloc + per-screen BLoCs, pages, widgets
```

Server error codes (`ERR_INVALID_CREDENTIALS`, `ERR_INVALID_OTP`, `ERR_OTP_EXPIRED`, `ERR_ACCOUNT_LOCKED`, `ERR_TOO_MANY_REQUESTS`, `ERR_SOCIAL_AUTH_FAILED`, ...) are mapped in the data layer to typed `AuthFailure` values. The presentation layer maps failures to Vietnamese user-facing messages; raw server strings are never shown directly.

### 7. State management: one `AuthBloc` plus per-screen BLoCs

A long-lived `AuthBloc` owns global session state (`unknown` → `authenticated` / `unauthenticated`) and drives router redirects. Signup, login, forgot password, OTP, and reset each get their own short-lived BLoC for form state, validation, and submission. Social buttons dispatch into signup/login BLoCs (or a thin social use case) that ultimately updates `AuthBloc` on success.

### 8. Validation runs in the domain layer

Email format (RFC 5322), password rules (8–32 chars with upper, lower, digit, special from `!@#$%^&*`), and OTP shape (exactly 4 digits `0-9`) are pure Dart validators in `domain`. The server re-validates; the client treats `ERR_INVALID_INPUT` as a field-level error. Phone validators are not introduced.

## Risks / Trade-offs

- **Backend does not exist, so the contract may drift** → Specs in this change are the contract of record; the remote datasource is isolated behind `AuthRepository`, and a fake datasource lets UI work proceed before the API is live.
- **4-digit OTP is easier to brute-force than 6 digits or a magic link** → Server rate limits + short expiry + lockout after failed attempts; client honors resend cooldown and surfaces `ERR_TOO_MANY_REQUESTS`.
- **Google/Facebook SDK setup and store credentials** → Fake social path for UI; platform config tasks are explicit; Apple/X deferred.
- **Concurrent 401s could trigger multiple refresh calls or a refresh loop** → Single-flight refresh guarded by a shared completer; the refresh request itself bypasses the interceptor and a failed refresh immediately forces logout.
- **Ad-hoc styling drift** → No hardcoded color, typography, or spacing outside `green_kitchen_ui`; a review checklist verifies auth screens use package tokens and widgets (valid primary is the package token `#FF4749`).
- **This change introduces several dependencies at once** → They are conventional for this architecture and are set up in `core/` so later features reuse rather than re-choose them.
