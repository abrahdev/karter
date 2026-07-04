import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';

typedef _Preset = ({
  String label,
  String? i18nKey,
  String? descI18nKey,
  int km,
  int? months,
  String? description
});

List<MaintenanceInterval> defaultIntervalsFor(
    VehicleType type, String vehicleId) {
  final presets = _presetsByType[type] ?? [];
  return presets.map((p) {
    return MaintenanceInterval(
      id: uuid.v4(),
      vehicleId: vehicleId,
      label: p.label,
      i18nKey: p.i18nKey,
      descI18nKey: p.descI18nKey,
      kmInterval: p.km,
      monthsInterval: p.months,
      description: p.description,
      isCustom: false,
    );
  }).toList();
}

const _presetsByType = {
  VehicleType.combustion: <_Preset>[
    (
      label: 'Oil change',
      i18nKey: 'seed_interval_oil_change',
      descI18nKey: 'seed_desc_oil_change',
      km: 10000,
      months: 12,
      description:
          'Oil loses its lubricating properties with mileage and time. '
          'Regular changes protect the engine from premature wear.',
    ),
    (
      label: 'Oil filter',
      i18nKey: 'seed_interval_oil_filter',
      descI18nKey: 'seed_desc_oil_filter',
      km: 10000,
      months: 12,
      description:
          'The oil filter traps particles and contaminants. '
          'If saturated, oil circulates unfiltered and accelerates engine wear.',
    ),
    (
      label: 'Air filter',
      i18nKey: 'seed_interval_air_filter',
      descI18nKey: 'seed_desc_air_filter',
      km: 20000,
      months: null,
      description:
          'A dirty air filter reduces power, increases consumption, '
          'and can damage intake sensors.',
    ),
    (
      label: 'Brake pads',
      i18nKey: 'seed_interval_brake_pads',
      descI18nKey: 'seed_desc_brake_pads',
      km: 30000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 3mm thickness, braking distance increases dangerously.',
    ),
    (
      label: 'Tires',
      i18nKey: 'seed_interval_tires',
      descI18nKey: 'seed_desc_tires',
      km: 50000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear compromises grip and safety.',
    ),
    (
      label: 'Spark plugs',
      i18nKey: 'seed_interval_spark_plugs',
      descI18nKey: 'seed_desc_spark_plugs',
      km: 40000,
      months: null,
      description:
          'Worn spark plugs increase consumption, make starting difficult, '
          'and can damage the ignition coil.',
    ),
    (
      label: 'Timing belt',
      i18nKey: 'seed_interval_timing_belt',
      descI18nKey: 'seed_desc_timing_belt',
      km: 100000,
      months: 60,
      description:
          'The timing belt is critical: if it breaks, the engine suffers severe damage. '
          'It must be changed at the manufacturer\'s interval without exception.',
    ),
    (
      label: 'Brake fluid',
      i18nKey: 'seed_interval_brake_fluid',
      descI18nKey: 'seed_desc_brake_fluid',
      km: 40000,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Coolant',
      i18nKey: 'seed_interval_coolant',
      descI18nKey: 'seed_desc_coolant',
      km: 60000,
      months: 36,
      description:
          'Coolant loses its antifreeze and anticorrosive properties '
          'over time, potentially damaging the engine\'s internal circuit.',
    ),
  ],
  VehicleType.electric: <_Preset>[
    (
      label: 'Brake pads',
      i18nKey: 'seed_interval_brake_pads',
      descI18nKey: 'seed_desc_brake_pads',
      km: 30000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 3mm thickness, braking distance increases dangerously.',
    ),
    (
      label: 'Tires',
      i18nKey: 'seed_interval_tires',
      descI18nKey: 'seed_desc_tires',
      km: 50000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear compromises grip and safety.',
    ),
    (
      label: 'Battery cooling',
      i18nKey: 'seed_interval_battery_cooling',
      descI18nKey: 'seed_desc_battery_cooling',
      km: 60000,
      months: null,
      description:
          'The battery cooling system is vital for maintaining optimal '
          'temperature and prolonging cell life.',
    ),
    (
      label: 'Cabin filter',
      i18nKey: 'seed_interval_cabin_filter',
      descI18nKey: 'seed_desc_cabin_filter',
      km: 20000,
      months: null,
      description:
          'The cabin filter purifies the air entering the interior. '
          'A saturated filter reduces HVAC efficiency and can generate odors.',
    ),
    (
      label: 'Brake fluid',
      i18nKey: 'seed_interval_brake_fluid',
      descI18nKey: 'seed_desc_brake_fluid',
      km: 40000,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Coolant',
      i18nKey: 'seed_interval_coolant',
      descI18nKey: 'seed_desc_coolant',
      km: 80000,
      months: 36,
      description:
          'Coolant loses its antifreeze and anticorrosive properties '
          'over time, potentially damaging the internal circuit.',
    ),
  ],
  VehicleType.motorcycle: <_Preset>[
    (
      label: 'Chain (Clean and lube)',
      i18nKey: 'seed_interval_chain',
      descI18nKey: 'seed_desc_chain',
      km: 1000,
      months: null,
      description:
          'The chain is the component that suffers the most wear. '
          'Regular lubrication extends its life and prevents dangerous breakage.',
    ),
    (
      label: 'Tire pressure and condition',
      i18nKey: 'seed_interval_tire_pressure',
      descI18nKey: null,
      km: 1000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear severely compromises grip.',
    ),
    (
      label: 'Engine oil and filter',
      i18nKey: 'seed_interval_engine_oil_filter',
      descI18nKey: 'seed_desc_oil_change',
      km: 10000,
      months: 12,
      description:
          'Oil loses its lubricating properties with mileage and time. '
          'Regular changes protect the engine from premature wear.',
    ),
    (
      label: 'Air filter',
      i18nKey: 'seed_interval_air_filter',
      descI18nKey: 'seed_desc_air_filter',
      km: 10000,
      months: null,
      description:
          'A dirty air filter reduces power, increases consumption, '
          'and can damage intake sensors.',
    ),
    (
      label: 'Brake pads',
      i18nKey: 'seed_interval_brake_pads',
      descI18nKey: 'seed_desc_motorcycle_brake_pads',
      km: 5000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 1.5mm thickness, safety is compromised.',
    ),
    (
      label: 'Brake fluid',
      i18nKey: 'seed_interval_brake_fluid',
      descI18nKey: 'seed_desc_brake_fluid',
      km: 999999,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Spark plugs',
      i18nKey: 'seed_interval_spark_plugs',
      descI18nKey: 'seed_desc_spark_plugs',
      km: 20000,
      months: null,
      description:
          'Worn spark plugs increase consumption, make starting difficult, '
          'and can damage the ignition coil.',
    ),
    (
      label: 'Valve adjustment',
      i18nKey: 'seed_interval_valve_adjustment',
      descI18nKey: 'seed_desc_valve_adjustment',
      km: 24000,
      months: null,
      description:
          'Valve adjustment maintains proper compression and prevents '
          'premature wear on the cylinder head.',
    ),
    (
      label: 'Drive kit (Chain, sprocket, crown)',
      i18nKey: 'seed_interval_drive_kit',
      descI18nKey: 'seed_desc_drive_kit',
      km: 20000,
      months: null,
      description:
          'Chain, sprocket, and crown wear as a set. '
          'Replacing them separately accelerates wear on the new component.',
    ),
    (
      label: 'Fork oil',
      i18nKey: 'seed_interval_fork_oil',
      descI18nKey: 'seed_desc_fork_oil',
      km: 30000,
      months: 36,
      description:
          'Over time it breaks down, losing density and worsening '
          'front suspension behavior.',
    ),
    (
      label: 'Coolant',
      i18nKey: 'seed_interval_coolant',
      descI18nKey: 'seed_desc_coolant',
      km: 40000,
      months: 36,
      description:
          'Coolant loses its antifreeze and anticorrosive properties '
          'over time, potentially damaging the internal circuit.',
    ),
    (
      label: 'Battery',
      i18nKey: 'seed_interval_battery',
      descI18nKey: 'seed_desc_battery_maintenance',
      km: 50000,
      months: 48,
      description:
          'Battery loses capacity with charge cycles and time. '
          'Using maintainers in winter prolongs its useful life.',
    ),
  ],
};
