## ADDED Requirements

### Requirement: Base widget set
The package SHALL provide `AppButton`, `AppText`, `AppTextField`, `AppCard`, `AppDialog`, `AppLoading`, `AppLinkText`, `AppCheckbox`, `AppBottomSheet`, `AppTabs`, `AppNavigationHeader`, `AppPageIndicator`, `AppDropdown`, `AppChips`, `AppSelectionList`, `AppSwitch`, `AppSlider`, `AppRadio`, and `AppRadioGroup` widgets.

#### Scenario: Widgets are importable from barrel
- **WHEN** an app imports `package:green_kitchen_ui/green_kitchen_ui.dart`
- **THEN** all nineteen base widgets SHALL be available without importing `src/` paths

### Requirement: AppButton variants and states
`AppButton` SHALL support `social`, `primary`, `soft`, `outline`, and `text` variants, plus loading and disabled states, and SHALL accept an optional `leading` widget. All variants SHALL render with the pill radius token. The `secondary` (yellow) variant SHALL NOT exist.

#### Scenario: Primary button styling
- **WHEN** `AppButton` uses the `primary` variant
- **THEN** it SHALL fill with the brand color, render its label in white, and use the pill radius

#### Scenario: Soft button styling
- **WHEN** `AppButton` uses the `soft` variant
- **THEN** it SHALL fill with the soft brand surface token for the active theme mode and render its label in the brand color

#### Scenario: Social button with leading icon
- **WHEN** `AppButton` uses the `social` variant with a `leading` widget
- **THEN** it SHALL render a surface fill with a hairline greyscale stroke, place the leading widget before the label, and use the pill radius

#### Scenario: Outline button styling
- **WHEN** `AppButton` uses the `outline` variant
- **THEN** it SHALL use a surface or transparent fill, a brand-colored hairline stroke, a brand-colored label, and the pill radius

#### Scenario: Outline button with leading icon
- **WHEN** `AppButton` uses the `outline` variant with a `leading` widget
- **THEN** the leading widget SHALL appear before the label and SHALL use the brand color (or be supplied already in brand color by the caller)

#### Scenario: Primary button in loading state
- **WHEN** `AppButton` is primary and loading is true
- **THEN** the button SHALL show a loading indicator and MUST NOT invoke its press callback

### Requirement: AppText uses typography tokens
`AppText` SHALL render text using the package typography scale.

#### Scenario: Caption style
- **WHEN** `AppText` is created with the caption variant
- **THEN** the text SHALL use the caption typography token in Urbanist

### Requirement: AppTextField appearance
`AppTextField` SHALL render an optional label above a filled, borderless input using the `10` radius token, with optional prefix and suffix widgets, hint text, and error text. The field SHALL NOT change its border or apply a focus ring when focused.

#### Scenario: Field is filled and borderless
- **WHEN** `AppTextField` is rendered
- **THEN** it SHALL show a filled surface with radius 10 and no visible border stroke

#### Scenario: Focus does not alter the field chrome
- **WHEN** `AppTextField` receives focus
- **THEN** its border, fill, and radius SHALL remain unchanged

#### Scenario: Text field shows error
- **WHEN** `AppTextField` is given an error message
- **THEN** the error text SHALL be visible to the user in the error color

### Requirement: AppTextField prefix icon reflects content state
When `AppTextField` has a prefix widget, the prefix SHALL render in a muted greyscale tone while the field is empty and in the on-surface tone once the field has content.

#### Scenario: Prefix icon while empty
- **WHEN** `AppTextField` has a prefix icon and no entered text
- **THEN** the prefix SHALL use the muted greyscale token, matching the hint text tone

#### Scenario: Prefix icon once filled
- **WHEN** the user types into the field
- **THEN** the prefix SHALL switch to the on-surface tone

### Requirement: AppTextField password mode
When `AppTextField` is configured to obscure text, it SHALL manage its own visibility state and expose a trailing toggle without requiring the caller to wire that state.

#### Scenario: Password starts hidden
- **WHEN** `AppTextField` is created with obscure text enabled
- **THEN** the entered characters SHALL be masked and a trailing "reveal" toggle SHALL be shown

