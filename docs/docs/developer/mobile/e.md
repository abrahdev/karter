---
sidebar_position: 4
title: Native Car Integrations
---
## Android Auto (andoridx.car.app) 
## Apple CarPlay (CarPlay.faramework)
Esta estructura que presentas sigue los principios de **Clean Architecture**. Es una base sólida para manejar múltiples fuentes de datos (OBD y Sistemas Nativos) de forma organizada.

Aquí tienes el mapa exacto de dónde colocar cada pieza de la implementación para que el código sea escalable y fácil de mantener:

---

### 1. Capa de Domain (`/domain`)

Es el corazón de la lógica. Aquí defines **qué** hace la app, sin importar si el dato viene de un dongle chino o de un servidor de Google.

* **`model/`**: Crea una entidad única llamada `VehicleTelemetry`. Esta clase es limpia; no sabe nada de Hexadecimal ni de APIs de Android.
* **`interfaces/`**: Define el contrato `IVehicleRepository`. Aquí declaras métodos como `streamTelemetry()` o `getFuelLevel()`.
* **`services/`**: Aquí iría un `TelemetryAggregatorService`. Su trabajo es decidir: *"Si Android Auto está conectado, usa sus datos; si no, pide datos al OBD"*.

### 2. Capa de Data (`/data`)

Aquí es donde ocurre la "magia sucia" y las implementaciones específicas.

* **`datasources/`**:
* `obd_bluetooth_datasource.dart`: Aquí va toda tu lógica de **comandos AT** y el manejo del socket Bluetooth.
* `android_auto_datasource.dart`: Aquí implementas los listeners del **CarHardwareManager**.
* `carplay_datasource.dart`: Implementación con **CoreBluetooth**.


* **`dto/`**:
* `ObdResponseDto`: Para transformar el Hexadecimal (`41 0C 1A F8`) en números.
* `AndroidAutoSensorDto`: Para mapear los objetos que devuelve el SDK de Google.


* **`repositories/`**:
* `VehicleRepositoryImpl`: Esta es la clase que implementa la interfaz de la capa de Domain. Orquesta las llamadas a los `datasources`.



### 3. Capa de Presentation (`/presentation`)

Aquí solo te importa mostrar la información.

* **`providers/`**: Un `telemetryProvider` que escucha el stream del repositorio. La UI se redibuja automáticamente cuando el combustible baja o las RPM suben.
* **`pages/`**:
* `DashboardPage`: La pantalla principal.
* `ObdScannerPage`: Para buscar y emparejar el dongle.


* **`widgets/`**: Velocímetros, barras de combustible y gráficos de telemetría.

### 4. Capa Core & Constants (`/core` & `/constants`)

* **`constants/`**: Aquí van todos los **PIDs de OBD-II** (ej. `static const String rpmPid = "010C";`) y los strings de permisos de Android Auto.
* **`core/errors/`**: Define fallos específicos como `ObdConnectionFailure` o `CarHardwareAccessDenied`.

---

### Resumen Visual de la Carpeta `/data` y `/domain`

```text
lib/
├── data/
│   ├── datasources/
│   │   ├── obd_datasource.dart       <-- Lógica de Comandos AT
│   │   └── native_car_datasource.dart <-- Android Auto / CarPlay
│   ├── dto/
│   │   ├── obd_decoder.dart          <-- Fórmulas matemáticas (A*256+B)/4
│   │   └── car_sensor_mapper.dart
│   └── repositories/
│       └── vehicle_repository_impl.dart <-- El "Cerebro" que une todo
├── domain/
│   ├── interfaces/
│   │   └── i_vehicle_repository.dart <-- El Contrato
│   └── model/
│       └── vehicle_data.dart         <-- El objeto final que lee la UI

```

### El flujo de diseño sería este:

1. El **Datasource** recibe `41 0C 1A F8`.
2. El **DTO** lo convierte en `1726 RPM`.
3. El **Repository** lo envuelve en un objeto `VehicleTelemetry`.
4. El **Provider** lo entrega a la **Page** de Flutter.

**¿Te gustaría que te escribiera el código de la Interface del Repositorio para que veas cómo unificar OBD y Android Auto en un solo lugar?**