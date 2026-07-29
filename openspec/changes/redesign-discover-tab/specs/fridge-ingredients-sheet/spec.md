## ADDED Requirements

### Requirement: Fridge Quick Start opens ingredient bottom sheet
When the user taps the Quick Start pill "Nguyên liệu trong tủ lạnh", the app SHALL open a modal bottom sheet (`isScrollControlled: true`, ~85% screen height) with rounded top corners and a drag handle.

The sheet header SHALL include:
- Title `discoverFridgeSheetTitle`
- Subtitle `discoverFridgeSheetSubtitle`
- Close (×) control

#### Scenario: Sheet opens from fridge pill
- **WHEN** the user taps the fridge Quick Start pill
- **THEN** the fridge ingredients bottom sheet SHALL be presented

#### Scenario: User closes sheet without applying
- **WHEN** the user taps close or dismisses the sheet without applying
- **THEN** the main Discover prompt SHALL remain unchanged
- **AND** sheet search query, search results, and selected ingredients SHALL remain in bloc state for the next open

### Requirement: Sheet state persists across open and apply
Closing the fridge sheet (via dismiss, close control, or **Thêm nguyên liệu**) SHALL NOT clear sheet search query, ingredient search results, or selected ingredients. Only explicit user actions clear sheet fields:

| Action | Clears search | Clears results | Clears selection |
|--------|---------------|----------------|------------------|
| Search clear (×) on search field | yes | yes | no |
| **Xóa lựa chọn** | no | no | yes |
| Close / dismiss sheet | no | no | no |
| **Thêm nguyên liệu** (apply) | no | no | no |

#### Scenario: Apply preserves sheet state
- **WHEN** the user has search text, results, and selected ingredients and taps **Thêm nguyên liệu**
- **THEN** the main prompt SHALL be updated from the selection
- **AND** reopening the sheet SHALL show the same search text, results, and selected ingredients

#### Scenario: Dismiss preserves sheet state
- **WHEN** the user dismisses the sheet without applying
- **THEN** reopening the sheet SHALL restore the previous search text, results, and selection

### Requirement: Fridge sheet searches ingredients with debounced API
The sheet SHALL provide a search field with hint `discoverFridgeSearchHint`. As the user types, the app SHALL debounce (300ms) and call `GET /api/v1/ingredients?q=` with the authenticated session.

#### Scenario: Empty query shows no grid
- **WHEN** the search field is empty
- **THEN** the ingredient grid SHALL NOT be shown
- **AND** the sheet SHALL show recent searches and/or hint `discoverFridgeSearchEmpty`

#### Scenario: Search returns grouped grid
- **WHEN** the user types a query that matches ingredients
- **THEN** results SHALL be displayed in a **two-column grid**, grouped by `category` with localized category headers (e.g. vegetable → `discoverIngredientCategoryVegetable`)

### Requirement: Fridge sheet shows recent ingredient sets on open
When the sheet opens and the search field is empty, the app SHALL display up to **five** recent ingredient sets from local storage (`recentIngredientSets`).

#### Scenario: User reuses recent set in sheet
- **WHEN** the user taps a recent ingredient set
- **THEN** the sheet selection SHALL be pre-filled with those ingredient names

### Requirement: Ingredient selection uses grid cards with toggle
Each ingredient in the grid SHALL appear as a card with the canonical name and a circular add control (`+`). Tapping SHALL toggle selection.

Rules:
- Maximum **7** selected ingredients (`maxFridgeIngredients`)
- No duplicates
- When 7 are selected, add controls on unselected cards SHALL be disabled
- Tapping a selected card SHALL deselect it

#### Scenario: Duplicate selection rejected
- **WHEN** an ingredient is already selected
- **THEN** selecting it again SHALL NOT create a duplicate entry

#### Scenario: Max selection enforced
- **WHEN** 7 ingredients are already selected
- **THEN** the user SHALL NOT be able to select an eighth ingredient until one is deselected

### Requirement: Fridge sheet footer shows selection counter and actions
The sheet SHALL have a sticky footer with:
- Primary button: `discoverFridgeAddIngredients` showing `(n/7)` count
- Secondary text action: `discoverFridgeClearSelection`

#### Scenario: Apply disabled with no selection
- **WHEN** no ingredients are selected
- **THEN** the primary footer button SHALL be disabled

#### Scenario: Clear selection
- **WHEN** the user taps "Xóa lựa chọn"
- **THEN** all selected ingredients in the sheet SHALL be cleared

### Requirement: Apply composes prompt on main Discover
When the user taps the primary footer button with one or more ingredients selected, the app SHALL:
1. Compose a localized prompt via `QuickStartPreset.fridge` (e.g. `"Tôi có: cà chua, dưa leo. Gợi ý món nấu."`)
2. Set the main Discover `prompt` to that string
3. Close the sheet
4. Update recent ingredient sets locally with the applied set

Sheet search query, search results, and selected ingredients SHALL NOT be cleared on apply (same persistence rules as dismiss).

The main Discover screen SHALL NOT show separate ingredient chips after apply — only the filled prompt.

#### Scenario: Apply fills main prompt
- **WHEN** the user selects "cà chua" and "dưa leo" and taps apply
- **THEN** the main prompt SHALL contain both ingredient names
- **AND** the Find recipes CTA on main Discover SHALL become enabled

#### Scenario: Apply does not trigger discovery search
- **WHEN** the user applies ingredients from the sheet
- **THEN** the app SHALL NOT call `POST /discovery/search` until the user taps Find recipes on the main screen

## MODIFIED Requirements

### Requirement: Ingredient autocomplete uses the discovery API
Ingredient autocomplete SHALL occur **inside the fridge ingredients bottom sheet only**, not on the main Discover screen. Behavior (debounced `GET /ingredients?q=`, Bearer token, empty query → no results) is unchanged from `add-home-shell`.

#### Scenario: Autocomplete not on main Discover
- **WHEN** the main Discover tab is displayed
- **THEN** there SHALL be no ingredient autocomplete list on the main screen

### Requirement: Recent local pantry shortcuts
Recent ingredient sets SHALL be surfaced **inside the fridge bottom sheet** when the search field is empty, not on the main Discover scroll content.

#### Scenario: Recent shortcuts in sheet only
- **WHEN** the fridge sheet is open with an empty search field
- **THEN** recent ingredient sets SHALL be visible in the sheet