#### Scenario: Toggling reveals the password
- **WHEN** the user taps the trailing visibility toggle
- **THEN** the entered characters SHALL become readable and the toggle icon SHALL reflect the new state

### Requirement: AppLinkText renders tappable inline links
`AppLinkText` SHALL render a single paragraph composed of text spans where any span may carry a tap callback. Spans with a callback SHALL use the brand color and a heavier weight than surrounding body text, and SHALL NOT be underlined. The widget SHALL support multiple linked spans in one paragraph and configurable text alignment.

#### Scenario: Link span is visually distinct
- **WHEN** `AppLinkText` renders a span that has a tap callback
- **THEN** that span SHALL use the brand color with a heavier weight and no underline, while spans without a callback use the on-surface color

#### Scenario: Tapping a link invokes its callback
- **WHEN** the user taps a span that has a tap callback
- **THEN** that span's callback SHALL be invoked

### Requirement: AppCheckbox with arbitrary label widget
`AppCheckbox` SHALL render a square box using the `10` radius token beside an optional `child` widget used as the label. Unchecked SHALL render a brand-colored border over a transparent fill; checked SHALL render a brand fill with a white checkmark. Only the box SHALL toggle the value; taps inside the `child` SHALL NOT change it.

#### Scenario: Unchecked appearance
- **WHEN** `AppCheckbox` has a false value
- **THEN** the box SHALL show a brand-colored border with a transparent fill and radius 10

#### Scenario: Checked appearance
- **WHEN** `AppCheckbox` has a true value
- **THEN** the box SHALL fill with the brand color and display a white checkmark

#### Scenario: Only the box toggles
- **WHEN** the user taps the label `child` (for example a link inside `AppLinkText`)
- **THEN** the checkbox value SHALL remain unchanged and the child's own gesture SHALL run

#### Scenario: Tapping the box toggles
- **WHEN** the user taps the box
- **THEN** the change callback SHALL be invoked with the inverted value

### Requirement: AppPageIndicator
`AppPageIndicator` SHALL render a horizontal row of page markers for a given `count` and selected `index`. The active marker SHALL be a brand-colored elongated pill; inactive markers SHALL be greyscale circles. The widget SHALL be controlled by the caller and MUST NOT own a page view or slide layout. When an optional change callback is provided, tapping an inactive marker SHALL invoke that callback with the tapped index; when omitted, taps SHALL NOT change selection.

#### Scenario: Active and inactive markers
- **WHEN** `AppPageIndicator` is shown with count 3 and index 1
- **THEN** the middle marker SHALL be a brand pill and the other two SHALL be greyscale circles

#### Scenario: Display-only when no callback
- **WHEN** no change callback is provided and the user taps a marker
- **THEN** the indicator SHALL NOT change its selected index by itself

#### Scenario: Tappable when callback provided
- **WHEN** a change callback is provided and the user taps an inactive marker
- **THEN** the callback SHALL be invoked with that marker's index

### Requirement: AppNavigationHeader
`AppNavigationHeader` SHALL render a flat toolbar of height `48` with an optional leading back control, a centered title, and an optional trailing list of action widgets. The title SHALL use the H4 typography token (Urbanist bold, size 24, line-height 1.4) in the on-surface / Text Light color and SHALL remain visually centered even when trailing actions are absent. The header SHALL NOT add elevation or card chrome. The status bar is out of scope. Leading defaults to a back affordance that invokes an optional back callback or pops the navigator; callers MAY hide or replace the leading control. Trailing actions are supplied entirely by the caller.

#### Scenario: Default layout
- **WHEN** `AppNavigationHeader` is shown with a title, back enabled, and one trailing action
- **THEN** the back control SHALL appear on the left, the title SHALL be centered in H4 style, and the action SHALL appear on the right within a 48-tall row

#### Scenario: Title stays centered without actions
- **WHEN** trailing actions are omitted
- **THEN** the title SHALL remain visually centered (leading side balanced) rather than shifting toward the empty trailing side

