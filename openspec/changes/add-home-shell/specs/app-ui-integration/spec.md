## MODIFIED Requirements

### Requirement: App applies package themes
The app root `MaterialApp` SHALL use `AppTheme.light` and `AppTheme.dark` from the package (with a system or explicit `themeMode`). When the user is authenticated, the primary app surface SHALL be the four-tab home shell rather than the auth feature placeholder home screen.

#### Scenario: MaterialApp wired to AppTheme
- **WHEN** the app starts
- **THEN** light and dark themes SHALL come from `AppTheme` rather than the default Flutter seed theme

#### Scenario: Authenticated root is home shell
- **WHEN** the user is authenticated
- **THEN** the default authenticated route SHALL be the home shell with bottom tabs, not the auth module placeholder `HomePage` as the sole post-login screen
