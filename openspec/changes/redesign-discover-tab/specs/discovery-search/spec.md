## ADDED Requirements

### Requirement: Discovery search calls the discovery API
When the user taps Find recipes on Discover with a non-empty prompt, the app SHALL navigate to `/discovery/results` and call `POST /api/v1/discovery/search` with body:

```json
{
  "prompt": "<string, max 500>",
  "options": {
    "use_preferences": <boolean>,
    "exclude_allergies": <boolean>
  },
  "filters": {
    "max_time": <optional int>,
    "difficulty": <optional string>,
    "tags": <optional string[]>
  }
}
```

using the authenticated Bearer token.

#### Scenario: Successful discovery search
- **WHEN** the server returns `success: true` with a recipe array in `data`
- **THEN** the results screen SHALL list each recipe with title, time, and difficulty via `RecipeListTile`

#### Scenario: Unauthenticated discovery search blocked
- **WHEN** the access token is missing or rejected
- **THEN** the app SHALL NOT show recipe results and SHALL follow existing session-expired / auth redirect behavior

### Requirement: Discovery data layer follows Clean Architecture
The app SHALL implement:
- `DiscoveryRemoteDataSource` — HTTP POST wrapper
- `DiscoveryRepository` + implementation — maps API envelope to domain `Recipe` entities
- `SearchDiscovery` use case — returns `Result<List<Recipe>>`
- `DiscoverySearchQuery` entity — prompt, options, filters

Registration SHALL occur in `injection.dart` alongside existing pantry/recipes dependencies.

#### Scenario: Repository maps API errors
- **WHEN** the API returns `ERR_TOO_MANY_REQUESTS`, `ERR_INVALID_INPUT`, or `ERR_INTERNAL_SERVER`
- **THEN** the repository SHALL map to existing `DiscoveryFailureCodes` for localized UI messages

### Requirement: Discovery results page shows loading and error states
While discovery search is in flight, the results screen SHALL show `AppLoading`. Failures SHALL show a localized error via `discoveryFailureMessage` with a retry affordance.

#### Scenario: User retries after failure
- **WHEN** discovery search fails and the user taps retry
- **THEN** the app SHALL re-issue the same discovery search request

#### Scenario: Empty results
- **WHEN** the API returns an empty recipe array
- **THEN** the results screen SHALL show a localized empty state

### Requirement: Successful discovery search persists local session
On successful discovery search, the app SHALL append a `DiscoverySession` record `{ prompt, recipe_ids, searched_at }` to local storage for the Library tab "Từ tủ bếp" / discover history use cases.

#### Scenario: Session recorded after search
- **WHEN** discovery search returns two recipes
- **THEN** local storage SHALL contain a session linking the prompt to those recipe IDs

### Requirement: Discover navigates to discovery results not pantry results
The Find recipes CTA on the redesigned Discover tab SHALL push `/discovery/results` with `DiscoverySearchArgs`, not `/pantry/results` with `PantrySearchArgs`.

#### Scenario: CTA navigation target
- **WHEN** the user submits a discovery search from Tab Khám phá
- **THEN** navigation SHALL use the discovery results route and bloc

## MODIFIED Requirements

### Requirement: Pantry search calls the discovery API
Pantry search via `POST /api/v1/pantry/search` remains implemented but SHALL NOT be the primary submission path from Tab Khám phá after this change. The pantry results route MAY remain for backward compatibility.

#### Scenario: Discover no longer calls pantry search directly
- **WHEN** the user completes the redesigned Discover flow
- **THEN** the app SHALL call `POST /discovery/search`, not `POST /pantry/search`
