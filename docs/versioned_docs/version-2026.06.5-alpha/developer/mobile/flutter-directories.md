---
sidebar_position: 2
title: Flutter Directory Structure
---

## Directory Structure

The `lib/` directory is organized as follows:

```text
lib/
├── core/                # Global configuration, core tools, and utilities.
│   ├── errors/          # Exception and failure classes.
│   ├── network/         # HTTP client setup (e.g., Dio, interceptors).
│   ├── routes/          # Navigation setup (e.g., GoRouter).
│   └── theme/           # App themes, typography, and global styles.
├── constants/           # Static values, API endpoints, strings, and assets.
├── data/                # Data layer: implementations and external sources.
│   ├── datasources/     # Data sources (remote_data_source, local_data_source).
│   ├── dto/             # Data Transfer Objects (API-specific models and JSON serialization).
│   └── repositories/    # Implementations of the interfaces defined in the Domain layer.
├── domain/              # Business layer: pure logic and framework-agnostic rules.
│   ├── interfaces/      # Contracts (Abstract classes) that the Data layer must fulfill.
│   ├── model/           # Pure business entities (no dependencies on JSON or external libraries).
│   ├── services/        # Use cases or services that orchestrate the business logic.
│   └── utils/           # Domain-specific utilities.
├── presentation/        # User Interface (UI) layer.
│   ├── pages/           # Complete application screens.
│   ├── providers/       # State management (Riverpod/Bloc/Provider).
│   └── widgets/         # Reusable visual components.
└── main.dart            # Application entry point.

```

## Layer Descriptions

### 1. Core & Constants

* **Purpose:** To contain cross-cutting code used throughout the entire application.
* **Rule:** No other layer should inject heavy dependencies here. This is the home for network configuration, color palettes, routing logic, and global error handling.

### Domain

* **Purpose:** Contains pure business logic.
* **Golden Rule:** **It must not depend on any other layer.** It shouldn't import anything from Flutter material, databases (like SQL or Hive), or network libraries (like HTTP).
* **Flow:** It defines the `models` (entities) and `interfaces` (repositories) that dictate what data the app needs, but it doesn't care where or how that data is fetched.

### Data

* **Purpose:** To fetch, submit, and cache data. It acts as the bridge between the outside world (APIs, local DBs) and the Domain layer.
* **Flow:** This is where `repositories` are created to *implement* the `interfaces` from the Domain layer. The `dto` files handle translating raw JSONs from the API into the pure `models` required by the Domain layer.

### Presentation

* **Purpose:** To display information to the user and capture their interactions.
* **Flow:** The `pages` consume `providers` (or controllers). The `providers` communicate with the `services` (use cases) from the Domain layer. The UI must never make direct calls to the API or the database.

## Recommended Data Flow

1. **User Interaction:** The user taps a button in `presentation/pages`.
2. **State Management:** The view notifies the provider in `presentation/providers`.
3. **Business Logic:** The provider executes a function in `domain/services` (Use Case).
4. **Data Request:** The service requests data via an interface in `domain/interfaces`.
5. **Fetching:** The actual implementation in `data/repositories` decides whether to fetch data from the network or local cache (`data/datasources`).
6. **Return:** Data travels back as pure Entities (`domain/model`) to the view to update the UI.