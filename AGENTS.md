# Karter Project — Agent Instructions

## Project Overview
Karter is an open-source vehicle maintenance tracker built with Flutter (mobile app).

## General Rules
- Never commit without explicit user permission.
- Never build app bundle unless explicitly asked.
- Always run `flutter analyze` after code changes and fix any issues before reporting done.
- Always check existing code conventions before making changes (imports, naming, structure).
- Follow existing patterns — mimic code style, use existing libraries/utilities.
- Never add comments to code unless explicitly requested.
- Keep responses concise (fewer than 4 lines) unless user asks for detail.

## Git & GitHub
- Branch: `feat/ui-improvements` — merge PRs to `main`.
- Commit messages follow Conventional Commits: `type(scope): description`.
- Types: `feat`, `fix`, `refactor`, `chore`, `ui`, `style`.
- Before committing, inspect `git status`, `git diff`, and `git log --oneline -10`.
- Stage only intended files, never commit secrets or keys.
- Use `gh` CLI for GitHub tasks (PRs, issues, checks).
- Create GitHub issues before PRs when resolving features or fixes.

## Design System (Material 3)
- `AppSpacing.pagePadding = 16` — use for all ListView padding across pages.
- Global Card margin: `EdgeInsets.symmetric(horizontal: 0, vertical: 8)` in `app_theme.dart`.
- `SectionHeader` shared widget for section titles (labelSmall, primary color, toUpperCase, letterSpacing: 1.2).
- Font: `fontFamily: 'Roboto'` set globally in `app_theme.dart`.
- Use `Card` with `Padding` for grouped sections (M3 pattern).
- Use `SegmentedButton` for type/unit selectors, not `DropdownButton` where appropriate.
- Input decoration: `InputDecorationTheme` with filled style.

## Responsive Layout
- Breakpoint: `600px` using `LayoutBuilder`.
- Below 600px: single `ListView` (mobile).
- Above 600px: 2-column layout with independent scrolling using `Column` + `Expanded` + `SingleChildScrollView`.
- Left column: primary content. Right column: secondary content.
- Example: Vehicle Detail — Left: Info + Odometer + Actions | Right: Next Maintenance.
- Example: More page — Left: Preferences + Data + Tips | Right: Community + About.

## Localization (i18n)
- Languages: English (en), Spanish (es), Estonian (et).
- All user-facing strings MUST have translations in all 3 languages.
- Use `AppLocalizations.of(context)!` to access strings.
- Keys go in `app_en.arb`, `app_es.arb`, `app_et.arb`.

## Vehicle Type Selector
- SegmentedButton with icons always visible.
- Text label shown only on the selected segment (use conditional `label` with `SizedBox.shrink()` for unselected).

## Vehicle Form Page
- 4-card layout: Vehicle Info, Details, Units, Actions.
- Units card: Odometer + km/mi on same line, Volume (L/gal) below, Currency dropdown separate.

## Context Menu (VehicleCard)
- Long-press and right-click show `PopupMenu`.
- Options: Edit, Add to dashboard (placeholder), Setup notifications (modal).
- Menu positioned at touch point using `onLongPressStart` + `onSecondaryTapUp` with `RelativeRect`.

## Changelog
- Show as modal bottom sheet (`ChangelogSheet`), not a full page.
- Parse CHANGELOG.md to extract only the current version section.
- Drag handle at top, version number in header.

## Build
- `flutter build appbundle --release` for Play Store builds.
- Bundle output: `mobile/build/app/outputs/bundle/release/app-release.aab`.
- Version format: `YYYY.MM.BUILD+NUMBER` (e.g., `2026.07.10+14`).
- Update `VERSION`, `pubspec.yaml`, and `CHANGELOG.md` when releasing.

## Prohibited
- Do NOT refactor working code unless asked.
- Do NOT change theme colors or fonts without asking.
- Do NOT add new dependencies without checking if existing ones cover the need.
- Do NOT generate or guess URLs for the user.
- Do NOT create documentation files unless explicitly requested.

## Acknowledgments

Localization is powered by [Weblate](https://hosted.weblate.org/engage/karter/) — a free and open-source translation platform for open source projects. We are grateful to Weblate for providing free hosting for the Karter project.
