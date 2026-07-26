# design-system-tokens Specification

## Purpose
TBD - created by archiving change add-green-kitchen-ui. Update Purpose after archive.
## Requirements
### Requirement: Brand color tokens
The design-system package SHALL expose a brand color token equal to `#FF4749` that is identical in light and dark themes, together with a soft brand surface token (`#FFF0F0` light, `#35383F` dark), an error token `#F75555`, and a mode-independent `absoluteWhite` token equal to `#FFFFFF`. The package MUST NOT expose the former Duolingo green (`#58CC02`, `#46A302`) or yellow accent (`#FFC800`) tokens.

#### Scenario: App reads the brand color
- **WHEN** a consumer reads the brand color token from the package
- **THEN** the value SHALL be `#FF4749`

#### Scenario: Brand color does not change with theme mode
- **WHEN** a consumer reads the brand color token under the light theme and under the dark theme
- **THEN** both SHALL resolve to the same value `#FF4749`

#### Scenario: Soft brand surface differs per mode
- **WHEN** a consumer reads the soft brand surface token
- **THEN** the light value SHALL be `#FFF0F0` and the dark value SHALL be `#35383F`

#### Scenario: Absolute white is mode-independent
- **WHEN** a consumer reads the `absoluteWhite` token under light or dark theme
- **THEN** the value SHALL be `#FFFFFF` in both cases

### Requirement: Light and dark surface tokens
The package SHALL expose background, surface, elevated-surface, stroke, and on-surface text tokens for both modes: light background `#F5F5F5`, surface `#FFFFFF`, elevated `#EEEEEE`, stroke `#E0E0E0`, on-surface `#212121`; dark background `#181A20`, surface `#1F222A`, elevated `#35383F`, stroke `#35383F`, on-surface `#FFFFFF`.

#### Scenario: Dark surfaces form a contrast ladder
- **WHEN** a consumer reads the dark background, surface, and elevated tokens
- **THEN** they SHALL be `#181A20`, `#1F222A`, and `#35383F` respectively, giving three distinguishable depth levels

#### Scenario: Light and dark surfaces differ
- **WHEN** a consumer reads light vs dark background/surface/on-surface tokens
- **THEN** light and dark token sets SHALL provide distinct values suitable for each theme

### Requirement: Greyscale and accent tokens
The package SHALL expose a greyscale ladder for muted text and icons whose values invert by mode (light: `#BDBDBD`, `#9E9E9E`, `#757575`, `#616161`; dark: `#9E9E9E`, `#BDBDBD`, `#E0E0E0`, `#EEEEEE`), plus material accent tokens Orange `#FF981F`, Blue `#1A96F0`, Green `#4AAF57`, and Purple `#9D28AC`.

#### Scenario: Muted text token is readable in both modes
- **WHEN** a widget renders placeholder or secondary text using the muted greyscale token
- **THEN** the resolved color SHALL be darker than the surface in light mode and lighter than the surface in dark mode

### Requirement: Typography scale with Urbanist
The package SHALL define a typography scale using the Urbanist family via `google_fonts`, with heading styles at line-height 1.4 and letter-spacing 0, and body styles at line-height 1.6 and letter-spacing 0.2. The scale SHALL cover the Focuso sizes 24 (H4 bold), 20 (bold), 18 (bold), 16, 14, 12, and 10, and MAY extend to larger display sizes for headings above the reference range.

#### Scenario: Body text style is available
- **WHEN** a consumer requests the body typography token
- **THEN** the style SHALL use Urbanist at size 16 with line-height 1.6 and letter-spacing 0.2

#### Scenario: Heading uses heading metrics
- **WHEN** a consumer requests a heading typography token
- **THEN** the style SHALL use Urbanist bold with line-height 1.4 and letter-spacing 0

#### Scenario: H4 navigation title style
- **WHEN** a consumer requests the H4 / navigation title typography token
- **THEN** the style SHALL use Urbanist bold at size 24 with line-height 1.4

### Requirement: Spacing and radius scales
The package SHALL expose a spacing scale matching the Focuso gap steps `0, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28`, and radius tokens including `6` (tab segments), `8`, `10` (inputs and checkbox), `16` (popup / dialog shell and bottom sheet top corners), a card radius, and `pill` (`1000`).

#### Scenario: Fine spacing step is available
- **WHEN** a widget needs the 10-unit gap used by Focuso components
- **THEN** the spacing scale SHALL provide a `10` token rather than forcing a 8 or 12 approximation

#### Scenario: Input radius token
- **WHEN** a widget needs the input corner radius
- **THEN** the radius scale SHALL provide a `10` token

#### Scenario: Popup radius token
- **WHEN** a widget needs the dialog / popup shell corner radius
- **THEN** the radius scale SHALL provide a `16` token

#### Scenario: Tab segment radius token
- **WHEN** a widget needs the tab segment corner radius
- **THEN** the radius scale SHALL provide a `6` token

