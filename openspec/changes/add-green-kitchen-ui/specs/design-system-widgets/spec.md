## ADDED Requirements

### Requirement: Base widget set
The package SHALL provide `AppButton`, `AppText`, `AppTextField`, `AppCard`, `AppDialog`, and `AppLoading` widgets.

#### Scenario: Widgets are importable from barrel
- **WHEN** an app imports `package:green_kitchen_ui/green_kitchen_ui.dart`
- **THEN** all six base widgets SHALL be available without importing `src/` paths

### Requirement: AppButton variants and states
`AppButton` SHALL support primary, secondary, outline, and text variants, plus loading and disabled states.

#### Scenario: Primary button in loading state
- **WHEN** `AppButton` is primary and loading is true
- **THEN** the button SHALL show a loading indicator and MUST NOT invoke its press callback

### Requirement: AppText uses typography tokens
`AppText` SHALL render text using the package typography scale (display through caption).

#### Scenario: Caption style
- **WHEN** `AppText` is created with the caption variant
- **THEN** the text SHALL use the caption typography token (size 12)

### Requirement: Form and feedback widgets
`AppTextField` SHALL support label and error text; `AppCard` SHALL use surface/radius/spacing tokens; `AppDialog` SHALL provide a standard title/body/actions dialog helper; `AppLoading` SHALL show a brand-colored progress indicator.

#### Scenario: Text field shows error
- **WHEN** `AppTextField` is given an error message
- **THEN** the error text SHALL be visible to the user

#### Scenario: Loading uses brand color
- **WHEN** `AppLoading` is displayed
- **THEN** the indicator color SHALL use the primary brand token
