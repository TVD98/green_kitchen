## Why

`green_kitchen` currently ships only a design system and a placeholder home screen; there is no way for a user to create an account or sign in, so no user-scoped feature can be built on top of it. The backend auth service does not exist yet either, so this change also fixes the client/server contract that the API team will implement against.

## What Changes

- Add the `auth` feature module under `lib/features/auth/` following `flutter-clean-architecture` (domain / data / presentation with BLoC).
- Support **email + password** accounts only for credential-based signup and sign-in.
- Support **Google** and **Facebook** social sign-in (and social sign-up) on Welcome, Signup, and Sign In screens. Apple and X/Twitter are out of scope.
- Add forgot/reset password for email accounts via a **4-digit email OTP**, then a new-password screen and a success screen (no magic link / deep link).
- Define the auth HTTP contract (`/api/v1/auth/*`): `signup`, `login`, `social-login`, `forgot-password`, `verify-otp`, `reset-password`, `refresh-token`, `logout`.
- Add secure session handling: tokens stored in Keychain (iOS) / EncryptedSharedPreferences (Android), silent refresh on `401`, and force logout when the refresh token is rejected.
- Add auth screens aligned to the Focuso Figma layout/structure (Welcome, Sign up, Sign in, Forgot password, Enter OTP, New password, Password updated). Screens use `green_kitchen_ui` Focuso tokens, `AppTheme`, and package widgets (`AppTextField`, `AppButton`, `AppCheckbox`, `AppLinkText`, `AppNavigationHeader`, `AppLoading`, `AppDialog`).
- Replace the placeholder counter home with an auth-gated entry point that routes to Welcome or Home based on session state.

Non-goals for this change: phone number + SMS OTP flows, Apple / X social login, biometric login (tracked as a separate change that depends on `auth-session`), 2FA/MFA on unknown devices, guest mode, magic-link password reset, and SSL pinning.

## Capabilities

### New Capabilities
- `auth-signup`: Email + password account creation, terms acceptance, Google/Facebook social signup entry points, and Focuso-layout Welcome / Sign up screens on `green_kitchen_ui`.
- `auth-login`: Email + password sign-in, Remember me, Forgot Password entry, Google/Facebook social login, and Focuso-layout Sign in screen on `green_kitchen_ui`.
- `auth-password-reset`: Forgot password → 4-digit email OTP → new password → success, including OTP resend cooldown and error mapping.
- `auth-session`: Secure token storage, authenticated request handling, silent refresh on expiry, force logout, and session-based app entry routing.

### Modified Capabilities
None. Auth only consumes the archived design-system specs (`design-system-tokens`, `design-system-theme`, `design-system-widgets`) whose brand primary is `#4AAF57`; this change does not revise those requirements.

## Impact

- **New code**: `lib/features/auth/{domain,data,presentation}`, app-level routing and session bootstrap in `lib/main.dart`.
- **Removed code**: the placeholder `MyHomePage` counter screen in `lib/main.dart`.
- **Dependencies (new)**: HTTP client (`dio`), state management (`flutter_bloc`), value equality (`equatable`), secure storage (`flutter_secure_storage`), dependency injection (`get_it`), routing (`go_router`), device identity (`device_info_plus`), and Google / Facebook auth SDKs for native social login.
- **Backend**: the API team must implement `/api/v1/auth/*` as specified; the specs in this change are the contract of record until the service exists.
- **UI**: screens follow Focuso Figma structure (sections, field order, CTA placement) and consume only `package:green_kitchen_ui/green_kitchen_ui.dart`; no hardcoded color, typography, or spacing outside the package (valid primary is the package token `#4AAF57`).
- **Testing**: unit tests for validators, use cases, and BLoCs; widget tests for the auth screens.
