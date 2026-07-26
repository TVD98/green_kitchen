## Context

`green_kitchen` is a new Flutter app with default Material demo UI. We need a local design-system package so future feature screens share one brand across light and dark themes. The visual reference is the **Focuso — Pomodoro App UI Kit** (Figma file `AQleSaRlpNona2LxlAP3IJ`), modern theme:

- Home / light: node `56437:20918`
- Home / dark: node `56545:50456`
- Buttons: node `4238:13902` (Figma MCP quota exhausted; captured from user screenshots instead)
- Auth building blocks (buttons, inputs, links, checkbox): captured from user screenshots

## Goals / Non-Goals

**Goals:**
- Ship `packages/green_kitchen_ui` with Focuso tokens, ThemeData, and base widgets
- Integrate into the app via path dependency
- Support light + dark themes out of the box
- Cover every building block the login/signup flow needs (social buttons, inputs, password toggle, inline links, terms checkbox)

**Non-Goals:**
- Publishing to pub.dev
- Separate GitHub repo for the UI package
- Login/signup screens, BLoC, networking (follow-up change)
- Focuso neobrutalism theme variant
- Bundled custom `.ttf` files (use `google_fonts` only)
- Icon assets for social providers (apps pass their own `leading` widget)

## Decisions

1. **Monorepo path package** over sibling/git dependency
   - Rationale: simplest sync for a single-app stage; one PR can update tokens + consumers.

2. **Tokens + ThemeData + widgets in one package** over tokens-only
   - Rationale: widgets encode the brand (radius, padding, variants) so screens stay consistent.

3. **Brand `#FF4749` is mode-independent**
   - Light and dark both use the same brand color; only surfaces, text, and soft-button fills change per mode.
   - Replaces the earlier Duolingo green `#58CC02`.

4. **Yellow accent `#FFC800` is removed entirely**
   - Secondary emphasis is expressed with a soft brand surface instead (light `#FFF0F0`, dark `#35383F`).
   - Status/category color needs are served by the Focuso material accents (Orange `#FF981F`, Blue `#1A96F0`, Green `#4AAF57`, Purple `#9D28AC`).

5. **Urbanist via `google_fonts`** over Nunito, system fonts, or bundled TTF
   - Heading line-height 1.4 / letter-spacing 0; body line-height 1.6 / letter-spacing 0.2.
   - Observed Focuso sizes: 10, 12, 14, 16, 18, 20, and H4 bold **24** (line-height 1.4) for navigation titles. Larger display sizes above that remain extrapolated if needed.

6. **Spacing follows the Focuso gap scale**: 0, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 28
   - Rationale: the kit's component padding uses the finer steps (2/6/10/14); a coarse 4/8/16 scale cannot express them.

7. **Elevation is mode-aware**
   - Light: soft, low-opacity shadow lifting white cards off the `#F5F5F5` background.
   - Dark: depth comes from surface contrast (`#181A20` → `#1F222A` → `#35383F`) with shadows effectively off.

8. **Radius by role**
   - Buttons: pill (`1000`)
   - Inputs and checkbox: `10`
   - Tab segments: `6`
   - Popup / dialog shell: `16`; bottom sheet: `16` top corners only

9. **`AppButton` variants: `social`, `primary`, `soft`, `outline`, `text`**
   - `social`: surface fill + hairline greyscale stroke + `leading` icon (Continue with Google/Apple/Facebook/X)
   - `primary`: brand fill, white/`absoluteWhite` label, soft shadow (Sign up)
   - `soft`: soft brand surface, brand label (Sign in)
   - `outline`: surface/transparent fill, brand hairline stroke, brand label and optional `leading` (e.g. “Add Custom” + plus) — Focuso add action
   - `text`: brand/greyscale text, no fill

10. **`AppTextField` has no focus chrome**
    - Filled, borderless, radius 10. Focus does not change border/ring — matches the kit and avoids inventing a state we have no reference for.
    - Prefix icon renders in a muted greyscale tone while empty and in the on-surface tone once the field has content.
    - When `obscureText` is true, the widget owns its own visibility toggle (default hidden, eye-off icon) rather than pushing that state to callers.

