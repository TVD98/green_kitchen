## ADDED Requirements

### Requirement: Suggestions tab presents curated sections
Tab 3 (Suggestions) SHALL display vertically stacked editorial sections with localized titles, including at minimum: Featured today, Popular, Quick meals, and Easy recipes.

#### Scenario: Suggestions tab renders sections
- **WHEN** the user opens the Suggestions tab
- **THEN** the app SHALL show the four section headers with recipe rows or cards beneath each

### Requirement: Section content uses real recipe API data
Each section SHALL load recipes from `GET /api/v1/recipes` using section-appropriate query parameters (e.g. `max_time=30` for Quick, `difficulty=easy` for Easy, newest-first for Featured/Popular base lists).

#### Scenario: Quick section applies max time filter
- **WHEN** the Quick meals section loads
- **THEN** the client request SHALL include `max_time=30` (or equivalent agreed constant)

### Requirement: Popular section uses simulated engagement metrics
The Popular section SHALL attach **client-generated mock** popularity metadata (e.g. view counts) derived deterministically from recipe ids. The UI MUST NOT claim the metrics come from the server. No trending/analytics API is required in this change.

#### Scenario: Mock view count is stable per recipe
- **WHEN** the same recipe appears in Popular across two loads in one session
- **THEN** the displayed mock view count SHALL remain consistent for that recipe id

#### Scenario: Popular uses API-backed recipe rows
- **WHEN** the Popular section renders
- **THEN** recipe titles and cook metadata SHALL come from real `GET /api/v1/recipes` results, with mock counts overlaid in the presentation layer

### Requirement: Suggestions rows open shared recipe detail
Tapping a recipe in any Suggestions section SHALL navigate to `/recipes/:id`.

#### Scenario: Open featured recipe
- **WHEN** the user taps a recipe in Featured today
- **THEN** the app SHALL open the shared recipe detail screen

### Requirement: Suggestions UI uses design system and localization
The Suggestions tab SHALL use `green_kitchen_ui` list/card patterns and localized section titles via `AppLocalizations`.

#### Scenario: Localized section headers
- **WHEN** locale is English
- **THEN** section titles SHALL appear in English ARB strings
