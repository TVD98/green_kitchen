# Design: `green_kitchen_ui` local design-system package

**Date:** 2026-07-26  
**Status:** Approved for implementation planning  
**App:** `green_kitchen` (Flutter)

## Goal

Create a local Flutter package that owns the app design system (tokens + base UI widgets), then wire it into the `green_kitchen` app via a path dependency.

## Decisions (locked)

| Topic | Choice |
|-------|--------|
| Scope | Full design system: tokens + ThemeData + base widgets (button, text, text field, card, dialog, loading) |
| Location | Monorepo: `packages/green_kitchen_ui/` |
| Themes | Light + Dark |
| Brand color | Duolingo-like green (`#58CC02`) |
| Typography | Google Fonts — **Nunito** |

## Package layout

```text
packages/green_kitchen_ui/
├── pubspec.yaml
├── analysis_options.yaml
├── lib/
│   ├── green_kitchen_ui.dart          # public barrel exports
│   └── src/
│       ├── tokens/
│       │   ├── app_colors.dart
│       │   ├── app_typography.dart
│       │   ├── app_spacing.dart
│       │   └── app_radius.dart
│       ├── theme/
│       │   └── app_theme.dart         # AppTheme.light / AppTheme.dark
│       └── widgets/
│           ├── app_button.dart
│           ├── app_text.dart
│           ├── app_text_field.dart
│           ├── app_card.dart
│           ├── app_dialog.dart
│           └── app_loading.dart
└── test/                              # smoke tests for theme + widgets (minimal)
```

## Design tokens

### Colors (`AppColors`)

Duolingo-inspired palette. Semantic colors are shared; surfaces/text adapt per theme.

| Token | Value | Usage |
|-------|-------|--------|
| `primary` | `#58CC02` | Main brand / primary buttons |
| `primaryDark` | `#46A302` | Pressed / darker brand |
| `secondary` | `#FFC800` | Accent / secondary highlight |
| `error` | `#FF4B4B` | Errors |
| `warning` | `#FFC800` | Warnings |
| `success` | `#58CC02` | Success (= primary) |
| Light `background` | `#FFFFFF` | Scaffold background |
| Light `surface` | `#F7F7F7` | Cards / sheets |
| Light `onSurface` | `#3C3C3C` | Body text |
| Dark `background` | `#131F24` | Scaffold background |
| Dark `surface` | `#202F36` | Cards / sheets |
| Dark `onSurface` | `#FFFFFF` | Body text |

Exact Flutter `Color` constants live in `app_colors.dart`. Theme builders map these into `ColorScheme`.

### Typography (`AppTypography` + Nunito)

- Dependency: `google_fonts`
- Family: Nunito (all weights used by the scale)
- Scale (font sizes):

| Style | Size | Weight |
|-------|------|--------|
| display | 32 | Bold |
| headline | 24 | Bold |
| title | 20 | SemiBold |
| body | 16 | Regular |
| label | 14 | SemiBold |
| caption | 12 | Regular |

`AppTheme` applies Nunito via `GoogleFonts.nunitoTextTheme(...)` so Material text styles stay consistent.

### Spacing (`AppSpacing`)

| Token | Value |
|-------|-------|
| `xs` | 4 |
| `sm` | 8 |
| `md` | 16 |
| `lg` | 24 |
| `xl` | 32 |
| `xxl` | 48 |

### Radius (`AppRadius`)

| Token | Value |
|-------|-------|
| `sm` | 8 |
| `md` | 12 |
| `lg` | 16 |
| `pill` | 999 |

## Theme API

```dart
class AppTheme {
  static ThemeData get light { ... }
  static ThemeData get dark { ... }
}
```

Both themes set:
- `colorScheme` from `AppColors`
- `textTheme` from Nunito + `AppTypography`
- component themes for buttons, inputs, cards, dialogs so Material defaults match the design system

App usage:

```dart
MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system, // or .light / .dark
  ...
);
```

## Widgets (v1)

| Widget | Responsibility |
|--------|----------------|
| `AppButton` | Variants: primary, secondary, outline, text. Supports loading + disabled |
| `AppText` | Text bound to typography tokens (`display`…`caption`) |
| `AppTextField` | Labeled input with error text; themed borders/radius |
| `AppCard` | Surface card with padding/radius from tokens |
| `AppDialog` | Standard title/body/actions dialog helper |
| `AppLoading` | Centered CircularProgressIndicator using brand color |

Public API is exported only through `lib/green_kitchen_ui.dart`. App code must not import `src/` paths.

## App integration

In root `pubspec.yaml`:

```yaml
dependencies:
  green_kitchen_ui:
    path: packages/green_kitchen_ui
```

Then:
1. Replace default `ThemeData` in `lib/main.dart` with `AppTheme.light` / `AppTheme.dark`
2. Optionally swap demo UI to use `AppButton` / `AppText` as a smoke check

Out of scope for this package: feature screens, BLoC, networking, assets beyond what Google Fonts provides.

## Dependencies

**Package `green_kitchen_ui`:**
- `flutter` (sdk)
- `google_fonts`

**App `green_kitchen`:**
- path dependency on `green_kitchen_ui` (no need to re-declare `google_fonts` unless used directly)

## Testing / verification

1. `flutter pub get` at package and app roots
2. `flutter analyze` for package + app
3. Minimal widget/theme smoke test in package
4. Run app and confirm light/dark brand colors + Nunito + widgets render

## Non-goals (explicit)

- Publishing to pub.dev
- Separate GitHub repo for the UI package
- Full Duolingo clone UI (illustrations, gamification, custom painters)
- Custom bundled `.ttf` files (use Google Fonts CDN/package only)
