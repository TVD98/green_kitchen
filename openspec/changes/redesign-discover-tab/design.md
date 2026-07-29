## Context

`green_kitchen` Tab 1 (Khám phá) currently implements ingredient autocomplete, chips, and pantry search per `add-home-shell`. The API now exposes `POST /api/v1/discovery/search` with `{ prompt, options?, filters? }` and user preference toggles map to `options.use_preferences` / `options.exclude_allergies`.

Product mocks define two surfaces:
1. **Main Discover** — NL prompt, personalization toggles, Quick Start pills, voice, "Tìm công thức".
2. **Fridge bottom sheet** — ingredient search grid, max 7 selections, apply composes prompt on main screen.

Constraints: Clean Architecture + BLoC, `green_kitchen_ui` only, vi/en via ARB, real API (no fake discovery datasource).

## Goals / Non-Goals

**Goals:**

- Main Discover matches Yemake mock layout and copy (localized).
- Quick Start pills compose `prompt` + optional `filters` on the client (no preset API).
- Fridge pill opens bottom sheet; other pills fill prompt directly.
- After sheet apply, main screen shows filled prompt (no ingredient chips on main).
- Discovery search → results list → recipe detail; persist `DiscoverySession` locally.
- Voice input appends transcript to prompt.

**Non-goals:**

- Profile screens for editing preferences/allergies.
- Recent prompts on main Discover screen.
- Back button on Discover (tab lives in shell).
- Full ingredient browse without search query.
- Replacing or removing pantry search API/module.

## Decisions

### 1. Single DiscoverBloc owns main + sheet state

One `DiscoverBloc` holds both `prompt`/toggles/filters and sheet fields (`ingredientQuery`, `suggestions`, `selectedIngredients`, `recentIngredientSets`). Sheet is presentation-only overlay; closing or applying from the sheet does not reset sheet search/selection — only the search clear control and **Xóa lựa chọn** mutate those fields.

**Alternative considered:** separate `FridgePickerBloc`. Rejected — shared apply-to-prompt and simpler DI for MVP.

### 2. Search entry point switches from pantry to discovery

| Action | Before | After |
|--------|--------|-------|
| Discover CTA | `/pantry/results` + `SearchPantry` | `/discovery/results` + `SearchDiscovery` |
| Fridge sheet apply | N/A | Fills prompt only; user taps CTA on main |

`PantryResultsPage` remains for any legacy/direct routes but is not linked from redesigned Discover.

### 3. Discovery data layer mirrors pantry pattern

```
DiscoveryRemoteDataSource → DiscoveryRepositoryImpl → SearchDiscovery use case
```

Entity: `DiscoverySearchQuery { prompt, usePreferences, excludeAllergies, filters }`.

### 4. Fridge sheet UX (locked)

- Open: ~85% height, drag handle, close ✕.
- Initial: recent ingredient sets (local, max 5) + empty search hint.
- After typing: debounce 300ms → `GET /ingredients?q=` → grid grouped by `category`.
- Selection: tap `+` toggle, max **7**, counter on footer CTA `(n/7)`.
- Apply: `QuickStartPreset.fridge.build(userInput: names.join(', '))` → set `prompt`, close sheet (sheet search/selection unchanged).

### 5. Quick Start presets (client-only)

| Pill | Behavior |
|------|----------|
| Fridge | Open bottom sheet |
| Cravings | Set prompt template (editable) |
| Fast & healthy | Prompt + `filters.maxTime: 30`, `tags: ['healthy']` |
| Vegetarian | Prompt + `tags: ['vegetarian']` |

Prompt strings from `AppLocalizations`, not hardcoded Vietnamese.

### 6. Discover theming

Mocks use kitchen green for CTA/toggles/pills. Apply **local** `Theme`/`ButtonStyle` on Discover widgets without changing global Focuso coral brand in `green_kitchen_ui`.

### 7. Local history

On successful discovery search, persist:

```dart
DiscoverySession { prompt, recipeIds, searchedAt }
```

Keep `recentIngredientSets` for fridge sheet only (update when sheet apply succeeds).

### 8. Voice

`DiscoverSpeechService` in presentation layer wraps `speech_to_text`. Append transcript to prompt; respect 500-char cap. Snackbar on permission denied.

## Router

| Route | Purpose |
|-------|---------|
| `/home/discover` | Redesigned tab (unchanged path) |
| `/discovery/results` | Discovery search results (new) |
| `/recipes/:id` | Unchanged |
| `/pantry/results` | Kept, not linked from new Discover |

## Module layout

```
lib/features/discover/
├── presentation/
│   ├── bloc/           # refactored DiscoverBloc
│   ├── pages/          # discover_page, discovery_results_page
│   ├── widgets/        # prompt card, option tile, quick start, fridge sheet
│   ├── models/         # discovery_search_args
│   └── services/       # discover_speech_service
lib/features/recipes/
├── data/               # DiscoveryRemoteDataSource, repo impl
└── domain/             # DiscoveryRepository, SearchDiscovery, DiscoverySearchQuery
```
