import 'package:mobile/l10n/app_localizations.dart';

typedef _Getter = String Function(AppLocalizations);

String localizedLabel(AppLocalizations l, String? i18nKey, String fallback) {
  if (i18nKey == null) return fallback;
  final map = _labelGetters();
  final getter = map[i18nKey];
  if (getter == null) return fallback;
  return getter(l);
}

String localizedDesc(AppLocalizations l, String? descI18nKey, String fallback) {
  if (descI18nKey == null) return fallback;
  final map = _descGetters();
  final getter = map[descI18nKey];
  if (getter == null) return fallback;
  return getter(l);
}

Map<String, _Getter> _labelGetters() => {
      'seed_interval_oil_change': (l) => l.seedIntervalOilChange,
      'seed_interval_oil_filter': (l) => l.seedIntervalOilFilter,
      'seed_interval_air_filter': (l) => l.seedIntervalAirFilter,
      'seed_interval_brake_pads': (l) => l.seedIntervalBrakePads,
      'seed_interval_tires': (l) => l.seedIntervalTires,
      'seed_interval_spark_plugs': (l) => l.seedIntervalSparkPlugs,
      'seed_interval_timing_belt': (l) => l.seedIntervalTimingBelt,
      'seed_interval_brake_fluid': (l) => l.seedIntervalBrakeFluid,
      'seed_interval_coolant': (l) => l.seedIntervalCoolant,
      'seed_interval_battery_cooling': (l) => l.seedIntervalBatteryCooling,
      'seed_interval_cabin_filter': (l) => l.seedIntervalCabinFilter,
      'seed_interval_chain': (l) => l.seedIntervalChain,
      'seed_interval_tire_pressure': (l) => l.seedIntervalTirePressure,
      'seed_interval_engine_oil_filter': (l) => l.seedIntervalEngineOilFilter,
      'seed_interval_valve_adjustment': (l) => l.seedIntervalValveAdjustment,
      'seed_interval_drive_kit': (l) => l.seedIntervalDriveKit,
      'seed_interval_fork_oil': (l) => l.seedIntervalForkOil,
      'seed_interval_battery': (l) => l.seedIntervalBattery,
      'seed_interval_fuel_filter': (l) => l.seedIntervalFuelFilter,
      'seed_interval_egr_cleaning': (l) => l.seedIntervalEgrCleaning,
      'seed_interval_dpf_cleaning': (l) => l.seedIntervalDpfCleaning,
      'seed_interval_glow_plugs': (l) => l.seedIntervalGlowPlugs,
      'seed_interval_inverter_coolant': (l) => l.seedIntervalInverterCoolant,
      'seed_interval_drive_unit_oil': (l) => l.seedIntervalDriveUnitOil,
      'seed_interval_hybrid_battery_filter': (l) =>
          l.seedIntervalHybridBatteryFilter,
      'seed_interval_adblue_refill': (l) => l.seedIntervalAdblueRefill,
    };

Map<String, _Getter> _descGetters() => {
      'seed_desc_oil_change': (l) => l.seedDescOilChange,
      'seed_desc_oil_filter': (l) => l.seedDescOilFilter,
      'seed_desc_air_filter': (l) => l.seedDescAirFilter,
      'seed_desc_brake_pads': (l) => l.seedDescBrakePads,
      'seed_desc_tires': (l) => l.seedDescTires,
      'seed_desc_spark_plugs': (l) => l.seedDescSparkPlugs,
      'seed_desc_timing_belt': (l) => l.seedDescTimingBelt,
      'seed_desc_brake_fluid': (l) => l.seedDescBrakeFluid,
      'seed_desc_coolant': (l) => l.seedDescCoolant,
      'seed_desc_battery_cooling': (l) => l.seedDescBatteryCooling,
      'seed_desc_cabin_filter': (l) => l.seedDescCabinFilter,
      'seed_desc_chain': (l) => l.seedDescChain,
      'seed_desc_valve_adjustment': (l) => l.seedDescValveAdjustment,
      'seed_desc_drive_kit': (l) => l.seedDescDriveKit,
      'seed_desc_fork_oil': (l) => l.seedDescForkOil,
      'seed_desc_battery_maintenance': (l) => l.seedDescBatteryMaintenance,
      'seed_desc_motorcycle_brake_pads': (l) => l.seedDescMotorcycleBrakePads,
      'seed_desc_fuel_filter': (l) => l.seedDescFuelFilter,
      'seed_desc_egr_cleaning': (l) => l.seedDescEgrCleaning,
      'seed_desc_dpf_cleaning': (l) => l.seedDescDpfCleaning,
      'seed_desc_glow_plugs': (l) => l.seedDescGlowPlugs,
      'seed_desc_inverter_coolant': (l) => l.seedDescInverterCoolant,
      'seed_desc_drive_unit_oil': (l) => l.seedDescDriveUnitOil,
      'seed_desc_hybrid_battery_filter': (l) => l.seedDescHybridBatteryFilter,
      'seed_desc_adblue_refill': (l) => l.seedDescAdblueRefill,
    };
