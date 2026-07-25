## ADDED Requirements

### Requirement: Light and dark ThemeData
The package SHALL provide `AppTheme.light` and `AppTheme.dark` as `ThemeData` instances built from design tokens and Nunito text styles.

#### Scenario: Light theme exposes brand primary
- **WHEN** the app applies `AppTheme.light`
- **THEN** the theme's color scheme primary SHALL match the primary brand token `#58CC02`

#### Scenario: Dark theme uses dark surfaces
- **WHEN** the app applies `AppTheme.dark`
- **THEN** the theme's scaffold/background colors SHALL use the dark background/surface tokens

### Requirement: Component themes align with tokens
Both themes SHALL configure Material component themes (buttons, inputs, cards, dialogs) so default Material widgets inherit package radius/colors where applicable.

#### Scenario: Text fields use package radius
- **WHEN** a themed `TextField` / input decoration is rendered under `AppTheme`
- **THEN** border radius SHALL follow package radius tokens (not arbitrary defaults)
