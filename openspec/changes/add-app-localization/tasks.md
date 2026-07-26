## 1. Dependencies and gen-l10n setup

- [x] 1.1 Add `flutter_localizations` (SDK), `intl`, `shared_preferences`, and `flutter_bloc` (if not already present) to the app `pubspec.yaml`
- [x] 1.2 Enable Flutter code generation (`flutter: generate: true`) and add `l10n.yaml` pointing at `lib/l10n` with template `app_en.arb`
- [x] 1.3 Create `lib/l10n/app_en.arb` and `lib/l10n/app_vi.arb` with Settings language keys plus a small sample set
- [x] 1.4 Run `flutter pub get` and confirm `AppLocalizations` generates successfully

## 2. Locale preference feature (Clean Architecture + BLoC)

- [x] 2.1 Scaffold `lib/features/locale_preference/{domain,data,presentation}` per flutter-clean-architecture
- [x] 2.2 Domain: `LocalePreference` (`system` | `vi` | `en`), repository interface, and use cases (get / set / watch or load)
- [x] 2.3 Domain: locale resolution helper — system → device `vi`/`en`, else fallback `vi`
- [x] 2.4 Data: SharedPreferences datasource + repository implementation for preference persistence
- [x] 2.5 Presentation: Cubit/Bloc that exposes preference + resolved `Locale?` for `MaterialApp`

## 3. MaterialApp wiring

- [x] 3.1 Load persisted preference before (or immediately with) app start to avoid locale flash
- [x] 3.2 Wire `MaterialApp` with `AppTheme.light` / `AppTheme.dark`, localization delegates, `supportedLocales` (`vi`, `en`), and preference-driven `locale` / resolution callback
- [x] 3.3 Provide `LocalePreference` Cubit/Bloc at app root so Settings and MaterialApp share state

## 4. Settings language UI

- [x] 4.1 Add a Settings language page/section reachable from the current app shell
- [x] 4.2 Build System / Vietnamese / English selection with `green_kitchen_ui` widgets (`AppRadioGroup` or equivalent) and app theme/tokens
- [x] 4.3 Bind selection to Cubit/Bloc; verify immediate UI language switch without restart
- [x] 4.4 Verify preference survives app restart

## 5. Sample usage and hardcode rule

- [x] 5.1 Use `AppLocalizations` for Settings strings and at least one sample string path into a `green_kitchen_ui` widget
- [x] 5.2 Document/enforce: new feature screens must not hardcode user-facing copy (kitchen sink backfill optional / out of critical path)

## 6. Verification

- [x] 6.1 Run `flutter pub get`
- [x] 6.2 Run `flutter analyze` and fix issues introduced by this change
- [x] 6.3 Manually verify: system `vi`/`en`, unsupported → `vi`, override EN/VI, System restore, restart persistence
