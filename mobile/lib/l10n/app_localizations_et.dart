// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Estonian (`et`).
class AppLocalizationsEt extends AppLocalizations {
  AppLocalizationsEt([String locale = 'et']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Juhtpaneel';

  @override
  String get navVehicles => 'Sõidukid';

  @override
  String get navMore => 'Veel';

  @override
  String get homeEmptyTitle => 'Sõidukeid pole';

  @override
  String get homeEmptySubtitle => 'Lisa oma esimene sõiduk';

  @override
  String homeError(Object error) {
    return 'Viga: $error';
  }

  @override
  String get dashboardTitle => 'Juhtpaneel';

  @override
  String get dashboardComingSoon => 'Varsti';

  @override
  String get vehicleDetailTitle => 'Sõiduk';

  @override
  String get vehicleNotFound => 'Sõidukit ei leidu';

  @override
  String get plate => 'Numbrimärk';

  @override
  String get vin => 'VIN-kood';

  @override
  String get brandModel => 'Mark ja mudel';

  @override
  String get year => 'Aasta';

  @override
  String get odometer => 'Odomeeter';

  @override
  String get update => 'Uuenda';

  @override
  String get actions => 'Tegevused';

  @override
  String get fuelLogs => 'Kütuselogid';

  @override
  String get maintenanceHistory => 'Hooldusraamat';

  @override
  String get configureIntervals => 'Seadista välpasid';

  @override
  String get nextMaintenance => 'Järgmine hooldus';

  @override
  String get allIntervalsDisabled => 'Kõik välbad on lülitatud välja.';

  @override
  String get register => 'Registreeri';

  @override
  String get registerService => 'Registreeri teenus';

  @override
  String get noDescriptionAvailable =>
      'Kirjeldust pole saadaval. Mine hooldusseadistustesse, et seda lisada.';

  @override
  String get close => 'Sulge';

  @override
  String get overduePerformService => 'Üle tähtaja - suundu hooldusesse';

  @override
  String nextIn(Object parts) {
    return 'Järgmine osa $parts';
  }

  @override
  String get vehicleFormNew => 'Uus sõiduk';

  @override
  String get vehicleFormEdit => 'Muuda sõidukit';

  @override
  String get brand => 'Tootja';

  @override
  String get model => 'Mudel';

  @override
  String get required => 'Nõutav';

  @override
  String get invalidYear => 'Vigane aasta';

  @override
  String get vehicleType => 'Sõiduki tüüp';

  @override
  String get combustion => 'Sisepõlemismootoriga sõiduk';

  @override
  String get electric => 'Elektrimootoriga sõiduk';

  @override
  String get motorcycle => 'Mootorratas';

  @override
  String get plateOptional => 'Registreerimisnumber (kui tahad lisada)';

  @override
  String get vinOptional => 'VIN-kood (kui tahad lisada)';

  @override
  String get invalid => 'Vigane';

  @override
  String get aliasOptional => 'Alias (kui tahad lisada)';

  @override
  String get aliasHint => 'Nt. Minu vanker, Meeletu loom, jne.';

  @override
  String get saveChanges => 'Salvesta muudatused';

  @override
  String get addVehicle => 'Lisa sõiduk';

  @override
  String get deleteVehicle => 'Kustuta sõiduk';

  @override
  String get deleteVehicleConfirm =>
      'Seda tegevust ei saa tagasi keerata. Kõik kütuselogid, hoolduste andmed ja seadistatud välbad kustutatakse.';

  @override
  String get cancel => 'Katkesta';

  @override
  String get delete => 'Kustuta';

  @override
  String get dataManagerTitle => 'Eksport ja import';

  @override
  String get selectAll => 'Vali kõik';

  @override
  String get exporting => 'Ekspordin...';

  @override
  String get export => 'Eksport';

  @override
  String get importing => 'Impordin...';

  @override
  String get import => 'Impordi';

  @override
  String get saveExport => 'Salvesta eksporditud sisu';

  @override
  String exportedAt(Object path) {
    return 'Eksporditud asukohta $path';
  }

  @override
  String exportError(Object error) {
    return 'Viga eksportimisel: $error';
  }

  @override
  String get importData => 'Impordi andmed';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Leiti:\n• $vehicles vehicle(s)\n• $fuelLogs fuel log(s)\n• $maintenanceLogs maintenance log(s)\n• $documents document(s)\n\nImportida? Olemasolevad andmed, millel on sama ID, kirjutatakse üle.';
  }

