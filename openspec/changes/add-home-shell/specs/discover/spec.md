## ADDED Requirements

### Requirement: Discover screen is the pantry entry point
Tab 1 (Discover) SHALL provide a primary flow for users to add ingredients they have on hand and request dish suggestions. The screen SHALL use `green_kitchen_ui` widgets (`AppTextField`, `AppChips`, `AppButton`, `AppCard`, `AppLoading`) and localized copy via `AppLocalizations`.

#### Scenario: Discover hero and ingredient entry
- **WHEN** the Discover tab is displayed
- **THEN** the user SHALL see a localized prompt to enter ingredients and a control to add ingredients to the current selection

### Requirement: Ingredient autocomplete uses the discovery API
As the user types, the app SHALL query `GET /api/v1/ingredients?q=` (debounced) with the authenticated Bearer token and display up to 20 matching suggestions by canonical name or alias.

#### Scenario: Autocomplete returns matches
- **WHEN** the user types a query that matches seeded ingredients
- **THEN** the app SHALL show selectable suggestions and SHALL NOT submit a pantry search automatically

#### Scenario: Empty query shows no suggestions
- **WHEN** the ingredient query field is empty
- **THEN** the autocomplete list SHALL be hidden or empty

### Requirement: Selected ingredients appear as removable chips
Selecting a suggestion or confirming free text SHALL add a deduplicated ingredient chip to the selection. The user SHALL be able to remove individual chips before searching.

#### Scenario: Duplicate ingredient rejected
- **WHEN** the user selects an ingredient already in the chip list
- **THEN** the app SHALL NOT add a duplicate chip

### Requirement: Pantry search requires at least one ingredient
The primary CTA to suggest dishes SHALL remain disabled until at least one ingredient chip is selected.

#### Scenario: CTA disabled with empty selection
- **WHEN** no ingredient chips are selected
- **THEN** the suggest-dishes button SHALL be disabled

### Requirement: Recent local pantry shortcuts
Discover SHALL surface up to five recent ingredient sets from local storage and allow one-tap reuse to pre-fill chips or re-run search.

#### Scenario: User reuses a recent search
- **WHEN** the user taps a recent ingredient set
- **THEN** the chip list SHALL populate with that set's ingredients
