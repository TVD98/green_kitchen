# design-system-theme Specification

## Purpose
TBD - created by archiving change add-green-kitchen-ui. Update Purpose after archive.
## Requirements
### Requirement: Light and dark ThemeData
The package SHALL provide `AppTheme.light` and `AppTheme.dark` as `ThemeData` instances built from design tokens and Urbanist text styles.

#### Scenario: Both themes expose the brand primary
- **WHEN** the app applies `AppTheme.light` or `AppTheme.dark`
- **THEN** the theme's color scheme primary SHALL be `#FF4749` in both cases

#### Scenario: Light theme uses light surfaces
- **WHEN** the app applies `AppTheme.light`
- **THEN** the scaffold background SHALL use `#F5F5F5` and card surfaces SHALL use `#FFFFFF`

#### Scenario: Dark theme uses the dark surface ladder
- **WHEN** the app applies `AppTheme.dark`
- **THEN** the scaffold background SHALL use `#181A20` and card surfaces SHALL use `#1F222A`

### Requirement: Text theme uses Urbanist
Both themes SHALL build their `TextTheme` from the package typography tokens so unstyled Material text renders in Urbanist with the token sizes and metrics.

#### Scenario: Default Text widget inherits Urbanist
- **WHEN** a plain `Text` widget is rendered under `AppTheme`
- **THEN** its resolved font family SHALL be Urbanist rather than the Flutter default

### Requirement: Component themes align with tokens
Both themes SHALL configure Material component themes (buttons, inputs, cards, dialogs, checkbox) so default Material widgets inherit package radius, colors, and elevation treatment.

#### Scenario: Buttons default to pill radius
- **WHEN** a themed Material button is rendered under `AppTheme`
- **THEN** its border radius SHALL use the pill radius token

#### Scenario: Inputs use the input radius and no focus chrome
- **WHEN** a themed `TextField` is rendered under `AppTheme` and gains focus
- **THEN** its border radius SHALL be the `10` radius token, its fill SHALL come from surface tokens, and no focus border or ring SHALL appear

#### Scenario: Elevation treatment differs by mode
- **WHEN** a themed `Card` is rendered under `AppTheme.light` and under `AppTheme.dark`
- **THEN** the light theme SHALL apply a soft shadow and the dark theme SHALL rely on surface contrast with effectively no shadow

