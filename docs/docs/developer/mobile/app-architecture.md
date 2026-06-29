---
sidebar_position: 1
title: App Architecture
---

```mermaid
classDiagram
    class DistanceUnit {
        <<enumeration>>
        kilometers
        miles
    }
    class VolumeUnit {
        <<enumeration>>
        liters
        gallons
    }
    class CoreError {
        <<enumeration>>
        emptyLicensePlate
        invalidLicensePlateFormat
        negativeOdometer
        negativeMoneyAmount
        invalidVehicleYear
    }
    class DomainException {
        +CoreError error
        +DomainException(error)
        +toString() String
    }

class Plate {
        -String value
        +Plate(String value)
        -isValid(String value) boolean
        +getValue() String
        +getCountryCode() String
    }

class Vin {
        -String code
        +getManufacturer() String
        +getVehicleDescription() String
        +getCheckDigit() char
        +getModelYear() int
        +getAssemblyPlant() char
        +getSerialNumber() String
        -isValid(String code) boolean
    }
    class Odometer {
        +double distance
        +DistanceUnit unit
        +Odometer(distance, unit)
        +add(value: double) Odometer
    }
    class Money {
        +double amount
        +String currency
        +Money(amount, currency)
    }

    class Volume {
        +double amount
        +VolumeUnit unit
        +Volume(amount, unit)
    }
    
    class SparePart {
        -String sku
        -String name
        -Brand brand
        -PartCategory category
        -Map~String, String~ attributes
        +getAttribute(String key) String
        +isCompatibleWith(Vehicle vehicle) boolean
    }

    class PartCategory {
        <<enumeration>>
        FLUIDS
        BRAKES
        FILTERS
        ELECTRONICS
    }

    class ReplacedPart {
        +String sparePartId
        +int quantity
        +Money unitPrice
        +Money getTotal() Money
    }

    class FitmentRule {
        -String make
        -String model
        -int startYear
        -int endYear
        -String requiredEngineCode
        +matches(Vehicle vehicle) boolean
    }

    class Consumption {
        +double value
        +DistanceUnit distanceUnit
        +VolumeUnit volumeUnit
    }

    class Brand {
        +String value
    }

    class Model {
        +String value
    }

    class VehicleType {
        <<enumeration>>
        combustion
        electric
        motorcycle
    }

    class MaintenanceInterval {
        +String id
        +String vehicleId
        +String label
        +int kmInterval
        +int? monthsInterval
        +String? description
        +double lastResetKm
        +DateTime? lastResetDate
        +bool isEnabled
        +bool isCustom
    }

    class Vehicle {
        +String id
        +String brand
        +String model
        +int year
        +String? alias
        +VehicleType type
        +Plate plate
        +Vin vin
        +Odometer currentOdometer
        +DateTime createdAt
        +bool isSynced
        +String get displayName
        +Vehicle(...)
        +copyWith(...) Vehicle
    }
    
    class FuelLog {
        +String id
        +String vehicleId
        +DateTime date
        +bool isSynced
        +FuelLog(...)
        +get calculatedConsumption() consumption
    }

    class MaintenanceLog {
        +String id
        +String vehicleId
        +DateTime date
        +String description
        +bool isSynced
        +MaintenanceLog(...)
    }

    Odometer --> DistanceUnit
    Volume --> VolumeUnit
    DomainException --> CoreError

    SparePart --> PartCategory
    SparePart "1" *-- "*" FitmentRule : compatible with

    
    Vehicle "1" *-- "1" Plate : contains
    Vehicle "1" *-- "1" Vin : contains
    Vehicle *-- Odometer : currentOdometer
    
    FuelLog *-- Volume : fueledVolume
    FuelLog *-- Odometer : odometerAtFueling
    
    MaintenanceLog "1" *-- "*" ReplacedPart : includes parts
    ReplacedPart "*" --> "1" SparePart : references by sparePartId+-

    Vehicle "1" <-- "*" FuelLog : references by vehicleId
    Vehicle "1" <-- "*" MaintenanceLog : references by vehicleId
    Vehicle "1" <-- "*" MaintenanceInterval : references by vehicleId
    Vehicle --> VehicleType
```

 ## Objects

### Imutable Value Objects
#### VIN (Vehicle Identification Number)
 ```mermaid
 classDiagram
 class Vin {
        -String code
        +getManufacturer() String
        +getVehicleDescription() String
        +getCheckDigit() char
        +getModelYear() int
        +getAssemblyPlant() char
        +getSerialNumber() String
        -isValid(String code) boolean
    }
 ```

| Position | Section | Technical Name | Method Name | Description | Example |
|----------|---------|-----------------|-------------|-------------|---------|
| 1 - 3 | WMI | World Manufacturer Identifier | getWmi() | Country of origin and manufacturer code. | 1HG (Honda USA) |
| 4 - 8 | VDS | Vehicle Descriptor Section | getAttributes() | Body type, engine, model, and restraint system. | EJ8449 |
| 9 | VDS | Check Digit | getCheckDigit() | Mathematical verifier to detect typos or fakes. | 5 |
| 10 | VIS | Model Year | getModelYear() | The specific year of manufacture (30-year cycle). | L (2020) |
| 11 | VIS | Plant Code | getPlantCode() | The specific factory where it was assembled. | S (Suzuka) |
| 12 - 17 | VIS | Sequence Number | getSerialNumber() | The unique production ID (the last 6 digits). | 012345 |

