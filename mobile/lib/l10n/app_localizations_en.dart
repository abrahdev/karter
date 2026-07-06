// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVehicles => 'Vehicles';

  @override
  String get navMore => 'More';

  @override
  String get homeEmptyTitle => 'No vehicles';

  @override
  String get homeEmptySubtitle => 'Add your first vehicle';

  @override
  String homeError(Object error) {
    return 'Error: $error';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardComingSoon => 'Coming Soon';

  @override
  String get vehicleDetailTitle => 'Vehicle';

  @override
  String get vehicleNotFound => 'Vehicle not found';

  @override
  String get plate => 'Plate';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Brand / Model';

  @override
  String get year => 'Year';

  @override
  String get odometer => 'Odometer';

  @override
  String get update => 'Update';

  @override
  String get actions => 'Actions';

  @override
  String get fuelLogs => 'Fuel logs';

  @override
  String get maintenanceHistory => 'Maintenance history';

  @override
  String get configureIntervals => 'Configure intervals';

  @override
  String get nextMaintenance => 'Next Maintenance';

  @override
  String get allIntervalsDisabled => 'All intervals are disabled.';

  @override
  String get register => 'Register';

  @override
  String get registerService => 'Register service';

  @override
  String get noDescriptionAvailable =>
      'No description available. Go to Maintenance settings to add one.';

  @override
  String get close => 'Close';

  @override
  String get overduePerformService => 'Overdue — perform service';

  @override
  String nextIn(Object parts) {
    return 'Next in $parts';
  }

  @override
  String get vehicleFormNew => 'New vehicle';

  @override
  String get vehicleFormEdit => 'Edit vehicle';

  @override
  String get brand => 'Brand';

  @override
  String get model => 'Model';

  @override
  String get required => 'Required';

  @override
  String get invalidYear => 'Invalid year';

  @override
  String get vehicleType => 'Vehicle type';

  @override
  String get combustion => 'Combustion';

  @override
  String get electric => 'Electric';

  @override
  String get motorcycle => 'Motorcycle';

  @override
  String get plateOptional => 'Plate (optional)';

  @override
  String get vinOptional => 'VIN (optional)';

  @override
  String get invalid => 'Invalid';

  @override
  String get aliasOptional => 'Alias (optional)';

  @override
  String get aliasHint => 'E.g.: My ride, The beast, etc.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get addVehicle => 'Add vehicle';

  @override
  String get deleteVehicle => 'Delete vehicle';

  @override
  String get deleteVehicleConfirm =>
      'This action cannot be undone. All fuel logs, maintenance records, and intervals associated will be deleted.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get dataManagerTitle => 'Export / Import data';

  @override
  String get selectAll => 'Select all';

  @override
  String get exporting => 'Exporting...';

  @override
  String get export => 'Export';

  @override
  String get importing => 'Importing...';

  @override
  String get import => 'Import';

  @override
  String get saveExport => 'Save export';

  @override
  String exportedAt(Object path) {
    return 'Exported at $path';
  }

  @override
  String exportError(Object error) {
    return 'Export error: $error';
  }

  @override
  String get importData => 'Import data';

  @override
  String importPreview(
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Found:\n• $vehicles vehicle(s)\n• $fuelLogs fuel log(s)\n• $maintenanceLogs maintenance log(s)\n\nImport? Existing data with the same ID will be overwritten.';
  }

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String importError(Object error) {
    return 'Import error: $error';
  }

  @override
  String get invalidJson => 'Invalid JSON file';

  @override
  String exportShareText(Object count) {
    return 'Karter Export — $count vehicle(s)';
  }

  @override
  String get maintenanceSettingsTitle => 'Maintenance intervals';

  @override
  String get maintenanceSettingsInstruction =>
      'Enable or disable items according to your vehicle\'s needs. Custom intervals can be deleted.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Time (months)';

  @override
  String get months => 'months';

  @override
  String get description => 'Description';

  @override
  String get newInterval => 'New interval';

  @override
  String get name => 'Name';

  @override
  String get add => 'Add';

  @override
  String get edit => 'Edit';

  @override
  String get deleteInterval => 'Delete';

  @override
  String get noDescriptionAvailableSettings =>
      'No description available. Press \"Edit\" to add one.';

  @override
  String formattedKmK(Object km) {
    return '${km}k km';
  }

  @override
  String formattedKm(Object km) {
    return '$km km';
  }

  @override
  String intervalSubtitleKm(Object km) {
    return 'every $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months months';
  }

  @override
  String get maintenanceLogTitleEdit => 'Edit service';

  @override
  String get maintenanceLogTitleNew => 'New service';

  @override
  String date(Object date) {
    return 'Date: $date';
  }

  @override
  String get descriptionRequired => 'Description';

  @override
  String get odometerAtService => 'Odometer at service (optional)';

  @override
  String get resetInterval => 'Reset interval (optional)';

  @override
  String get saveChangesShort => 'Save changes';

  @override
  String get saveService => 'Save service';

  @override
  String get deleteService => 'Delete service';

  @override
  String get deleteServiceConfirm =>
      'Are you sure you want to delete this service?';

  @override
  String get maintenanceListTitle => 'Maintenance';

  @override
  String get maintenanceEmpty => 'No services recorded';

  @override
  String get maintenanceHistoryTab => 'History';

  @override
  String get maintenancePdfExportTab => 'PDF Export';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count service(s) in this period';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... and $count more';
  }

  @override
  String get maintenanceNoServicesInRange => 'No services in this date range.';

  @override
  String get maintenanceExportPdf => 'Export PDF';

  @override
  String get maintenanceSharePdf => 'Share';

  @override
  String get maintenanceReportTitle => 'Maintenance Report';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Generated $date $time';
  }

  @override
  String get maintenanceReportEmpty => 'No maintenance logs in this period.';

  @override
  String get maintenanceReportDateHeader => 'Date';

  @override
  String get maintenanceReportDescHeader => 'Description';

  @override
  String get maintenanceReportOdometerHeader => 'Odometer';

  @override
  String get fuelFormTitle => 'New fuel-up';

  @override
  String get volume => 'Volume';

  @override
  String get unitL => 'L';

  @override
  String get unitGal => 'gal';

  @override
  String get unitKm => 'km';

  @override
  String get unitMi => 'mi';

  @override
  String get pricePerUnit => 'Price per unit (optional)';

  @override
  String get fullTank => 'Full tank';

  @override
  String get saveFuelUp => 'Save fuel-up';

  @override
  String get fuelListTitle => 'Fuel logs';

  @override
  String get fuelEmpty => 'No fuel-ups recorded';

  @override
  String get moreAbout => 'About Karter';

  @override
  String get moreDescription =>
      'Karter is a local-first, open source vehicle maintenance app that respects your privacy.';

  @override
  String get moreExport => 'Export / Import data';

  @override
  String get moreExportSubtitle => 'Back up or transfer your information';

  @override
  String get moreDocs => 'Documentation';

  @override
  String get moreDocsSubtitle => 'Usage guide and features';

  @override
  String get moreSource => 'Source code';

  @override
  String get moreSourceSubtitle => 'GitHub repository';

  @override
  String get moreDonate => 'Donate';

  @override
  String get moreDonateSubtitle => 'Support development on GitHub Sponsors';

  @override
  String get moreFooter => 'Made with ❤️ by abrahdev';

  @override
  String moreUrlError(Object url) {
    return 'Could not open $url';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get odometerUpdateTitle => 'Update odometer';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Last: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'The value is lower than the last record ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'You drove $delta $unit since last time. Is this correct?';
  }

  @override
  String get odometerSave => 'Save';

  @override
  String get odometerCancel => 'Cancel';

  @override
  String get seedIntervalOilChange => 'Oil change';

  @override
  String get seedIntervalOilFilter => 'Oil filter';

  @override
  String get seedIntervalAirFilter => 'Air filter';

  @override
  String get seedIntervalBrakePads => 'Brake pads';

  @override
  String get seedIntervalTires => 'Tires';

  @override
  String get seedIntervalSparkPlugs => 'Spark plugs';

  @override
  String get seedIntervalTimingBelt => 'Timing belt';

  @override
  String get seedIntervalBrakeFluid => 'Brake fluid';

  @override
  String get seedIntervalCoolant => 'Coolant';

  @override
  String get seedIntervalBatteryCooling => 'Battery cooling';

  @override
  String get seedIntervalCabinFilter => 'Cabin filter';

  @override
  String get seedIntervalChain => 'Chain (Clean and lube)';

  @override
  String get seedIntervalTirePressure => 'Tire pressure and condition';

  @override
  String get seedIntervalEngineOilFilter => 'Engine oil and filter';

  @override
  String get seedIntervalValveAdjustment => 'Valve adjustment';

  @override
  String get seedIntervalDriveKit => 'Drive kit (Chain, sprocket, crown)';

  @override
  String get seedIntervalForkOil => 'Fork oil';

  @override
  String get seedIntervalBattery => 'Battery';

  @override
  String get seedIntervalFuelFilter => 'Fuel filter';

  @override
  String get seedIntervalEgrCleaning => 'EGR cleaning';

  @override
  String get seedIntervalDpfCleaning => 'DPF / FAP cleaning';

  @override
  String get seedIntervalGlowPlugs => 'Glow plugs';

  @override
  String get seedIntervalInverterCoolant => 'Inverter / motor coolant';

  @override
  String get seedIntervalDriveUnitOil => 'Drive unit oil';

  @override
  String get seedIntervalHybridBatteryFilter => 'Hybrid battery cooling filter';

  @override
  String get seedIntervalAdblueRefill => 'AdBlue / DEF refill';

  @override
  String get seedDescOilChange =>
      'Oil loses its lubricating properties with mileage and time. Regular changes protect the engine from premature wear.';

  @override
  String get seedDescOilFilter =>
      'The oil filter traps particles and contaminants. If saturated, oil circulates unfiltered and accelerates engine wear.';

  @override
  String get seedDescAirFilter =>
      'A dirty air filter reduces power, increases consumption, and can damage intake sensors.';

  @override
  String get seedDescBrakePads =>
      'Friction compound wears with use. Below 3mm thickness, braking distance increases dangerously.';

  @override
  String get seedDescTires =>
      'Tires degrade both by mileage and age. Incorrect pressure or uneven wear compromises grip and safety.';

  @override
  String get seedDescSparkPlugs =>
      'Worn spark plugs increase consumption, make starting difficult, and can damage the ignition coil.';

  @override
  String get seedDescTimingBelt =>
      'The timing belt is critical: if it breaks, the engine suffers severe damage. It must be changed at the manufacturer\'s interval without exception.';

  @override
  String get seedDescBrakeFluid =>
      'Brake fluid is hygroscopic: it absorbs moisture, reducing its boiling point and braking effectiveness.';

  @override
  String get seedDescCoolant =>
      'Coolant loses its antifreeze and anticorrosive properties over time, potentially damaging the engine\'s internal circuit.';

  @override
  String get seedDescBatteryCooling =>
      'The battery cooling system is vital for maintaining optimal temperature and prolonging cell life.';

  @override
  String get seedDescCabinFilter =>
      'The cabin filter purifies the air entering the interior. A saturated filter reduces HVAC efficiency and can generate odors.';

  @override
  String get seedDescChain =>
      'The chain is the component that suffers the most wear. Regular lubrication extends its life and prevents dangerous breakage.';

  @override
  String get seedDescMotorcycleBrakePads =>
      'Friction compound wears with use. Below 1.5mm thickness, safety is compromised.';

  @override
  String get seedDescValveAdjustment =>
      'Valve adjustment maintains proper compression and prevents premature wear on the cylinder head.';

  @override
  String get seedDescDriveKit =>
      'Chain, sprocket, and crown wear as a set. Replacing them separately accelerates wear on the new component.';

  @override
  String get seedDescForkOil =>
      'Over time it breaks down, losing density and worsening front suspension behavior.';

  @override
  String get seedDescBatteryMaintenance =>
      'Battery loses capacity with charge cycles and time. Using maintainers in winter prolongs its useful life.';

  @override
  String get seedDescFuelFilter =>
      'The fuel filter traps water and contaminants. A clogged filter causes power loss and hard starting.';

  @override
  String get seedDescEgrCleaning =>
      'Diesel peculiarity: the EGR valve accumulates soot over time. Cleaning restores engine efficiency and reduces emissions.';

  @override
  String get seedDescDpfCleaning =>
      'The diesel particulate filter accumulates ash. If not regenerated properly, it may need professional cleaning or replacement.';

  @override
  String get seedDescGlowPlugs =>
      'Glow plugs preheat the combustion chamber for cold starts. A failed plug causes misfiring and white smoke.';

  @override
  String get seedDescInverterCoolant =>
      'The power electronics and electric motor generate heat. Coolant prevents overheating and component failure.';

  @override
  String get seedDescDriveUnitOil =>
      'The reduction gear in the drive unit has its own oil. Change intervals vary by manufacturer.';

  @override
  String get seedDescHybridBatteryFilter =>
      'The hybrid battery has a dedicated cooling fan with an intake filter. Clean annually; replace if clogged.';

  @override
  String get seedDescAdblueRefill =>
      'The SCR system consumes AdBlue. Refill at each service or when warning appears.';
}
