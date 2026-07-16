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
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Se encontraron:\n• $vehicles vehículo(s)\n• $fuelLogs carga(s) de combustible\n• $maintenanceLogs registro(s) de mantenimiento\n• $documents documento(s)\n\n¿Importar? Los datos existentes con el mismo ID serán sobrescritos.';
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
  String get saveFile => 'Guardar archivo';

  @override
  String get lastService => 'Último';

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
  String get takePhoto => 'Tomar foto';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get browseFiles => 'Examinar archivos';

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
  String get moreRate => 'Calificar Karter';

  @override
  String get moreRateSubtitle => 'Dejá una reseña en la Play Store';

  @override
  String get ratePromptMessage =>
      '¿Te gusta Karter? ¡Una reseña ayuda a otros a descubrir la app!';

  @override
  String get rate => 'Calificar';

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
  String get moreNotifications => 'Notificaciones';

  @override
  String get moreNotificationsSubtitle =>
      'Recordatorios de odómetro y mantenimiento';

  @override
  String get notificationSettingsTitle => 'Configuración de notificaciones';

  @override
  String get notificationSettingsSubtitle =>
      'Configurá los recordatorios para este vehículo';

  @override
  String get notificationOdometerSection => 'Recordatorio de odómetro';

  @override
  String get notificationMaintenanceSection => 'Recordatorio de mantenimiento';

  @override
  String get notificationFreqLabel => 'Frecuencia de recordatorio';

  @override
  String get notificationFreqOff => 'Apagado';

  @override
  String notificationFreqValue(Object days) {
    return 'Cada $days días';
  }

  @override
  String get notificationMaintenanceToggle => 'Recordatorios de mantenimiento';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Recibí recordatorios diarios sobre el mantenimiento pendiente';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Pospuesto por $days día(s) más';
  }

  @override
  String get notificationSnoozeCancel => 'Cancelar posposición';

  @override
  String get notificationNoVehicles =>
      'Agregá un vehículo para configurar notificaciones';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Odómetro: $freq • Mantenimiento: $maint';
  }

  @override
  String get notificationConfigure => 'Configurar';

  @override
  String get notificationMaintOn => 'Encendido';

  @override
  String get notificationMaintOff => 'Apagado';

  @override
  String get notificationSnoozeAction => 'Posponer 1 semana';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Pospuesto hasta el $date';
  }

  @override
  String get notificationFreqWeekly => 'Cada 7 días';

  @override
  String get notificationFreqMonthly => 'Cada 30 días';

  @override
  String get notificationFreqCustom => 'Personalizado';

  @override
  String notificationFreqDays(Object days) {
    return '$days días';
  }

  @override
  String get notificationMaintenanceSnooze => 'Posponer mantenimiento 1 semana';

  @override
  String get notificationSnoozeToggle => 'Posponer recordatorios';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days días';
  }

  @override
  String get unsavedChanges => 'Cambios sin guardar';

  @override
  String get discardChangesConfirm =>
      'Tienes cambios sin aplicar. ¿Estás seguro de que quieres salir?';

  @override
  String get discard => 'Descartar';

  @override
  String get moreTemplateSource => 'Fuente de plantillas';

  @override
  String get moreTemplateSourceSubtitle =>
      'Obtener plantillas desde GitHub o usar locales';

  @override
  String get moreTemplateSourceOffline => 'Local (sin conexión)';

  @override
  String get moreTemplateSourceOnline => 'En línea (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL del repositorio';

  @override
  String get moreTemplateSourceReset => 'Restablecer valor por defecto';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://raw.githubusercontent.com/...';

  @override
  String get moreTemplateSourceEditUrl => 'Editar URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL actualizada';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingDone => 'Empezar';

  @override
  String get onboardingReplay => 'Ver introducción';

  @override
  String get onboardingReplaySubtitle => 'Repetir la guía de bienvenida';

  @override
  String get onboardingWelcomeTitle => 'Bienvenido a Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Un rastreador de mantenimiento vehicular open source y respetuoso con tu privacidad. 100% offline — sin cuentas ni telemetría.';

  @override
  String get onboardingVehicleTitle => 'Agregá tu vehículo';

  @override
  String get onboardingVehicleDesc =>
      'Registrá tu auto, moto o eléctrico. Elegí una plantilla y Karter completa los intervalos de mantenimiento.';

  @override
  String get onboardingTrackTitle => 'Rastreá combustible y mantenimiento';

  @override
  String get onboardingTrackDesc =>
      'Registrá cargas con cálculos automáticos de consumo. Rastreá reparaciones, repuestos y costos.';

  @override
  String get onboardingRemindersTitle => 'No te olvides del service';

  @override
  String get onboardingRemindersDesc =>
      'Recibí recordatorios para cambios de aceite, pastillas de freno y todos los intervalos de mantenimiento.';
}
