# app-ui-integration Specification

## Purpose
TBD - created by archiving change add-green-kitchen-ui. Update Purpose after archive.
## Requirements
### Requirement: Path dependency on local package
The `green_kitchen` app SHALL depend on `green_kitchen_ui` via a local path dependency pointing at `packages/green_kitchen_ui`.

#### Scenario: Pub resolves local package
- **WHEN** `flutter pub get` is run at the app root
- **THEN** `green_kitchen_ui` SHALL resolve from the local path without requiring pub.dev

### Requirement: App applies package themes
The app root `MaterialApp` SHALL use `AppTheme.light` and `AppTheme.dark` from the package (with a system or explicit `themeMode`).

#### Scenario: MaterialApp wired to AppTheme
- **WHEN** the app starts
- **THEN** light and dark themes SHALL come from `AppTheme` rather than the default Flutter seed theme

