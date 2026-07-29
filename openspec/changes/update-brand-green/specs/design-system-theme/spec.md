## MODIFIED Requirements

### Requirement: Light and dark ThemeData
The package SHALL provide `AppTheme.light` and `AppTheme.dark` as `ThemeData` instances built from design tokens and Urbanist text styles.

#### Scenario: Both themes expose the brand primary
- **WHEN** the app applies `AppTheme.light` or `AppTheme.dark`
- **THEN** the theme's color scheme primary SHALL be `#4AAF57` in both cases
