## Why

The app name is **green_kitchen** and the Discover flow already validated kitchen green (`#4AAF57`) as the product accent. The global brand token still pointed at Focuso coral (`#FF4749`), so CTAs, navigation, toggles, and auth screens did not match the intended product identity.

## What Changes

- **BREAKING (visual)**: set `AppColors.brand` / `AppColors.primary` to `#4AAF57` (kitchen green) in `green_kitchen_ui`.
- Update `lightSoftBrand` from coral tint `#FFF0F0` to green tint `#F0FAF1`; keep dark soft brand `#35383F`.
- Alias `AppColors.accentGreen` to `AppColors.brand` so material green accent and brand stay in sync.
- Revise active design-system specs (`design-system-tokens`, `design-system-theme`) and `openspec/config.yaml` brand context.

Non-goals: changing typography, spacing, radius, surface ladder, error color, or non-green material accents (orange/blue/purple).

## Capabilities

### Modified Capabilities
- `design-system-tokens`: brand `#4AAF57`, soft brand light `#F0FAF1`, green accent equals brand.
- `design-system-theme`: `AppTheme` primary `#4AAF57` in light and dark.

## Impact

- **Package**: `packages/green_kitchen_ui/lib/src/tokens/app_colors.dart` and color tests.
- **App**: all screens/widgets already consuming `AppColors.brand` / `AppTheme` pick up green automatically; no per-screen color edits required.
- **Specs**: `openspec/specs/design-system-tokens`, `openspec/specs/design-system-theme`, `openspec/config.yaml`.
