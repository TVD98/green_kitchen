## ADDED Requirements

### Requirement: Language selection in Settings
The application SHALL provide a Settings language control that lets the user choose System, Vietnamese, or English.

#### Scenario: User opens language settings
- **WHEN** the user navigates to the language setting
- **THEN** the app SHALL present the options System, Vietnamese, and English using `green_kitchen_ui` components and the active app theme/tokens

#### Scenario: Option labels are localized
- **WHEN** the language settings UI is displayed
- **THEN** option labels and the settings title SHALL come from the app localization layer (not hardcoded product copy)

### Requirement: Immediate locale application
Changing the language preference in Settings SHALL update the application locale immediately without requiring an app restart.

#### Scenario: Switch from Vietnamese to English
- **WHEN** the user selects English while the app is running
- **THEN** subsequent user-facing app strings SHALL render in English without restarting the process

#### Scenario: Switch to System
- **WHEN** the user selects System
- **THEN** the app SHALL immediately re-resolve locale from the device using the supported-locale and Vietnamese-fallback rules

### Requirement: Language change resets Discover draft content
When the user selects a **different** language preference (System, Vietnamese, or English), the app SHALL reset language-bound Discover draft state so leftover text and ingredient names from the previous locale do not remain:

1. Clear the main Discover `prompt` (description field)
2. Clear fridge-sheet selected ingredients, search query, and suggestions
3. Clear local `recentIngredientSets` (persisted recent searches) via the interactions repository

Selecting the same preference again SHALL NOT reset Discover state.

Personalization toggles (`usePreferences`, `excludeAllergies`) MAY remain unchanged.

#### Scenario: Switching language clears Discover prompt and fridge draft
- **WHEN** the user changes language preference from Vietnamese to English (or any other distinct option)
- **THEN** the Discover prompt SHALL become empty
- **AND** fridge sheet selected ingredients and search fields SHALL be cleared
- **AND** Find recipes SHALL be disabled until the user enters a new prompt

#### Scenario: Switching language clears recent ingredient searches
- **WHEN** the user changes language preference
- **THEN** locally stored `recentIngredientSets` SHALL be emptied
- **AND** reopening the fridge sheet with an empty search field SHALL show no recent sets

#### Scenario: Re-selecting the same language does nothing
- **WHEN** the user taps the already-selected language option
- **THEN** the app SHALL NOT clear Discover prompt, sheet selection, or recent ingredient sets
