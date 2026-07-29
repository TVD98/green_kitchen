## Context

`green_kitchen` ships auth, localization, and `green_kitchen_ui`, but post-login UX is a minimal welcome screen inside `lib/features/auth/presentation/pages/home_page.dart`. The sibling API (`green_kitchen_api`) already implements discovery endpoints with JWT protection and Gemini-backed pantry search.

Product decisions locked for MVP:

1. **Hide "Đã tạo"** — no user-recipe CRUD segment in Tab 2 until a future API change.
2. **Mock popular/trending** — Tab 3 "Nhiều người quan tâm" uses simulated view/save counts on real recipe rows.
3. **Local-first interactions** — viewed, saved, and pantry session history persist on device only.

Constraints: Clean Architecture + BLoC, `green_kitchen_ui` only, vi/en via ARB, discovery calls real API (Bearer from existing auth interceptor).

## Goals / Non-Goals

**Goals:**

- 4-tab authenticated home matching product IA: Khám phá, Công thức, Gợi ý, Cá nhân.
- End-to-end pantry discovery: pick ingredients → search → view recipe detail.
- Tab 2 library filtered by local viewed/saved/pantry history.
- Tab 3 editorial sections with honest mock metadata for popularity.
- Shared recipe detail with bookmark + viewed recording.
- Router preserves tab state; detail/recipe flows push above shell.

**Non-Goals:**

- **Đã tạo** tab/segment or user recipe authoring.
- Server sync of saved/viewed/history.
- Real analytics/trending backend.
- Discovery fake datasource (offline demo).
- Backend error message localization.
- Recipe images / media upload.

## Decisions

### 1. Shell routing with `StatefulShellRoute.indexedStack`

Use `go_router` `StatefulShellRoute.indexedStack` with four branches:

| Index | Path | Tab |
|-------|------|-----|
| 0 | `/home/discover` | Khám phá |
| 1 | `/home/library` | Công thức |
| 2 | `/home/suggestions` | Gợi ý |
| 3 | `/home/profile` | Cá nhân |

Full-screen routes outside the shell:

- `/recipes/:id` — recipe detail
- `/pantry/results` — pantry result list (from discover)

Auth redirect: authenticated users hitting `/home` → `/home/discover`.

Bottom bar: Flutter `NavigationBar` themed with `AppColors.brand` for selected indicator; labels/icons from localized strings.

**Alternative considered:** single `/home` with manual tab state. Rejected — `StatefulShellRoute` preserves scroll/tab state and deep-link friendly paths.

### 2. Feature module boundaries

```
lib/features/
├── home_shell/          presentation only — scaffold + NavigationBar
├── discover/            Tab 1 + ingredient autocomplete UI
├── pantry/              domain/data for pantry search + results page
├── recipes/             shared recipe entity, remote DS, detail page, list cards
├── recipe_library/      Tab 2 presentation + bloc (reads local + recipes repo)
├── recipe_interactions/ domain/data local store (viewed, saved, pantry sessions)
├── suggestions/         Tab 3 presentation + bloc (mock popularity mapper)
└── profile/             Tab 4 (extract from auth home actions)
```

`recipes` is shared; tabs depend on it, not on each other's presentation.

### 3. Local interactions store

`RecipeInteractionsLocalDataSource` backed by `SharedPreferences` (or app `KeyValueStore` if already abstracted):

| Key | Shape | Purpose |
|-----|-------|---------|
| `viewed_recipe_ids` | JSON list `{id, viewed_at}` | Tab 2 "Đã xem", detail on open |
| `saved_recipe_ids` | JSON list `{id, saved_at}` | Tab 2 "Đã lưu", bookmark toggle |
| `pantry_sessions` | JSON list `{ingredients, recipe_ids, searched_at}` | Tab 2 "Từ tủ bếp", discover "Tìm lại" |
| `recent_pantry_ingredients` | string[] | Discover shortcuts (last 5 unique sets) |

