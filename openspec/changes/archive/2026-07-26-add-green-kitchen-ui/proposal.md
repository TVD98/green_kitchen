## Why

`green_kitchen` needs a shared design system so screens stay visually consistent. The visual direction is now the **Focuso — Pomodoro App UI Kit** language (coral brand `#FF4749`, Urbanist, greyscale ladder, soft elevated surfaces, pill CTAs), replacing the earlier Duolingo-green direction. Building this as a local Flutter package keeps tokens and widgets reusable without publishing to pub.dev, and unblocks the upcoming login/signup flow.

## What Changes

- Add local package `packages/green_kitchen_ui/` with Focuso design tokens (colors, typography, spacing, radius)
- Add light + dark `ThemeData` (`AppTheme.light` / `AppTheme.dark`) using Urbanist via `google_fonts`
- **BREAKING (visual)**: drop the Duolingo palette (`#58CC02`, `#46A302`) and the yellow accent (`#FFC800`); brand becomes `#FF4749` in both light and dark
- **BREAKING (API)**: `AppButton` variants change from `primary/secondary/outline/text` to `social/primary/soft/outline/text`, always pill-shaped
- Add base widgets: `AppButton`, `AppText`, `AppTextField`, `AppCard`, `AppLoading`, plus new `AppLinkText`, `AppCheckbox`, `AppBottomSheet`, `AppTabs`, `AppNavigationHeader`, `AppPageIndicator`, `AppDropdown`, `AppChips`, `AppSelectionList`, `AppSwitch`, `AppSlider`, `AppRadio`, and `AppRadioGroup`
- Rework `AppDialog` into a Focuso-style popup shell (radius 16, blur+dim barrier, illustration/title/body/actions slots, tap-outside dismiss)
- Add `AppBottomSheet` as a presentation shell only (slide up from bottom, top corners radius 16, blur+dim barrier, drag/tap-outside dismiss, `child` content)
- Add `AppTabs`, a controlled segmented selector with `fill`, `hug`, and `scrollable` layouts
- Add `AppNavigationHeader` (height 48, back leading, centered H4 title, optional trailing actions)
- Add `AppPageIndicator` (controlled dots: active brand pill, inactive greyscale circles) — onboarding slide/page shell is out of scope
- Add `AppDropdown` (filled trigger radius 10, overlay menu below field with vertical scroll when overflowing, optional leading icons) — color swatches are out of scope
- Add `AppChips` for multi-select toggle chips with `scroll` (single row, horizontal scroll) and `wrap` layouts; pill shape as in Focuso; group API only (no standalone chip widget)
- Add `AppSelectionList` as a standalone vertical selection list (single or multi) with brand checkmarks, hairline dividers, radius 10, and vertical scroll when overflowing — not shared with `AppDropdown` in this change
- Add `AppSwitch` (brand ON / greyscale OFF) and `AppSlider` (brand active track + thumb) from Focuso settings patterns; settings list-tile row deferred
- Add `AppRadio` (single control with `child` label) and `AppRadioGroup` (single-select vertical list, no dividers)
- Add an `absoluteWhite` (`#FFFFFF`) color token for mode-independent white (e.g. `AppLoading`)
- Wire the app to the package via path dependency and apply themes in `lib/main.dart`
- Add minimal package smoke tests for theme/widgets

Non-goals: auth screens themselves, feature/domain layers, BLoC, networking, publishing to pub.dev, and the Focuso neobrutalism theme variant (modern theme only).

## Capabilities

### New Capabilities
- `design-system-tokens`: Focuso color, typography, spacing, and radius tokens for light/dark brand styling
- `design-system-theme`: `AppTheme` light/dark ThemeData built from tokens + Urbanist
- `design-system-widgets`: Base UI widgets exported through the package barrel file
- `app-ui-integration`: Path dependency + app theme wiring to consume the package

### Modified Capabilities
- (none — greenfield; no existing OpenSpec specs yet)

## Impact

- New folder: `packages/green_kitchen_ui/`
- App `pubspec.yaml`: path dependency on `green_kitchen_ui`
- App `lib/main.dart`: use `AppTheme.light` / `AppTheme.dark`
- New dependency inside package: `google_fonts` (Urbanist)
- `openspec/project.md` context still describes the Duolingo brand and needs updating to Focuso
- Does not affect feature/domain layers yet (Clean Architecture features remain out of scope for this change); the login/signup flow will consume these widgets in a follow-up change
