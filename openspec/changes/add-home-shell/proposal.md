## Why

After authentication, users land on a placeholder Home screen with no recipe-discovery experience. The backend already exposes ingredient autocomplete, pantry search (Gemini), and recipe read APIs, but the Flutter app has no shell or feature modules to consume them. This change delivers the post-login product core: a 4-tab home with discover, personal recipe library, curated suggestions, and profile.

## What Changes

- Replace the auth-owned placeholder `HomePage` with a **4-tab home shell** (Khám phá, Công thức, Gợi ý, Cá nhân) using `go_router` `StatefulShellRoute` and Material 3 `NavigationBar` styled with `green_kitchen_ui` tokens.
- Add **`discover`** feature: ingredient autocomplete, selected-ingredient chips, pantry search entry, and local recent-search shortcuts (Tab 1).
- Add **`pantry-search`** flow: `POST /api/v1/pantry/search` with optional filters, results list, navigation to recipe detail.
- Add **`recipe-detail`** shared screen: `GET /api/v1/recipes/:id`, steps/ingredients/nutrition, bookmark toggle, record viewed on open.
- Add **`recipe-library`** (Tab 2): segmented filter via `AppTabs` — **Tất cả | Đã xem | Đã lưu | Từ tủ bếp**. The **Đã tạo** segment is **hidden entirely** until a future user-recipe API exists.
- Add **`recipe-interactions-local`**: persist viewed recipe IDs, saved recipe IDs, and pantry search sessions on device (no server sync in this change).
- Add **`suggestions`** (Tab 3): editorial-style sections (featured, popular, quick, easy). **Popular / trending uses simulated engagement data** layered on real `GET /api/v1/recipes` results until analytics APIs exist.
- Add **`profile`** (Tab 4): move logout and language settings from the old home; show session user info.
- Add discovery HTTP client modules (`ingredients`, `recipes`, `pantry`) following `flutter-clean-architecture` + BLoC.
- Add ARB keys (vi + en) for all new user-facing copy.

Non-goals for this change: user-created recipe CRUD and a **Đã tạo** library segment; server-side saved/viewed sync; real trending/analytics APIs; image recognition; social features; fake datasource for discovery (real API only, same as auth remote switch pattern).

## Capabilities

### New Capabilities

- `home-shell`: Authenticated 4-tab bottom navigation shell and router integration replacing the single placeholder home route.
- `discover`: Tab 1 discover screen — ingredient search/autocomplete, chip selection, pantry search CTA, recent local searches.
- `pantry-search`: Pantry search submission, optional filters, results presentation, and error/loading states.
- `recipe-detail`: Shared full-screen recipe detail with bookmark and viewed tracking hooks.
- `recipe-library`: Tab 2 personal library with AppTabs segments (no **Đã tạo** segment).
- `recipe-interactions-local`: Local persistence for viewed, saved, and pantry session history.
- `suggestions`: Tab 3 curated feed with mock popular metrics on API-backed recipe lists.
- `profile`: Tab 4 account surface (user info, language entry, logout).

### Modified Capabilities

- `app-ui-integration`: Authenticated home SHALL be the 4-tab shell (not the auth placeholder `HomePage`).

## Impact

- **Routing**: `lib/core/router/app_router.dart` — `StatefulShellRoute` for `/home/*`, shared `/recipes/:id`, `/pantry/results`; redirect `/home` → default tab.
- **Removed/replaced**: auth `HomePage` as the post-login destination; logout/language move to profile tab.
- **New modules**: `lib/features/{home_shell,discover,pantry,recipes,recipe_library,suggestions,profile,recipe_interactions}/` per Clean Architecture + BLoC.
- **Dependencies**: likely `shared_preferences` (or existing key-value store if reusable) for local interactions; reuses existing `dio` + auth interceptor.
- **Backend consumed**: `GET /ingredients`, `POST /pantry/search`, `GET /recipes`, `GET /recipes/:id` (JWT required).
- **UI / l10n**: all new screens via `green_kitchen_ui` + `AppLocalizations`; no hardcoded product copy.
- **Testing**: unit tests for local store + mappers; bloc tests for discover/pantry/library/suggestions; widget tests for shell tab switching.
