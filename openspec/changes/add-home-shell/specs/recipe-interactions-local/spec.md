## ADDED Requirements

### Requirement: Local store persists viewed recipes
The app SHALL persist viewed recipe records locally as `{ id, viewed_at }` entries without calling a backend sync API.

#### Scenario: Viewed list survives restart
- **WHEN** the user viewed a recipe and cold-starts the app
- **THEN** the viewed record SHALL still be present in local storage

### Requirement: Local store persists saved recipes
The app SHALL persist saved recipe records locally as `{ id, saved_at }` entries without calling a backend sync API.

#### Scenario: Saved list survives restart
- **WHEN** the user saved a recipe and cold-starts the app
- **THEN** the saved record SHALL still be present in local storage

### Requirement: Local store persists pantry sessions
The app SHALL persist pantry search sessions locally as `{ ingredients, recipe_ids, searched_at }` for Library and Discover shortcuts.

#### Scenario: Pantry session stores ingredient set
- **WHEN** a pantry search completes for ingredients `["trứng","cà chua"]`
- **THEN** the session record SHALL include that ingredient array and the returned recipe id list

### Requirement: Local lists are bounded
The implementation SHALL cap stored history length (documented constants in code) to prevent unbounded preference growth.

#### Scenario: Oldest entries evicted at cap
- **WHEN** viewed history exceeds the configured maximum
- **THEN** the oldest viewed entries SHALL be removed before adding new ones

### Requirement: Domain layer exposes interaction use cases
Interaction reads and writes SHALL live behind a repository interface in the domain layer (`RecordRecipeViewed`, `ToggleRecipeSaved`, `GetViewedRecipeIds`, `GetSavedRecipeIds`, `GetPantrySessions`, `SavePantrySession`) so presentation does not access `SharedPreferences` directly.

#### Scenario: BLoC uses repository
- **WHEN** recipe detail records a view
- **THEN** the presentation layer SHALL call a domain use case, not a storage API directly from widgets