#### Scenario: Back can be hidden
- **WHEN** the caller disables the back control
- **THEN** no default back chevron SHALL be shown

#### Scenario: Flat chrome
- **WHEN** the header is rendered
- **THEN** it SHALL NOT apply a material elevation or card-style border/shadow

### Requirement: AppTabs segmented selector
`AppTabs` SHALL render a horizontal set of segments on a track, where the selected segment fills with the brand color and renders a white label, and unselected segments render a muted greyscale label on the track. Segments SHALL use the `6` radius token. `AppTabs` SHALL support three layouts: `fill` (segments share the available width equally), `hug` (each segment sizes to its label), and `scrollable` (segments scroll horizontally when they overflow). `AppTabs` SHALL be controlled — it reports selection through a change callback and MUST NOT own page or content switching.

#### Scenario: Selected segment styling
- **WHEN** `AppTabs` renders with a selected index
- **THEN** that segment SHALL fill with the brand color, render its label in white, and use radius 6

#### Scenario: Unselected segment styling
- **WHEN** `AppTabs` renders segments that are not selected
- **THEN** those segments SHALL render a muted greyscale label without a brand fill

#### Scenario: Fill layout
- **WHEN** `AppTabs` uses the `fill` layout
- **THEN** the segments SHALL divide the available width equally

#### Scenario: Hug layout
- **WHEN** `AppTabs` uses the `hug` layout
- **THEN** each segment SHALL size to its own label rather than stretching

#### Scenario: Scrollable layout overflows
- **WHEN** `AppTabs` uses the `scrollable` layout and the segments exceed the available width
- **THEN** the segments SHALL scroll horizontally instead of shrinking or wrapping

#### Scenario: Selection is reported, not owned
- **WHEN** the user taps an unselected segment
- **THEN** `AppTabs` SHALL invoke its change callback with that index and MUST NOT switch any content itself

### Requirement: AppBottomSheet presentation shell
`AppBottomSheet` SHALL present an arbitrary `child` widget in a surface shell that slides up from the bottom of the screen. The shell SHALL use radius `16` on the top two corners only, with bottom edges flush to the screen. The barrier SHALL dim and blur the content behind the sheet. By default, tapping outside the shell SHALL dismiss it and drag-to-dismiss SHALL be enabled. The package MUST NOT prescribe the child's internal layout (title, body, or actions).

#### Scenario: Sheet slides up with blurred barrier
- **WHEN** `AppBottomSheet` is shown with a `child`
- **THEN** the child SHALL appear in a bottom-anchored surface card with top-corner radius 16 over a dimmed and blurred barrier

#### Scenario: Tap outside dismisses
- **WHEN** the sheet is shown with default dismiss settings and the user taps outside the shell
- **THEN** the sheet SHALL close

#### Scenario: Drag dismisses
- **WHEN** the sheet is shown with default drag settings and the user drags the sheet downward past the dismiss threshold
- **THEN** the sheet SHALL close

#### Scenario: Child owns content
- **WHEN** the caller passes any `child` widget
- **THEN** that widget SHALL be rendered inside the shell without the package injecting title, body, or action rows

### Requirement: AppDialog popup shell
`AppDialog` SHALL present a centered popup shell with radius `16`, surface fill, and generous padding. The shell SHALL support optional slots for `illustration`, title, body, and `actions` (or a free-form `child`). The barrier SHALL dim and blur the content behind the dialog. Tapping outside the shell SHALL dismiss the dialog by default (`barrierDismissible: true`). Illustration assets SHALL be supplied by the caller; the package MUST NOT hardcode Focuso artwork.

#### Scenario: Shell appearance
- **WHEN** `AppDialog` is shown with a title and body
- **THEN** the content SHALL appear in a centered surface card with corner radius 16 over a dimmed and blurred barrier

#### Scenario: Illustration slot
- **WHEN** the caller passes an `illustration` widget
- **THEN** that widget SHALL render above the title inside the shell

#### Scenario: Optional actions
- **WHEN** the caller omits actions
- **THEN** the shell SHALL still render illustration/title/body without an action row

