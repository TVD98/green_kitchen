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
