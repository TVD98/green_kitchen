## MODIFIED Requirements

### Requirement: Brand color tokens
The design-system package SHALL expose a brand color token equal to `#4AAF57` that is identical in light and dark themes, together with a soft brand surface token (`#F0FAF1` light, `#35383F` dark), an error token `#F75555`, and a mode-independent `absoluteWhite` token equal to `#FFFFFF`. The package MUST NOT expose the former Duolingo green (`#58CC02`, `#46A302`), former Focuso coral brand (`#FF4749`), or yellow accent (`#FFC800`) tokens.

#### Scenario: App reads the brand color
- **WHEN** a consumer reads the brand color token from the package
- **THEN** the value SHALL be `#4AAF57`

#### Scenario: Brand color does not change with theme mode
- **WHEN** a consumer reads the brand color token under the light theme and under the dark theme
- **THEN** both SHALL resolve to the same value `#4AAF57`

#### Scenario: Soft brand surface differs per mode
- **WHEN** a consumer reads the soft brand surface token
- **THEN** the light value SHALL be `#F0FAF1` and the dark value SHALL be `#35383F`

### Requirement: Greyscale and accent tokens
The package SHALL expose a greyscale ladder for muted text and icons whose values invert by mode (light: `#BDBDBD`, `#9E9E9E`, `#757575`, `#616161`; dark: `#9E9E9E`, `#BDBDBD`, `#E0E0E0`, `#EEEEEE`), plus material accent tokens Orange `#FF981F`, Blue `#1A96F0`, Green `#4AAF57` (same value as brand), and Purple `#9D28AC`.
