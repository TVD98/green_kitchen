## Context

`green_kitchen` is a new Flutter app with default Material demo UI. We need a local design-system package so future feature screens share one brand (Duolingo-like green + Nunito) across light and dark themes.

## Goals / Non-Goals

**Goals:**
- Ship `packages/green_kitchen_ui` with tokens, ThemeData, and base widgets
- Integrate into the app via path dependency
- Support light + dark themes out of the box

**Non-Goals:**
- Publishing to pub.dev
- Separate GitHub repo for the UI package
- Feature screens, BLoC, networking
- Full Duolingo clone (illustrations, gamification)
- Bundled custom `.ttf` files (use `google_fonts` only)

## Decisions

1. **Monorepo path package** over sibling/git dependency  
   - Rationale: simplest sync for a single-app stage; one PR can update tokens + consumers.

2. **Tokens + ThemeData + widgets in one package** over tokens-only  
   - Rationale: widgets encode the brand (radius, padding, variants) so screens stay consistent.

3. **Duolingo green `#58CC02` + accent `#FFC800`**  
   - Rationale: matches product direction requested by stakeholders.

4. **Nunito via `google_fonts`** over system fonts or bundled TTF  
   - Rationale: friendly rounded look; no font asset maintenance.

5. **Public API only through barrel `green_kitchen_ui.dart`**  
   - Rationale: hide `src/` so internals can refactor without breaking app imports.

6. **`ThemeMode.system` default in app**  
   - Rationale: light + dark both ship; OS preference is a sensible default.

## Risks / Trade-offs

- [Google Fonts needs network on first load] → Mitigation: accept for v1; can later add offline font assets if needed  
- [Package API churn while brand evolves] → Mitigation: keep widgets thin wrappers over tokens; version via monorepo commits  
- [Over-building widgets unused early] → Mitigation: stick to the locked v1 widget list only

## Migration Plan

1. Create package scaffold and implement tokens → theme → widgets  
2. Add path dependency; update `main.dart`  
3. `flutter pub get` + `flutter analyze` at package and app  
4. Smoke-run app in light/dark  
5. Rollback: remove path dependency and revert `main.dart` if needed (package folder can remain unused)

## Open Questions

- None blocking — palette, font, location, and scope already approved.
