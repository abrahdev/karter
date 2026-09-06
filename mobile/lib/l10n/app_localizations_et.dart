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
  String get navObd => 'OBD II';

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
  String get tools => 'Tööriistad';

  @override
  String get information => 'Teave';

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
  String get retry => 'Proovi uuesti';

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
  String get vehicleFormDetails => 'Detailid';

  @override
  String get vehicleFormVehicle => 'Sõiduk';

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
  String get newVehicleServicesOverdueTitle =>
      'Hooldustööd kuvatakse ületähtajatena';

  @override
  String get newVehicleServicesOverdueBody =>
      'Kuna teie sõidukil on juba üle 500 km, kuvatakse kõik hooldustööd ületähtajatena.\n\nRegistreerige juba tehtud hooldustööd. Kui täpset läbisõitu ei mäleta, märkige ligikaudne km viimase hoolduse kohta.';

  @override
  String get deleteVehicle => 'Kustuta sõiduk';

  @override
  String get deleteVehicleConfirm =>
      'Seda tegevust ei saa tagasi keerata. Kõik kütuselogid, hoolduste andmed ja seadistatud välbad kustutatakse.';

  @override
  String get cancel => 'Katkesta';

  @override
  String get resetToDefault => 'Taasta vaikeväärtus';

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
  String get partsTitle => 'Varuosad';

  @override
  String get partUnitUnit => 'tk';

  @override
  String get partUnitSet => 'komplekt';

  @override
  String get partUnitKit => 'komplekt';

  @override
  String get partUnitCan => 'purk';

  @override
  String get partUnitLabel => 'Ühik';

  @override
  String get localParts => 'Kohalikud varuosad';

  @override
  String get intervalParts => 'Intervallide varuosad';

  @override
  String get newPart => 'Uus varuosa';

  @override
  String get createPart => 'Loo varuosa';

  @override
  String get partsSection => 'Varuosad';

  @override
  String get usedParts => 'Varuosad';

  @override
  String usedInServicesCount(Object count) {
    return '$count hooldust';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Seda varuosa kasutatakse $count hoolduse juures. Kustutada ikkagi?';
  }

  @override
  String get reportPartsHeader => 'Varuosad';

  @override
  String get templateFound => 'Mall leitud';

  @override
  String get templateDisclaimer =>
      'Malli andmed on ainult viitamiseks. Kontrolli intervalle alati oma sõiduki käsiraamatu järgi.';

  @override
  String get noTemplate => 'Mall puudub';

  @override
  String get useTemplate => 'Kasuta malli';

  @override
  String get searchTemplate => 'Otsi malli';

  @override
  String templateWithName(Object name) {
    return 'Mall: $name';
  }

  @override
  String get noResultsTitle => 'Tulemusi pole';

  @override
  String get noTemplateFoundDescription =>
      'Sisestatud andmete jaoks malli ei leitud.';

  @override
  String get searchParameters => 'Otsingu parameetrid:';

  @override
  String get defaultIntervalsHint => 'Sõiduk kasutab vaikimisi intervalle.';

  @override
  String get missingTemplateContribute =>
      'Kas malli puudub? Aita kaasa aadressil github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Vaata kõiki malle';

  @override
  String get contribute => 'Aita kaasa';

  @override
  String get contributeOnGitHub => 'Aita GitHubis kaasa';

  @override
  String get gotIt => 'Sain aru';

  @override
  String get templateUnderConstruction => 'Mall on pooleli';

  @override
  String get templateNotReady =>
      'See mall pole veel valmis.\nTöötame selle kallal!';

  @override
  String get contributionsWelcome =>
      'Oodatud on panus — lisa või paranda oma sõiduki malle:';

  @override
  String requestedParam(Object params) {
    return 'Taotletud: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Kas oled kindel, et soovid selle välbi kustutada?';

  @override
  String get addPart => 'Lisa varuosa';

  @override
  String get partName => 'Varuosa nimi';

  @override
  String get quantity => 'Kogus';

  @override
  String get oemNumber => 'OEM number';

  @override
  String get addLink => 'Lisa link';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Ava';

  @override
  String get noLinks => 'Linke pole';

  @override
  String get noParts => 'Varuosasid veel pole';

  @override
  String get invalidUrl => 'Vigane URL';

  @override
  String get copied => 'Kopeeritud';

  @override
  String get linksTitle => 'Viitelingid';

  @override
  String get copy => 'Kopeeri';

  @override
  String get addModeManual => 'Käsitsi';

  @override
  String get addModeTemplate => 'Mall';

  @override
  String get newFromTemplate => 'Uued mallist';

  @override
  String get updatesAvailable => 'Uuendusi saadaval';

  @override
  String get restore => 'Taasta';

  @override
  String get windowMinimize => 'Minimeeri';

  @override
  String get windowMaximize => 'Maksimeeri';

  @override
  String get windowClose => 'Sulge';

  @override
  String get syncInstruction => 'Sünkrooni hooldusvälbad oma sõiduki mallist.';

  @override
  String get upToDate => 'Kõik ajakohane';

  @override
  String get syncAdded => 'Mallist lisatud hooldusvahe';

  @override
  String get syncRestored => 'Mallist taastatud hooldusvahe';

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
  String get addToDashboard => 'Lisa töölauda';

  @override
  String get setupNotifications => 'Seadista märguandeid';

  @override
  String get addToDashboardComingSoon => 'Tulemas';

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
  String get files => 'failid';

  @override
  String get share => 'Jaga';

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
  String get maintenanceHistoryTab => 'Ajalugu';

  @override
  String get maintenancePdfExportTab => 'PDF-i eksport';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count teenus(t) selles perioodis';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... ja $count veel';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Selles kuupäevavahemikus pole teenuseid.';

  @override
  String get maintenanceExportPdf => 'Ekspordi PDF';

  @override
  String get maintenanceSharePdf => 'Jaga';

  @override
  String get maintenanceReportTitle => 'Hooldusaruanne';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Loodud $date $time';
  }

  @override
  String get maintenanceReportEmpty => 'Selles perioodis pole hoolduslogisid.';

  @override
  String get maintenanceReportDateHeader => 'Kuupäev';

  @override
  String get maintenanceReportDescHeader => 'Kirjeldus';

  @override
  String get maintenanceReportOdometerHeader => 'Läbisõidumõõdik';

  @override
  String get addDocument => 'Lisa dokument';

  @override
  String get documentType => 'Dokumendi tüüp';

  @override
  String get selectFile => 'Vali fail';

  @override
  String get noFileSelected => 'Faili pole valitud';

  @override
  String get notesOptional => 'Märkused (valikuline)';

  @override
  String get expiryDateOptional => 'Aegumiskuupäev (valikuline)';

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
  String get docTypeVehicleRegister => 'Sõidukiregister';

  @override
  String get docTypeOther => 'Muu';

  @override
  String get vehicleDocuments => 'Dokumendid';

  @override
  String get fuelFormTitle => 'Uus kütuse sissekanne';

  @override
  String get volume => 'Maht';

  @override
  String get unitL => 'L';

  @override
  String get unitGal => 'gal';

  @override
  String get unitKm => 'km';

  @override
  String get unitMi => 'mi';

  @override
  String get pricePerUnit => 'Hind ühiku kohta (valikuline)';

  @override
  String get fullTank => 'Täis paak';

  @override
  String get volumeUnit => 'Kütuse mahu ühik';

  @override
  String get currency => 'Valuuta';

  @override
  String get cost => 'Kulud (valikuline)';

  @override
  String get saveFuelUp => 'Salvesta kütuse sissekanne';

  @override
  String get fuelListTitle => 'Kütuse logid';

  @override
  String get fuelEmpty => 'Kütuse sissekandeid pole';

  @override
  String get moreAbout => 'Karterist';

  @override
  String get moreDescription =>
      'Karter on kohalik-põhine, avatud lähtekoodiga sõidukihoolduse rakendus, mis austab sinu privaatsust.';

  @override
  String get moreExport => 'Ekspordi / Impordi andmeid';

  @override
  String get moreExportSubtitle => 'Varundage või teisaldage oma teave';

  @override
  String get moreDocs => 'Dokumentatsioon';

  @override
  String get moreDocsSubtitle => 'Kasutusjuhend ja funktsioonid';

  @override
  String get moreSource => 'Lähtekood';

  @override
  String get moreSourceSubtitle => 'GitHubi hoidla';

  @override
  String get moreDonate => 'Anneta';

  @override
  String get moreDonateSubtitle => 'Toeta arendust GitHub Sponsorsi kaudu';

  @override
  String get moreFooter => 'Tehtud ❤️ abrahdev poolt';

  @override
  String get moreRate => 'Hinda Karterit';

  @override
  String get moreRateSubtitle => 'Jäta ülevaade Play poes';

  @override
  String get moreFeedback => 'Hinda rakendust';

  @override
  String get moreFeedbackSubtitle =>
      'Hinda rakendust ja seadista meeldetuletusi';

  @override
  String get feedbackTitle => 'Tagasiside';

  @override
  String get sectionPreferences => 'Eelistused';

  @override
  String get sectionData => 'Andmed';

  @override
  String get sectionFeedbackCommunity => 'Tagasiside ja kogukond';

  @override
  String get sectionTips => 'Tee programm';

  @override
  String get sectionAbout => 'Karterist';

  @override
  String get theme => 'Teema';

  @override
  String get themeAutomatic => 'Automaatne';

  @override
  String get themeAutomaticDesc => 'Jälgi seadme sätteid';

  @override
  String get themeSystem => 'Süsteemi';

  @override
  String get themeSystemDesc => 'Jälgi seadme sätteid';

  @override
  String get themeLight => 'Hele';

  @override
  String get themeDark => 'Tume';

  @override
  String get colorScheme => 'Põhivärv';

  @override
  String get colorCustom => 'Kohandatud';

  @override
  String get colorOfInterface => 'Liidese värv';

  @override
  String get colorOfInterfaceDesc => 'Rakenda põhivärv taustapindadele';

  @override
  String get customColor => 'Kohandatud värv';

  @override
  String get customColorDesc => 'Kasuta isiklikku värvi süsteemi asemel';

  @override
  String get selectColor => 'Vali värv';

  @override
  String get hapticFeedback => 'Haptiline tagasiside';

  @override
  String get hapticFeedbackDesc => 'Vibreeri interaktsioonide ajal';

  @override
  String get hapticModeOff => 'Väljas';

  @override
  String get hapticModeOffDesc => 'Vibreerimine välja lülitatud';

  @override
  String get hapticModeClear => 'Selge';

  @override
  String get hapticModeClearDesc => 'Üks terav vibratsioon toimingu kohta';

  @override
  String get hapticModeRich => 'Rikas';

  @override
  String get hapticModeRichDesc =>
      'Kihtideks virnastatud vibratsioonid erineva tugevusega';

  @override
  String get testNotification => 'Testteavitus';

  @override
  String get testNotificationDesc =>
      'Saada testteavitus, et kontrollida seadistust';

  @override
  String get testNotificationSent => 'Testteavitus saadetud';

  @override
  String get notificationsPermissionTitle => 'Teavitused keelatud';

  @override
  String get notificationsPermissionDesc =>
      'Lülitage teavitused sisse, et saada odomeetri ja hoolduse meeldetuletusi';

  @override
  String get notificationsPermissionAllow => 'Luba teavitused';

  @override
  String get notificationsPermissionDeniedTitle => 'Teavitused blokeeritud';

  @override
  String get notificationsPermissionDeniedDesc =>
      'Teavitusluba on püsivalt keelatud. Selle lubamiseks minge Seaded > Rakendused > Karter > Teavitused ja lülitage need sisse.';

  @override
  String get notificationsPermissionDeniedStep1 => '1. Avage seadme Seaded';

  @override
  String get notificationsPermissionDeniedStep2 =>
      '2. Minge Rakendused > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Puudutage Teavitused';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Lülitage sisse \"Näita teavitusi\"';

  @override
  String get notificationsPermissionOpenSettings => 'Ava seaded';

  @override
  String get shakeToOdometer => 'Raputa odomeetri värskendamiseks';

  @override
  String get shakeToOdometerDesc =>
      'Raputa seadet, et avada odomeetri värskendus sõiduki ekraanil';

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
  String get tipProgram => 'Tee programm';

  @override
  String get tipProgramComingSoon =>
      'See funktsioon arenduses ja saab peagi kättesaadavaks.';

  @override
  String get tipBadges => 'Märgid';

  @override
  String get tipBadgesNone => 'Puuduvad';

  @override
  String get tipInfo => 'Teave';

  @override
  String get tipInfoText =>
      'Tee programm on viis, kuidas kasutajad saavad näidata toetust ja tänu kiire toe, pidevate täienduste ja järjepidevate värskenduste eest, mida Karter on pakkunud.';

  @override
  String get tipOneTime => 'Ühekordne tee';

  @override
  String get tipRecurring => 'Korduv tee';

  @override
  String get tipBronze => 'Pronks';

  @override
  String get tipSilver => 'Hõbe';

  @override
  String get tipGold => 'Kuld';

  @override
  String get tipBronzePrice => 'Pronksi tee';

  @override
  String get tipSilverPrice => 'Hõbe tee';

  @override
  String get tipGoldPrice => 'Kuldt tee';

  @override
  String get tipBronzeMonthly => 'Pronks / kuu';

  @override
  String get tipSilverMonthly => 'Hõbe / kuu';

  @override
  String get tipGoldMonthly => 'Kuld / kuu';

  @override
  String get officialWebsite => 'Ametlik veebileht';

  @override
  String get communityForums => 'Kogukonna foorumid';

  @override
  String get translations => 'Tõlked';

  @override
  String get privacyPolicy => 'Privaatsuspoliitika';

  @override
  String get privacyPolicyDesc => 'Loe meie privaatsuspoliitikat veebis.';

  @override
  String get openPrivacyPolicy => 'Ava privaatsuspoliitika';

  @override
  String get version => 'Versioon';

  @override
  String get deviceId => 'Seadme ID';

  @override
  String get changelog => 'Muudatuste logi';

  @override
  String get openSourceLicenses => 'Avatud lähtekoodiga litsentsid';

  @override
  String get language => 'Keel';

  @override
  String get selectLanguage => 'Vali keel';

  @override
  String get languageSystem => 'Süsteemi vaikesätteid';

  @override
  String get english => 'Inglise';

  @override
  String get spanish => 'Hispaania';

  @override
  String get eesti => 'Eesti';

  @override
  String get german => 'Saksa';

  @override
  String get portuguese => 'Portugali';

  @override
  String get russian => 'Vene';

  @override
  String get french => 'Prantsuse';

  @override
  String get polish => 'Poola';

  @override
  String get italian => 'Itaalia';

  @override
  String get dutch => 'Hollandi';

  @override
  String get odometerUpdateTitle => 'Uuenda läbisõidumõõdikut';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Viimane: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'Väärtus on madalam kui viimane kirje ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Oled viimati sõitnud $delta $unit. Kas see on õige?';
  }

  @override
  String get odometerSave => 'Salvesta';

  @override
  String get odometerCancel => 'Tühista';

  @override
  String get moreNotifications => 'Teavitused';

  @override
  String get moreNotificationsSubtitle =>
      'Läbisõidumõõdiku ja hoolduse meeldetuletused';

  @override
  String get notificationSettingsTitle => 'Teavituste seaded';

  @override
  String get notificationSettingsSubtitle =>
      'Seadista meeldetuletusi sellele sõidukile';

  @override
  String get notificationOdometerSection => 'Läbisõidumõõdiku meeldetuletus';

  @override
  String get notificationMaintenanceSection => 'Hoolduse meeldetuletus';

  @override
  String get notificationFreqLabel => 'Meeldetuletuse sagedus';

  @override
  String get notificationFreqOff => 'Väljas';

  @override
  String notificationFreqValue(Object days) {
    return 'Iga $days päeva tagant';
  }

  @override
  String get notificationMaintenanceToggle => 'Hoolduse meeldetuletused';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Saa igapäevaseid meeldetuletusi ootavate hoolduste kohta';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Edasi lükatud veel $days päev(a)';
  }

  @override
  String get notificationSnoozeCancel => 'Tühista edasilükkamine';

  @override
  String get notificationNoVehicles => 'Lisa sõiduk teavituste seadistamiseks';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Läbisõidumõõdik: $freq • Hooldus: $maint';
  }

  @override
  String get notificationConfigure => 'Seadista';

  @override
  String get notificationMaintOn => 'Sees';

  @override
  String get notificationMaintOff => 'Väljas';

  @override
  String get notificationSnoozeAction => 'Lükka 1 nädala võrra edasi';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Edasi lükatud kuni $date';
  }

  @override
  String get notificationFreqWeekly => 'Iga 7 päeva tagant';

  @override
  String get notificationFreqMonthly => 'Iga 30 päeva tagant';

  @override
  String get notificationFreqCustom => 'Kohandatud';

  @override
  String notificationFreqDays(Object days) {
    return '$days päeva';
  }

  @override
  String get notificationMaintenanceSnooze =>
      'Lükka hoolduse meeldetuletus 1 nädala võrra edasi';

  @override
  String get notificationSnoozeToggle => 'Lükka meeldetuletusi edasi';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days päeva';
  }

  @override
  String get unsavedChanges => 'Salvestamata muudatused';

  @override
  String get discardChangesConfirm =>
      'Sul on salvestamata muudatusi. Kas oled kindel, et soovid lahkuda?';

  @override
  String get discard => 'Loobu';

  @override
  String get moreTemplateSource => 'Malli allikas';

  @override
  String get moreTemplateSourceSubtitle =>
      'Hangi malle GitHubist või kasuta kohalikke varasid';

  @override
  String get moreTemplateSourceOffline => 'Kohalik (võrguühenduseta)';

  @override
  String get moreTemplateSourceOnline => 'Veebis (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'Hoidla URL';

  @override
  String get moreTemplateSourceReset => 'Lähtesta vaikeväärtusele';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Muuda URL-i';

  @override
  String get moreTemplateSourceUrlSaved => 'URL uuendatud';

  @override
  String get testConnection => 'Ühenduse testimine';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Viimati muudetud: $date';
  }

  @override
  String get importCheckTranslations => 'Tõlked';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found/$total saadaval';
  }

  @override
  String get importCheckIndex => 'Mallide indeks';

  @override
  String importCheckIndexResult(int count) {
    return '$count malli';
  }

  @override
  String get importCheckDb => 'Kataloogi andmebaas (kaug)';

  @override
  String get importCheckDbRemoteFound => 'Saadaval GitHubis';

  @override
  String get importCheckDbRemoteNotFound => 'Ainult kohalik (mitte GitHubis)';

  @override
  String get importCheckDbLocal => 'Imporditud andmebaasi andmed';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Versioon: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Sõidukid: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Hooldustööd: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Varuosad: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'OBD-koodid: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Imporditud andmebaasi ei õnnestunud lugeda';

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

  @override
  String get supporterBadge => 'Oled Karteri toetaja!';

  @override
  String get restorePurchases => 'Taasta ostud';

  @override
  String get tipPurchased => 'Aitäh!';

  @override
  String get tipSupport => 'Toeta';

  @override
  String get sectionBackup => 'Varukoopia';

  @override
  String get moreBackup => 'Varukoopia';

  @override
  String get moreBackupSubtitle => 'Krüpteeritud varukoopia';

  @override
  String get backupConnect => 'Ühenda Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Ühendatud kui $email';
  }

  @override
  String get backupNow => 'Tee varukoopia';

  @override
  String get backupInProgress => 'Varukoopia tegemine…';

  @override
  String backupLast(Object date) {
    return 'Viimane varukoopia: $date';
  }

  @override
  String get backupNever => 'Pole varukoopiat tehtud';

  @override
  String get backupRestore => 'Taasta varukoopiast';

  @override
  String get backupRestoreInProgress => 'Taastamine…';

  @override
  String get backupRestoreConfirm =>
      'See asendab kõik praegused andmed varukoopiaga. Kas oled kindel?';

  @override
  String backupError(Object error) {
    return 'Varukoopia viga: $error';
  }

  @override
  String get backupSuccess => 'Varukoopia üles laaditud';

  @override
  String get backupRestoreSuccess =>
      'Andmed taastatud. Taaskäivita rakendus muudatuste nägemiseks.';

  @override
  String get backupDisconnect => 'Ühenda lahti';

  @override
  String get backupNoBackups => 'Varukoopiaid ei leitud';

  @override
  String get backupRestoreBtn => 'Taasta';

  @override
  String get backupDelete => 'Kustuta';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Kustuta varukoopia $name?';
  }

  @override
  String get backupDeleteSuccess => 'Varukoopia kustutatud';

  @override
  String backupCount(Object current, Object max) {
    return 'Varukoopiad: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Veakoodide otsing';

  @override
  String get dtcSearchHint => 'Sisesta kood, nt P0171';

  @override
  String get dtcEmptyState => 'Kirjuta kood, et näha selle kirjeldust';

  @override
  String get dtcNoMatch => 'Otsingule ei vasta ükski kood';

  @override
  String get dtcDescription => 'Kirjeldus';

  @override
  String get dtcRelatedMaintenance => 'Seotud hooldus';

  @override
  String get dtcScopeStandard => 'Standardne';

  @override
  String get dtcScopeManufacturer => 'Tootja';

  @override
  String get dtcGeneralDb => 'Üldised OBD-II koodid';

  @override
  String get dtcCatalogBrands => 'Kataloogi kaubamärgid';

  @override
  String get dtcMyVehicles => 'Minu sõidukid';

  @override
  String get dtcVehicle => 'Sõiduk';

  @override
  String get dtcVehicleNotFound => 'Sõidukit ei leitud';

  @override
  String get dtcLoadError => 'Veakoodide laadimine ebaõnnestus';

  @override
  String get notificationOdometerTitle => 'Uuenda odomeetrit';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days päeva viimasest meeldetuletusest.';
  }

  @override
  String get notificationMaintenanceTitle => 'Ootel hooldus';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — vaata hooldusintervallide staatust.';
  }

  @override
  String errorGeneric(String error) {
    return 'Viga: $error';
  }

  @override
  String get deleteFuelUp => 'Kustuta tankimine';

  @override
  String get deleteFuelUpConfirm =>
      'Kas olete kindel, et soovite selle tankimise kustutada?';

  @override
  String get editFuelUp => 'Muuda tankimist';

  @override
  String get deleteDocument => 'Kustuta dokument';

  @override
  String get deleteDocumentConfirm =>
      'Kas olete kindel, et soovite selle dokumendi kustutada?';

  @override
  String get editDocument => 'Muuda dokumenti';

  @override
  String get title => 'Pealkiri';

  @override
  String get selectExpiryDate => 'Vali aegumiskuupäev';

  @override
  String get addMoreFiles => 'Lisa veel faile';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Mallid';

  @override
  String get templatesTitle => 'Mallid';

  @override
  String get templatesSubtitle => 'Vaata kogukonna mallikataloogi';

  @override
  String get createTemplate => 'Loo mall';

  @override
  String get createTemplateSubtitle =>
      'Koosta mall ja ekspordi see JSON-failina';

  @override
  String get templatesLoadError => 'Mallikataloogi ei õnnestunud laadida.';

  @override
  String get searchTemplatesHint => 'Otsi margi, mudeli või põlvkonna järgi';

  @override
  String get allMakes => 'Kõik margid';

  @override
  String get noTemplatesFound => 'Ükski mall ei vasta sinu otsingule.';

  @override
  String templateItemsCount(int count) {
    return '$count hooldustööd';
  }

  @override
  String get templateYearsOpen => 'praeguseni';

  @override
  String get templateNotFound => 'Malli ei leitud';

  @override
  String get templateInfo => 'Malli teave';

  @override
  String get templateYears => 'Aastad';

  @override
  String get templateEngine => 'Mootor';

  @override
  String get templateAuthor => 'Autor';

  @override
  String get templateVersion => 'Versioon';

  @override
  String get templateSources => 'Allikad';

  @override
  String get dtcCodesTitle => 'Veakoodid';

  @override
  String dtcCount(int count) {
    return '$count veakoodi';
  }

  @override
  String get noPartsFound => 'Varugi pole';

  @override
  String get createCopied => 'Malli JSON kopeeritud lõikelauale';

  @override
  String get saveTemplate => 'Salvesta mall';

  @override
  String savedAt(String path) {
    return 'Salvestatud: $path';
  }

  @override
  String get createHasErrors => 'Paranda vead, et eksportida';

  @override
  String get createMake => 'Mark';

  @override
  String get createModel => 'Mudel';

  @override
  String get createGeneration => 'Põlvkond';

  @override
  String get createYearFrom => 'Aasta alates';

  @override
  String get createYearTo => 'Aasta kuni';

  @override
  String get createFuel => 'Kütus';

  @override
  String get createPowertrain => 'Jõuallikas';

  @override
  String get createEngineCode => 'Mootori kood';

  @override
  String get createDisplacement => 'Töömaht (cc)';

  @override
  String get createPower => 'Võimsus (hj)';

  @override
  String get templateMetadata => 'Metaandmed ja pärandumine';

  @override
  String get createAuthor => 'Autor';

  @override
  String get createAuthorHint => 'Sinu GitHubi kasutajanimi';

  @override
  String get createExtends => 'Laiendab (põhimalle)';

  @override
  String get createExtendsHint => 'Päri ühiseid hooldusandmeid';

  @override
  String get createCustomExtends => 'Kohandatud extends-teed';

  @override
  String get createAddPart => 'Lisa varuosa';

  @override
  String get createNoParts => 'Varuosasid veel pole. Need on valikulised.';

  @override
  String get partSingular => 'Varuosa';

  @override
  String get createAddItem => 'Lisa hooldustöö';

  @override
  String get createNoItems => 'Hooldustööd puuduvad.';

  @override
  String get createPreview => 'Eelvaade';

  @override
  String createErrorsFound(int count) {
    return '$count valideerimisviga';
  }

  @override
  String get createCopy => 'Kopeeri';

  @override
  String get createShare => 'Jaga';

  @override
  String get createSave => 'Salvesta';

  @override
  String get createQuantity => 'Kogus';

  @override
  String get createI18nKey => 'i18n-võti';

  @override
  String get createDescI18nKey => 'Kirjelduse i18n-võti';

  @override
  String get createIntervalKm => 'Intervall (km)';

  @override
  String get createIntervalMonths => 'Intervall (kuud)';

  @override
  String get createDescription => 'Kirjeldus';

  @override
  String get createAddPartRef => 'Lisa varuosa viide';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nimi';

  @override
  String get createFieldUnit => 'Ühik';

  @override
  String get createFieldOem => 'OEM-number';

  @override
  String get createFieldLabel => 'Silt';

  @override
  String get createFieldPart => 'Varuosa';

  @override
  String get fuelGasoline => 'Bensiin';

  @override
  String get fuelDiesel => 'Diisel';

  @override
  String get fuelLpg => 'LPG';

  @override
  String get fuelCng => 'CNG';

  @override
  String get fuelHydrogen => 'Vesinik';

  @override
  String get fuelEthanol => 'Etanool';

  @override
  String get powertrainCombustion => 'Põlemismootor';

  @override
  String get powertrainHybrid => 'Hübriid';

  @override
  String get powertrainPluginHybrid => 'Pistikühendusega hübriid';

  @override
  String get powertrainElectric => 'Elekter';

  @override
  String get catalogDb => 'Kataloogi andmebaas';

  @override
  String get catalogSourceBuiltin => 'Kaasas olev (vaikevaade)';

  @override
  String get catalogSourceOnline => 'Veebis (GitHub release)';

  @override
  String get catalogSourcesTitle => 'Saadaolevad kataloogid';

  @override
  String get catalogCannotDelete => 'Vaikekataloog — seda ei saa kustutada';

  @override
  String catalogVersionOf(String version) {
    return 'Versioon $version';
  }

  @override
  String get catalogVersionUnknown => 'Versioon puudub';

  @override
  String get catalogRefreshOnline => 'Värskenda veebikataloogi';

  @override
  String get catalogRefreshed => 'Veebikataloog värskendatud';

  @override
  String get catalogRefreshFailed => 'Veebikataloogi ei õnnestunud värskendada';

  @override
  String get catalogNotAvailable => 'See kataloog pole saadaval';

  @override
  String get catalogImportDb => 'Impordi kohalik andmebaas';

  @override
  String get catalogImported => 'Kataloog imporditud';

  @override
  String get catalogImportFailed => 'Kataloogi ei õnnestunud importida';

  @override
  String get catalogDelete => 'Kustuta kataloog';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Kustutada kataloog $name? Seda ei saa tagasi võtta.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Veebikataloogi ei õnnestunud alla laadida. Kontrolli ühendust ja proovi uuesti.';

  @override
  String get templateUrlExample =>
      'Näide: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> asendatakse selle repositooriumi viimase väljalaskega. Võid kasutada mõnda teist GitHubi repositooriumit või kleepida otse lingi. Kui tag\'i ei saa määrata, kasutatakse linki nii nagu on ja test näitab tõrke.';

  @override
  String get templateUrlUsage =>
      'Kasutatakse kataloogi, mallide indeksi ja tõlgete (i18n) hankimiseks.';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Laheneb: $url';
  }

  @override
  String get templateUrlVersion => 'Versioon';

  @override
  String get templateUrlLatest => 'Uusim (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Versioone ei õnnestunud laadida';

  @override
  String get templateUrlHelp => 'URL-i abi';

  @override
  String get moreTemplateSourceUrlLabel => 'Repo URL';

  @override
  String get moreTemplateSourceVersionLatest => 'Uusim';

  @override
  String catalogDbVersion(String version) {
    return 'Andmebaasi versioon: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Väljalase: $version';
  }

  @override
  String get createInheritedParts => 'Päritud osad (extends-ist)';

  @override
  String get createInheritedItems => 'Päritud hooldus (extends-ist)';

  @override
  String get templateExtendsNotLoaded => 'Mõnda extendsi ei õnnestunud laadida';

  @override
  String get templateRepoLoading => 'Laadimine mallide repositooriumist…';

  @override
  String get templateRepoError =>
      'Ei õnnestunud mallide repositooriumiga ühendust saada';

  @override
  String templateBy(String author) {
    return 'autor: $author';
  }
}