11. **`AppLinkText` uses a generic span list** over a fixed `prompt + link` helper
    - Rationale: one widget covers "I agree to … Terms & Conditions." and "Already have an account? Sign in" without locking copy or the number of links.
    - Links are brand-colored and slightly heavier weight, never underlined.

12. **`AppCheckbox` takes a `child` widget, not a label string or spans**
    - Rationale: keeps the checkbox decoupled from `AppLinkText`; the label can be any widget.
    - **Only the box toggles** (not the whole row) — avoids hit-test conflicts with tappable link spans inside the label.

13. **`AppDialog` is a slot-based popup shell, not a rigid AlertDialog**
    - Structure: optional `illustration` widget → centered title → centered body → optional `actions` widget (or a free-form `child` when needed).
    - Shell: surface fill, radius `16`, generous padding, centered on a dimmed **and blurred** barrier (matches Focuso short-break modal).
    - Illustration assets stay in the app; the package only provides the slot.
    - Default `barrierDismissible: true` — tap outside dismisses.
    - Convenience helpers for title/body strings may wrap the same shell.

14. **`AppBottomSheet` is presentation-only — a `child` shell that slides up from the bottom**
    - Scope is the mechanism: enter/exit from bottom, surface fill, radius `16` on the **top two corners only** (bottom edges flush with the screen), dimmed **and blurred** barrier, optional drag handle.
    - Defaults: tap outside dismisses; drag-to-dismiss enabled.
    - Content layout is entirely the caller's `child` (no built-in title/body/actions). Confirm UIs compose `AppText` + `AppButton` themselves.
    - Distinct from `AppDialog` (centered, all four corners radius 16) — same barrier language, different anchor and motion.

15. **`AppTabs` is a controlled segmented selector, not a page controller**
    - Segmented pill style is the only tab style: selected segment fills with brand and white label; unselected sits on the track with a muted greyscale label. No underline variant.
    - Segment radius is `6`.
    - Three layouts: `fill` (segments share the width equally), `hug` (segments size to their label), `scrollable` (horizontal scroll when segments overflow).
    - The widget emits `onChanged` only. Callers own the selected index and render whatever view corresponds to it — no built-in `PageView` or content switching.

16. **`AppNavigationHeader` is a flat toolbar row: back · centered title · optional actions**
    - Height is `48`. No elevation, no card chrome — sits on the scaffold / page background.
    - Leading defaults to a back chevron that calls `onBack` or pops the navigator; callers may hide it or replace it.
    - Title uses Urbanist H4 bold (size 24, line-height 1.4), centered, on-surface / Text Light color. When actions are absent, the leading side is balanced so the title stays visually centered.
    - Trailing `actions` is an optional list of widgets (icon buttons, menus) owned by the caller. Status bar is out of scope.

17. **`AppPageIndicator` only — no onboarding slide shell in this change**
    - Controlled widget: caller owns `count` and `index` (and any PageView).
    - Active page = brand-colored elongated pill; inactive pages = greyscale circles.
    - Optional `onChanged` when a dot is tappable; if omitted, the indicator is display-only.
    - Full slide-page layout (brand curved hero, title, body, carousel / PageView) stays out of this change.

18. **`AppLoading` keeps its current API and structure; indicator is white**
    - Remains a centered spinning `CircularProgressIndicator` (size/strokeWidth as today).
    - Indicator color uses the mode-independent `absoluteWhite` token (`#FFFFFF`), matching the Focuso loading mark — not the brand fill.
    - No gradient arc, no brand-background full-screen shell, and no API expansion in this change.

19. **`absoluteWhite` (`#FFFFFF`) is a first-class color token**
    - Rationale: white used on brand surfaces (loading spinner, primary-button labels, etc.) must not depend on light-surface / dark-onSurface aliases that change meaning by mode.

20. **`AppDropdown` is a controlled select with an overlay menu under the field**
    - Trigger matches text-field chrome: filled, borderless, radius `10`, trailing chevron.
    - Empty state shows muted hint; selected state shows optional leading widget + label.
    - Menu opens as an overlay anchored below the trigger (not a bottom sheet), with surface fill, hairline dividers, and rows of optional leading + label.
    - When items exceed a max menu height (default ~240–280), the menu body scrolls vertically; the trigger stays fixed.
    - Color swatches from the Focuso form remain out of scope for this change.

