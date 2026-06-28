import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/core/database/app_database.dart';

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
      label: 'Cambio de aceite',
      km: 10000,
      months: 12,
      description:
          'El aceite pierde propiedades lubricantes con los kilómetros y el tiempo. '
          'Un cambio regular protege el motor del desgaste prematuro.',
    ),
    (
      label: 'Filtro de aceite',
      km: 10000,
      months: 12,
      description:
          'El filtro de aceite retiene partículas y contaminantes. '
          'Si se satura, el aceite circula sin filtrar y acelera el desgaste del motor.',
    ),
    (
      label: 'Filtro de aire',
      km: 20000,
      months: null,
      description:
          'Un filtro de aire sucio reduce la potencia, aumenta el consumo '
          'y puede dañar los sensores de admisión.',
    ),
    (
      label: 'Pastillas de freno',
      km: 30000,
      months: null,
      description:
          'El compuesto de fricción se desgasta con el uso. '
          'Por debajo de 3mm de grosor, la distancia de frenado aumenta peligrosamente.',
    ),
    (
      label: 'Neumáticos',
      km: 50000,
      months: null,
      description:
          'Los neumáticos se degradan tanto por kilometraje como por edad. '
          'La presión incorrecta o el desgaste irregular comprometen el agarre y la seguridad.',
    ),
    (
      label: 'Bujías',
      km: 40000,
      months: null,
      description:
          'Las bujías desgastadas aumentan el consumo, dificultan el arranque '
          'y pueden dañar la bobina de encendido.',
    ),
    (
      label: 'Correa de distribución',
      km: 100000,
      months: 60,
      description:
          'La correa de distribución es crítica: si se rompe, el motor sufre daños graves. '
          'Debe cambiarse según el intervalo del fabricante sin excepción.',
    ),
    (
      label: 'Líquido de frenos',
      km: 40000,
      months: 24,
      description:
          'El líquido de frenos es higroscópico: absorbe humedad, lo que reduce '
          'su punto de ebullición y la eficacia de la frenada.',
    ),
    (
      label: 'Líquido refrigerante',
      km: 60000,
      months: 36,
      description:
          'El refrigerante pierde propiedades anticongelantes y anticorrosivas '
          'con el tiempo, pudiendo dañar el circuito interno del motor.',
    ),
  ],
  VehicleType.electric: <_Preset>[
    (
      label: 'Pastillas de freno',
      km: 30000,
      months: null,
      description:
          'El compuesto de fricción se desgasta con el uso. '
          'Por debajo de 3mm de grosor, la distancia de frenado aumenta peligrosamente.',
    ),
    (
      label: 'Neumáticos',
      km: 50000,
      months: null,
      description:
          'Los neumáticos se degradan tanto por kilometraje como por edad. '
          'La presión incorrecta o el desgaste irregular comprometen el agarre y la seguridad.',
    ),
    (
      label: 'Refrigeración batería',
      km: 60000,
      months: null,
      description:
          'El sistema de refrigeración de la batería es vital para mantener '
          'la temperatura óptima y prolongar la vida útil de las celdas.',
    ),
    (
      label: 'Filtro habitáculo',
      km: 20000,
      months: null,
      description:
          'El filtro del habitáculo purifica el aire que ingresa al interior. '
          'Un filtro saturado reduce la eficiencia del climatizador y puede generar malos olores.',
    ),
    (
      label: 'Líquido de frenos',
      km: 40000,
      months: 24,
      description:
          'El líquido de frenos es higroscópico: absorbe humedad, lo que reduce '
          'su punto de ebullición y la eficacia de la frenada.',
    ),
    (
      label: 'Líquido refrigerante',
      km: 80000,
      months: 36,
      description:
          'El refrigerante pierde propiedades anticongelantes y anticorrosivas '
          'con el tiempo, pudiendo dañar el circuito interno.',
    ),
  ],
  VehicleType.motorcycle: <_Preset>[
    (
      label: 'Cadena (Limpieza y engrase)',
      km: 1000,
      months: null,
      description:
          'La cadena es el componente que más desgaste sufre. '
          'Una lubrificación regular prolonga su vida útil y evita roturas peligrosas.',
    ),
    (
      label: 'Presión y estado de neumáticos',
      km: 1000,
      months: null,
      description:
          'Los neumáticos se degradan tanto por kilometraje como por edad. '
          'La presión incorrecta o el desgaste irregular comprometen gravemente el agarre.',
    ),
    (
      label: 'Aceite de motor y filtro',
      km: 10000,
      months: 12,
      description:
          'El aceite pierde propiedades lubricantes con los kilómetros y el tiempo. '
          'Un cambio regular protege el motor del desgaste prematuro.',
    ),
    (
      label: 'Filtro de aire',
      km: 10000,
      months: null,
      description:
          'Un filtro de aire sucio reduce la potencia, aumenta el consumo '
          'y puede dañar los sensores de admisión.',
    ),
    (
      label: 'Pastillas de freno',
      km: 5000,
      months: null,
      description:
          'El compuesto de fricción se desgasta con el uso. '
          'Por debajo de 1.5mm de grosor, la seguridad se ve comprometida.',
    ),
    (
      label: 'Líquido de frenos',
      km: 999999,
      months: 24,
      description:
          'El líquido de frenos es higroscópico: absorbe humedad, lo que reduce '
          'su punto de ebullición y la eficacia de la frenada.',
    ),
    (
      label: 'Bujías',
      km: 20000,
      months: null,
      description:
          'Las bujías desgastadas aumentan el consumo, dificultan el arranque '
          'y pueden dañar la bobina de encendido.',
    ),
    (
      label: 'Reglaje de válvulas',
      km: 24000,
      months: null,
      description:
          'El ajuste de válvulas mantiene la compresión correcta '
          'y evita desgastes prematuros en la culata.',
    ),
    (
      label: 'Kit de arrastre (Cadena, piñón y corona)',
      km: 20000,
      months: null,
      description:
          'Cadena, piñón y corona se desgastan como conjunto. '
          'Cambiarlos por separado acelera el desgaste del componente nuevo.',
    ),
    (
      label: 'Aceite de horquilla',
      km: 30000,
      months: 36,
      description:
          'Con el tiempo se descompone, perdiendo densidad y empeorando '
          'el comportamiento de la suspensión delantera.',
    ),
    (
      label: 'Líquido refrigerante',
      km: 40000,
      months: 36,
      description:
          'El refrigerante pierde propiedades anticongelantes y anticorrosivas '
          'con el tiempo, pudiendo dañar el circuito interno.',
    ),
    (
      label: 'Batería',
      km: 50000,
      months: 48,
      description:
          'La batería pierde capacidad con los ciclos de carga y el tiempo. '
          'El uso de mantenedores en invierno prolonga su vida útil.',
    ),
  ],
};
