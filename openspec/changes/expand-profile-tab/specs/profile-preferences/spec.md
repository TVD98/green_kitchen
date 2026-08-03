## ADDED Requirements

### Requirement: Preferences editor loads current preferences
The preferences editor SHALL call `GET /api/v1/users/me/preferences` (JWT) on open and populate the form from the response. Empty/null defaults (first-time user) SHALL render as unset selections and empty lists, not as an error.

The screen SHALL use `green_kitchen_ui` widgets and localized copy via `AppLocalizations` (no hardcoded product copy).

#### Scenario: First-time user sees empty form
- **WHEN** GET returns null scalar fields and empty arrays
- **THEN** the editor SHALL show no dietary style or spice selection and empty multi-select lists

#### Scenario: Existing preferences hydrate the form
- **WHEN** GET returns `dietary_style: "vegetarian"` and `spice_level: "mild"`
- **THEN** the editor SHALL show those values as selected

#### Scenario: Load failure shows retry
- **WHEN** GET preferences fails
- **THEN** the editor SHALL show a localized error state with a retry action

### Requirement: Preferences editor saves via PUT
Saving SHALL call `PUT /api/v1/users/me/preferences` with the edited fields matching the API contract:

| Field | Client behavior |
|-------|-----------------|
| `dietary_style` | One of `omnivore`, `vegetarian`, `vegan`, `pescatarian`, or omitted/cleared per product UX |
| `spice_level` | One of `mild`, `medium`, `hot`, or omitted/cleared per product UX |
| `cuisine_preferences` | Subset of the client curated cuisine allow-list |
| `health_goals` | Subset of the client curated health-goal allow-list |
| `disliked_ingredients` | Free-text string list as entered by the user |

Wire enum/token values SHALL remain English API tokens; only UI labels are localized.

The Save control SHALL be enabled only when the draft differs from the last loaded/saved preferences snapshot. While saving is in progress, Save SHALL remain disabled (or show loading).

#### Scenario: User saves dietary style and spice
- **WHEN** the user selects vegetarian + medium spice and taps Save
- **THEN** the client SHALL PUT those values and on success leave or confirm the saved state

#### Scenario: Save disabled when unchanged
- **WHEN** the preferences form matches the last loaded or successfully saved snapshot
- **THEN** the Save control SHALL be disabled

#### Scenario: Save enabled after edit
- **WHEN** the user changes any preference field from the snapshot
- **THEN** the Save control SHALL become enabled

#### Scenario: Save failure keeps draft
- **WHEN** PUT preferences fails
- **THEN** the editor SHALL keep the in-progress form values and show a localized error

### Requirement: Cuisine and health goals use curated allow-lists
The client SHALL present cuisine preferences and health goals as multi-select controls backed by documented curated allow-lists (not unbounded free text). Disliked ingredients SHALL remain free-text chips/tags.

#### Scenario: User cannot enter arbitrary cuisine tokens via UI
- **WHEN** the user edits cuisine preferences
- **THEN** only curated cuisine options SHALL be selectable in the UI

### Requirement: Preferences use design system and localization
Preferences editor presentation SHALL use `green_kitchen_ui` tokens/widgets/theme and `AppLocalizations` for all user-facing strings.

#### Scenario: Localized save label
- **WHEN** Preferences renders in Vietnamese
- **THEN** primary actions and field labels SHALL use Vietnamese ARB strings
