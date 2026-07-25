## Why

`green_kitchen` needs a shared design system so screens stay visually consistent (Duolingo-like green brand, typography, and reusable UI). Building this as a local Flutter package keeps tokens and widgets reusable without publishing to pub.dev.

## What Changes

- Add local package `packages/green_kitchen_ui/` with design tokens (colors, typography, spacing, radius)
- Add light + dark `ThemeData` (`AppTheme.light` / `AppTheme.dark`) using Nunito via `google_fonts`
- Add base widgets: `AppButton`, `AppText`, `AppTextField`, `AppCard`, `AppDialog`, `AppLoading`
- Wire the app to the package via path dependency and apply themes in `lib/main.dart`
- Add minimal package smoke tests for theme/widgets

## Capabilities

### New Capabilities
- `design-system-tokens`: Color, typography, spacing, and radius tokens for light/dark brand styling
- `design-system-theme`: `AppTheme` light/dark ThemeData built from tokens + Nunito
- `design-system-widgets`: Base UI widgets exported through the package barrel file
- `app-ui-integration`: Path dependency + app theme wiring to consume the package

### Modified Capabilities
- (none — greenfield; no existing OpenSpec specs yet)

## Impact

- New folder: `packages/green_kitchen_ui/`
- App `pubspec.yaml`: path dependency on `green_kitchen_ui`
- App `lib/main.dart`: use `AppTheme.light` / `AppTheme.dark`
- New dependency inside package: `google_fonts`
- Does not affect feature/domain layers yet (Clean Architecture features remain out of scope for this change)
