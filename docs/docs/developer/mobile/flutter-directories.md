---
sidebar_position: 2
title: Flutter Directory Structure
---

## Directory Structure

The `lib/` directory is organized as follows:

```text
lib/
├── main.dart                      # Application entry point
├── l10n/                          # UI localization (ARB) — buttons, menus, alerts only
│   ├── app_en.arb
│   ├── app_es.arb
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_es.dart
├── core/                          # Cross-cutting configuration and utilities
│   ├── database/                  # Drift database definition and migrations
│   │   ├── app_database.dart
│   │   └── app_database.g.dart
│   └── theme/                     # App themes, typography, and global styles
│       └── app_theme.dart
├── domain/                        # Business layer: pure logic, no framework deps
│   ├── README.md
│   ├── entities/                  # Core business entities
│   │   ├── vehicle.dart
│   │   ├── fuel_log.dart
│   │   ├── maintenance_log.dart
│   │   ├── maintenance_interval.dart
│   │   ├── vehicle_document.dart
│   │   └── maintenance_interval.dart
│   ├── enums/                     # Enumerations used across entities
│   │   ├── vehicle_type.dart
│   │   ├── distance_unit.dart
│   │   ├── volume_unit.dart
│   │   ├── document_type.dart
│   │   └── core_error.dart
│   ├── value_objects/             # Immutable value objects (Volume, Odometer, Plate, VIN)
│   │   ├── volume.dart
│   │   ├── odometer.dart
│   │   ├── plate.dart
│   │   └── vin.dart
│   ├── repositories/              # Abstract repository interfaces (contracts)
│   │   ├── vehicle_repository.dart
│   │   ├── fuel_log_repository.dart
│   │   ├── maintenance_log_repository.dart
│   │   ├── maintenance_interval_repository.dart
│   │   └── vehicle_document_repository.dart
│   └── errors/                    # Domain exception classes
│       └── domain_exception.dart
├── data/                          # Data layer: implementations and external sources
│   ├── models/                    # Data models (template parsing, etc.)
│   │   ├── template_index.dart
│   │   ├── template_item.dart
│   │   └── template_meta.dart
│   ├── repositories/              # Repository implementations (Drift-backed)
│   │   ├── vehicle_repository_impl.dart
│   │   ├── fuel_log_repository_impl.dart
│   │   ├── maintenance_log_repository_impl.dart
│   │   ├── maintenance_interval_repository_impl.dart
│   │   ├── vehicle_document_repository_impl.dart
│   │   └── seed_intervals.dart
│   └── services/                  # Application services (export, PDF, templates, i18n)
│       ├── export_service.dart
│       ├── pdf_export_service.dart
│       ├── template_resolver.dart
│       └── template_translations.dart
└── presentation/                  # User Interface (UI) layer
    ├── pages/                     # Complete application screens
    │   ├── home_page.dart
    │   ├── dashboard_page.dart
    │   ├── vehicle_detail_page.dart
    │   ├── vehicle_form_page.dart
    │   ├── fuel_log_list_page.dart
    │   ├── fuel_log_form_page.dart
    │   ├── maintenance_log_list_page.dart
    │   ├── maintenance_log_form_page.dart
    │   ├── maintenance_settings_page.dart
    │   ├── document_list_page.dart
    │   ├── data_manager_page.dart
    │   └── more_page.dart
    ├── providers/                 # State management (Riverpod)
    │   ├── vehicle_providers.dart
    │   └── locale_provider.dart
    ├── widgets/                   # Reusable visual components and modals
    │   ├── vehicle_card.dart
    │   ├── add_fuel_log_modal.dart
    │   ├── add_maintenance_log_modal.dart
    │   ├── add_document_modal.dart
    │   └── odometer_dialog.dart
    └── utils/                     # Presentation utilities
        └── maintenance_localizer.dart
```

## Layer Descriptions

### 1. Core (`core/`)

- **Purpose:** Contains cross-cutting code used throughout the entire application.
- **Contents:** Database setup (Drift), theme configuration.
- **Rule:** No other layer should inject heavy framework dependencies here. This is the home for database schema, color palettes, and global configuration.

### 2. Domain (`domain/`)

