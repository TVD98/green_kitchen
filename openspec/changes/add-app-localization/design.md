## Context

`green_kitchen` is a Flutter app with `AppTheme` from `packages/green_kitchen_ui` and hardcoded English UI strings. There is no `flutter_localizations`, ARB/gen-l10n, or locale preference. Design-system widgets correctly accept `String` parameters and must stay locale-agnostic. Auth and other features are about to land, so localization must exist before new screens accumulate hardcoding.

## Goals / Non-Goals

**Goals:**
- Support `vi` and `en` via official Flutter gen-l10n
- Resolve locale from system by default; fall back to `vi` when system language is unsupported
- Let users override via Settings (System / Vietnamese / English) with persistence
- Own copy in the app; pass localized strings into `green_kitchen_ui`
- Enforce no hardcoded user-facing copy on new feature screens
- Implement locale preference as a Clean Architecture + BLoC feature module

**Non-Goals:**
- API/backend error message localization
- Locales beyond `vi` / `en`
- Product strings inside `green_kitchen_ui`
- Exhaustive kitchen-sink string migration (only enough sample keys to prove wiring)
- RTL-specific layouts (neither `vi` nor `en` requires RTL)

## Decisions

### 1. Official gen-l10n + ARB (not easy_localization / slang)

- **Choice:** `flutter: generate: true`, `l10n.yaml`, `lib/l10n/app_en.arb` + `app_vi.arb`, generated `AppLocalizations`
- **Why:** First-party, low dependency surface, standard for Flutter teams, works well with Material/Cupertino delegates
- **Alternatives:** easy_localization (faster DX, less idiomatic); slang (stronger typing, extra toolchain) — deferred unless gen-l10n becomes painful

### 2. App owns copy; UI package stays shell

- **Choice:** ARB files and `AppLocalizations` live in the app. Widgets in `green_kitchen_ui` continue to take `label` / `hint` / `title` as `String`
- **Why:** Matches current design-system boundary; package remains reusable without brand/product copy
- **Alternatives:** Package-level l10n — rejected (would couple DS to product strings)

### 3. Locale preference feature module (Clean Architecture + BLoC)

```
lib/features/locale_preference/
  domain/     # LocalePreference entity (system | vi | en), repository interface, use cases
  data/       # SharedPreferences (or equivalent) repository impl
  presentation/  # LocalePreferenceCubit/Bloc + Settings language UI
```

- **Choice:** Preference modeled as `system | vi | en` (not a raw `Locale?` alone)
- **Resolution:**
  - `system` → device locale if `vi`/`en`, else **`vi`**
  - `vi` / `en` → fixed override
- **Why:** Domain stays pure Dart; BLoC drives `MaterialApp.locale` rebuilds; Settings UI uses `green_kitchen_ui` (`AppRadioGroup` / list selection)
- **Persistence:** `shared_preferences` key for preference enum/string

### 4. MaterialApp wiring at app root

- `localizationsDelegates`: `AppLocalizations.delegate` + `GlobalMaterialLocalizations` + `GlobalWidgetsLocalizations` + `GlobalCupertinoLocalizations`
- `supportedLocales`: `Locale('vi')`, `Locale('en')`
- `locale`: from Cubit/Bloc state when override; `null` (follow system) when preference is `system`, with `localeResolutionCallback` / `localeListResolutionCallback` enforcing supported set + `vi` fallback
- Themes remain `AppTheme.light` / `AppTheme.dark`

### 5. Settings language UI

- Accessible from app navigation (minimal entry for v1 — e.g. Settings page or section reachable from current shell)
- Options rendered with `green_kitchen_ui` components; labels themselves come from l10n
- Changing preference updates UI immediately (no app restart)
- Changing to a **different** preference clears language-bound Discover draft state: main `prompt`, fridge sheet selection/search, and persisted `recentIngredientSets` (`ClearRecentIngredientSets`). Re-selecting the same option is a no-op.

### 6. Hardcode ban for new screens

- Convention (documented in tasks / team rule): new feature presentation code uses `AppLocalizations.of(context)!` (or injected lookup) for user-facing strings
- Kitchen sink may keep some English literals until optionally migrated; new auth/feature work must not

## Risks / Trade-offs

- **[Risk] Incomplete migration of existing demo strings** → Mitigation: scope kitchen sink as non-blocking; enforce rule on new screens only
- **[Risk] Locale flash on cold start before prefs load** → Mitigation: await preference read before `runApp`, or start with `system`/`vi` then emit loaded preference
- **[Risk] Missing ARB keys cause runtime/gen failures** → Mitigation: keep `en` + `vi` keys in sync; prefer template ARB as source of truth
- **[Trade-off] shared_preferences vs stronger storage** → Accept shared_preferences for a single enum preference

## Migration Plan

1. Add l10n config + seed ARB keys (Settings labels + a few samples)
2. Scaffold `locale_preference` feature + wire MaterialApp
3. Ship Settings language control
4. Apply no-hardcode rule to subsequent features
5. Optionally backfill kitchen sink later (separate change if large)

Rollback: remove locale wiring and feature module; themes/UI package unaffected.

## Open Questions

None — product decisions locked: `vi`+`en`, system default, `vi` fallback, Settings now, hardcode ban on new screens, API messages out of scope.
