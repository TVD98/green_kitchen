## ADDED Requirements

### Requirement: Allergies editor loads current allergies
The allergies editor SHALL call `GET /api/v1/users/me/allergies` (JWT) on open and display the returned `{ ingredient_id, name }[]` as a selectable working set. An empty list SHALL render as an empty selection state, not as an error.

The screen SHALL use `green_kitchen_ui` widgets and localized copy via `AppLocalizations` (no hardcoded product copy).

#### Scenario: User with no allergies
- **WHEN** GET returns `{ "allergies": [] }`
- **THEN** the editor SHALL show an empty selected set with affordance to search and add

#### Scenario: Existing allergies hydrate chips
- **WHEN** GET returns two allergies with canonical names
- **THEN** the editor SHALL show both names in the selected set

#### Scenario: Load failure shows retry
- **WHEN** GET allergies fails
- **THEN** the editor SHALL show a localized error state with a retry action

### Requirement: Allergies editor searches ingredients to add
The editor SHALL let the user search ingredients via the existing ingredients API (`GET /api/v1/ingredients?q=`), with debounced query input, and toggle results into the working allergy set by `ingredient_id`.

#### Scenario: Search adds an allergy candidate
- **WHEN** the user searches "đậu" and taps an ingredient result
- **THEN** that ingredient SHALL appear in the working selected set

#### Scenario: Toggle removes from working set
- **WHEN** the user toggles off a selected allergy chip or result
- **THEN** that ingredient SHALL leave the working set before save

### Requirement: Allergies editor replaces set via PUT
Saving SHALL call `PUT /api/v1/users/me/allergies` with body `{ "ingredient_ids": string[] }` representing the full working set (atomic replace). Clearing all allergies SHALL PUT an empty array. The client SHALL only submit ingredient IDs obtained from GET allergies or ingredients search results.

The Save control SHALL be enabled only when the working set of ingredient IDs differs from the last loaded/saved snapshot. While saving is in progress, Save SHALL remain disabled (or show loading). Clear all that results in no net change relative to an already-empty snapshot SHALL leave Save disabled.

#### Scenario: User saves two allergies
- **WHEN** the working set contains two ingredient IDs and the user taps Save
- **THEN** the client SHALL PUT those two IDs and on success reflect the saved set

#### Scenario: Save disabled when unchanged
- **WHEN** the working allergy set matches the last loaded or successfully saved snapshot
- **THEN** the Save control SHALL be disabled

#### Scenario: Save enabled after edit
- **WHEN** the user adds or removes an allergy from the snapshot set
- **THEN** the Save control SHALL become enabled

#### Scenario: User clears all allergies
- **WHEN** the working set is empty, differs from the snapshot, and the user taps Save
- **THEN** the client SHALL PUT `{ "ingredient_ids": [] }`

#### Scenario: Save failure keeps working set
- **WHEN** PUT allergies fails
- **THEN** the editor SHALL keep the in-progress working set and show a localized error

### Requirement: Allergies use design system and localization
Allergies editor presentation SHALL use `green_kitchen_ui` tokens/widgets/theme and `AppLocalizations` for all user-facing strings.

#### Scenario: Localized empty state
- **WHEN** Allergies renders with an empty set in Vietnamese
- **THEN** empty-state copy SHALL use Vietnamese ARB strings