  @override
  String get importSuccess => 'Andmed on edukalt imporditud';

  @override
  String importError(Object error) {
    return 'Importimisviga: $error';
  }

  @override
  String get invalidJson => 'Kehtetu JSON-fail';

  @override
  String exportShareText(Object count) {
    return 'Karter Export — $count sõidukit';
  }

  @override
  String get maintenanceSettingsTitle => 'Hooldusintervallid';

  @override
  String get maintenanceSettingsInstruction =>
      'Lülitage funktsioonid sisse või välja vastavalt oma sõiduki vajadustele. Kohandatud intervallid on võimalik kustutada.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Aeg (kuud)';

  @override
  String get months => 'kuud';

  @override
  String get description => 'Kirjeldus';

  @override
  String get newInterval => 'Uus välp';

  @override
  String get name => 'Nimi';

  @override
  String get add => 'Lisa';

  @override
  String get edit => 'Muuda';

  @override
  String get deleteInterval => 'Kustuta';

  @override
  String get noDescriptionAvailableSettings =>
      'Kirjeldust ei leidu. Lisamiseks klõpsa „Muuda“.';

  @override
  String formattedKmK(Object km) {
    return '$km tuh km';
  }

  @override
  String formattedKm(Object km) {
    return '$km km';
  }

  @override
  String intervalSubtitleKm(Object km) {
    return 'iga $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months kuud';
  }

  @override
  String get maintenanceLogTitleEdit => 'Muuda teenust';

  @override
  String get maintenanceLogTitleNew => 'Uus teenus';

  @override
  String date(Object date) {
    return 'Kuupäev: $date';
  }

  @override
  String get descriptionRequired => 'Kirjeldus';

  @override
  String get odometerAtService => 'Kilomeetrilugeja hoolduse ajal (valikuline)';

  @override
  String get resetInterval => 'Taastamisintervall (valikuline)';

  @override
  String get saveChangesShort => 'Salvesta muudatused';

  @override
  String get saveService => 'Salvesta teenus';

  @override
  String get saveFile => 'Salvesta fail';

  @override
  String get lastService => 'Viimane';

  @override
  String get addPhoto => 'Lisa foto';

  @override
  String get photos => 'fotod';

  @override
  String get deleteService => 'Kustuta teenus';

  @override
  String get deleteServiceConfirm =>
      'Kas sa oled kindel, et soovid selle teenuse kustutada?';

  @override
  String get maintenanceListTitle => 'Hooldus';

  @override
  String get maintenanceEmpty => 'Teenuseid ei ole registreeritud';

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
  String get addDocument => 'Add document';

  @override
  String get documentType => 'Document type';

  @override
  String get selectFile => 'Select file';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get expiryDateOptional => 'Expiry date (optional)';

  @override
  String get pleaseSelectFile => 'Palun vali fail';

  @override
  String get documentSaved => 'Dokument on salvestatud';

  @override
  String get takePhoto => 'Pildista';

  @override
  String get chooseFromGallery => 'Vali galeriist';

  @override
  String get browseFiles => 'Sirvi faile';

  @override
  String get docTypeFine => 'Trahv';

  @override
  String get docTypeParkingFee => 'Parkimistasu';

  @override
  String get docTypeInsurance => 'Kindlustus';

  @override
  String get docTypeVehicleCheck => 'Ülevaatus';

  @override
  String get docTypeTax => 'Maks';

  @override
  String get docTypeComplexInsurance => 'Kompleksne kindlustus';

  @override
  String get docTypeVehicleRegister => 'Vehicle register';

  @override
  String get docTypeOther => 'Other';

  @override
  String get vehicleDocuments => 'Documents';

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
  String get volumeUnit => 'Fuel volume unit';

  @override
  String get currency => 'Currency';

  @override
  String get cost => 'Cost (optional)';

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
  String get moreRate => 'Hinda Karterit';

  @override
  String get moreRateSubtitle => 'Jäta ülevaade Play poes';

  @override
  String get moreFeedback => 'Tagasiside';

  @override
  String get moreFeedbackSubtitle =>
      'Hinda rakendust ja seadista meeldetuletusi';

  @override
  String get feedbackTitle => 'Tagasiside';

  @override
  String get feedbackReminderToggle => 'Hindamise meeldetuletus';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Näita meeldetuletust rakenduse hindamiseks pärast teenuste salvestamist';

