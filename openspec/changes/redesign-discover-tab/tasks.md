## 1. OpenSpec & scaffolding

- [ ] 1.1 Confirm change package under `openspec/changes/redesign-discover-tab/`
- [ ] 1.2 Create feature branch `feature/redesign-discover-tab`

## 2. Localization

- [ ] 2.1 Add/update ARB keys (vi + en) per design: hero, prompt, toggles, Quick Start, sheet, voice, disclaimer
- [ ] 2.2 Run `flutter gen-l10n`
- [ ] 2.3 Refactor `quick_start_preset.dart` to use `AppLocalizations`

## 3. Data layer — discovery search

- [ ] 3.1 Add `DiscoverySearchQuery` entity
- [ ] 3.2 Add `DiscoveryRemoteDataSource` (`POST /discovery/search`)
- [ ] 3.3 Add `DiscoveryRepository` + impl + error mapping
- [ ] 3.4 Add `SearchDiscovery` use case
- [ ] 3.5 Register in `injection.dart`

## 4. DiscoverBloc refactor

- [ ] 4.1 Extend state: `prompt`, toggles, filters, sheet fields (`ingredientQuery`, `suggestions`, `selectedIngredients`, `recentIngredientSets`)
- [ ] 4.2 Add events: prompt, options, quick start, fridge apply/clear, ingredient toggle (max 7)
- [ ] 4.3 Keep debounced `SearchIngredients` for sheet only
- [ ] 4.4 Update `discover_bloc_test.dart`

## 5. Discovery results flow

- [ ] 5.1 Add `DiscoverySearchArgs` model
- [ ] 5.2 Add `DiscoveryResultsBloc` + page (reuse `RecipeListTile`, error/loading patterns)
- [ ] 5.3 Add route `/discovery/results` in `app_router.dart`
- [ ] 5.4 Persist `DiscoverySession` on success; update recent ingredient sets on fridge apply

## 6. Main Discover UI

- [ ] 6.1 `discover_hero_section.dart`
- [ ] 6.2 `discover_prompt_card.dart` (500 chars, counter, clear, voice hook)
- [ ] 6.3 `discover_option_tile.dart` (icon + title + subtitle + AppSwitch)
- [ ] 6.4 `discover_quick_start_grid.dart` + `quick_start_pill.dart`
- [ ] 6.5 `discover_bottom_bar.dart` (sticky CTA + disclaimer)
- [ ] 6.6 Rewrite `discover_page.dart` (no AppBar, no main ingredient UI)

## 7. Fridge ingredients bottom sheet

- [ ] 7.1 `fridge_ingredients_sheet.dart` (header, search, footer sticky)
- [ ] 7.2 `ingredient_search_bar.dart`
- [ ] 7.3 `ingredient_category_section.dart` + `ingredient_pick_card.dart` (2-col grid)
- [ ] 7.4 `fridge_recent_searches.dart`
- [ ] 7.5 Wire fridge pill → sheet; apply → main prompt
- [ ] 7.6 `fridge_ingredients_sheet_test.dart`

## 8. Voice input

- [ ] 8.1 Add `speech_to_text` dependency
- [ ] 8.2 Add Android `RECORD_AUDIO` + iOS speech/mic usage strings
- [ ] 8.3 Implement `DiscoverSpeechService`
- [ ] 8.4 Wire voice button in prompt card

## 9. Verification

- [ ] 9.1 `flutter analyze` passes
- [ ] 9.2 Unit + widget tests pass
- [ ] 9.3 Smoke: prompt search → results → detail (`USE_FAKE_AUTH=false`)
- [ ] 9.4 Smoke: fridge sheet → apply → prompt filled → search
- [ ] 9.5 Smoke: voice append (device with mic)
