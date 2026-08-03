## ADDED Requirements

### Requirement: Profile hub links to preferences and allergies
Tab 4 (Profile) SHALL include navigation rows to dietary preferences and allergies editors, in addition to the existing language and logout actions. Rows SHALL use `green_kitchen_ui` list/card patterns and localized labels via `AppLocalizations`.

#### Scenario: Open preferences from Profile
- **WHEN** the user taps the preferences row on Profile
- **THEN** the app SHALL navigate to the preferences editor route under the Profile branch

#### Scenario: Open allergies from Profile
- **WHEN** the user taps the allergies row on Profile
- **THEN** the app SHALL navigate to the allergies editor route under the Profile branch

### Requirement: Profile hub may show preference and allergy summaries
When preferences and/or allergies load successfully, the Profile hub SHALL show a short localized summary on the corresponding row (for example dietary style label and allergy count). Load failure SHALL NOT block rendering of the hub; summaries MAY remain empty.

#### Scenario: Allergy count summary
- **WHEN** the user has three saved allergies and the hub load succeeds
- **THEN** the allergies row subtitle SHALL reflect a localized count of three

#### Scenario: Hub usable when summary load fails
- **WHEN** preferences or allergies GET fails
- **THEN** the Profile hub SHALL still show session user info, language, preferences/allergies rows, and logout

### Requirement: Profile retains session info language and logout
Profile SHALL continue to display the authenticated user's display name (when present) and email, provide language settings entry to `/settings/language`, and provide logout that clears the session and returns to Welcome.

#### Scenario: Language and logout still available
- **WHEN** an authenticated user opens Profile after this change
- **THEN** the screen SHALL still expose language navigation and logout alongside the new preferences and allergies rows
