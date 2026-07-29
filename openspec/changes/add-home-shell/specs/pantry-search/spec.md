## ADDED Requirements

### Requirement: Pantry search calls the discovery API
When the user submits Discover with one or more ingredients, the app SHALL call `POST /api/v1/pantry/search` with body `{ ingredients: string[], filters?: { max_time?, difficulty?, tags? } }` using the authenticated session.

#### Scenario: Successful pantry search
- **WHEN** the server returns `success: true` with a recipe array in `data`
- **THEN** the app SHALL navigate to a results screen listing each returned recipe title, time, and difficulty

#### Scenario: Unauthenticated pantry search blocked
- **WHEN** the access token is missing or rejected
- **THEN** the app SHALL NOT show recipe results and SHALL follow the existing session-expired / auth redirect behavior

### Requirement: Optional filters before search
The Discover flow SHALL allow optional filters for maximum cook time and difficulty via an `AppBottomSheet` or equivalent design-system surface before submitting pantry search.

#### Scenario: User applies max time filter
- **WHEN** the user sets `max_time` to 30 and submits search
- **THEN** the POST body SHALL include `filters.max_time: 30`

### Requirement: Pantry results loading and error states
While pantry search is in flight, the results screen SHALL show `AppLoading`. Failures (network, `ERR_TOO_MANY_REQUESTS`, `ERR_INTERNAL_SERVER`) SHALL show a localized error state with retry affordance and SHALL NOT crash the app.

#### Scenario: User retries after failure
- **WHEN** a pantry search fails and the user taps retry
- **THEN** the app SHALL re-issue the same search request

### Requirement: Successful pantry search persists local session history
On successful pantry search, the app SHALL append a pantry session record (ingredient set, returned recipe IDs, timestamp) to local storage for Library tab "From pantry" and Discover recent shortcuts.

#### Scenario: Session recorded after search
- **WHEN** pantry search returns two recipes
- **THEN** local storage SHALL contain a session linking the ingredient set to those two recipe IDs
