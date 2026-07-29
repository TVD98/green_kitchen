## 1. Localization and ARB scaffolding

- [x] 1.1 Add vi/en ARB keys for tab labels, discover, pantry, library segments, suggestions sections, profile, recipe detail, and empty/error states
- [x] 1.2 Run gen-l10n and confirm `AppLocalizations` exposes new getters

## 2. Home shell and routing

- [x] 2.1 Create `lib/features/home_shell/presentation/pages/home_shell_page.dart` with `NavigationBar` (4 tabs) using `green_kitchen_ui` theme tokens
- [x] 2.2 Refactor `app_router.dart` to use `StatefulShellRoute.indexedStack` with branches `/home/discover`, `/home/library`, `/home/suggestions`, `/home/profile`
- [x] 2.3 Add full-screen routes `/recipes/:id` and `/pantry/results` outside the shell
- [x] 2.4 Redirect authenticated `/home` → `/home/discover`; stop routing post-login to auth `HomePage`
- [x] 2.5 Widget test: tab switching preserves selected index and localized labels render

## 3. Recipes shared module (domain + data)

- [x] 3.1 Create `Recipe` entity and `RecipesRepository` contract (search, getById, getByIds)
- [x] 3.2 Implement DTOs + mappers for snake_case API recipe shape
- [x] 3.3 Implement `RecipesRemoteDataSource` for `GET /recipes` and `GET /recipes/:id`
- [x] 3.4 Register recipes module in DI
- [x] 3.5 Unit tests for DTO mapping and repository error translation

## 4. Recipe interactions local module

- [x] 4.1 Create domain entities for viewed/saved records and pantry sessions
- [x] 4.2 Define repository + use cases: record viewed, toggle saved, read viewed/saved ids, save/read pantry sessions, recent ingredient sets
- [x] 4.3 Implement local data source (SharedPreferences or existing key-value store) with bounded list caps
- [x] 4.4 Register in DI
- [x] 4.5 Unit tests for dedupe, ordering, eviction at cap, and session append

## 5. Discover tab (Tab 1)

- [x] 5.1 Create `IngredientsRemoteDataSource` for `GET /ingredients?q=`
- [x] 5.2 Implement `DiscoverBloc` (query debounce, suggestions, chip selection, recent shortcuts)
- [x] 5.3 Build Discover page: hero, autocomplete field, chips, optional filter entry, suggest CTA
- [x] 5.4 Wire recent shortcuts to local recent ingredient sets
- [x] 5.5 Bloc/widget tests for chip dedupe and disabled CTA when empty

## 6. Pantry search flow

- [x] 6.1 Implement `PantryRemoteDataSource` for `POST /pantry/search`
- [x] 6.2 Implement `PantryBloc` (submit, loading, success, retry on failure)
- [x] 6.3 Build pantry results page with `AppCard` list and `AppLoading`/error states
- [x] 6.4 On success, persist pantry session + recent ingredients via interaction use cases
- [x] 6.5 Bloc test: success persists session; failure exposes retry event

## 7. Recipe detail (shared)

- [x] 7.1 Implement `RecipeDetailBloc` (load by id, bookmark toggle, record view on success)
- [x] 7.2 Build detail page: header, meta, tags, ingredients, steps, nutrition, save control
- [x] 7.3 Navigate from discover results, library, and suggestions to `/recipes/:id`
- [x] 7.4 Widget/bloc tests for save toggle and viewed recording

## 8. Recipe library tab (Tab 2)

- [x] 8.1 Implement `RecipeLibraryBloc` with `AppTabs` segments: All, Viewed, Saved, From pantry (**no Created segment**)
- [x] 8.2 Hydrate recipe summaries via `RecipesRepository` from local id lists / pantry sessions
- [x] 8.3 Build library page with segment control, list, and per-segment empty states
- [x] 8.4 Bloc test: All dedupes viewed+saved+pantry; Saved updates after detail bookmark

## 9. Suggestions tab (Tab 3)

- [x] 9.1 Implement mock popularity mapper (deterministic fake view counts from recipe id)
- [x] 9.2 Implement `SuggestionsBloc` loading Featured, Popular, Quick (`max_time=30`), Easy (`difficulty=easy`) sections from API
- [x] 9.3 Build suggestions page with vertical sections and horizontal or vertical recipe rows
- [x] 9.4 Unit test: mock counts stable per id; API titles unchanged
- [x] 9.5 Widget test: section headers localized

## 10. Profile tab (Tab 4)

- [x] 10.1 Create `profile` feature page showing session user name/email
- [x] 10.2 Add language settings row → `/settings/language`
- [x] 10.3 Add logout row → `AuthLogoutRequested`
- [x] 10.4 Remove logout/language actions from auth `HomePage` or delete unused home page

## 11. Verification

- [x] 11.1 Confirm no new screen hardcodes user-facing copy outside ARB
- [x] 11.2 Confirm all new UI uses `package:green_kitchen_ui/green_kitchen_ui.dart` only
- [x] 11.3 Confirm Library has exactly four segments and no "Đã tạo" UI
- [ ] 11.4 Manual smoke: login → discover → pantry search → detail → save → library saved segment → suggestions → profile logout
- [x] 11.5 Run `flutter analyze` and `flutter test`