- **Purpose:** Contains pure business logic with zero framework dependencies.
- **Golden Rule:** **It must not depend on any other layer.** It cannot import anything from Flutter/Material, databases (Drift/SQL), or network libraries.
- **Contents:**
  - `entities/` — Business entities (Vehicle, FuelLog, MaintenanceLog, VehicleDocument, etc.)
  - `enums/` — Enum types (VehicleType, VolumeUnit, DistanceUnit, DocumentType, CoreError)
  - `value_objects/` — Immutable objects enforcing domain rules (Volume, Odometer, Plate, VIN)
  - `repositories/` — Abstract repository interfaces that define what data the app needs
  - `errors/` — Domain exception classes for business rule violations

### 3. Data (`data/`)

- **Purpose:** Fetches, submits, and caches data. Bridges the outside world (local DB, assets) and the Domain layer.
- **Contents:**
  - `repositories/` — Concrete implementations of domain repository interfaces, backed by Drift database
  - `services/` — Application services (data export/import, PDF generation, template resolution, template translations with remote fetch support)
  - `models/` — Data models for non-persistent structures (template JSON parsing)
- **Flow:** Repository implementations receive a Drift `AppDatabase` instance and translate between database rows and domain entities.

### 4. Presentation (`presentation/`)

- **Purpose:** Displays information to the user and captures interactions.
- **Contents:**
  - `pages/` — Full-screen routes
  - `providers/` — Riverpod providers that bridge data layer to UI
  - `widgets/` — Reusable components including bottom sheet modals (add document, add fuel, add service, odometer update)
  - `utils/` — Formatting/display helpers
- **Flow:** Pages consume Riverpod providers. Providers call repository methods directly (no use-case layer currently). The UI should never make direct database or service calls.

## Providers (Riverpod)

State management uses `flutter_riverpod`. Providers are organized in:

- `presentation/providers/vehicle_providers.dart` — All repository providers and async data providers
- `presentation/providers/locale_provider.dart` — Locale/language state

## i18n Architecture

Translations are split into two systems:

- **`lib/l10n/app_*.arb`** — Flutter UI strings (buttons, menus, alerts, forms). Standard ARB-based localization via `flutter gen-l10n`.
- **`templates/i18n/*.json`** — Template/community translations (maintenance item names, descriptions, brand names). Flat JSON format (`{"key": "value"}`) for easy community contribution. Served from the same remote URL as template JSONs. Accessible in the app via a symlink at `mobile/i18n/` (listed as a separate asset in `pubspec.yaml` since Flutter doesn't recursively bundle symlinked subdirectories on Linux).
- **`data/services/template_translations.dart`** — Loads template JSON translations at startup. Supports remote fetch (same URL as templates) with local asset fallback. Used by `maintenance_localizer.dart` to resolve interval names/descriptions.

## Templates Directory Structure

The `templates/` directory is a self-contained package that can be forked by communities to create their own template repos:

```text
templates/
├── data/                     # Vehicle templates (community-contributed)
│   ├── index.json            # Generated manifest of all templates
│   ├── _base/                # Base templates (powertrain types)
│   │   ├── car-common.json
│   │   ├── car-combustion.json
│   │   ├── car-diesel.json
│   │   ├── car-electric.json
│   │   ├── dtc.json
│   │   ├── motorcycle-2t.json
│   │   ├── motorcycle-4t.json
│   │   ├── motorcycle-common.json
│   │   └── motorcycle-ev.json
│   ├── audi/                 # Per-manufacturer directories
│   ├── toyota/
│   └── ... (31 manufacturers)
├── i18n/                     # Infrastructure: community translations
│   ├── en.json
│   ├── es.json
│   └── et.json
├── schemas/                  # Infrastructure: template validation
│   └── template-v2.json
└── tools/                    # Infrastructure: generation scripts
    ├── build_catalog.py
    ├── generate_index.py
    ├── i18n_json.py
    └── import_dtc.py
```

Repository providers are created once using `Provider<T>`. Async data providers use `FutureProvider.family` keyed by `vehicleId` to fetch per-vehicle data (fuel logs, maintenance logs, intervals, documents).

## Recommended Data Flow

1. **User Interaction:** The user taps a button in `presentation/pages`.
2. **State Management:** The widget calls `ref.read(provider)` or watches a provider in `presentation/providers`.
3. **Data Request:** The provider calls a repository method on the injected implementation in `data/repositories`.
4. **Persistence:** The repository implementation interacts with Drift (`core/database`) to read/write data.
5. **Return:** Data travels back as domain entities (`domain/entities`) to update the UI.
