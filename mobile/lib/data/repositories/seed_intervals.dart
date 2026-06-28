import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/core/database/app_database.dart';

List<MaintenanceInterval> defaultIntervalsFor(
    VehicleType type, String vehicleId) {
  final presets = _presetsByType[type] ?? [];
  return presets.map((p) {
    return MaintenanceInterval(
      id: uuid.v4(),
      vehicleId: vehicleId,
      label: p.$1,
      kmInterval: p.$2,
      isCustom: false,
    );
  }).toList();
}

const _presetsByType = {
  VehicleType.combustion: [
    ('Cambio de aceite', 10000),
    ('Filtro de aceite', 10000),
    ('Filtro de aire', 20000),
    ('Pastillas de freno', 30000),
    ('Neumáticos', 50000),
    ('Bujías', 40000),
    ('Correa de distribución', 100000),
  ],
  VehicleType.electric: [
    ('Pastillas de freno', 30000),
    ('Neumáticos', 50000),
    ('Refrigeración batería', 60000),
    ('Filtro habitáculo', 20000),
    ('Líquido de frenos', 40000),
  ],
  VehicleType.motorcycle: [
    ('Cambio de aceite', 5000),
    ('Filtro de aceite', 10000),
    ('Cadena (engrase/ajuste)', 1000),
    ('Cadena (reemplazo)', 20000),
    ('Pastillas de freno', 15000),
    ('Neumáticos', 10000),
    ('Bujías', 20000),
  ],
};
