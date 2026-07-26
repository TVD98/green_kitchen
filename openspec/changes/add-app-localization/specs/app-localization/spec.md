## ADDED Requirements

### Requirement: Supported locales
The application SHALL support Vietnamese (`vi`) and English (`en`) as application UI locales.

#### Scenario: Vietnamese locale available
- **WHEN** the resolved application locale is `vi`
- **THEN** user-facing strings from the app localization layer SHALL be served in Vietnamese

#### Scenario: English locale available
- **WHEN** the resolved application locale is `en`
- **THEN** user-facing strings from the app localization layer SHALL be served in English

### Requirement: System locale with Vietnamese fallback
When the user has not selected a language override (system mode), the application SHALL follow the device locale if it is `vi` or `en`, and SHALL fall back to `vi` when the device locale is neither.

#### Scenario: Device is Vietnamese
- **WHEN** language preference is system and the device locale is `vi`
- **THEN** the application locale SHALL be `vi`

#### Scenario: Device is English
- **WHEN** language preference is system and the device locale is `en`
- **THEN** the application locale SHALL be `en`

#### Scenario: Device locale unsupported
- **WHEN** language preference is system and the device locale is neither `vi` nor `en`
- **THEN** the application locale SHALL be `vi`

### Requirement: Persisted language override
The application SHALL allow the user to override language to System, Vietnamese, or English, and SHALL persist that preference across app restarts.

#### Scenario: Override to English persists
- **WHEN** the user selects English and later restarts the app
- **THEN** the application locale SHALL remain English

#### Scenario: Return to system mode
- **WHEN** the user selects System after an override
- **THEN** the application SHALL resolve locale from the device with the Vietnamese fallback rule

### Requirement: MaterialApp localization wiring
The app root `MaterialApp` SHALL register localization delegates for app-generated localizations and Flutter Material/Widgets/Cupertino localizations, and SHALL declare `vi` and `en` as supported locales.

#### Scenario: Delegates registered at startup
- **WHEN** the app starts
- **THEN** `MaterialApp` SHALL expose app and Flutter localization delegates so widgets can resolve localized strings and Material strings for the active locale

### Requirement: App owns copy; design system remains locale-agnostic
Product user-facing copy SHALL live in the app localization layer. `green_kitchen_ui` widgets SHALL continue to accept caller-provided `String` values and SHALL NOT own product translation catalogs.

#### Scenario: Localized string passed into design-system widget
- **WHEN** a screen displays a design-system control that needs a label
- **THEN** the screen SHALL resolve the label via the app localization layer and pass it into the `green_kitchen_ui` widget as a `String`

### Requirement: No hardcoded copy on new feature screens
New feature screens SHALL NOT hardcode user-facing UI copy; they MUST obtain such strings from the app localization layer.

#### Scenario: New screen uses localization lookup
- **WHEN** a new feature screen renders user-facing text
- **THEN** that text SHALL come from the app localization layer rather than a string literal in the widget tree
