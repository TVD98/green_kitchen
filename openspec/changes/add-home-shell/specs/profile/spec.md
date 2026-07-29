## ADDED Requirements

### Requirement: Profile tab shows authenticated user info
Tab 4 (Profile) SHALL display the current user's display name (when present) and email from the active auth session.

#### Scenario: Profile shows email
- **WHEN** an authenticated user opens Profile
- **THEN** the screen SHALL show the session user's email

### Requirement: Profile provides language settings entry
Profile SHALL include a navigation row to the existing language settings route (`/settings/language`).

#### Scenario: Open language settings
- **WHEN** the user taps the language row on Profile
- **THEN** the app SHALL navigate to the language settings page

### Requirement: Profile provides logout
Profile SHALL include a logout action that dispatches the existing auth logout flow and returns the user to Welcome.

#### Scenario: User logs out from Profile
- **WHEN** the user confirms logout on Profile
- **THEN** stored auth tokens SHALL be cleared and the router SHALL redirect to Welcome

### Requirement: Auth placeholder home actions move to Profile
The previous auth `HomePage` logout and language icon actions SHALL be removed from that screen once the shell ships; those affordances SHALL live on Profile instead.

#### Scenario: Old home no longer primary destination
- **WHEN** authentication succeeds after this change
- **THEN** the user SHALL NOT land on the auth placeholder home as the main app root

### Requirement: Profile uses design system and localization
Profile SHALL use `green_kitchen_ui` list/row patterns and localized labels via `AppLocalizations`.

#### Scenario: Localized logout label
- **WHEN** Profile renders in Vietnamese
- **THEN** the logout control SHALL use the Vietnamese localized string
