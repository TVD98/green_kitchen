## ADDED Requirements

### Requirement: Library tab shows personal recipe collections
Tab 2 (Library) SHALL list recipes relevant to the user using `AppTabs` segments and localized labels. Segments SHALL be exactly: **All**, **Viewed**, **Saved**, and **From pantry**.

#### Scenario: Library segment list
- **WHEN** the Library tab is displayed
- **THEN** the app SHALL show four segments and SHALL NOT show a "Created" or "Đã tạo" segment

### Requirement: All segment merges local interaction sources
The All segment SHALL show the deduplicated union of recipe IDs from viewed, saved, and pantry session history, ordered by most recent interaction timestamp.

#### Scenario: Recipe appears once in All
- **WHEN** a recipe is both viewed and saved
- **THEN** the All segment SHALL list that recipe once, ordered by the latest interaction time

### Requirement: Viewed segment lists locally viewed recipes
The Viewed segment SHALL list recipe IDs from the local viewed store, most recent first.

#### Scenario: Empty viewed state
- **WHEN** the user has no viewed recipes
- **THEN** the Viewed segment SHALL show a localized empty state

### Requirement: Saved segment lists locally saved recipes
The Saved segment SHALL list recipe IDs from the local saved store, most recent first.

#### Scenario: Saved recipe appears after bookmark
- **WHEN** the user saved a recipe from detail
- **THEN** the Saved segment SHALL include that recipe without requiring an app restart

### Requirement: From pantry segment lists pantry session recipes
The From pantry segment SHALL list recipes associated with prior successful pantry searches stored locally, grouped or ordered by session recency.

#### Scenario: Pantry session recipes visible
- **WHEN** the user previously completed a pantry search that returned recipes
- **THEN** those recipes SHALL be reachable from the From pantry segment

### Requirement: Library rows navigate to shared detail
Tapping a library row SHALL navigate to `/recipes/:id` using the shared recipe detail screen.

#### Scenario: Open from library
- **WHEN** the user taps a recipe in the Saved segment
- **THEN** the app SHALL open recipe detail for that id
