// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVehicles => 'Vehículos';

  @override
  String get navMore => 'Más';

  @override
  String get homeEmptyTitle => 'No hay vehículos';

  @override
  String get homeEmptySubtitle => 'Agrega tu primer vehículo';

  @override
  String homeError(Object error) {
    return 'Error: $error';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardComingSoon => 'Próximamente';

  @override
  String get vehicleDetailTitle => 'Vehículo';

  @override
  String get vehicleNotFound => 'Vehículo no encontrado';

  @override
  String get plate => 'Placa';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Marca / Modelo';

  @override
  String get year => 'Año';

  @override
  String get odometer => 'Odómetro';

  @override
  String get update => 'Actualizar';

  @override
  String get actions => 'Acciones';

  @override
  String get fuelLogs => 'Cargas de combustible';

  @override
  String get maintenanceHistory => 'Historial de mantenimiento';

  @override
  String get configureIntervals => 'Configurar intervalos';

  @override
  String get nextMaintenance => 'Próximo Mantenimiento';

  @override
  String get allIntervalsDisabled => 'Todos los intervalos están desactivados.';

  @override
  String get register => 'Registrar';

  @override
  String get registerService => 'Registrar servicio';

  @override
  String get noDescriptionAvailable =>
      'Sin descripción disponible. Ve a Ajustes de mantenimiento para añadir una.';

  @override
  String get close => 'Cerrar';

  @override
  String get overduePerformService => 'Vencido — realizá el servicio';

  @override
  String nextIn(Object parts) {
    return 'Próximo en $parts';
  }

  @override
  String get vehicleFormNew => 'Nuevo vehículo';

  @override
  String get vehicleFormEdit => 'Editar vehículo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modelo';

  @override
  String get required => 'Requerido';

  @override
  String get invalidYear => 'Año inválido';

  @override
  String get vehicleType => 'Tipo de vehículo';

  @override
  String get combustion => 'Combustión';

  @override
  String get electric => 'Eléctrico';

  @override
  String get motorcycle => 'Moto';

  @override
  String get plateOptional => 'Placa (opcional)';

  @override
  String get vinOptional => 'VIN (opcional)';

  @override
  String get invalid => 'Inválido';

  @override
  String get aliasOptional => 'Alias (opcional)';

  @override
  String get aliasHint => 'Ej: Mi nave, La bestia, etc.';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get addVehicle => 'Agregar vehículo';

  @override
  String get deleteVehicle => 'Eliminar vehículo';

  @override
  String get deleteVehicleConfirm =>
      'Esta acción no se puede deshacer. Se eliminarán todos los registros de combustible, mantenimiento e intervalos asociados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get dataManagerTitle => 'Exportar / Importar datos';

  @override
  String get selectAll => 'Seleccionar todos';

  @override
  String get exporting => 'Exportando...';

  @override
  String get export => 'Exportar';

  @override
  String get importing => 'Importando...';

  @override
  String get import => 'Importar';

  @override
  String get saveExport => 'Guardar exportación';

  @override
  String exportedAt(Object path) {
    return 'Exportado en $path';
  }

  @override
  String exportError(Object error) {
    return 'Error al exportar: $error';
  }

  @override
  String get importData => 'Importar datos';

  @override
  String importPreview(
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Se encontraron:\n• $vehicles vehículo(s)\n• $fuelLogs carga(s) de combustible\n• $maintenanceLogs registro(s) de mantenimiento\n\n¿Importar? Los datos existentes con el mismo ID serán sobrescritos.';
  }

  @override
  String get importSuccess => 'Datos importados correctamente';

  @override
  String importError(Object error) {
    return 'Error al importar: $error';
  }

  @override
  String get invalidJson => 'Archivo JSON inválido';

  @override
  String exportShareText(Object count) {
    return 'Exportación Karter — $count vehículo(s)';
  }

  @override
  String get maintenanceSettingsTitle => 'Intervalos de mantenimiento';

  @override
  String get maintenanceSettingsInstruction =>
      'Activa o desactiva los ítems según las necesidades de tu vehículo. Los intervalos personalizados se pueden eliminar.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Tiempo (meses)';

  @override
  String get months => 'meses';

  @override
  String get description => 'Descripción';

  @override
  String get newInterval => 'Nuevo intervalo';

  @override
  String get name => 'Nombre';

  @override
  String get add => 'Agregar';

  @override
  String get edit => 'Editar';

  @override
  String get deleteInterval => 'Eliminar';

  @override
  String get noDescriptionAvailableSettings =>
      'Sin descripción disponible. Pulsa \"Editar\" para añadir una.';

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
    return 'cada $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months meses';
  }

  @override
  String get maintenanceLogTitleEdit => 'Editar servicio';

  @override
  String get maintenanceLogTitleNew => 'Nuevo servicio';

  @override
  String date(Object date) {
    return 'Fecha: $date';
  }

  @override
  String get descriptionRequired => 'Descripción';

  @override
  String get odometerAtService => 'Odómetro al servicio (opcional)';

  @override
  String get resetInterval => 'Resetear intervalo (opcional)';

  @override
  String get saveChangesShort => 'Guardar cambios';

  @override
  String get saveService => 'Guardar servicio';

  @override
  String get addPhoto => 'Agregar foto';

  @override
  String get photos => 'fotos';

  @override
  String get deleteService => 'Eliminar servicio';

  @override
  String get deleteServiceConfirm => '¿Estás seguro de eliminar este servicio?';

  @override
  String get maintenanceListTitle => 'Mantenimiento';

  @override
  String get maintenanceEmpty => 'Sin servicios registrados';

  @override
  String get maintenanceHistoryTab => 'Historial';

  @override
  String get maintenancePdfExportTab => 'Exportar PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count servicio(s) en este período';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... y $count más';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Sin servicios en este rango de fechas.';

  @override
  String get maintenanceExportPdf => 'Exportar PDF';

  @override
  String get maintenanceSharePdf => 'Compartir';

  @override
  String get maintenanceReportTitle => 'Informe de mantenimiento';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Generado $date $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'Sin registros de mantenimiento en este período.';

  @override
  String get maintenanceReportDateHeader => 'Fecha';

  @override
  String get maintenanceReportDescHeader => 'Descripción';

  @override
  String get maintenanceReportOdometerHeader => 'Odómetro';

  @override
  String get addDocument => 'Agregar documento';

  @override
  String get documentType => 'Tipo de documento';

  @override
  String get selectFile => 'Seleccionar archivo';

  @override
  String get noFileSelected => 'Ningún archivo seleccionado';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get expiryDateOptional => 'Fecha de vencimiento (opcional)';

  @override
  String get pleaseSelectFile => 'Por favor seleccioná un archivo';

  @override
  String get documentSaved => 'Documento guardado';

  @override
  String get docTypeFine => 'Multa';

  @override
  String get docTypeParkingFee => 'Estacionamiento';

  @override
  String get docTypeInsurance => 'Seguro';

  @override
  String get docTypeVehicleCheck => 'Revisión técnica';

  @override
  String get docTypeTax => 'Impuesto';

  @override
  String get docTypeComplexInsurance => 'Seguro complejo';

  @override
  String get docTypeVehicleRegister => 'Registro del vehículo';

  @override
  String get docTypeOther => 'Otro';

  @override
  String get vehicleDocuments => 'Documentos';

  @override
  String get fuelFormTitle => 'Nueva carga';

  @override
  String get volume => 'Volumen';

  @override
  String get unitL => 'L';

  @override
  String get unitGal => 'gal';

  @override
  String get unitKm => 'km';

  @override
  String get unitMi => 'mi';

  @override
  String get pricePerUnit => 'Precio por unidad (opcional)';

  @override
  String get fullTank => 'Tanque lleno';

  @override
  String get volumeUnit => 'Unidad de volumen';

  @override
  String get currency => 'Moneda';

  @override
  String get cost => 'Costo (opcional)';

  @override
  String get saveFuelUp => 'Guardar carga';

  @override
  String get fuelListTitle => 'Cargas de combustible';

  @override
  String get fuelEmpty => 'Sin cargas registradas';

  @override
  String get moreAbout => 'Acerca de Karter';

  @override
  String get moreDescription =>
      'Karter es una app de mantenimiento de vehículos local-first, open source y respetuosa con tu privacidad.';

  @override
  String get moreExport => 'Exportar / Importar datos';

  @override
  String get moreExportSubtitle => 'Respaldar o transferir tu información';

  @override
  String get moreDocs => 'Documentación';

  @override
  String get moreDocsSubtitle => 'Guía de uso y características';

  @override
  String get moreSource => 'Código fuente';

  @override
  String get moreSourceSubtitle => 'Repositorio en GitHub';

  @override
  String get moreDonate => 'Donar';

  @override
  String get moreDonateSubtitle => 'Apoya el desarrollo en GitHub Sponsors';

  @override
  String get moreFooter => 'Hecho con ❤️ por abrahdev';

  @override
  String moreUrlError(Object url) {
    return 'No se pudo abrir $url';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get odometerUpdateTitle => 'Actualizar odómetro';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Último: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'El valor es menor al último registro ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Recorriste $delta $unit desde la última vez. ¿Es correcto?';
  }

  @override
  String get odometerSave => 'Guardar';

  @override
  String get odometerCancel => 'Cancelar';

  @override
  String get seedIntervalOilChange => 'Cambio de aceite';

  @override
  String get seedIntervalOilFilter => 'Filtro de aceite';

  @override
  String get seedIntervalAirFilter => 'Filtro de aire';

  @override
  String get seedIntervalBrakePads => 'Pastillas de freno';

  @override
  String get seedIntervalTires => 'Neumáticos';

  @override
  String get seedIntervalSparkPlugs => 'Bujías';

  @override
  String get seedIntervalTimingBelt => 'Correa de distribución';

  @override
  String get seedIntervalBrakeFluid => 'Líquido de frenos';

  @override
  String get seedIntervalCoolant => 'Líquido refrigerante';

  @override
  String get seedIntervalBatteryCooling => 'Refrigeración batería';

  @override
  String get seedIntervalCabinFilter => 'Filtro habitáculo';

  @override
  String get seedIntervalChain => 'Cadena (Limpieza y engrase)';

  @override
  String get seedIntervalTirePressure => 'Presión y estado de neumáticos';

  @override
  String get seedIntervalEngineOilFilter => 'Aceite de motor y filtro';

  @override
  String get seedIntervalValveAdjustment => 'Reglaje de válvulas';

  @override
  String get seedIntervalDriveKit => 'Kit de arrastre (Cadena, piñón y corona)';

  @override
  String get seedIntervalForkOil => 'Aceite de horquilla';

  @override
  String get seedIntervalBattery => 'Batería';

  @override
  String get seedIntervalFuelFilter => 'Filtro de combustible';

  @override
  String get seedIntervalEgrCleaning => 'Limpieza de EGR';

  @override
  String get seedIntervalDpfCleaning => 'Limpieza de DPF / FAP';

  @override
  String get seedIntervalGlowPlugs => 'Bujías de precalentamiento';

  @override
  String get seedIntervalInverterCoolant => 'Refrigerante del inversor / motor';

  @override
  String get seedIntervalDriveUnitOil => 'Aceite de la unidad de transmisión';

  @override
  String get seedIntervalHybridBatteryFilter =>
      'Filtro de refrigeración batería híbrida';

  @override
  String get seedIntervalAdblueRefill => 'Recarga de AdBlue / DEF';

  @override
  String get seedDescOilChange =>
      'El aceite pierde propiedades lubricantes con los kilómetros y el tiempo. Un cambio regular protege el motor del desgaste prematuro.';

  @override
  String get seedDescOilFilter =>
      'El filtro de aceite retiene partículas y contaminantes. Si se satura, el aceite circula sin filtrar y acelera el desgaste del motor.';

  @override
  String get seedDescAirFilter =>
      'Un filtro de aire sucio reduce la potencia, aumenta el consumo y puede dañar los sensores de admisión.';

  @override
  String get seedDescBrakePads =>
      'El compuesto de fricción se desgasta con el uso. Por debajo de 3mm de grosor, la distancia de frenado aumenta peligrosamente.';

  @override
  String get seedDescTires =>
      'Los neumáticos se degradan tanto por kilometraje como por edad. La presión incorrecta o el desgaste irregular comprometen el agarre y la seguridad.';

  @override
  String get seedDescSparkPlugs =>
      'Las bujías desgastadas aumentan el consumo, dificultan el arranque y pueden dañar la bobina de encendido.';

  @override
  String get seedDescTimingBelt =>
      'La correa de distribución es crítica: si se rompe, el motor sufre daños graves. Debe cambiarse según el intervalo del fabricante sin excepción.';

  @override
  String get seedDescBrakeFluid =>
      'El líquido de frenos es higroscópico: absorbe humedad, lo que reduce su punto de ebullición y la eficacia de la frenada.';

  @override
  String get seedDescCoolant =>
      'El refrigerante pierde propiedades anticongelantes y anticorrosivas con el tiempo, pudiendo dañar el circuito interno del motor.';

  @override
  String get seedDescBatteryCooling =>
      'El sistema de refrigeración de la batería es vital para mantener la temperatura óptima y prolongar la vida útil de las celdas.';

  @override
  String get seedDescCabinFilter =>
      'El filtro del habitáculo purifica el aire que ingresa al interior. Un filtro saturado reduce la eficiencia del climatizador y puede generar malos olores.';

  @override
  String get seedDescChain =>
      'La cadena es el componente que más desgaste sufre. Una lubrificación regular prolonga su vida útil y evita roturas peligrosas.';

  @override
  String get seedDescMotorcycleBrakePads =>
      'El compuesto de fricción se desgasta con el uso. Por debajo de 1.5mm de grosor, la seguridad se ve comprometida.';

  @override
  String get seedDescValveAdjustment =>
      'El ajuste de válvulas mantiene la compresión correcta y evita desgastes prematuros en la culata.';

  @override
  String get seedDescDriveKit =>
      'Cadena, piñón y corona se desgastan como conjunto. Cambiarlos por separado acelera el desgaste del componente nuevo.';

  @override
  String get seedDescForkOil =>
      'Con el tiempo se descompone, perdiendo densidad y empeorando el comportamiento de la suspensión delantera.';

  @override
  String get seedDescBatteryMaintenance =>
      'La batería pierde capacidad con los ciclos de carga y el tiempo. El uso de mantenedores en invierno prolonga su vida útil.';

  @override
  String get seedDescFuelFilter =>
      'El filtro de combustible retiene agua y contaminantes. Un filtro obstruido causa pérdida de potencia y dificultad de arranque.';

  @override
  String get seedDescEgrCleaning =>
      'Particularidad diésel: la válvula EGR acumula hollín con el tiempo. La limpieza restaura la eficiencia del motor y reduce emisiones.';

  @override
  String get seedDescDpfCleaning =>
      'El filtro de partículas diésel acumula cenizas. Si no se regenera correctamente, puede necesitar limpieza profesional o reemplazo.';

  @override
  String get seedDescGlowPlugs =>
      'Las bujías de precalentamiento calientan la cámara de combustión para arranques en frío. Una bujía fallada causa tirones y humo blanco.';

  @override
  String get seedDescInverterCoolant =>
      'Los electrónicos de potencia y el motor eléctrico generan calor. El refrigerante evita el sobrecalentamiento y la falla de componentes.';

  @override
  String get seedDescDriveUnitOil =>
      'El engranaje reductor de la unidad de transmisión tiene su propio aceite. Los intervalos de cambio varían según el fabricante.';

  @override
  String get seedDescHybridBatteryFilter =>
      'La batería híbrida tiene un ventilador de refrigeración con filtro de admisión. Limpiar anualmente; reemplazar si está obstruido.';

  @override
  String get seedDescAdblueRefill =>
      'El sistema SCR consume AdBlue. Recargar en cada servicio o cuando aparezca el aviso.';
}
