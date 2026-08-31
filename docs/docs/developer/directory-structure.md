---
sidebar_position: 2
title: Directory Structure
sidebar_custom_props:
  icon: '📁'
---

# Directory Structure

## Repository layout

The [GitHub repository](https://github.com/abrahdev/karter) is a [monorepo](https://en.wikipedia.org/wiki/Monorepo) and includes the following folders:

| Folder | Description |
| :--- | :--- |
| `.github/` | GitHub templates and action workflows |
| `.vscode/` | VSCode debug launch profiles |
| `design/` | Screenshots and logos for the README |
| `docs/` | Source code for the [Karter Docs](https://karter.abrah.dev/) website |
| `mobile/` | Source code for the mobile app (Android, iOS, Linux) |
| `templates/` | Vehicle maintenance templates (JSON), community translations, and the tools that compile them into the catalog database — see [Data & Template Pipeline](../templates/data-pipeline) |

## Mobile app `lib/` structure

The `lib/` directory is organized as follows:

```text
lib/
├── main.dart                      # Application entry point
├── l10n/                          # UI localization (ARB) — buttons, menus, alerts only
│   ├── app_en.arb
│   ├── app_es.arb
│   ├── app_et.arb
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_es.dart
│   └── app_localizations_et.dart
├── core/                          # Cross-cutting configuration and utilities
│   ├── database/                  # Drift database definition and migrations
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   └── theme/                     # App themes, typography, and global styles
│       └── app_theme.dart
├── domain/                        # Business layer: pure logic, no framework deps
│   ├── entities/                  # Core business entities (vehicle, fuel_log, ...)
│   ├── enums/                     # Enumerations used across entities
│   ├── value_objects/             # Immutable value objects (Volume, Odometer, Plate, VIN)
│   ├── repositories/              # Abstract repository interfaces (contracts)
│   └── errors/                    # Domain exception classes
├── data/                          # Data layer: implementations and external sources
│   ├── models/                    # Data models (template parsing, etc.)
│   │   ├── template_index.dart
│   │   ├── template_item.dart
│   │   ├── template_part.dart
│   │   ├── template_meta.dart
│   │   └── template_dtc.dart
│   ├── repositories/              # Repository implementations (Drift-backed)
│   └── services/                  # Application services (export, PDF, templates, i18n, catalog)
│       ├── export_service.dart
│       ├── pdf_export_service.dart
│       ├── catalog_service.dart
│       ├── catalog_repository.dart
│       ├── catalog_source.dart
│       ├── template_resolver.dart
│       ├── template_translations.dart
│       └── template_validator.dart
└── presentation/                  # User Interface (UI) layer
    ├── pages/                     # Complete application screens
    │   ├── home_page.dart
    │   ├── dashboard_page.dart
    │   ├── vehicle_detail_page.dart
    │   ├── vehicle_form_page.dart
    │   ├── fuel_log_list_page.dart
    │   ├── maintenance_log_list_page.dart
    │   ├── maintenance_settings_page.dart
    │   ├── document_list_page.dart
    │   ├── data_manager_page.dart
    │   ├── template_list_page.dart
    │   ├── template_detail_page.dart
    │   ├── template_creator_page.dart
    │   └── more_page.dart
    ├── providers/                 # State management (Riverpod)
    │   ├── vehicle_providers.dart
    │   ├── locale_provider.dart
    │   ├── template_source_provider.dart
    │   └── catalog_sources_provider.dart
    ├── widgets/                   # Reusable visual components and modals
    └── utils/                     # Presentation utilities (maintenance_localizer.dart)
```

### Layer descriptions

**Core (`core/`)** — Cross-cutting code (Drift database, themes). No heavy framework dependencies.

**Domain (`domain/`)** — Pure business logic with zero framework dependencies. It must not depend on any other layer: no Flutter/Material, no databases, no network libraries. Contains entities, enums, value objects, repository interfaces, and error classes.

**Data (`data/`)** — Fetches, submits, and caches data. Bridges the outside world (local DB, assets) and the Domain layer. Repository implementations receive a Drift `AppDatabase` instance and translate between database rows and domain entities.

**Presentation (`presentation/`)** — Displays information and captures interactions. Pages consume Riverpod providers; providers call repository methods directly (no use-case layer). The UI should never make direct database or service calls.

## Templates directory

The `templates/` directory is a self-contained package that can be forked by communities to create their own template repos. See [Data & Template Pipeline](../templates/data-pipeline) and [Authoring templates](../templates/authoring) for details:

```text
templates/
├── data/                     # Vehicle templates (community-contributed)
│   ├── _base/                # Base templates (powertrain types) + dtc.json
│   ├── audi/                 # Per-manufacturer directories
│   ├── toyota/
│   └── ... (31 manufacturers)
├── i18n/                     # Community translations (en/es/et)
├── schemas/                  # JSON Schema template-v2.json
└── tools/                    # Generation scripts (build_catalog.py, ...)
```

## i18n Architecture

Translations are split into two systems:

- **`lib/l10n/app_*.arb`** — Flutter UI strings (buttons, menus, alerts, forms). Standard ARB-based localization via `flutter gen-l10n`.
- **`templates/i18n/*.json`** — Template/community translations (maintenance item names, descriptions, brand names). Flat JSON format (`{"key": "value"}`) for easy community contribution. Served from the same remote URL as template JSONs. Accessible in the app via a symlink at `mobile/i18n/` (listed as a separate asset in `pubspec.yaml` since Flutter doesn't recursively bundle symlinked subdirectories on Linux).
- **`data/services/template_translations.dart`** — Loads template JSON translations at startup. Supports remote fetch (same URL as templates) with local asset fallback. Used by `maintenance_localizer.dart` to resolve interval names/descriptions.

## Recommended Data Flow

1. **User Interaction:** The user taps a button in `presentation/pages`.
2. **State Management:** The widget calls `ref.read(provider)` or watches a provider in `presentation/providers`.
3. **Data Request:** The provider calls a repository method on the injected implementation in `data/repositories`.
4. **Persistence:** The repository implementation interacts with Drift (`core/database`) to read/write data.
5. **Return:** Data travels back as domain entities (`domain/entities`) to update the UI.