## ADDED Requirements

### Requirement: Discover main screen uses prompt-first layout
Tab 1 (Discover) SHALL present a prompt-first layout inside the home shell (no AppBar title, no back button). The screen SHALL use `green_kitchen_ui` widgets and localized copy via `AppLocalizations`.

The layout SHALL include, in order:
1. Hero headline and subtitle
2. Prompt card (multiline input)
3. Two personalization option rows (icon, title, subtitle, `AppSwitch`)
4. Quick Start section label and 2×2 pill grid
5. Sticky bottom area with primary CTA and AI disclaimer caption

#### Scenario: Discover tab shows hero and prompt card
- **WHEN** the user opens Tab Khám phá
- **THEN** the user SHALL see localized headline `discoverTitle`, subtitle `discoverSubtitle`, and an empty or previously entered prompt field with hint `discoverPromptHint`

#### Scenario: No back button on Discover tab
- **WHEN** Discover is shown as part of the authenticated shell
- **THEN** the screen SHALL NOT show a back navigation control

### Requirement: Discover uses design-system colors only
Discover presentation widgets SHALL use `green_kitchen_ui` color tokens and themed widgets only (`AppColors`, `AppTheme`, `AppButton`, `AppSwitch`, etc.). Discover MUST NOT define local theme helpers, custom accent colors, or hardcoded color values outside the design-system package.

#### Scenario: Primary CTA uses AppButton
- **WHEN** the sticky bottom CTA is rendered
- **THEN** it SHALL use `AppButton` (primary variant) rather than a locally styled `FilledButton`

### Requirement: Prompt card supports multiline input with utilities
The prompt card SHALL be an `AppCard` containing a multiline text field with maximum length **500** characters.

The card footer SHALL show:
- Voice affordance (mic icon + `discoverVoiceSuggestion`) on the left
- Character counter `{current}/500` and a clear (×) control on the right

#### Scenario: Character counter updates
- **WHEN** the user types in the prompt field
- **THEN** the counter SHALL reflect the current character count and SHALL NOT exceed 500

#### Scenario: Clear prompt
- **WHEN** the user taps the clear control
- **THEN** the prompt field SHALL become empty

#### Scenario: Prompt at max length rejects excess input
- **WHEN** the prompt already has 500 characters
- **THEN** additional characters SHALL NOT be accepted

### Requirement: Personalization toggles control discovery search options
Discover SHALL expose two option rows:

| Toggle | Default | Maps to API |
|--------|---------|-------------|
| Dùng sở thích ăn uống | ON | `options.use_preferences: true` |
| Loại trừ dị ứng | OFF | `options.exclude_allergies: true` |

Each row SHALL display a leading icon, title, subtitle, and `AppSwitch`.

#### Scenario: User disables preferences toggle
- **WHEN** the user turns off "Dùng sở thích ăn uống"
- **THEN** the next discovery search request SHALL send `use_preferences: false`

#### Scenario: User enables allergy exclusion
- **WHEN** the user turns on "Loại trừ dị ứng"
- **THEN** the next discovery search request SHALL send `exclude_allergies: true`

### Requirement: Quick Start pills compose client-side prompt and filters
Discover SHALL show four Quick Start pills in a 2×2 grid with localized labels and icons:

- Nguyên liệu trong tủ lạnh (opens fridge sheet — see `fridge-ingredients-sheet` spec)
- Cơn thèm
- Nhanh & lành mạnh
- Chỉ ăn chay

Pills for cravings, fast & healthy, and vegetarian SHALL update `prompt` and optional `filters` on the Discover bloc without calling the API.

#### Scenario: Cravings pill fills prompt
- **WHEN** the user taps the Cravings Quick Start pill
- **THEN** the prompt field SHALL be populated with the localized cravings template

#### Scenario: Fast healthy pill sets filters
- **WHEN** the user taps the Fast & healthy pill
- **THEN** the prompt SHALL be set and `filters` SHALL include `maxTime: 30` and tag `healthy`

### Requirement: Find recipes CTA requires non-empty prompt
The sticky primary CTA (`discoverFindRecipes`) SHALL be disabled when `prompt.trim()` is empty.

#### Scenario: CTA disabled with empty prompt
- **WHEN** the prompt is empty or whitespace only
- **THEN** the Find recipes button SHALL be disabled

#### Scenario: CTA enabled after fridge sheet apply
- **WHEN** the user applies ingredients from the fridge sheet and the prompt is filled
- **THEN** the Find recipes button SHALL be enabled

### Requirement: Discover shows AI disclaimer
Below the primary CTA, Discover SHALL show localized caption text `discoverAiDisclaimer`.

#### Scenario: Disclaimer visible
- **WHEN** the Discover tab is displayed
- **THEN** the AI disclaimer caption SHALL be visible above the bottom navigation bar

### Requirement: Voice input appends to prompt
Discover SHALL integrate speech-to-text. Tapping the voice affordance SHALL start listening and append recognized text to the prompt, respecting the 500-character limit.

#### Scenario: Voice appends transcript
- **WHEN** speech recognition returns text and permission is granted
- **THEN** the recognized text SHALL be appended to the current prompt without exceeding 500 characters

#### Scenario: Permission denied
- **WHEN** microphone or speech permission is denied
- **THEN** the app SHALL show a localized snackbar (`discoverVoicePermissionDenied`) and SHALL NOT crash

### Requirement: Main Discover does not show recent prompts list
The main Discover screen SHALL NOT display a recent prompts section. Recent ingredient shortcuts SHALL only appear inside the fridge ingredients bottom sheet.

#### Scenario: No recent list on main screen
- **WHEN** the Discover tab is displayed
- **THEN** there SHALL be no recent-search list on the main scroll content

### Requirement: Locale change resets Discover draft via DiscoverContentReset
When the app language preference changes to a different value, Discover SHALL handle a `DiscoverContentReset` event that clears:

- `prompt` (and the prompt text field UI)
- Quick Start `filters`
- Fridge sheet fields: `sheetQuery`, `sheetSuggestions`, `sheetSelectedIngredients`
- In-memory `recentIngredientSets` (persistence clear is owned by the locale preference layer — see `settings-language`)

`usePreferences` and `excludeAllergies` SHALL NOT be reset by this event.

#### Scenario: Locale change empties prompt and disables CTA
- **WHEN** the language preference changes while Discover is mounted (including via shell IndexedStack)
- **THEN** the prompt field SHALL become empty
- **AND** the Find recipes CTA SHALL be disabled

#### Scenario: Locale change clears Quick Start filters
- **WHEN** the user had applied Fast & healthy or Vegetarian filters and then changes language
- **THEN** Discover `filters` SHALL return to the default empty `PantryFilters`

## REMOVED Requirements

### Requirement: Selected ingredients appear as removable chips on main Discover
**Reason:** Ingredient selection moves to fridge bottom sheet; selected items are encoded in the prompt string on the main screen.
**Migration:** Remove chip list and ingredient autocomplete from `discover_page.dart`; retain chip/search logic in sheet only.

### Requirement: Pantry search requires at least one ingredient on main Discover
**Reason:** Primary CTA now requires a non-empty prompt and calls discovery search.
**Migration:** Replace `canSearch` based on `selectedIngredients` with `prompt.trim().isNotEmpty`.

### Requirement: Discover screen is the pantry entry point with inline ingredient entry
**Reason:** Superseded by prompt-first entry; pantry flow remains available via API module but not as Tab 1 primary UX.
**Migration:** Document in `fridge-ingredients-sheet` and `discovery-search` specs.
