## Why

Tab Khám phá hiện tại (`add-home-shell`) dùng flow chọn nguyên liệu trực tiếp trên màn chính (autocomplete + chips) và gọi `POST /pantry/search`. Product mock Yemake-style yêu cầu màn chính là **prompt tự nhiên** với toggles cá nhân hóa, Quick Start, voice, và CTA "Tìm công thức" qua **`POST /discovery/search`** (đã có trên API).

Flow chọn nguyên liệu **không biến mất** — chuyển vào **bottom sheet** khi user bấm Quick Start "Nguyên liệu trong tủ lạnh", với UI grid theo mock riêng.

## What Changes

- **Redesign** [`discover_page.dart`](green_kitchen/lib/features/discover/presentation/pages/discover_page.dart): hero, prompt card (500 chars), voice, 2 option toggles, Quick Start 2×2 grid, sticky CTA + AI disclaimer.
- **Add** fridge ingredients bottom sheet: search debounced, grid 2 cột theo category, chọn tối đa 7, recent ingredient sets, apply → fill prompt màn chính.
- **Add** discovery search client + results flow: `POST /discovery/search`, route `/discovery/results`, `DiscoveryResultsPage`.
- **Refactor** `DiscoverBloc`: prompt state + ingredient picker state (sheet).
- **Add** `speech_to_text` integration for voice prompt input.
- **Update** ARB keys (vi + en); localize `quick_start_preset.dart`.
- **Add** `DiscoverySession` local persistence on successful search.

Non-goals for this change: Profile UI to edit preferences/allergies; server-side history sync; removing `POST /pantry/search` or `PantryResultsPage`; browse-all ingredients when search query is empty (API returns `[]`); recent prompts list on main Discover screen.

## Capabilities

### New Capabilities

- `discover-prompt-ui`: Yemake-style main Discover screen (prompt, toggles, Quick Start, voice, CTA).
- `fridge-ingredients-sheet`: Bottom sheet ingredient picker with grid UI and apply-to-prompt flow.
- `discovery-search`: Flutter client for `POST /discovery/search` and results presentation.

### Modified Capabilities

- `discover`: Supersedes main-screen requirements from `add-home-shell` (ingredient chips on tab, pantry CTA). Ingredient search behavior moves to `fridge-ingredients-sheet`.
- `recipe-interactions-local`: Adds `DiscoverySession` storage alongside pantry sessions.
- `app-ui-integration`: Discover tab no longer uses AppBar title; uses in-body hero.

## Impact

- **Features:** `discover/` (presentation refactor + new widgets), `recipes/` (DiscoveryRemoteDataSource, repository), new `discovery/` results under discover or pantry module.
- **Router:** `/discovery/results` added; Discover CTA no longer pushes `/pantry/results`.
- **Dependencies:** `speech_to_text`; platform mic permissions (Android/iOS).
- **Backend consumed:** `POST /api/v1/discovery/search` (JWT); `GET /api/v1/ingredients?q=` (sheet only).
- **l10n:** Many new/updated ARB keys; no hardcoded product copy on new screens.
- **Testing:** bloc tests, widget tests for sheet + page, discovery results bloc test.