#### Scenario: Tap outside dismisses
- **WHEN** the dialog is shown with default barrier settings and the user taps outside the shell
- **THEN** the dialog SHALL close

### Requirement: AppDropdown select
`AppDropdown` SHALL provide a controlled select control with a filled, borderless trigger of radius `10` and a trailing chevron. When empty it SHALL show muted hint text; when a value is selected it SHALL show an optional leading widget and the item label. Opening the control SHALL present an overlay menu anchored below the trigger (not a bottom sheet), with surface-filled rows that may include a leading widget and label, separated by hairline dividers. When the item list exceeds the menu's maximum height, the menu body SHALL scroll vertically while the trigger remains fixed. Selecting a row SHALL invoke the change callback with that value and close the menu. Color swatches are out of scope.

#### Scenario: Trigger chrome
- **WHEN** `AppDropdown` is rendered
- **THEN** the trigger SHALL use a filled surface, radius 10, no border stroke, and a trailing chevron

#### Scenario: Empty vs selected
- **WHEN** no value is selected
- **THEN** the trigger SHALL show the hint in a muted greyscale tone
- **WHEN** a value is selected with a leading widget
- **THEN** the trigger SHALL show that leading widget and the item label in the on-surface tone

#### Scenario: Overlay menu below the field
- **WHEN** the user opens the dropdown
- **THEN** a menu overlay SHALL appear anchored below the trigger with selectable rows and hairline dividers

#### Scenario: Menu scrolls when items overflow
- **WHEN** the dropdown menu contains more items than fit within its maximum height
- **THEN** the menu body SHALL scroll vertically and the trigger SHALL remain fixed

#### Scenario: Selection reports value
- **WHEN** the user taps a menu row
- **THEN** the change callback SHALL receive that row's value and the menu SHALL close

### Requirement: AppChips multi-select group
`AppChips` SHALL render a controlled group of pill-shaped chips for multi-selection. Tapping a chip SHALL toggle that option in or out of the selected set and invoke a change callback with the updated selection. Selected chips SHALL use brand fill and `absoluteWhite` labels; unselected chips SHALL use a surface fill, greyscale stroke, and on-surface labels. The package SHALL support two layouts: `scroll` (a single horizontal row that scrolls when options overflow) and `wrap` (chips wrap onto additional lines). The package MUST export only the group widget — not a standalone chip widget.

#### Scenario: Multi toggle
- **WHEN** the user taps an unselected chip
- **THEN** that option SHALL be added to the selection reported by the change callback
- **WHEN** the user taps a selected chip
- **THEN** that option SHALL be removed from the selection reported by the change callback

#### Scenario: Selected and unselected styling
- **WHEN** a chip is selected
- **THEN** it SHALL fill with the brand color, use an `absoluteWhite` label, and have a pill shape
- **WHEN** a chip is unselected
- **THEN** it SHALL use a surface fill, greyscale stroke, on-surface label, and a pill shape

#### Scenario: Scroll layout
- **WHEN** `AppChips` uses the `scroll` layout and options exceed the available width
- **THEN** the chips SHALL remain on one row and scroll horizontally

#### Scenario: Wrap layout
- **WHEN** `AppChips` uses the `wrap` layout and options exceed the available width
- **THEN** remaining chips SHALL wrap onto the next line instead of scrolling

### Requirement: AppSelectionList
`AppSelectionList` SHALL render a standalone vertical list of selectable rows inside a surface container with radius `10` and hairline dividers between rows. Each row SHALL show a left-aligned label and, when selected, a brand-colored checkmark on the right. The list SHALL support single-select and multi-select modes. When content exceeds the maximum height, the list SHALL scroll vertically. `AppSelectionList` MUST NOT be required by `AppDropdown` in this change — it is an independent widget.

#### Scenario: Selected row shows brand check
- **WHEN** a row is selected
- **THEN** a brand-colored checkmark SHALL appear on the right side of that row

#### Scenario: Single select replaces selection
- **WHEN** the list is in single-select mode and the user taps a different row
- **THEN** the change callback SHALL report that row as the only selection

