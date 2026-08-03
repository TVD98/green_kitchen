## 1. Localization

- [x] 1.1 Add vi/en ARB keys for Profile hub rows (preferences, allergies, summaries), preferences editor fields/actions/errors, and allergies editor search/empty/save/errors
- [x] 1.2 Run code generation and confirm `AppLocalizations` exposes the new getters

## 2. Profile domain + data (Clean Architecture)

- [x] 2.1 Scaffold `lib/features/profile/{domain,data,presentation}` per flutter-clean-architecture
- [x] 2.2 Domain: `UserPreferences`, `UserAllergy` entities; curated cuisine/health-goal allow-list constants; repository interfaces; use cases (get/update preferences, get/replace allergies)
- [x] 2.3 Data: DTOs + mappers for `/users/me/preferences` and `/users/me/allergies`; `ProfileRemoteDataSource` (Dio, JWT interceptor); repository implementations
- [x] 2.4 Register profile repository/use cases (and reuse existing `SearchIngredients`) in `injection.dart`
- [x] 2.5 Unit tests: DTO mapping, use cases with mocked remote

## 3. Routing

- [x] 3.1 Add nested Profile routes `/home/profile/preferences` and `/home/profile/allergies` under the Profile shell branch
- [x] 3.2 Wire page builders / DI for Preferences and Allergies blocs on those routes

## 4. Preferences editor

- [x] 4.1 Implement `PreferencesBloc` (load, edit fields, save, failure/retry)
- [x] 4.2 Build `PreferencesPage` with `green_kitchen_ui` controls: dietary style, spice level, cuisine multi-select, health goals multi-select, disliked ingredient chips, Save CTA (enabled only when dirty), loading/error states
- [x] 4.3 Bloc test: hydrate from GET; successful PUT; failure keeps draft; Save no-ops when unchanged
- [x] 4.4 Dirty-state: track loaded/saved baseline; enable Save only when draft differs

## 5. Allergies editor

- [x] 5.1 Implement `AllergiesBloc` (load, debounced search via `SearchIngredients`, toggle selection, save replace-all, failure/retry)
- [x] 5.2 Build `AllergiesPage` with selected chips, search field + results list, Save / clear-all (Save enabled only when dirty), loading/error states using `green_kitchen_ui`
- [x] 5.3 Bloc test: hydrate from GET; toggle selection; PUT ids; empty PUT clears; search debounce behavior; Save no-ops when unchanged
- [x] 5.4 Dirty-state: track loaded/saved baseline IDs; enable Save only when working set differs

## 6. Profile hub

- [x] 6.1 Expand `ProfilePage` with preferences and allergies rows (localized) while keeping language + logout
- [x] 6.2 Optional hub summary load (dietary label + allergy count); failures leave subtitles empty without blocking the hub
- [x] 6.3 Widget/smoke test: hub shows new rows and navigates to editors

## 7. Verification

- [x] 7.1 `flutter pub get` and `flutter analyze` clean for touched packages
- [x] 7.2 Run profile-related unit/bloc/widget tests
- [ ] 7.3 Manual smoke: set preferences → Discover with preferences toggle ON → set allergies → Discover with exclude allergies ON → language + logout still work
