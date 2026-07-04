import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';

typedef _Preset = ({String label, int km, int? months, String? description});

List<MaintenanceInterval> defaultIntervalsFor(
    VehicleType type, String vehicleId) {
  final presets = _presetsByType[type] ?? [];
  return presets.map((p) {
    return MaintenanceInterval(
      id: uuid.v4(),
      vehicleId: vehicleId,
      label: p.label,
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
      km: 10000,
      months: 12,
      description:
          'Oil loses its lubricating properties with mileage and time. '
          'Regular changes protect the engine from premature wear.',
    ),
    (
      label: 'Oil filter',
      km: 10000,
      months: 12,
      description:
          'The oil filter traps particles and contaminants. '
          'If saturated, oil circulates unfiltered and accelerates engine wear.',
    ),
    (
      label: 'Air filter',
      km: 20000,
      months: null,
      description:
          'A dirty air filter reduces power, increases consumption, '
          'and can damage intake sensors.',
    ),
    (
      label: 'Brake pads',
      km: 30000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 3mm thickness, braking distance increases dangerously.',
    ),
    (
      label: 'Tires',
      km: 50000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear compromises grip and safety.',
    ),
    (
      label: 'Spark plugs',
      km: 40000,
      months: null,
      description:
          'Worn spark plugs increase consumption, make starting difficult, '
          'and can damage the ignition coil.',
    ),
    (
      label: 'Timing belt',
      km: 100000,
      months: 60,
      description:
          'The timing belt is critical: if it breaks, the engine suffers severe damage. '
          'It must be changed at the manufacturer\'s interval without exception.',
    ),
    (
      label: 'Brake fluid',
      km: 40000,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Coolant',
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
      km: 30000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 3mm thickness, braking distance increases dangerously.',
    ),
    (
      label: 'Tires',
      km: 50000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear compromises grip and safety.',
    ),
    (
      label: 'Battery cooling',
      km: 60000,
      months: null,
      description:
          'The battery cooling system is vital for maintaining optimal '
          'temperature and prolonging cell life.',
    ),
    (
      label: 'Cabin filter',
      km: 20000,
      months: null,
      description:
          'The cabin filter purifies the air entering the interior. '
          'A saturated filter reduces HVAC efficiency and can generate odors.',
    ),
    (
      label: 'Brake fluid',
      km: 40000,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Coolant',
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
      km: 1000,
      months: null,
      description:
          'The chain is the component that suffers the most wear. '
          'Regular lubrication extends its life and prevents dangerous breakage.',
    ),
    (
      label: 'Tire pressure and condition',
      km: 1000,
      months: null,
      description:
          'Tires degrade both by mileage and age. '
          'Incorrect pressure or uneven wear severely compromises grip.',
    ),
    (
      label: 'Engine oil and filter',
      km: 10000,
      months: 12,
      description:
          'Oil loses its lubricating properties with mileage and time. '
          'Regular changes protect the engine from premature wear.',
    ),
    (
      label: 'Air filter',
      km: 10000,
      months: null,
      description:
          'A dirty air filter reduces power, increases consumption, '
          'and can damage intake sensors.',
    ),
    (
      label: 'Brake pads',
      km: 5000,
      months: null,
      description:
          'Friction compound wears with use. '
          'Below 1.5mm thickness, safety is compromised.',
    ),
    (
      label: 'Brake fluid',
      km: 999999,
      months: 24,
      description:
          'Brake fluid is hygroscopic: it absorbs moisture, reducing its '
          'boiling point and braking effectiveness.',
    ),
    (
      label: 'Spark plugs',
      km: 20000,
      months: null,
      description:
          'Worn spark plugs increase consumption, make starting difficult, '
          'and can damage the ignition coil.',
    ),
    (
      label: 'Valve adjustment',
      km: 24000,
      months: null,
      description:
          'Valve adjustment maintains proper compression and prevents '
          'premature wear on the cylinder head.',
    ),
    (
      label: 'Drive kit (Chain, sprocket, crown)',
      km: 20000,
      months: null,
      description:
          'Chain, sprocket, and crown wear as a set. '
          'Replacing them separately accelerates wear on the new component.',
    ),
    (
      label: 'Fork oil',
      km: 30000,
      months: 36,
      description:
          'Over time it breaks down, losing density and worsening '
          'front suspension behavior.',
    ),
    (
      label: 'Coolant',
      km: 40000,
      months: 36,
      description:
          'Coolant loses its antifreeze and anticorrosive properties '
          'over time, potentially damaging the internal circuit.',
    ),
    (
      label: 'Battery',
      km: 50000,
      months: 48,
      description:
          'Battery loses capacity with charge cycles and time. '
          'Using maintainers in winter prolongs its useful life.',
    ),
  ],
};