#### Scenario: Multi select toggles independently
- **WHEN** the list is in multi-select mode and the user taps an unselected row
- **THEN** that row SHALL be added to the selection
- **WHEN** the user taps a selected row in multi-select mode
- **THEN** that row SHALL be removed from the selection

#### Scenario: List scrolls when overflowing
- **WHEN** the list contains more rows than fit within its maximum height
- **THEN** the list body SHALL scroll vertically

### Requirement: AppRadio
`AppRadio` SHALL render a single circular radio control beside an optional `child` label widget. When unselected it SHALL show a greyscale ring with an empty center; when selected it SHALL show a brand-colored ring with a filled brand dot. Selecting SHALL invoke the change callback with that control's value.

#### Scenario: Unselected appearance
- **WHEN** `AppRadio` is not selected
- **THEN** it SHALL render a greyscale ring with an empty center

#### Scenario: Selected appearance
- **WHEN** `AppRadio` is selected
- **THEN** it SHALL render a brand-colored ring with a filled brand dot

#### Scenario: Selecting reports value
- **WHEN** the user taps an unselected `AppRadio`
- **THEN** the change callback SHALL be invoked with that control's value

### Requirement: AppRadioGroup
`AppRadioGroup` SHALL render a controlled single-select vertical list of `AppRadio` rows with the control on the left and the label on the right. Exactly one option SHALL be selected at a time. The group MUST NOT draw dividers between rows. Selecting a different row SHALL invoke the change callback with the new value.

#### Scenario: Single selection
- **WHEN** the user selects a different option in `AppRadioGroup`
- **THEN** the change callback SHALL report that option as the only selected value

#### Scenario: No dividers
- **WHEN** `AppRadioGroup` renders its rows
- **THEN** no divider lines SHALL be drawn between rows

### Requirement: AppSwitch
`AppSwitch` SHALL be a controlled boolean toggle. When on, the track SHALL use the brand color and the thumb SHALL be white (`absoluteWhite`). When off, the track SHALL use a greyscale tone and the thumb SHALL be white. Toggling SHALL invoke the change callback with the new value.

#### Scenario: On state
- **WHEN** `AppSwitch` value is true
- **THEN** the track SHALL be brand-colored and the thumb SHALL be white

#### Scenario: Off state
- **WHEN** `AppSwitch` value is false
- **THEN** the track SHALL be greyscale and the thumb SHALL be white

#### Scenario: Toggle reports value
- **WHEN** the user toggles the switch
- **THEN** the change callback SHALL receive the inverted boolean value

### Requirement: AppSlider
`AppSlider` SHALL be a controlled continuous slider. The active (filled) portion of the track and the thumb SHALL use the brand color; the inactive track SHALL use a greyscale tone. Value changes SHALL invoke a change callback. Leading/trailing decorative icons (e.g. mute/loud speakers) are owned by the caller and are not part of `AppSlider`.

#### Scenario: Brand active track and thumb
- **WHEN** `AppSlider` is rendered with a mid-range value
- **THEN** the filled track and thumb SHALL use the brand color and the remaining track SHALL use greyscale

#### Scenario: Value changes are reported
- **WHEN** the user drags the thumb
- **THEN** the change callback SHALL receive the updated continuous value

### Requirement: Surface and feedback widgets
`AppCard` SHALL use surface, radius, and spacing tokens with mode-aware elevation (soft shadow in light, surface contrast in dark); `AppLoading` SHALL remain a centered spinning `CircularProgressIndicator` whose color is the `absoluteWhite` token, without changing its existing API or adding gradient/full-screen variants.

#### Scenario: Card elevation in light mode
- **WHEN** `AppCard` is rendered under the light theme
- **THEN** it SHALL render a white surface with a soft low-opacity shadow against the light background

#### Scenario: Card elevation in dark mode
- **WHEN** `AppCard` is rendered under the dark theme
- **THEN** it SHALL rely on the `#1F222A` surface against the `#181A20` background rather than a shadow

#### Scenario: Loading uses a white spinner
- **WHEN** `AppLoading` is displayed
- **THEN** the `CircularProgressIndicator` color SHALL be the `absoluteWhite` token
