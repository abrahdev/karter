import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

List<IntervalPart> templateParts(
  TemplateResolution resolution,
  ResolvedItem item,
) {
  final byId = {for (final p in resolution.parts) p.id: p};
  return item.parts.entries.map((e) {
    final part = byId[e.key];
    return IntervalPart(
      partId: e.key,
      name: part?.name,
      i18nKey: part?.i18nKey,
      oemNumber: part?.oemNumber,
      quantity: e.value,
      unit: part?.unit,
      description: part?.description,
    );
  }).toList();
}

MaintenanceInterval intervalFromTemplate(
  String vehicleId,
  ResolvedItem item,
  TemplateResolution resolution,
) {
  return MaintenanceInterval(
    id: _uuid.v4(),
    vehicleId: vehicleId,
    label: item.label,
    i18nKey: item.i18nKey,
    descI18nKey: item.descI18nKey,
    kmInterval: item.intervalKm,
    monthsInterval: item.intervalMonths,
    description: item.description,
    isCustom: false,
    parts: templateParts(resolution, item),
  );
}

bool templateItemChanged(ResolvedItem item, MaintenanceInterval interval) {
  if (interval.kmInterval != item.intervalKm) {
    return true;
  }
  if (interval.monthsInterval != item.intervalMonths) {
    return true;
  }
  if (interval.description != item.description) {
    return true;
  }
  if (interval.label != item.label) {
    return true;
  }
  final current = {
    for (final p in interval.parts) p.partId: p.quantity,
  };
  if (current.length != item.parts.length) return true;
  for (final entry in item.parts.entries) {
    if (current[entry.key] != entry.value) return true;
  }
  return false;
}
