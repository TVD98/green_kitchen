## Why

Discover already sends `options.use_preferences` and `options.exclude_allergies`, and the API already stores user preferences and allergies under `/api/v1/users/me/*`, but Profile only shows session identity, language, and logout. Users have no place to edit the data those toggles depend on, so personalization is effectively empty.

## What Changes

- **Expand** Profile hub (Tab 4): keep name/email, language, and logout; add navigation rows (with optional summary) into preferences and allergies editors.
- **Add** dietary preferences editor: load/save via `GET`/`PUT /api/v1/users/me/preferences` (dietary style, spice level, cuisines, disliked ingredients, health goals).
- **Add** allergies editor: load/replace via `GET`/`PUT /api/v1/users/me/allergies`, with ingredient search (`GET /api/v1/ingredients?q=`) to pick allergen ingredients.
- Scaffold `profile` feature layers beyond the current presentation-only page (Clean Architecture + BLoC) for preferences/allergies clients and screens.
- Add ARB keys (vi + en); screens use `green_kitchen_ui` + `AppLocalizations` only (no hardcoded product copy).

Non-goals for this change: edit display name / avatar (no `PATCH /users/me` yet); change password / unlink social / delete account; theme mode picker; clear local viewed/saved/fridge history UI; nutrition goals beyond `health_goals` already on the preferences API; push notifications; server sync of saved/viewed recipes; changing Discover toggle UX (toggles stay on Discover).

## Capabilities

### New Capabilities

- `profile-preferences`: Flutter client and Profile sub-screen to read/update eating preferences against `/users/me/preferences`.
- `profile-allergies`: Flutter client and Profile sub-screen to read/replace allergy ingredient IDs against `/users/me/allergies`, with ingredient search picker.

### Modified Capabilities

- `profile`: Tab 4 hub gains entries (and light summaries) for preferences and allergies while retaining session info, language, and logout.

## Impact

- **Features:** expand `lib/features/profile/` with domain/data/presentation (BLoC) per flutter-clean-architecture; may reuse existing ingredients remote client from discover/pantry modules.
- **Router:** push routes under Profile (e.g. `/home/profile/preferences`, `/home/profile/allergies`) or equivalent nested routes.
- **Backend consumed:** `GET`/`PUT /api/v1/users/me/preferences`, `GET`/`PUT /api/v1/users/me/allergies`, `GET /api/v1/ingredients?q=` (JWT via existing Dio interceptor).
- **UI / l10n:** `green_kitchen_ui` widgets/tokens/theme; new ARB keys for all Profile expansion copy.
- **Discover:** unchanged UX; preferences/allergies data written here is what Discover options already request from the API.
- **Testing:** bloc/unit tests for preferences and allergies flows; widget tests for hub rows and editor save/error states.
