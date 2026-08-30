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
  String get navObd => 'OBD II';

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
  String get plate => 'Matrícula';

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
  String get tools => 'Herramientas';

  @override
  String get information => 'Información';

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
  String get retry => 'Reintentar';

  @override
  String get overduePerformService => 'Vencido — realiza el servicio';

  @override
  String nextIn(Object parts) {
    return 'Próximo en $parts';
  }

  @override
  String get vehicleFormNew => 'Nuevo vehículo';

  @override
  String get vehicleFormEdit => 'Editar vehículo';

  @override
  String get vehicleFormDetails => 'Detalles';

  @override
  String get vehicleFormVehicle => 'Vehículo';

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
  String get plateOptional => 'Matrícula (opcional)';

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
  String get newVehicleServicesOverdueTitle =>
      'Los servicios aparecen como vencidos';

  @override
  String get newVehicleServicesOverdueBody =>
      'Como tu vehículo ya tiene más de 500 km, todos los servicios de mantenimiento aparecen como vencidos.\n\nRegistra los servicios que ya hayas realizado. Si no recuerdas el kilometraje exacto, indica unos km aproximados del último servicio.';

  @override
  String get deleteVehicle => 'Eliminar vehículo';

  @override
  String get deleteVehicleConfirm =>
      'Esta acción no se puede deshacer. Se eliminarán todos los registros de combustible, mantenimiento e intervalos asociados.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetToDefault => 'Restablecer por defecto';

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
  String get partsTitle => 'Repuestos';

  @override
  String get partUnitUnit => 'unidad';

  @override
  String get partUnitSet => 'juego';

  @override
  String get partUnitKit => 'kit';

  @override
  String get partUnitCan => 'lata';

  @override
  String get partUnitLabel => 'Unidad';

  @override
  String get localParts => 'Repuestos locales';

  @override
  String get intervalParts => 'Repuestos de intervalos';

  @override
  String get newPart => 'Nuevo repuesto';

  @override
  String get createPart => 'Crear repuesto';

  @override
  String get partsSection => 'Repuestos';

  @override
  String get usedParts => 'Repuestos';

  @override
  String usedInServicesCount(Object count) {
    return '$count servicio(s)';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Este repuesto se usa en $count servicio(s). ¿Eliminarlo de todos modos?';
  }

  @override
  String get reportPartsHeader => 'Repuestos';

  @override
  String get templateFound => 'Plantilla encontrada';

  @override
  String get templateDisclaimer =>
      'Los datos de la plantilla son solo de referencia. Verifica siempre los intervalos con el manual de tu vehículo.';

  @override
  String get noTemplate => 'Sin plantilla';

  @override
  String get useTemplate => 'Usar plantilla';

  @override
  String get searchTemplate => 'Buscar plantilla';

  @override
  String templateWithName(Object name) {
    return 'Plantilla: $name';
  }

  @override
  String get noResultsTitle => 'Sin resultados';

  @override
  String get noTemplateFoundDescription =>
      'No se encontró ninguna plantilla para los datos ingresados.';

  @override
  String get searchParameters => 'Parámetros de búsqueda:';

  @override
  String get defaultIntervalsHint =>
      'El vehículo usará intervalos predeterminados.';

  @override
  String get missingTemplateContribute =>
      '¿Falta una plantilla? Contribuye en github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Ver todas las plantillas';

  @override
  String get contribute => 'Contribuir';

  @override
  String get contributeOnGitHub => 'Contribuye en GitHub';

  @override
  String get gotIt => 'Entendido';

  @override
  String get templateUnderConstruction => 'Plantilla en construcción';

  @override
  String get templateNotReady =>
      'Esta plantilla aún no está lista.\n¡Estamos trabajando en ello!';

  @override
  String get contributionsWelcome =>
      'Las contribuciones son bienvenidas: añade o corrige plantillas para tu vehículo:';

  @override
  String requestedParam(Object params) {
    return 'Solicitado: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      '¿Seguro que quieres eliminar este intervalo?';

  @override
  String get addPart => 'Añadir repuesto';

  @override
  String get partName => 'Nombre del repuesto';

  @override
  String get quantity => 'Cant.';

  @override
  String get oemNumber => 'Número OEM';

  @override
  String get addLink => 'Añadir enlace';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Abrir';

  @override
  String get noLinks => 'Sin enlaces';

  @override
  String get noParts => 'Aún no hay repuestos';

  @override
  String get invalidUrl => 'URL no válida';

  @override
  String get copied => 'Copiado';

  @override
  String get linksTitle => 'Enlaces de referencia';

  @override
  String get copy => 'Copiar';

  @override
  String get addModeManual => 'Manual';

  @override
  String get addModeTemplate => 'Plantilla';

  @override
  String get newFromTemplate => 'Nuevos de la plantilla';

  @override
  String get updatesAvailable => 'Actualizaciones disponibles';

  @override
  String get restore => 'Restaurar';

  @override
  String get windowMinimize => 'Minimizar';

  @override
  String get windowMaximize => 'Maximizar';

  @override
  String get windowClose => 'Cerrar';

  @override
  String get syncInstruction =>
      'Sincroniza los intervalos de mantenimiento desde la plantilla de tu vehículo.';

  @override
  String get upToDate => 'Todo al día';

  @override
  String get syncAdded => 'Intervalo añadido desde la plantilla';

  @override
  String get syncRestored => 'Intervalo restaurado desde la plantilla';

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
  String get addToDashboard => 'Agregar al panel';

  @override
  String get setupNotifications => 'Configurar notificaciones';

  @override
  String get addToDashboardComingSoon => 'Próximamente';

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
  String get files => 'archivos';

  @override
  String get share => 'Compartir';

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
  String get pleaseSelectFile => 'Por favor selecciona un archivo';

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
  String get moreRateSubtitle => 'Deja una reseña en la Play Store';

  @override
  String get moreFeedback => 'Calificar la aplicación';

  @override
  String get moreFeedbackSubtitle =>
      'Califica la app y configura recordatorios';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Preferencias';

  @override
  String get sectionData => 'Datos';

  @override
  String get sectionFeedbackCommunity => 'Feedback y Comunidad';

  @override
  String get sectionTips => 'Programa de propinas';

  @override
  String get sectionAbout => 'Acerca de Karter';

  @override
  String get theme => 'Tema';

  @override
  String get themeAutomatic => 'Automático';

  @override
  String get themeAutomaticDesc => 'Seguir ajuste del dispositivo';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeSystemDesc => 'Seguir ajuste del dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get colorScheme => 'Color primario';

  @override
  String get colorCustom => 'Personalizado';

  @override
  String get colorOfInterface => 'Color de interfaz';

  @override
  String get colorOfInterfaceDesc =>
      'Aplicar color primario a las superficies de fondo';

  @override
  String get customColor => 'Color personalizado';

  @override
  String get customColorDesc =>
      'Usar un color propio en lugar del accent del sistema';

  @override
  String get selectColor => 'Elige un color';

  @override
  String get hapticFeedback => 'Respuesta háptica';

  @override
  String get hapticFeedbackDesc => 'Vibrar en las interacciones';

  @override
  String get hapticModeOff => 'Desactivado';

  @override
  String get hapticModeOffDesc => 'Sin vibración en interacciones';

  @override
  String get hapticModeClear => 'Claro';

  @override
  String get hapticModeClearDesc => 'Un solo golpe nítido por acción';

  @override
  String get hapticModeRich => 'Avanzado';

  @override
  String get hapticModeRichDesc =>
      'Vibraciones escalonadas con intensidad variable';

  @override
  String get testNotification => 'Notificación de prueba';

  @override
  String get testNotificationDesc =>
      'Enviar una notificación para verificar que funciona';

  @override
  String get testNotificationSent => 'Notificación de prueba enviada';

  @override
  String get notificationsPermissionTitle => 'Notificaciones desactivadas';

  @override
  String get notificationsPermissionDesc =>
      'Activa las notificaciones para recibir recordatorios de odómetro y mantenimiento';

  @override
  String get notificationsPermissionAllow => 'Permitir notificaciones';

  @override
  String get notificationsPermissionDeniedTitle => 'Notificaciones bloqueadas';

  @override
  String get notificationsPermissionDeniedDesc =>
      'El permiso de notificaciones fue denegado permanentemente. Para activarlo, ve a Ajustes > Aplicaciones > Karter > Notificaciones y actívalas.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Abre Ajustes del dispositivo';

  @override
  String get notificationsPermissionDeniedStep2 =>
      '2. Ve a Aplicaciones > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Toca Notificaciones';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Activa \"Mostrar notificaciones\"';

  @override
  String get notificationsPermissionOpenSettings => 'Abrir ajustes';

  @override
  String get shakeToOdometer => 'Agitar para actualizar cuentakilómetros';

  @override
  String get shakeToOdometerDesc =>
      'Agita el dispositivo para abrir la actualización del cuentakilómetros en la pantalla del vehículo';

  @override
  String get feedbackReminderToggle => 'Recordatorio de valoración';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Mostrar un recordatorio para calificar después de guardar servicios';

  @override
  String get feedbackServicesInterval => 'Servicios antes del aviso';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Después de $count servicio(s)';
  }

  @override
  String get feedbackServicesSuffix => 'servicios';

  @override
  String get feedbackRepeatDays => 'Intervalo del recordatorio';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Cada $days día(s)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'días';

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
  String get tipProgram => 'Programa de propinas';

  @override
  String get tipProgramComingSoon =>
      'Esta funcionalidad está en desarrollo y estará disponible pronto.';

  @override
  String get tipBadges => 'Insignias';

  @override
  String get tipBadgesNone => 'Ninguna';

  @override
  String get tipInfo => 'Información';

  @override
  String get tipInfoText =>
      'El programa de propinas es una forma de que los usuarios muestren apoyo y agradecimiento extra por el soporte rápido, las mejoras constantes y las actualizaciones continuas que Karter ha ofrecido.';

  @override
  String get tipOneTime => 'Propina única';

  @override
  String get tipRecurring => 'Propina recurrente';

  @override
  String get tipBronze => 'Bronce';

  @override
  String get tipSilver => 'Plata';

  @override
  String get tipGold => 'Oro';

  @override
  String get tipBronzePrice => 'Propina de bronce';

  @override
  String get tipSilverPrice => 'Propina de plata';

  @override
  String get tipGoldPrice => 'Propina de oro';

  @override
  String get tipBronzeMonthly => 'Bronce / mes';

  @override
  String get tipSilverMonthly => 'Plata / mes';

  @override
  String get tipGoldMonthly => 'Oro / mes';

  @override
  String get officialWebsite => 'Sitio web oficial';

  @override
  String get communityForums => 'Foros de la comunidad';

  @override
  String get translations => 'Traducciones';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPolicyDesc =>
      'Lee nuestra política de privacidad en línea.';

  @override
  String get openPrivacyPolicy => 'Abrir política de privacidad';

  @override
  String get version => 'Versión';

  @override
  String get deviceId => 'ID del dispositivo';

  @override
  String get changelog => 'Registro de cambios';

  @override
  String get openSourceLicenses => 'Licencias de código abierto';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get eesti => 'Eesti';

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
      'Configura los recordatorios para este vehículo';

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
      'Recibe recordatorios diarios sobre el mantenimiento pendiente';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Pospuesto por $days día(s) más';
  }

  @override
  String get notificationSnoozeCancel => 'Cancelar posposición';

  @override
  String get notificationNoVehicles =>
      'Añade un vehículo para configurar notificaciones';

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
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Editar URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL actualizada';

  @override
  String get testConnection => 'Probar conexión';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Última modificación: $date';
  }

  @override
  String get importCheckTranslations => 'Traducciones';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found de $total disponibles';
  }

  @override
  String get importCheckIndex => 'Índice de plantillas';

  @override
  String importCheckIndexResult(int count) {
    return '$count plantillas';
  }

  @override
  String get importCheckDb => 'Base de datos del catálogo (remota)';

  @override
  String get importCheckDbRemoteFound => 'Disponible en GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Solo local (no en GitHub)';

  @override
  String get importCheckDbLocal => 'Datos de la base de datos importada';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Versión: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Vehículos: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Tareas de mantenimiento: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Repuestos: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Códigos OBD: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'No se pudo leer la base de datos importada';

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
      'Una aplicación de código abierto para el seguimiento del mantenimiento de vehículos que da prioridad a la privacidad. 100 % sin conexión: sin cuentas, sin telemetría, sin seguimiento.';

  @override
  String get onboardingVehicleTitle => 'Añade tu vehículo';

  @override
  String get onboardingVehicleDesc =>
      'Registra tu coche, moto o vehículo eléctrico. Elige una plantilla y Karter completará automáticamente los intervalos de mantenimiento correspondientes a tu modelo.';

  @override
  String get onboardingTrackTitle =>
      'Llevar un control del combustible y el mantenimiento';

  @override
  String get onboardingTrackDesc =>
      'Registra los repostajes con cálculos automáticos de consumo (MPG, L/100 km, km/L). Lleva un control de las reparaciones, las piezas y los costes.';

  @override
  String get onboardingRemindersTitle => 'Mantente al día con el servicio';

  @override
  String get onboardingRemindersDesc =>
      'Recibe notificaciones cuando llegue el momento de cambiar el aceite, las pastillas de freno y en cada intervalo de mantenimiento, ya sea por distancia o por tiempo.';

  @override
  String get supporterBadge => '¡Eres un colaborador de Karter!';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get tipPurchased => '¡Gracias!';

  @override
  String get tipSupport => 'Apoyar';

  @override
  String get sectionBackup => 'Copia de seguridad';

  @override
  String get moreBackup => 'Copia de seguridad';

  @override
  String get moreBackupSubtitle => 'Copia cifrada';

  @override
  String get backupConnect => 'Conectar Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Conectado como $email';
  }

  @override
  String get backupNow => 'Copiar ahora';

  @override
  String get backupInProgress => 'Copiando…';

  @override
  String backupLast(Object date) {
    return 'Última copia: $date';
  }

  @override
  String get backupNever => 'Sin copias';

  @override
  String get backupRestore => 'Restaurar desde copia';

  @override
  String get backupRestoreInProgress => 'Restaurando…';

  @override
  String get backupRestoreConfirm =>
      'Esto sobrescribirá todos los datos actuales. ¿Estás seguro?';

  @override
  String backupError(Object error) {
    return 'Error de copia: $error';
  }

  @override
  String get backupSuccess => 'Copia subida exitosamente';

  @override
  String get backupRestoreSuccess =>
      'Datos restaurados. Reinicia la app para ver los cambios.';

  @override
  String get backupDisconnect => 'Desconectar';

  @override
  String get backupNoBackups => 'No se encontraron copias';

  @override
  String get backupRestoreBtn => 'Restaurar';

  @override
  String get backupDelete => 'Eliminar';

  @override
  String backupDeleteConfirm(Object name) {
    return '¿Eliminar copia $name?';
  }

  @override
  String get backupDeleteSuccess => 'Copia eliminada';

  @override
  String backupCount(Object current, Object max) {
    return 'Copias: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Consulta de códigos de fallo';

  @override
  String get dtcSearchHint => 'Introduce un código, p. ej. P0171';

  @override
  String get dtcEmptyState => 'Escribe un código para ver su descripción';

  @override
  String get dtcNoMatch => 'Ningún código coincide con tu búsqueda';

  @override
  String get dtcDescription => 'Descripción';

  @override
  String get dtcRelatedMaintenance => 'Mantenimiento relacionado';

  @override
  String get dtcScopeStandard => 'Estándar';

  @override
  String get dtcScopeManufacturer => 'Fabricante';

  @override
  String get dtcGeneralDb => 'Códigos OBD-II generales';

  @override
  String get dtcCatalogBrands => 'Marcas del catálogo';

  @override
  String get dtcMyVehicles => 'Mis vehículos';

  @override
  String get dtcVehicle => 'Vehículo';

  @override
  String get dtcVehicleNotFound => 'Vehículo no encontrado';

  @override
  String get dtcLoadError => 'No se pudieron cargar los códigos de fallo';

  @override
  String get notificationOdometerTitle => 'Actualiza el odómetro';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — han pasado $days días desde el último recordatorio.';
  }

  @override
  String get notificationMaintenanceTitle => 'Mantenimiento pendiente';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — revisa el estado de los intervalos de mantenimiento.';
  }

  @override
  String errorGeneric(String error) {
    return 'Error: $error';
  }

  @override
  String get deleteFuelUp => 'Eliminar repostaje';

  @override
  String get deleteFuelUpConfirm =>
      '¿Seguro que quieres eliminar este repostaje?';

  @override
  String get editFuelUp => 'Editar repostaje';

  @override
  String get deleteDocument => 'Eliminar documento';

  @override
  String get deleteDocumentConfirm =>
      '¿Seguro que quieres eliminar este documento?';

  @override
  String get editDocument => 'Editar documento';

  @override
  String get title => 'Título';

  @override
  String get selectExpiryDate => 'Seleccionar fecha de vencimiento';

  @override
  String get addMoreFiles => 'Añadir más archivos';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Plantillas';

  @override
  String get templatesTitle => 'Plantillas';

  @override
  String get templatesSubtitle =>
      'Explora el catálogo de plantillas de la comunidad';

  @override
  String get createTemplate => 'Crear plantilla';

  @override
  String get createTemplateSubtitle =>
      'Redacta una plantilla y expórtala como JSON';

  @override
  String get templatesLoadError =>
      'No se pudo cargar el catálogo de plantillas.';

  @override
  String get searchTemplatesHint => 'Buscar por marca, modelo o generación';

  @override
  String get allMakes => 'Todas las marcas';

  @override
  String get noTemplatesFound => 'Ninguna plantilla coincide con tu búsqueda.';

  @override
  String templateItemsCount(int count) {
    return '$count elementos de mantenimiento';
  }

  @override
  String get templateYearsOpen => 'actualidad';

  @override
  String get templateNotFound => 'Plantilla no encontrada';

  @override
  String get templateInfo => 'Información de la plantilla';

  @override
  String get templateYears => 'Años';

  @override
  String get templateEngine => 'Motor';

  @override
  String get templateAuthor => 'Autor';

  @override
  String get templateVersion => 'Versión';

  @override
  String get templateSources => 'Fuentes';

  @override
  String get dtcCodesTitle => 'Códigos de avería';

  @override
  String dtcCount(int count) {
    return '$count código(s) de avería';
  }

  @override
  String get noPartsFound => 'Sin piezas';

  @override
  String get createCopied => 'JSON de la plantilla copiado al portapapeles';

  @override
  String get saveTemplate => 'Guardar plantilla';

  @override
  String savedAt(String path) {
    return 'Guardado en $path';
  }

  @override
  String get createHasErrors => 'Corrige los errores para exportar';

  @override
  String get createMake => 'Marca';

  @override
  String get createModel => 'Modelo';

  @override
  String get createGeneration => 'Generación';

  @override
  String get createYearFrom => 'Año desde';

  @override
  String get createYearTo => 'Año hasta';

  @override
  String get createFuel => 'Combustible';

  @override
  String get createPowertrain => 'Propulsión';

  @override
  String get createEngineCode => 'Código de motor';

  @override
  String get createDisplacement => 'Cilindrada (cc)';

  @override
  String get createPower => 'Potencia (cv)';

  @override
  String get templateMetadata => 'Metadatos y herencia';

  @override
  String get createAuthor => 'Autor';

  @override
  String get createAuthorHint => 'Tu usuario de GitHub';

  @override
  String get createExtends => 'Extiende (plantillas base)';

  @override
  String get createExtendsHint => 'Hereda datos de mantenimiento compartidos';

  @override
  String get createCustomExtends => 'Rutas de extends personalizadas';

  @override
  String get createAddPart => 'Añadir pieza';

  @override
  String get createNoParts => 'Aún no hay piezas. Las piezas son opcionales.';

  @override
  String get partSingular => 'Pieza';

  @override
  String get createAddItem => 'Añadir elemento de mantenimiento';

  @override
  String get createNoItems => 'Aún no hay elementos de mantenimiento.';

  @override
  String get createPreview => 'Vista previa';

  @override
  String createErrorsFound(int count) {
    return '$count error(es) de validación';
  }

  @override
  String get createCopy => 'Copiar';

  @override
  String get createShare => 'Compartir';

  @override
  String get createSave => 'Guardar';

  @override
  String get createQuantity => 'Cantidad';

  @override
  String get createI18nKey => 'Clave i18n';

  @override
  String get createDescI18nKey => 'Clave i18n de la descripción';

  @override
  String get createIntervalKm => 'Intervalo (km)';

  @override
  String get createIntervalMonths => 'Intervalo (meses)';

  @override
  String get createDescription => 'Descripción';

  @override
  String get createAddPartRef => 'Añadir referencia de pieza';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nombre';

  @override
  String get createFieldUnit => 'Unidad';

  @override
  String get createFieldOem => 'Referencia OEM';

  @override
  String get createFieldLabel => 'Etiqueta';

  @override
  String get createFieldPart => 'Pieza';

  @override
  String get fuelGasoline => 'Gasolina';

  @override
  String get fuelDiesel => 'Diésel';

  @override
  String get fuelLpg => 'GLP';

  @override
  String get fuelCng => 'GNC';

  @override
  String get fuelHydrogen => 'Hidrógeno';

  @override
  String get fuelEthanol => 'Etanol';

  @override
  String get powertrainCombustion => 'Combustión';

  @override
  String get powertrainHybrid => 'Híbrido';

  @override
  String get powertrainPluginHybrid => 'Híbrido enchufable';

  @override
  String get powertrainElectric => 'Eléctrico';

  @override
  String get catalogDb => 'Base de datos de catálogo';

  @override
  String get catalogSourceBuiltin => 'Empaquetada (por defecto)';

  @override
  String get catalogSourceOnline => 'En línea (release de GitHub)';

  @override
  String get catalogSourcesTitle => 'Catálogos disponibles';

  @override
  String get catalogCannotDelete =>
      'Catálogo por defecto: no se puede eliminar';

  @override
  String catalogVersionOf(String version) {
    return 'Versión $version';
  }

  @override
  String get catalogVersionUnknown => 'Versión no disponible';

  @override
  String get catalogRefreshOnline => 'Actualizar catálogo en línea';

  @override
  String get catalogRefreshed => 'Catálogo en línea actualizado';

  @override
  String get catalogRefreshFailed =>
      'No se pudo actualizar el catálogo en línea';

  @override
  String get catalogNotAvailable => 'Este catálogo no está disponible';

  @override
  String get catalogImportDb => 'Importar DB local';

  @override
  String get catalogImported => 'Catálogo importado';

  @override
  String get catalogImportFailed => 'No se pudo importar el catálogo';

  @override
  String get catalogDelete => 'Eliminar catálogo';

  @override
  String catalogDeleteConfirm(String name) {
    return '¿Eliminar $name? Esta acción no se puede deshacer.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'No se pudo descargar el catálogo en línea. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get templateUrlExample =>
      'Ejemplo: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> se sustituye por la última release de ese repositorio. Puedes usar cualquier repositorio de GitHub o pegar un enlace directo. Si el tag no se puede resolver, se usa el enlace tal cual y el test mostrará el fallo.';

  @override
  String get templateUrlUsage =>
      'Se usa para obtener el catálogo, el índice de plantillas y las traducciones (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Resuelve a: $url';
  }

  @override
  String get templateUrlVersion => 'Versión';

  @override
  String get templateUrlLatest => 'Última (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'No se pudieron cargar las versiones';

  @override
  String get templateUrlHelp => 'Ayuda de la URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL del repositorio';

  @override
  String get moreTemplateSourceVersionLatest => 'Última';
}
