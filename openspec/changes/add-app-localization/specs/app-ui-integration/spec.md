## ADDED Requirements

### Requirement: App applies localization at MaterialApp root
In addition to applying `AppTheme.light` / `AppTheme.dark`, the app root `MaterialApp` SHALL wire localization delegates, supported locales (`vi`, `en`), and the resolved locale from the app localization preference layer.

#### Scenario: MaterialApp wired for theme and locale
- **WHEN** the app starts
- **THEN** light and dark themes SHALL come from `AppTheme` and localization SHALL be active for supported locales according to the localization preference rules
