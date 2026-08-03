## Context

Profile Tab 4 (`add-home-shell`) is a thin presentation page: session name/email, language → `/settings/language`, logout. Discover (`redesign-discover-tab`) already posts `options.use_preferences` / `options.exclude_allergies`, and `green_kitchen_api` already implements:

- `GET`/`PUT /api/v1/users/me/preferences`
- `GET`/`PUT /api/v1/users/me/allergies` (`ingredient_ids[]` replace-all)
- `GET /api/v1/ingredients?q=` (used by fridge sheet)

There is no Flutter client for preferences/allergies yet. Editing those values was an explicit non-goal of Discover redesign and belongs on Profile.

Constraints: Clean Architecture + BLoC, `green_kitchen_ui` only, vi/en via ARB, JWT via existing Dio interceptor. No new backend endpoints in this change.

## Goals / Non-Goals

**Goals:**

- Profile hub lists preferences and allergies entries (with optional summaries) alongside language and logout.
- Preferences editor loads and saves the full preferences payload the API already supports.
- Allergies editor loads current allergies and replaces the set via ingredient search + selection.
- Typed failures → localized generic error/retry UI; no raw server strings.

**Non-Goals:**

- `PATCH` user profile (name/avatar) — API not available.
- Account security (password, social unlink, delete account).
- Theme mode, clear local history, nutrition dashboards, notifications.
- Changing Discover toggle defaults or UI.
- Fake remote datasources for preferences/allergies (real API only, same pattern as discovery).

## Decisions

### 1. Expand `profile` feature (not a separate top-level feature tree)

Scaffold full layers under existing `lib/features/profile/`:

```
lib/features/profile/
├── domain/       # UserPreferences, UserAllergy entities; repository contracts; use cases
├── data/         # DTOs, ProfileRemoteDataSource (preferences + allergies), repository impls
└── presentation/
    ├── pages/    # ProfilePage (hub), PreferencesPage, AllergiesPage
    ├── bloc/     # ProfileHubCubit (optional summaries), PreferencesBloc, AllergiesBloc
    └── widgets/  # summary chips, allergy chips, enum selectors
```

**Rationale:** Profile is already Tab 4 ownership; preferences/allergies are account settings, not Discover concerns.

**Alternative considered:** new `user_settings` feature. Rejected — adds navigation ownership ambiguity while Profile already owns account surface.

### 2. Nested routes under the Profile shell branch

| Route | Screen |
|-------|--------|
| `/home/profile` | Hub |
| `/home/profile/preferences` | Preferences editor |
| `/home/profile/allergies` | Allergies editor |

Keep `/settings/language` as the existing global settings push (unchanged).

**Rationale:** nested under the Profile `StatefulShellRoute` branch preserves tab selection and back stack within Profile.

**Alternative considered:** full-screen routes outside the shell. Rejected — language already works as push, but preferences/allergies are Profile-owned and should stay in-tab for IA consistency.

### 3. Preferences field UX mapped to API enums/arrays

| API field | UI control |
|-----------|------------|
| `dietary_style` | Single select: `omnivore`, `vegetarian`, `vegan`, `pescatarian` (localized labels) |
| `spice_level` | Single select: `mild`, `medium`, `hot` |
| `cuisine_preferences` | Multi-select chips from a **client curated allow-list** (e.g. vietnamese, japanese, korean, chinese, thai, western, indian) — free-text cuisines out of MVP |
| `health_goals` | Multi-select chips from a **client curated allow-list** (e.g. low_carb, high_protein, low_fat, balanced, weight_loss) |
| `disliked_ingredients` | Multi free-text chips (string list as API stores); add via text field + chip |

Save uses `PUT` with the full edited form state (client sends complete snapshot of fields the screen owns). First visit: GET returns nulls/empty arrays — form shows empty/unset selections.

**Rationale:** API accepts free `string[]` for cuisines/goals but does not document a catalog; curated lists keep UX predictable and match Discover personalization without inventing backend enums.

**Alternative considered:** free-text for all arrays. Rejected for cuisine/goals — hard to keep Discover quality high; disliked ingredients stay free-text because they are open-ended.

### 4. Allergies = replace-all selected ingredient IDs

- On open: `GET /users/me/allergies` → chips of `{ingredient_id, name}`.
- Search: debounce ~300ms → reuse existing ingredients remote (`GET /ingredients?q=`) via shared repository/use case already used by Discover fridge sheet.
- Selection: toggle ingredient into working set; Save → `PUT { ingredient_ids: [...] }` (atomic replace). Clear-all sends `[]`.
- Unknown IDs are rejected by API (`INVALID_INPUT`) — client only submits IDs returned from search/GET.

**Rationale:** mirrors API contract exactly; reuses ingredient search UX patterns without inventing a parallel picker.

**Alternative considered:** local-only allergy names. Rejected — discovery exclusion requires ingredient IDs linked to the Ingredient table.

### 5. Hub summaries without blocking hub render

Hub always shows session user + static rows. Optionally fire a light load (`GET` preferences + allergies) to show subtitle summaries (e.g. dietary style label, allergy count). Failures leave subtitles empty — hub remains usable.

**Rationale:** editing is the core job; summaries are progressive enhancement.

### 6. Error and loading patterns

- Editors: `AppLoading` on initial GET; enable Save only when the draft/working set differs from the last loaded or successfully saved snapshot; disable Save while PUT in flight; snackbar or inline error with retry on failure.
- Map network / `INVALID_INPUT` / unauthorized to existing typed `Failure` → localized generic copy (same rule as Discover: no raw API messages unless a future change opts in).

### 7. Design system + localization

Screens compose `AppCard`, `AppText`, `AppButton`, `AppChips` / selection lists, `AppTextField`, `AppLoading`, `AppDialog` as needed. All user-facing strings via `AppLocalizations` (en + vi ARB). Enum wire values stay English API tokens; only labels are localized.

## Risks / Trade-offs

- **[Curated cuisine/goal lists drift from product]** → Document allow-lists in code constants; easy to expand without API change.
- **[Disliked ingredients free-text duplicates allergy semantics]** → Keep both: allergies are ID-linked exclusions; disliked are soft preference strings for Gemini context.
- **[Hub summary doubles GET traffic]** → Accept for MVP; cache in-memory for session if needed later.
- **[No edit display name]** → Users may expect it on Profile; hub keeps name read-only until a future users API change.

## Migration Plan

1. Scaffold profile domain/data + DI registrations.
2. Wire nested routes and Preferences/Allergies pages.
3. Expand Profile hub rows + optional summaries.
4. ARB keys + bloc/widget tests.
5. Manual smoke: set preferences → Discover with toggle ON → set allergies → Discover with exclude ON.

Rollback: remove nested routes and hub rows; Discover continues to work with empty server-side prefs/allergies.

## Open Questions

None blocking — API contracts already shipped; client curated lists for cuisine/health_goals are an accepted MVP product decision for this change.