#### Plate
```mermaid
classDiagram
class Plate {
        -String value
        +Plate(String value)
        -isValid(String value) boolean
        +getValue() String
        +getCountryCode() String
    }
```  

### Mutable Objects

#### Odometer
```mermaid
classDiagram
class Odometer {
        +double distance
        +DistanceUnit unit
        +Odometer(distance, unit)
        +add(value: double) Odometer
    }
class DistanceUnit {
        <<enumeration>>
        kilometers
        miles
    }
```

#### Tire Code
```mermaid
classDiagram
class TireCode {
        -String code
        +getWidth() int
        +getAspectRatio() int
        +getDiameter() int
        +getLoadIndex() int
        +getSpeedRating() char
        -isValid(String code) boolean
    }
```

#### Paint Code
```mermaid
classDiagram
class PaintCode {
        -String code
        +getColor() String
        +getManufacturer() String
        +isValid(String code) boolean
    }
```
### Maintenance parts
```mermaid
classDiagram
    class SparePart {
        -String sku
        -String name
        -Brand brand
        -PartCategory category
        -Map~String, String~ attributes
        +getAttribute(String key) String
        +isCompatibleWith(Vehicle vehicle) boolean
    }

    class PartCategory {
        <<enumeration>>
        FLUIDS
        BRAKES
        FILTERS
        ELECTRONICS
    }

    class FitmentRule {
        -String make
        -String model
        -int startYear
        -int endYear
        -String requiredEngineCode
        +matches(Vehicle vehicle) boolean
    }

    SparePart --> PartCategory
    SparePart "1" *-- "*" FitmentRule : compatible with
```
<details>
<summary>Examples</summary>
>Example 1: Engine Oil
>* SKU: "CAS-5W30-5L"
>* Name: "Castrol Edge 5W-30"
>* Category: FLUIDS
>* Attributes Map: * "Viscosity" -> "5W-30"
>* "Volume" -> "5L"
>* "Composition" -> "Synthetic"

>Example 2: Battery
>* SKU: "BOSCH-S4-005"
>* Name: "Bosch S4 Car Battery"
>* Category: ELECTRONICS
>* Attributes Map: * "Voltage" -> "12V"
>* "Capacity" -> "60Ah"
>* "CCA" -> "540A"
</details>

Here is the rest of the documentation to complete your App Architecture. I've added the missing **Core Entities (Aggregates)**, **Transactional Logs**, **Shared Value Objects**, and **Error Handling** based on your master diagram.

---

### Core Entities (Aggregates)

#### Vehicle

The root aggregate of the domain. It acts as the central hub tying the immutable identities (VIN, Plate) with the mutable state (Odometer) and logs.

```mermaid
classDiagram
    class Vehicle {
        +String id
        +String brand
        +String model
        +int year
        +String? alias
        +VehicleType type
        +DateTime createdAt
        +bool isSynced
        +String get displayName
        +Vehicle(...)
        +copyWith(...) Vehicle
    }

    class VehicleType {
        <<enumeration>>
        combustion
        electric
        motorcycle
    }

    class MaintenanceInterval {
        +String id
        +String vehicleId
        +String label
        +int kmInterval
        +int? monthsInterval
        +String? description
        +double lastResetKm
        +DateTime? lastResetDate
        +bool isEnabled
        +bool isCustom
        +MaintenanceInterval(...)
    }

```

### Transactional Logs

These entities represent events that happen to a vehicle over time. They are strictly bound to a specific `Vehicle` via the `vehicleId`.

#### Fuel Log

Records a refueling event to track expenses and calculate fuel consumption (e.g., L/100km or MPG).

```mermaid
classDiagram
    class FuelLog {
        +String id
        +String vehicleId
        +DateTime date
        +bool isSynced
        +FuelLog(...)
        +get calculatedConsumption() double
    }

```

#### Maintenance Log

Records services or repairs performed on the vehicle.

```mermaid
classDiagram
    class MaintenanceLog {
        +String id
        +String vehicleId
        +DateTime date
        +String description
        +bool isSynced
        +MaintenanceLog(...)
    }
```

### Shared Value Objects

Generic, immutable value objects used across different entities to enforce formatting and prevent primitive obsession (e.g., passing a negative amount or mixing up liters and gallons).

#### Money & Volume

```mermaid
classDiagram
    class Money {
        +double amount
        +String currency
        +Money(amount, currency)
    }
    
    class Volume {
        +double amount
        +VolumeUnit unit
        +Volume(amount, unit)
    }
    
    class VolumeUnit {
        <<enumeration>>
        liters
        gallons
    }

```

### Exceptions & Error Handling

Centralized domain errors ensure that business rules are strictly validated before any object is created or saved to the database.

```mermaid
classDiagram
    class CoreError {
        <<enumeration>>
        emptyLicensePlate
        invalidLicensePlateFormat
        negativeOdometer
        negativeMoneyAmount
        invalidVehicleYear
    }
    
    class DomainException {
        +CoreError error
        +DomainException(error)
        +toString() String
    }

```