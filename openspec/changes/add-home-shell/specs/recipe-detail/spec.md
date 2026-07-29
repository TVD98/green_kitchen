## ADDED Requirements

### Requirement: Recipe detail loads from the discovery API
The recipe detail screen SHALL load recipe data via `GET /api/v1/recipes/:id` and present title, description, time, difficulty, servings, tags, steps, ingredients, and nutrition when present.

#### Scenario: Successful detail load
- **WHEN** the user opens a valid recipe id
- **THEN** the app SHALL render the recipe steps in order and ingredient quantities

#### Scenario: Missing recipe
- **WHEN** the server returns 404 for the recipe id
- **THEN** the app SHALL show a localized not-found state with back navigation

### Requirement: Opening detail records a local view
When recipe detail successfully loads, the app SHALL record the recipe id in the local viewed store with a timestamp.

#### Scenario: Viewed recorded on open
- **WHEN** the user opens recipe detail for id `abc`
- **THEN** the local viewed store SHALL include `abc` with a `viewed_at` timestamp

### Requirement: Bookmark toggle persists locally
Recipe detail SHALL expose a save/bookmark control that toggles membership in the local saved store only (no server call in this change).

#### Scenario: User saves a recipe
- **WHEN** the user taps save on an unsaved recipe
- **THEN** the recipe id SHALL be added to the local saved store and the control SHALL reflect saved state

#### Scenario: User removes a saved recipe
- **WHEN** the user taps save on a saved recipe
- **THEN** the recipe id SHALL be removed from the local saved store

### Requirement: Detail UI uses design system and localization
Recipe detail SHALL compose layout with `green_kitchen_ui` components and SHALL resolve user-facing strings through `AppLocalizations`.

#### Scenario: Localized detail labels
- **WHEN** the detail screen renders
- **THEN** section headers such as ingredients and steps SHALL use localized strings, not hardcoded literals
