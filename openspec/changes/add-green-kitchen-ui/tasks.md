## 1. Package scaffold

- [x] 1.1 Create Flutter package at `packages/green_kitchen_ui` (`flutter create --template=package`)
- [x] 1.2 Add `google_fonts` dependency and set `publish_to: none` in package `pubspec.yaml`
- [x] 1.3 Add package `analysis_options.yaml` aligned with app lints

## 2. Design tokens

- [x] 2.1 Implement `AppColors` (Duolingo green palette + light/dark surfaces)
- [x] 2.2 Implement `AppTypography` scale (display→caption) with Nunito via `google_fonts`
- [x] 2.3 Implement `AppSpacing` and `AppRadius` token classes

## 3. Theme

- [x] 3.1 Implement `AppTheme.light` and `AppTheme.dark` from tokens + Nunito text theme
- [x] 3.2 Configure component themes (button, input, card, dialog) to use radius/colors

## 4. Widgets

- [x] 4.1 Implement `AppButton` (primary/secondary/outline/text + loading/disabled)
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
