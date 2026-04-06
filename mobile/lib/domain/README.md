# Domain Layer

This directory contains the **domain layer** of Karter. The domain layer is responsible for the **business logic** of the app. It includes **entities**, **value objects**, **repository interfaces**, and **use cases**. This layer should **never depend** on anything from the presentation layer or the data/infrastructure layer.

## Structure

* **[Entities](./entities/)**: Core data classes that represent the main business objects (e.g., `Vehicle`, `FuelLog`, `MaintenanceLog`).
* **[Value Objects](./value_objects/)**: Classes that encapsulate single domain concepts with validation (e.g., `Plate`, `Vin`, `Odometer`).
* **[Repositories](./repositories/)**: Abstract interfaces that define **contracts for data operations**. Implementations are provided in the data layer.
* **[UseCases](./usecases/)**: Classes that implement the **business actions** of the app, consuming repositories to perform tasks (e.g., `AddVehicle`, `GetVehicles`, `AddFuelLog`).

```
domain/
├── entities/
│   └── vehicle.dart
├── value_objects/
│   └── plate.dart
├── repositories/
│   └── vehicle_repository.dart
├── usecases/
│   └── add_vehicle.dart
```

---

## Usage

The domain layer exposes **use cases** that implement the business logic by consuming repositories through **dependency injection**.

```dart
// In presentation layer
final addVehicleUseCase = ref.watch(addVehicleUseCaseProvider);
await addVehicleUseCase(vehicle);

final getVehiclesUseCase = ref.watch(getVehiclesUseCaseProvider);
final vehicles = await getVehiclesUseCase();
```

> The presentation layer should **never interact directly with repositories**, but always go through the domain layer via **use cases**.