21. **`AppChips` is a controlled multi-select chip group**
    - Tapping a chip toggles it in/out of the selected set; multiple chips may be selected at once.
    - Selected: brand fill + `absoluteWhite` label; unselected: surface/white fill + greyscale stroke + on-surface label.
    - Shape is pill (fully rounded ends), matching the Focuso tags row.
    - Two layouts: `scroll` (single horizontal row that scrolls when overflowing) and `wrap` (chips flow to the next line).
    - Public API is the group only — no standalone `AppChip` widget exported.

22. **`AppSelectionList` is a standalone vertical selection list**
    - Surface container, radius `10`, hairline dividers between rows; label on the left; brand checkmark on the right for selected rows.
    - Supports **single** and **multi** modes (multi toggles checks independently).
    - Scrolls vertically when content exceeds max height.
    - Independent of `AppDropdown` for this change — dropdown keeps its own overlay menu; sharing can be considered later.

23. **`AppSwitch` and `AppSlider` cover Focuso settings controls; list-tile row waits**
    - `AppSwitch`: ON = brand track + white thumb; OFF = greyscale track + white thumb. Controlled via value + `onChanged`.
    - `AppSlider`: active track and thumb use brand; inactive track uses greyscale. Controlled continuous value; optional leading/trailing icons stay in the caller (mute/loud speakers in the Reminder volume row).
    - Settings navigation row (label · value · chevron) is deferred — compose later or add `AppListTile` in a follow-up.

24. **Radio ships as both a single control and a group**
    - `AppRadio`: one circle plus a `child` label, mirroring the `AppCheckbox` shape (control owns the box; the label is any widget).
    - `AppRadioGroup`: controlled single-select vertical list built from `AppRadio` rows, **without** dividers (matches the Focuso theme picker).
    - Unselected: greyscale ring with empty center. Selected: brand ring with a filled brand dot.
    - Distinct from `AppSelectionList`, which uses a right-side checkmark and supports multi-select.

25. **Public API only through barrel `green_kitchen_ui.dart`**
    - Rationale: hide `src/` so internals can refactor without breaking app imports.

26. **`ThemeMode.system` default in app**
    - Rationale: light + dark both ship; OS preference is a sensible default.

## Risks / Trade-offs

- [Display/headline type sizes are extrapolated] The reference nodes only expose 10–20px. Sizes above that are our own extension → Mitigation: keep them in one place (`AppTypography`) and retune once a larger Focuso heading node is available.
- [Figma MCP quota exhausted on the Starter plan] Button and auth components were transcribed from screenshots, so exact heights, icon sizes, and disabled treatments are assumptions → Mitigation: record them as explicit defaults (checkbox 24×24) and verify against the kit when quota resets.
- [Backdrop blur support varies by platform / Flutter version] Focuso uses a strong blur + dim scrim → Mitigation: implement blur where available (e.g. `ImageFilter.blur` / `BackdropFilter`) with a dim fallback that still reads as a modal overlay.
- [Google Fonts needs network on first load] → Mitigation: accept for v1; can later add offline font assets if needed.
- [Package API churn while brand evolves] → Mitigation: keep widgets thin wrappers over tokens; version via monorepo commits.
- [`AppButton` variant rename is a breaking change] The existing `secondary` variant disappears → Mitigation: the package has no external consumers yet; update the demo screen in the same change.

## Migration Plan

1. Retune tokens (colors → spacing → radius → typography)
2. Retune `AppTheme.light` / `AppTheme.dark` from the new tokens
3. Retune `AppButton` and `AppCard`; rework `AppTextField` and `AppDialog`; add `AppLinkText`, `AppCheckbox`, `AppBottomSheet`, `AppTabs`, `AppNavigationHeader`, `AppPageIndicator`, `AppDropdown`, `AppChips`, `AppSelectionList`, `AppSwitch`, `AppSlider`, `AppRadio`, and `AppRadioGroup`
4. Update barrel exports and the demo screen
5. `flutter pub get` + `flutter analyze` at package and app
6. Smoke-run app in light/dark
7. Rollback: remove path dependency and revert `main.dart` if needed (package folder can remain unused)

## Open Questions

- None blocking — brand, font, spacing, radius, widget list, and interaction rules are approved.
