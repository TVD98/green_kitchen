## ADDED Requirements

### Requirement: Authenticated home uses a four-tab shell
After successful authentication, the app SHALL present a home shell with four bottom tabs: Discover (Khám phá), Library (Công thức), Suggestions (Gợi ý), and Profile (Cá nhân). The shell SHALL use `go_router` `StatefulShellRoute` so each tab retains its navigation state when switching tabs.

#### Scenario: User lands on discover after login
- **WHEN** the user becomes authenticated and navigates to `/home`
- **THEN** the app SHALL redirect to `/home/discover` and show the Discover tab selected

#### Scenario: Tab switching preserves branch state
- **WHEN** the user switches from Discover to Library and back to Discover
- **THEN** the Discover branch SHALL retain its prior scroll/selection state without reloading the entire app

### Requirement: Bottom navigation uses design system theming
The shell bottom bar SHALL use Material 3 `NavigationBar` with selected styling aligned to `green_kitchen_ui` brand tokens (`AppColors.brand`). Tab labels and semantics SHALL come from `AppLocalizations` (vi/en).

#### Scenario: Localized tab labels
- **WHEN** the app locale is Vietnamese
- **THEN** the four tab labels SHALL display the localized Vietnamese strings for Discover, Library, Suggestions, and Profile

### Requirement: Full-screen flows sit above the shell
Recipe detail and pantry results SHALL be routable as full-screen destinations outside the tab body while the shell remains the authenticated root.

#### Scenario: Open recipe detail from any tab
- **WHEN** the user opens `/recipes/:id` from Discover, Library, or Suggestions
- **THEN** the recipe detail screen SHALL cover the tab content and provide back navigation to the previous route
