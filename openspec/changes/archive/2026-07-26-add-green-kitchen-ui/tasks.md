## 1. Package scaffold

- [x] 1.1 Create Flutter package at `packages/green_kitchen_ui` (`flutter create --template=package`)
- [x] 1.2 Add `google_fonts` dependency and set `publish_to: none` in package `pubspec.yaml`
- [x] 1.3 Add package `analysis_options.yaml` aligned with app lints

## 2. Design tokens

- [x] 2.1 Implement `AppColors`
- [x] 2.2 Implement `AppTypography` scale via `google_fonts`
- [x] 2.3 Implement `AppSpacing` and `AppRadius` token classes

## 3. Theme

- [x] 3.1 Implement `AppTheme.light` and `AppTheme.dark` from tokens
- [x] 3.2 Configure component themes (button, input, card, dialog) to use radius/colors

## 4. Widgets

- [x] 4.1 Implement `AppButton`
- [x] 4.2 Implement `AppText` bound to typography tokens
- [x] 4.3 Implement `AppTextField`, `AppCard`, `AppDialog`, `AppLoading`
- [x] 4.4 Export public API via `lib/green_kitchen_ui.dart` only

## 5. App integration

- [x] 5.1 Add path dependency `green_kitchen_ui: path: packages/green_kitchen_ui` to app `pubspec.yaml`
- [x] 5.2 Wire `MaterialApp` in `lib/main.dart` to `AppTheme.light` / `AppTheme.dark`
- [x] 5.3 Optionally update demo screen to use `AppButton` / `AppText` as smoke check

## 6. Verification

- [x] 6.1 Run `flutter pub get` in package and app
- [x] 6.2 Run `flutter analyze` in package and app (no errors)
- [x] 6.3 Add minimal package smoke test(s) for theme/widgets and run `flutter test` in package

## 7. Focuso retune — tokens

- [x] 7.1 Replace `AppColors` brand with `#FF4749` (same in both modes) and remove `#58CC02`, `#46A302`, `#FFC800`
- [x] 7.2 Add light/dark surface ladders (light `#F5F5F5`/`#FFFFFF`/`#EEEEEE`; dark `#181A20`/`#1F222A`/`#35383F`), stroke and on-surface tokens
- [x] 7.3 Add soft brand surface (`#FFF0F0` light, `#35383F` dark), error `#F75555`, greyscale ladder, material accents, and `absoluteWhite` `#FFFFFF`
- [x] 7.4 Retune `AppSpacing` to the Focuso gap scale (0,2,4,6,8,10,12,14,16,20,24,28)
- [x] 7.5 Retune `AppRadius`: add `6` (tabs), keep `8`, add `10` (inputs/checkbox), add `16` (popup/sheet), card radius, keep `pill` 1000

## 8. Focuso retune — typography and theme

- [x] 8.1 Switch `AppTypography` to Urbanist with heading (1.4 / 0) and body (1.6 / 0.2) metrics, including H4 bold 24 and the 10–20 size steps
- [x] 8.2 Rebuild `AppTheme.light` / `AppTheme.dark` from the new tokens
- [x] 8.3 Configure mode-aware card elevation (soft shadow light, surface contrast dark) and pill button shapes
- [x] 8.4 Configure input theme: filled, borderless, radius 10, no focus chrome

## 9. Focuso retune — widgets

- [x] 9.1 Rework `AppButton` variants to `social` / `primary` / `soft` / `outline` / `text` with a `leading` slot, all pill-shaped (`outline` = brand stroke/label, surface fill; e.g. Add Custom)
- [x] 9.2 Rework `AppTextField`: filled radius 10, prefix/suffix slots, prefix tone follows empty/filled state
- [x] 9.3 Add self-managed password visibility toggle to `AppTextField`
- [x] 9.4 Retune `AppCard` for mode-aware soft elevation
- [x] 9.5 Rework `AppDialog` into a slot-based shell (radius 16, blur+dim barrier, illustration/title/body/actions, tap-outside dismiss)
- [x] 9.6 Add `AppBottomSheet` (slide-up shell, top corners radius 16, blur+dim barrier, `child` only, tap-outside + drag dismiss)
- [x] 9.7 Add `AppLinkText` with tappable brand spans (no underline, heavier weight, configurable alignment)
- [x] 9.8 Add `AppCheckbox` (radius 10, brand border/fill, `child` label, box-only toggle)
- [x] 9.9 Add `AppTabs` (segmented pill, radius 6, `fill` / `hug` / `scrollable` layouts, controlled via `onChanged`)
- [x] 9.10 Add `AppNavigationHeader` (height 48, back leading, centered H4 title, optional actions, no elevation)
- [x] 9.11 Add `AppPageIndicator` (controlled dots; active brand pill; inactive greyscale circles; optional `onChanged`)
- [x] 9.12 Update `AppLoading` to use `AppColors.absoluteWhite`; keep existing API/structure
- [x] 9.13 Add `AppDropdown` (filled trigger radius 10, overlay menu below field with vertical scroll when overflowing max height, optional leading, controlled `onChanged`)
- [x] 9.14 Add `AppChips` (multi toggle, pill, selected brand/`absoluteWhite`, `scroll` + `wrap` layouts, group API only)
- [x] 9.15 Add `AppSelectionList` (standalone; single + multi; brand check; dividers; radius 10; vertical scroll when overflowing)
- [x] 9.16 Add `AppSwitch` (brand ON / greyscale OFF, white thumb, controlled)
- [x] 9.17 Add `AppSlider` (brand active track + thumb, greyscale inactive track, controlled; icons stay with caller)
- [x] 9.18 Add `AppRadio` (greyscale ring / brand ring + dot, `child` label) and `AppRadioGroup` (single-select, no dividers)
- [x] 9.19 Export new/updated widgets from the barrel and update the demo screen

## 10. Focuso retune — verification

- [x] 10.1 Update package smoke tests for the new brand, variants, and widgets
- [x] 10.2 Run `flutter analyze` and `flutter test` in package; `flutter analyze` in app
- [x] 10.3 Smoke-run the app in light and dark to compare against the Focuso reference nodes
- [x] 10.4 Update `openspec/project.md` context from the Duolingo brand to Focuso
