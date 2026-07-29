## Context

`green_kitchen_ui` inherited Focuso coral as brand when the design system was first built. Product direction now treats kitchen green (`#4AAF57`, formerly the material Green accent token) as the primary brand color across the app.

## Decisions

### 1. Brand = kitchen green `#4AAF57`

Mode-independent, same as the former `accentGreen` material token. Replaces Focuso coral `#FF4749`.

### 2. Soft brand light surface → `#F0FAF1`

Replaces coral-tinted `#FFF0F0` with a subtle green wash suitable for secondary buttons and hero backgrounds (e.g. Welcome logo container). Dark soft brand stays `#35383F`.

### 3. `accentGreen` aliases `brand`

Avoids two green hex values in the token table. Category/status uses of green continue to reference `AppColors.accentGreen`.

### 4. No local Discover override

Discover (and future features) SHOULD use global `AppColors.brand` / `AppTheme` rather than a separate local green theme.

## Risks

- **Auth/Focuso Figma parity**: layout stays Focuso; only the primary hue shifts. Acceptable product trade-off.
- **Contrast**: `#4AAF57` on white passes for large text/buttons; white on green buttons remains the default CTA pattern.