Cap list lengths (e.g. 100 viewed, 50 sessions) to avoid unbounded growth.

**Alternative considered:** Hive/Isar. Rejected for MVP — simple key-value sufficient.

### 4. Tab 2 segments (no Đã tạo)

`AppTabs` segments (localized):

1. **Tất cả** — union of viewed + saved + pantry recipe IDs (deduped, recent first)
2. **Đã xem** — IDs from local viewed store, hydrate via `RecipesRepository.getByIds` or cached summary
3. **Đã lưu** — saved IDs only
4. **Từ tủ bếp** — grouped by pantry session or flat list of recipes from sessions

Empty states per segment with localized copy. **No fifth segment, no disabled "coming soon" row for Đã tạo.**

### 5. Tab 3 mock popularity

`SuggestionsBloc` loads real recipes via `GET /recipes` with filters per section:

| Section | API query | Mock overlay |
|---------|-----------|--------------|
| Nổi bật hôm nay | `limit 1` newest or random from first page | `is_featured: true` badge |
| Nhiều người quan tâm | first page sorted by `created_at desc` | attach deterministic fake `view_count` from recipe `id` hash |
| Nấu nhanh | `max_time=30` | — |
| Dễ làm | `difficulty=easy` | — |

UI MAY show "12k lượt xem" style subtitle — spec requires it be **derived locally**, not from server. Optional small disclaimer in dev builds only (non-goal for production UI unless product asks).

### 6. Discover → pantry flow

1. User types in `AppTextField` → debounced `GET /ingredients?q=`
2. Tap suggestion → add `AppChips` chip (dedupe by canonical name)
3. "Gợi ý món" enabled when ≥1 ingredient
4. Optional filter bottom sheet (`AppBottomSheet`): max time, difficulty
5. Navigate to `/pantry/results` → `PantryBloc` POST search → list `AppCard` rows
6. On success: persist `pantry_sessions` + `recent_pantry_ingredients`
7. Tap row → `/recipes/:id`

### 7. Recipe detail shared behavior

On open:

- Fetch `GET /recipes/:id` if not in memory cache
- Call `RecordRecipeViewed(id)`
- Show save toggle bound to `ToggleRecipeSaved(id)`

Bookmark state reads/writes local store only.

### 8. Profile tab

Display `AuthBloc` session user (name, email). Rows:

- Language → existing `/settings/language` push
- Log out → `AuthLogoutRequested`

Remove logout/language icon buttons from old home.

### 9. API envelope handling

Reuse auth patterns: parse `{success, code, data}`, snake_case DTOs, map to domain entities in data layer. Discovery failures → typed `Failure` → localized generic messages in presentation (not raw server strings).

## Risks / Trade-offs

- **[Local-only saved/viewed lost on uninstall]** → Accept for MVP; future sync change adds API.
- **[Mock popularity may mislead users]** → Use plausible but clearly non-authoritative formatting; replace when analytics API lands.
- **[Pantry search latency / Gemini errors]** → `AppLoading` on results; map `ERR_TOO_MANY_REQUESTS` / network to retry-friendly empty/error states.
- **[Library lists need N+1 fetches]** → Batch `getByIds` where API allows; cache recipe summaries in memory during session.
- **[No discovery fake DS blocks offline UI dev]** → Requires API running like auth real-mode; acceptable given backend exists.

## Migration Plan

1. Implement shell + empty tab placeholders; route auth success to `/home/discover`.
2. Land discover + pantry + detail (core loop).
3. Land local interactions + library tab.
4. Land suggestions + profile.
5. Delete or repurpose auth `HomePage`; update widget tests and router tests.

Rollback: revert router to single `HomePage` if shell incomplete (feature flag optional, not required for MVP).

## Open Questions

None blocking MVP — user confirmed: hide Đã tạo, mock popular data, local-first interactions.
