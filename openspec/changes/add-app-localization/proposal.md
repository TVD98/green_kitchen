## Why

The app currently hardcodes English copy in UI screens and has no locale wiring, so Vietnamese users cannot use the product in their language and new features will keep accumulating untranslated strings. We need a localization foundation (vi/en) with Settings override before auth and other feature screens land.

## What Changes

- Add app-owned localization for **Vietnamese (`vi`)** and **English (`en`)** using Flutter's official gen-l10n / ARB workflow
- Wire `MaterialApp` with localization delegates, supported locales, and locale resolution
- Default locale follows the **device/system**; when the system locale is neither `vi` nor `en`, fall back to **`vi`**
- Add a **Settings** language control: System / Vietnamese / English, with preference persisted across restarts
- Establish a project rule: **new feature screens MUST NOT hardcode user-facing copy**; strings resolve via the localization layer and are passed into `green_kitchen_ui` widgets as `String`s
- Scaffold localization as a Clean Architecture feature module (domain/data/presentation + BLoC) where locale preference lives
- Settings UI uses `green_kitchen_ui` tokens/widgets/theme

### Non-goals

- Localizing backend/API error messages
- Additional locales beyond `vi` and `en`
- Putting product copy inside `green_kitchen_ui` (package remains locale-agnostic)
- Full migration of every kitchen-sink demo string (may include a minimal sample set only)

## Capabilities

### New Capabilities
- `app-localization`: Supported locales, system default + `vi` fallback, user override via Settings with persistence, MaterialApp wiring, and no-hardcoded-copy rule for new screens
- `settings-language`: Settings surface to choose System / Vietnamese / English and apply the choice immediately

### Modified Capabilities
- `app-ui-integration`: `MaterialApp` SHALL wire localization delegates / supported locales / resolved locale in addition to existing `AppTheme` wiring

## Impact

- App root (`lib/main.dart` / app bootstrap): locale delegates, `locale` / `localeResolutionCallback`, and preference-driven rebuilds
- New feature module under `lib/features/` for locale preference (Clean Architecture + BLoC)
- New Settings presentation (language picker) using `green_kitchen_ui`
- Dependencies: `flutter_localizations` (SDK), `intl`; local persistence for preference (e.g. shared_preferences)
- Generated l10n outputs from ARB files under the app (`lib/l10n/` or project-standard path)
- `green_kitchen_ui`: no copy ownership change; continues to accept caller-provided strings
- Future auth and feature work must consume `AppLocalizations` (or equivalent) instead of literal UI strings