  @override
  String get feedbackServicesInterval => 'Teenused enne küsimist';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Pärast $count teenust';
  }

  @override
  String get feedbackServicesSuffix => 'teenused';

  @override
  String get feedbackRepeatDays => 'Meeldetuletuse intervall';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Iga $days päev(a)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'päeva';

  @override
  String get ratePromptMessage =>
      'Karter meeldib? Arvustus aitab teistel rakendust leida!';

  @override
  String get rate => 'Hinda';

  @override
  String moreUrlError(Object url) {
    return 'URL-i ei saanud avada: $url';
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
  String get moreNotifications => 'Notifications';

  @override
  String get moreNotificationsSubtitle => 'Odometer and maintenance reminders';

  @override
  String get notificationSettingsTitle => 'Notification settings';

  @override
  String get notificationSettingsSubtitle =>
      'Configure reminders for this vehicle';

  @override
  String get notificationOdometerSection => 'Odometer reminder';

  @override
  String get notificationMaintenanceSection => 'Maintenance reminder';

  @override
  String get notificationFreqLabel => 'Reminder frequency';

  @override
  String get notificationFreqOff => 'Off';

  @override
  String notificationFreqValue(Object days) {
    return 'Every $days days';
  }

  @override
  String get notificationMaintenanceToggle => 'Maintenance reminders';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Receive daily reminders about pending maintenance';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Snoozed for $days more day(s)';
  }

  @override
  String get notificationSnoozeCancel => 'Cancel snooze';

  @override
  String get notificationNoVehicles =>
      'Add a vehicle to configure notifications';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Odometer: $freq • Maintenance: $maint';
  }

  @override
  String get notificationConfigure => 'Configure';

  @override
  String get notificationMaintOn => 'On';

  @override
  String get notificationMaintOff => 'Off';

  @override
  String get notificationSnoozeAction => 'Snooze for 1 week';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Snoozed until $date';
  }

  @override
  String get notificationFreqWeekly => 'Every 7 days';

  @override
  String get notificationFreqMonthly => 'Every 30 days';

  @override
  String get notificationFreqCustom => 'Custom';

  @override
  String notificationFreqDays(Object days) {
    return '$days days';
  }

  @override
  String get notificationMaintenanceSnooze => 'Snooze maintenance for 1 week';

  @override
  String get notificationSnoozeToggle => 'Snooze reminders';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days days';
  }

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get discardChangesConfirm =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get discard => 'Discard';

  @override
  String get moreTemplateSource => 'Template source';

  @override
  String get moreTemplateSourceSubtitle =>
      'Fetch templates from GitHub or use local assets';

  @override
  String get moreTemplateSourceOffline => 'Local (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'Repo URL';

  @override
  String get moreTemplateSourceReset => 'Reset to default';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://raw.githubusercontent.com/...';

  @override
  String get moreTemplateSourceEditUrl => 'Edit URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL updated';

  @override
  String get onboardingSkip => 'Jäta vahele';

  @override
  String get onboardingNext => 'Edasi';

  @override
  String get onboardingDone => 'Alusta';

  @override
  String get onboardingReplay => 'Näita sissejuhatust';

  @override
  String get onboardingReplaySubtitle => 'Korda tervituskäiku';

  @override
  String get onboardingWelcomeTitle => 'Tere tulemast Karterisse';

  @override
  String get onboardingWelcomeDesc =>
      'Privaatsust esikohal avatud lähtekoodiga sõiduki hoolduse jälgija. 100% võrguta — ilma kontodeta ja jälgimiseta.';

  @override
  String get onboardingVehicleTitle => 'Lisa oma sõiduk';

  @override
  String get onboardingVehicleDesc =>
      'Registreeri oma auto, motorroller või elektriauto. Vali mall ja Karter täidab hooldusvabad automaatselt.';

  @override
  String get onboardingTrackTitle => 'Jälgi kütust ja hooldust';

  @override
  String get onboardingTrackDesc =>
      'Logi tankimised automaatse kalkulatsiooniga. Jälgi remondi, varuosade ja kulude ajalugu.';

  @override
  String get onboardingRemindersTitle => 'Olge hooldusega kursis';

  @override
  String get onboardingRemindersDesc =>
      'Saa teavitusi õlivahetuse, piduriklotside ja kõigi hooldusvälpade kohta — distantsi või aja järgi.';
}
