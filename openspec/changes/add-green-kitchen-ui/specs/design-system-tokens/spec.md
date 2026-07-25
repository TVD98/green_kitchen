## ADDED Requirements

### Requirement: Brand color tokens
The design-system package SHALL expose color tokens including primary `#58CC02`, primaryDark `#46A302`, secondary `#FFC800`, error `#FF4B4B`, warning `#FFC800`, and success `#58CC02`, plus light/dark background, surface, and onSurface values.

#### Scenario: App reads primary brand color
- **WHEN** a consumer reads the primary color token from the package
- **THEN** the value SHALL be `#58CC02`

#### Scenario: Light and dark surfaces differ
- **WHEN** a consumer reads light vs dark background/surface/onSurface tokens
- **THEN** light and dark token sets SHALL provide distinct values suitable for each theme

### Requirement: Typography scale with Nunito
The package SHALL define a typography scale (display 32 bold, headline 24 bold, title 20 semiBold, body 16 regular, label 14 semiBold, caption 12 regular) using the Nunito family via `google_fonts`.

#### Scenario: Body text style is available
- **WHEN** a consumer requests the body typography token
- **THEN** the style SHALL use Nunito at size 16 with regular weight

### Requirement: Spacing and radius scales
The package SHALL expose spacing tokens (`xs` 4, `sm` 8, `md` 16, `lg` 24, `xl` 32, `xxl` 48) and radius tokens (`sm` 8, `md` 12, `lg` 16, `pill` 999).

#### Scenario: Standard card padding uses spacing token
- **WHEN** a widget needs medium spacing
- **THEN** it SHALL be able to use the `md` spacing token equal to 16
