// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVehicles => 'Voertuigen';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Meer';

  @override
  String get homeEmptyTitle => 'Geen voertuigen';

  @override
  String get homeEmptySubtitle => 'Voeg je eerste voertuig toe';

  @override
  String homeError(Object error) {
    return 'Fout: $error';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardComingSoon => 'Binnenkort beschikbaar';

  @override
  String get vehicleDetailTitle => 'Voertuig';

  @override
  String get vehicleNotFound => 'Voertuig niet gevonden';

  @override
  String get plate => 'Kenteken';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Merk / Model';

  @override
  String get year => 'Jaar';

  @override
  String get odometer => 'Kilometerteller';

  @override
  String get update => 'Bijwerken';

  @override
  String get actions => 'Acties';

  @override
  String get tools => 'Hulpmiddelen';

  @override
  String get information => 'Informatie';

  @override
  String get fuelLogs => 'Tanklogboek';

  @override
  String get maintenanceHistory => 'Onderhoudsgeschiedenis';

  @override
  String get configureIntervals => 'Intervallen instellen';

  @override
  String get nextMaintenance => 'Volgend onderhoud';

  @override
  String get allIntervalsDisabled => 'Alle intervallen zijn uitgeschakeld.';

  @override
  String get register => 'Registreren';

  @override
  String get registerService => 'Service registreren';

  @override
  String get noDescriptionAvailable =>
      'Geen beschrijving beschikbaar. Ga naar de onderhoudsinstellingen om er een toe te voegen.';

  @override
  String get close => 'Sluiten';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get overduePerformService => 'Achterstallig — voer onderhoud uit';

  @override
  String nextIn(Object parts) {
    return 'Volgende in $parts';
  }

  @override
  String get vehicleFormNew => 'Nieuw voertuig';

  @override
  String get vehicleFormEdit => 'Voertuig bewerken';

  @override
  String get vehicleFormDetails => 'Details';

  @override
  String get vehicleFormVehicle => 'Voertuig';

  @override
  String get brand => 'Merk';

  @override
  String get model => 'Model';

  @override
  String get required => 'Vereist';

  @override
  String get invalidYear => 'Ongeldig jaar';

  @override
  String get vehicleType => 'Voertuigtype';

  @override
  String get combustion => 'Verbranding';

  @override
  String get electric => 'Elektrisch';

  @override
  String get motorcycle => 'Motorfiets';

  @override
  String get plateOptional => 'Kenteken (optioneel)';

  @override
  String get vinOptional => 'VIN (optioneel)';

  @override
  String get invalid => 'Ongeldig';

  @override
  String get aliasOptional => 'Alias (optioneel)';

  @override
  String get aliasHint => 'Bijv.: Mijn bolide, Het beest, enz.';

  @override
  String get saveChanges => 'Wijzigingen opslaan';

  @override
  String get addVehicle => 'Voertuig toevoegen';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Services worden als achterstallig weergegeven';

  @override
  String get newVehicleServicesOverdueBody =>
      'Omdat je voertuig al meer dan 500 km heeft, worden alle onderhoudsservices als achterstallig weergegeven.\n\nRegistreer de services die je al hebt laten uitvoeren. Als je de exacte kilometerstand niet meer weet, geef dan een geschatte km-waarde op voor de laatste service.';

  @override
  String get deleteVehicle => 'Voertuig verwijderen';

  @override
  String get deleteVehicleConfirm =>
      'Deze actie kan niet ongedaan worden gemaakt. Alle bijbehorende tanklogboeken, onderhoudsrecords en intervallen worden verwijderd.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get resetToDefault => 'Herstellen naar standaard';

  @override
  String get delete => 'Verwijderen';

  @override
  String get dataManagerTitle => 'Gegevens exporteren / importeren';

  @override
  String get selectAll => 'Alles selecteren';

  @override
  String get exporting => 'Exporteren...';

  @override
  String get export => 'Exporteren';

  @override
  String get importing => 'Importeren...';

  @override
  String get import => 'Importeren';

  @override
  String get saveExport => 'Export opslaan';

  @override
  String exportedAt(Object path) {
    return 'Geëxporteerd naar $path';
  }

  @override
  String exportError(Object error) {
    return 'Exportfout: $error';
  }

  @override
  String get importData => 'Gegevens importeren';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Gevonden:\n• $vehicles voertuig(en)\n• $fuelLogs tanklogboek(en)\n• $maintenanceLogs onderhoudslogboek(en)\n• $documents document(en)\n\nImporteren? Bestaande gegevens met dezelfde ID worden overschreven.';
  }

  @override
  String get importSuccess => 'Gegevens succesvol geïmporteerd';

  @override
  String importError(Object error) {
    return 'Importfout: $error';
  }

  @override
  String get invalidJson => 'Ongeldig JSON-bestand';

  @override
  String exportShareText(Object count) {
    return 'Karter Export — $count voertuig(en)';
  }

  @override
  String get maintenanceSettingsTitle => 'Onderhoudsintervallen';

  @override
  String get maintenanceSettingsInstruction =>
      'Schakel items in of uit op basis van de behoeften van je voertuig. Aangepaste intervallen kunnen worden verwijderd.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Tijd (maanden)';

  @override
  String get partsTitle => 'Onderdelen';

  @override
  String get partUnitUnit => 'stuk';

  @override
  String get partUnitSet => 'set';

  @override
  String get partUnitKit => 'set';

  @override
  String get partUnitCan => 'blik';

  @override
  String get partUnitLabel => 'Eenheid';

  @override
  String get localParts => 'Lokale onderdelen';

  @override
  String get intervalParts => 'Intervalonderdelen';

  @override
  String get newPart => 'Nieuw onderdeel';

  @override
  String get createPart => 'Onderdeel maken';

  @override
  String get partsSection => 'Onderdelen';

  @override
  String get usedParts => 'Onderdelen';

  @override
  String usedInServicesCount(Object count) {
    return '$count service(s)';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Dit onderdeel wordt gebruikt in $count service(s). Toch verwijderen?';
  }

  @override
  String get reportPartsHeader => 'Onderdelen';

  @override
  String get templateFound => 'Template gevonden';

  @override
  String get templateDisclaimer =>
      'Templatedata is alleen ter referentie. Controleer intervallen altijd aan de hand van het onderhoudsboekje van je voertuig.';

  @override
  String get noTemplate => 'Geen template';

  @override
  String get useTemplate => 'Template gebruiken';

  @override
  String get searchTemplate => 'Template zoeken';

  @override
  String templateWithName(Object name) {
    return 'Template: $name';
  }

  @override
  String get noResultsTitle => 'Geen resultaten';

  @override
  String get noTemplateFoundDescription =>
      'Geen template gevonden voor de ingevoerde gegevens.';

  @override
  String get searchParameters => 'Zoekparameters:';

  @override
  String get defaultIntervalsHint =>
      'Het voertuig gebruikt standaardintervallen.';

  @override
  String get missingTemplateContribute =>
      'Template ontbreekt? Draag bij via github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Alle templates bekijken';

  @override
  String get contribute => 'Bijdragen';

  @override
  String get contributeOnGitHub => 'Bijdragen op GitHub';

  @override
  String get gotIt => 'Begrepen';

  @override
  String get templateUnderConstruction => 'Template in aanbouw';

  @override
  String get templateNotReady =>
      'Deze template is nog niet klaar.\nWe werken eraan!';

  @override
  String get contributionsWelcome =>
      'Bijdragen zijn welkom — voeg templates toe of corrigeer ze voor je voertuig:';

  @override
  String requestedParam(Object params) {
    return 'Gevraagd: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Weet je zeker dat je dit interval wilt verwijderen?';

  @override
  String get addPart => 'Onderdeel toevoegen';

  @override
  String get partName => 'Onderdeelnaam';

  @override
  String get quantity => 'Aantal';

  @override
  String get oemNumber => 'OEM-nummer';

  @override
  String get addLink => 'Link toevoegen';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Openen';

  @override
  String get noLinks => 'Geen links';

  @override
  String get noParts => 'Nog geen onderdelen';

  @override
  String get invalidUrl => 'Ongeldige URL';

  @override
  String get copied => 'Gekopieerd';

  @override
  String get linksTitle => 'Referentielinks';

  @override
  String get copy => 'Kopiëren';

  @override
  String get addModeManual => 'Handmatig';

  @override
  String get addModeTemplate => 'Template';

  @override
  String get newFromTemplate => 'Nieuw vanuit template';

  @override
  String get updatesAvailable => 'Updates beschikbaar';

  @override
  String get restore => 'Herstellen';

  @override
  String get windowMinimize => 'Minimaliseren';

  @override
  String get windowMaximize => 'Maximaliseren';

  @override
  String get windowClose => 'Sluiten';

  @override
  String get syncInstruction =>
      'Synchroniseer onderhoudsintervallen vanuit de template van je voertuig.';

  @override
  String get upToDate => 'Alles up-to-date';

  @override
  String get syncAdded => 'Interval toegevoegd vanuit template';

  @override
  String get syncRestored => 'Interval hersteld vanuit template';

  @override
  String get months => 'maanden';

  @override
  String get description => 'Beschrijving';

  @override
  String get newInterval => 'Nieuw interval';

  @override
  String get name => 'Naam';

  @override
  String get add => 'Toevoegen';

  @override
  String get edit => 'Bewerken';

  @override
  String get addToDashboard => 'Toevoegen aan dashboard';

  @override
  String get setupNotifications => 'Meldingen instellen';

  @override
  String get addToDashboardComingSoon => 'Binnenkort beschikbaar';

  @override
  String get deleteInterval => 'Verwijderen';

  @override
  String get noDescriptionAvailableSettings =>
      'Geen beschrijving beschikbaar. Druk op \"Bewerken\" om er een toe te voegen.';

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
    return 'elke $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months maanden';
  }

  @override
  String get maintenanceLogTitleEdit => 'Service bewerken';

  @override
  String get maintenanceLogTitleNew => 'Nieuwe service';

  @override
  String date(Object date) {
    return 'Datum: $date';
  }

  @override
  String get descriptionRequired => 'Beschrijving';

  @override
  String get odometerAtService => 'Kilometerstand bij service (optioneel)';

  @override
  String get resetInterval => 'Interval resetten (optioneel)';

  @override
  String get saveChangesShort => 'Wijzigingen opslaan';

  @override
  String get saveService => 'Service opslaan';

  @override
  String get saveFile => 'Bestand opslaan';

  @override
  String get lastService => 'Laatste';

  @override
  String get addPhoto => 'Foto toevoegen';

  @override
  String get photos => 'foto\'s';

  @override
  String get files => 'bestanden';

  @override
  String get share => 'Delen';

  @override
  String get deleteService => 'Service verwijderen';

  @override
  String get deleteServiceConfirm =>
      'Weet je zeker dat je deze service wilt verwijderen?';

  @override
  String get maintenanceListTitle => 'Onderhoud';

  @override
  String get maintenanceEmpty => 'Geen services geregistreerd';

  @override
  String get maintenanceHistoryTab => 'Geschiedenis';

  @override
  String get maintenancePdfExportTab => 'PDF-export';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count service(s) in deze periode';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... en nog $count meer';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Geen services in dit datumbereik.';

  @override
  String get maintenanceExportPdf => 'PDF exporteren';

  @override
  String get maintenanceSharePdf => 'Delen';

  @override
  String get maintenanceReportTitle => 'Onderhoudsrapport';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Gegenereerd $date $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'Geen onderhoudslogboeken in deze periode.';

  @override
  String get maintenanceReportDateHeader => 'Datum';

  @override
  String get maintenanceReportDescHeader => 'Beschrijving';

  @override
  String get maintenanceReportOdometerHeader => 'Kilometerstand';

  @override
  String get addDocument => 'Document toevoegen';

  @override
  String get documentType => 'Documenttype';

  @override
  String get selectFile => 'Bestand selecteren';

  @override
  String get noFileSelected => 'Geen bestand geselecteerd';

  @override
  String get notesOptional => 'Notities (optioneel)';

  @override
  String get expiryDateOptional => 'Vervaldatum (optioneel)';

  @override
  String get pleaseSelectFile => 'Selecteer een bestand';

  @override
  String get documentSaved => 'Document opgeslagen';

  @override
  String get takePhoto => 'Foto maken';

  @override
  String get chooseFromGallery => 'Kiezen uit galerij';

  @override
  String get browseFiles => 'Bestanden doorbladeren';

  @override
  String get docTypeFine => 'Boete';

  @override
  String get docTypeParkingFee => 'Parkeerkosten';

  @override
  String get docTypeInsurance => 'Verzekering';

  @override
  String get docTypeVehicleCheck => 'APK-keuring';

  @override
  String get docTypeTax => 'Belasting';

  @override
  String get docTypeComplexInsurance => 'Allriskverzekering';

  @override
  String get docTypeVehicleRegister => 'Voertuigregister';

  @override
  String get docTypeOther => 'Overig';

  @override
  String get vehicleDocuments => 'Documenten';

  @override
  String get fuelFormTitle => 'Nieuwe tankbeurt';

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
  String get pricePerUnit => 'Prijs per eenheid (optioneel)';

  @override
  String get fullTank => 'Volle tank';

  @override
  String get volumeUnit => 'Brandstofvolume-eenheid';

  @override
  String get currency => 'Valuta';

  @override
  String get cost => 'Kosten (optioneel)';

  @override
  String get saveFuelUp => 'Tankbeurt opslaan';

  @override
  String get fuelListTitle => 'Tanklogboek';

  @override
  String get fuelEmpty => 'Geen tankbeurten geregistreerd';

  @override
  String get moreAbout => 'Over Karter';

  @override
  String get moreDescription =>
      'Karter is een lokale, open source onderhoudsapp voor voertuigen die je privacy respecteert.';

  @override
  String get moreExport => 'Gegevens exporteren / importeren';

  @override
  String get moreExportSubtitle =>
      'Back-up maken van of je gegevens overdragen';

  @override
  String get moreDocs => 'Documentatie';

  @override
  String get moreDocsSubtitle => 'Gebruikershandleiding en functies';

  @override
  String get moreSource => 'Broncode';

  @override
  String get moreSourceSubtitle => 'GitHub-repository';

  @override
  String get moreDonate => 'Doneren';

  @override
  String get moreDonateSubtitle =>
      'Ondersteun de ontwikkeling via GitHub Sponsors';

  @override
  String get moreFooter => 'Gemaakt met ❤️ door abrahdev';

  @override
  String get moreRate => 'Karter beoordelen';

  @override
  String get moreRateSubtitle => 'Laat een beoordeling achter in de Play Store';

  @override
  String get moreFeedback => 'Beoordeel de app';

  @override
  String get moreFeedbackSubtitle =>
      'Beoordeel de app en stel herinneringen in';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Voorkeuren';

  @override
  String get sectionData => 'Gegevens';

  @override
  String get sectionFeedbackCommunity => 'Feedback & Community';

  @override
  String get sectionTips => 'Tip-programma';

  @override
  String get sectionAbout => 'Over Karter';

  @override
  String get theme => 'Thema';

  @override
  String get themeAutomatic => 'Automatisch';

  @override
  String get themeAutomaticDesc => 'Volg apparaatinstelling';

  @override
  String get themeSystem => 'Systeem';

  @override
  String get themeSystemDesc => 'Volg apparaatinstelling';

  @override
  String get themeLight => 'Licht';

  @override
  String get themeDark => 'Donker';

  @override
  String get colorScheme => 'Primaire kleur';

  @override
  String get colorCustom => 'Aangepast';

  @override
  String get colorOfInterface => 'Interfacekleur';

  @override
  String get colorOfInterfaceDesc =>
      'Pas primaire kleur toe op achtergrondvlakken';

  @override
  String get customColor => 'Aangepaste kleur';

  @override
  String get customColorDesc =>
      'Gebruik een persoonlijke kleur in plaats van de systeemaccentkleur';

  @override
  String get selectColor => 'Selecteer een kleur';

  @override
  String get hapticFeedback => 'Haptische feedback';

  @override
  String get hapticFeedbackDesc => 'Trillen bij interacties';

  @override
  String get hapticModeOff => 'Uit';

  @override
  String get hapticModeOffDesc => 'Geen trilling bij interacties';

  @override
  String get hapticModeClear => 'Helder';

  @override
  String get hapticModeClearDesc => 'Eén duidelijke tik per actie';

  @override
  String get hapticModeRich => 'Rijk';

  @override
  String get hapticModeRichDesc =>
      'Gelaagde trillingen met wisselende intensiteit';

  @override
  String get testNotification => 'Testmelding';

  @override
  String get testNotificationDesc =>
      'Verstuur een testmelding om de instellingen te controleren';

  @override
  String get testNotificationSent => 'Testmelding verzonden';

  @override
  String get notificationsPermissionTitle => 'Meldingen uitgeschakeld';

  @override
  String get notificationsPermissionDesc =>
      'Schakel meldingen in om kilometerteller- en onderhoudsherinneringen te ontvangen';

  @override
  String get notificationsPermissionAllow => 'Meldingen toestaan';

  @override
  String get notificationsPermissionDeniedTitle => 'Meldingen geblokkeerd';

  @override
  String get notificationsPermissionDeniedDesc =>
      'De meldingstoestemming is permanent geweigerd. Om deze in te schakelen ga je naar Instellingen > Apps > Karter > Meldingen en zet je ze aan.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Open de apparaatinstellingen';

  @override
  String get notificationsPermissionDeniedStep2 => '2. Ga naar Apps > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Tik op Meldingen';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Schakel \"Meldingen weergeven\" in';

  @override
  String get notificationsPermissionOpenSettings => 'Instellingen openen';

  @override
  String get shakeToOdometer => 'Schudden om kilometerteller bij te werken';

  @override
  String get shakeToOdometerDesc =>
      'Schud het apparaat om de kilometerteller-update te openen op het voertuigscherm';

  @override
  String get feedbackReminderToggle => 'Beoordelingsherinnering';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Toon een herinnering om de app te beoordelen na het opslaan van services';

  @override
  String get feedbackServicesInterval => 'Services voor prompt';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Na $count service(s)';
  }

  @override
  String get feedbackServicesSuffix => 'services';

  @override
  String get feedbackRepeatDays => 'Herinneringsinterval';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Elke $days dag(en)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'dagen';

  @override
  String get ratePromptMessage =>
      'Bevalt Karter? Een beoordeling helpt anderen de app te ontdekken!';

  @override
  String get rate => 'Beoordelen';

  @override
  String moreUrlError(Object url) {
    return 'Kan $url niet openen';
  }

  @override
  String get tipProgram => 'Tip-programma';

  @override
  String get tipProgramComingSoon =>
      'Deze functie is in ontwikkeling en zal binnenkort beschikbaar zijn.';

  @override
  String get tipBadges => 'Badges';

  @override
  String get tipBadgesNone => 'Geen';

  @override
  String get tipInfo => 'Informatie';

  @override
  String get tipInfoText =>
      'Het tip-programma is een manier voor gebruikers om extra steun en waardering te tonen voor de snelle ondersteuning, voortdurende verbeteringen en doorlopende updates die Karter heeft geboden.';

  @override
  String get tipOneTime => 'Eenmalige tip';

  @override
  String get tipRecurring => 'Terugkerende tip';

  @override
  String get tipBronze => 'Brons';

  @override
  String get tipSilver => 'Zilver';

  @override
  String get tipGold => 'Goud';

  @override
  String get tipBronzePrice => 'Brons tip';

  @override
  String get tipSilverPrice => 'Zilveren tip';

  @override
  String get tipGoldPrice => 'Gouden tip';

  @override
  String get tipBronzeMonthly => 'Brons / maand';

  @override
  String get tipSilverMonthly => 'Zilver / maand';

  @override
  String get tipGoldMonthly => 'Goud / maand';

  @override
  String get officialWebsite => 'Officiële website';

  @override
  String get communityForums => 'Communityforums';

  @override
  String get translations => 'Vertalingen';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get privacyPolicyDesc => 'Lees ons privacybeleid online.';

  @override
  String get openPrivacyPolicy => 'Privacybeleid openen';

  @override
  String get version => 'Versie';

  @override
  String get deviceId => 'Apparaat-ID';

  @override
  String get changelog => 'Wijzigingslogboek';

  @override
  String get openSourceLicenses => 'Open-sourcelicenties';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get languageSystem => 'Systeemstandaard';

  @override
  String get english => 'Engels';

  @override
  String get spanish => 'Spaans';

  @override
  String get eesti => 'Eesti';

  @override
  String get german => 'Duits';

  @override
  String get portuguese => 'Portugees';

  @override
  String get russian => 'Russisch';

  @override
  String get french => 'Frans';

  @override
  String get polish => 'Pools';

  @override
  String get italian => 'Italiaans';

  @override
  String get dutch => 'Nederlands';

  @override
  String get odometerUpdateTitle => 'Kilometerteller bijwerken';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Laatste: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'De waarde is lager dan de laatste registratie ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Je hebt $delta $unit gereden sinds de laatste keer. Klopt dit?';
  }

  @override
  String get odometerSave => 'Opslaan';

  @override
  String get odometerCancel => 'Annuleren';

  @override
  String get moreNotifications => 'Meldingen';

  @override
  String get moreNotificationsSubtitle =>
      'Kilometerteller- en onderhoudsherinneringen';

  @override
  String get notificationSettingsTitle => 'Meldinginstellingen';

  @override
  String get notificationSettingsSubtitle =>
      'Configureer herinneringen voor dit voertuig';

  @override
  String get notificationOdometerSection => 'Kilometerteller-herinnering';

  @override
  String get notificationMaintenanceSection => 'Onderhoudsherinnering';

  @override
  String get notificationFreqLabel => 'Herinneringsfrequentie';

  @override
  String get notificationFreqOff => 'Uit';

  @override
  String notificationFreqValue(Object days) {
    return 'Elke $days dagen';
  }

  @override
  String get notificationMaintenanceToggle => 'Onderhoudsherinneringen';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Ontvang dagelijkse herinneringen over uitstaand onderhoud';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Nog $days dag(en) uitgesteld';
  }

  @override
  String get notificationSnoozeCancel => 'Uitstel annuleren';

  @override
  String get notificationNoVehicles =>
      'Voeg een voertuig toe om meldingen te configureren';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Kilometerteller: $freq • Onderhoud: $maint';
  }

  @override
  String get notificationConfigure => 'Configureren';

  @override
  String get notificationMaintOn => 'Aan';

  @override
  String get notificationMaintOff => 'Uit';

  @override
  String get notificationSnoozeAction => '1 week uitstellen';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Uitgesteld tot $date';
  }

  @override
  String get notificationFreqWeekly => 'Elke 7 dagen';

  @override
  String get notificationFreqMonthly => 'Elke 30 dagen';

  @override
  String get notificationFreqCustom => 'Aangepast';

  @override
  String notificationFreqDays(Object days) {
    return '$days dagen';
  }

  @override
  String get notificationMaintenanceSnooze => 'Onderhoud 1 week uitstellen';

  @override
  String get notificationSnoozeToggle => 'Herinneringen uitstellen';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days dagen';
  }

  @override
  String get unsavedChanges => 'Niet-opgeslagen wijzigingen';

  @override
  String get discardChangesConfirm =>
      'Je hebt niet-opgeslagen wijzigingen. Weet je zeker dat je wilt afsluiten?';

  @override
  String get discard => 'Verwerpen';

  @override
  String get moreTemplateSource => 'Templatebron';

  @override
  String get moreTemplateSourceSubtitle =>
      'Templates ophalen van GitHub of lokale assets gebruiken';

  @override
  String get moreTemplateSourceOffline => 'Lokaal (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'Repo-URL';

  @override
  String get moreTemplateSourceReset => 'Herstellen naar standaard';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'URL bewerken';

  @override
  String get moreTemplateSourceUrlSaved => 'URL bijgewerkt';

  @override
  String get testConnection => 'Verbinding testen';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Laatst gewijzigd: $date';
  }

  @override
  String get importCheckTranslations => 'Vertalingen';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found van $total beschikbaar';
  }

  @override
  String get importCheckIndex => 'Template-index';

  @override
  String importCheckIndexResult(int count) {
    return '$count templates';
  }

  @override
  String get importCheckDb => 'Catalogusdatabase (extern)';

  @override
  String get importCheckDbRemoteFound => 'Beschikbaar op GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Alleen lokaal (niet op GitHub)';

  @override
  String get importCheckDbLocal => 'Geïmporteerde databasegegevens';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Versie: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Voertuigen: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Onderhoudsitems: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Onderdelen: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'OBD-codes: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Kan de geïmporteerde database niet lezen';

  @override
  String get onboardingSkip => 'Overslaan';

  @override
  String get onboardingNext => 'Volgende';

  @override
  String get onboardingDone => 'Aan de slag';

  @override
  String get onboardingReplay => 'Welkomstscherm bekijken';

  @override
  String get onboardingReplaySubtitle =>
      'Speel de welkomstwandeling opnieuw af';

  @override
  String get onboardingWelcomeTitle => 'Welkom bij Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Een privacy-eerst, open source onderhoudstracker voor voertuigen. 100% offline — geen accounts, geen telemetrie, geen tracking.';

  @override
  String get onboardingVehicleTitle => 'Voeg je voertuig toe';

  @override
  String get onboardingVehicleDesc =>
      'Registreer je auto, motorfiets of EV. Kies een template en Karter vult automatisch de onderhoudsintervallen voor je model in.';

  @override
  String get onboardingTrackTitle => 'Volg brandstof & onderhoud';

  @override
  String get onboardingTrackDesc =>
      'Leg tankbeurten vast met automatische verbruiksberekeningen (MPG, L/100km, km/L). Houd reparaties, onderdelen en kosten bij.';

  @override
  String get onboardingRemindersTitle => 'Blijf op de hoogte van onderhoud';

  @override
  String get onboardingRemindersDesc =>
      'Ontvang meldingen wanneer het tijd is voor olieverversing, remblokken en elk onderhoudsinterval — op afstand of tijd.';

  @override
  String get supporterBadge => 'Je bent een Karter-supporter!';

  @override
  String get restorePurchases => 'Aankopen herstellen';

  @override
  String get tipPurchased => 'Dank je wel!';

  @override
  String get tipSupport => 'Ondersteunen';

  @override
  String get sectionBackup => 'Back-up';

  @override
  String get moreBackup => 'Back-up';

  @override
  String get moreBackupSubtitle => 'Versleutelde back-up';

  @override
  String get backupConnect => 'Google Drive verbinden';

  @override
  String backupConnected(Object email) {
    return 'Verbonden als $email';
  }

  @override
  String get backupNow => 'Nu een back-up maken';

  @override
  String get backupInProgress => 'Back-up maken…';

  @override
  String backupLast(Object date) {
    return 'Laatste back-up: $date';
  }

  @override
  String get backupNever => 'Nooit een back-up gemaakt';

  @override
  String get backupRestore => 'Herstellen vanuit back-up';

  @override
  String get backupRestoreInProgress => 'Herstellen…';

  @override
  String get backupRestoreConfirm =>
      'Dit overschrijft alle huidige gegevens. Weet je het zeker?';

  @override
  String backupError(Object error) {
    return 'Back-upfout: $error';
  }

  @override
  String get backupSuccess => 'Back-up succesvol geüpload';

  @override
  String get backupRestoreSuccess =>
      'Gegevens hersteld. Start de app opnieuw om de wijzigingen te zien.';

  @override
  String get backupDisconnect => 'Verbinding verbreken';

  @override
  String get backupNoBackups => 'Geen back-ups gevonden';

  @override
  String get backupRestoreBtn => 'Herstellen';

  @override
  String get backupDelete => 'Verwijderen';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Back-up $name verwijderen?';
  }

  @override
  String get backupDeleteSuccess => 'Back-up verwijderd';

  @override
  String backupCount(Object current, Object max) {
    return 'Back-ups: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Foutcodes opzoeken';

  @override
  String get dtcSearchHint => 'Voer een code in, bijv. P0171';

  @override
  String get dtcEmptyState => 'Typ een code om de beschrijving op te zoeken';

  @override
  String get dtcNoMatch =>
      'Geen codes gevonden die overeenkomen met je zoekopdracht';

  @override
  String get dtcDescription => 'Beschrijving';

  @override
  String get dtcRelatedMaintenance => 'Gerelateerd onderhoud';

  @override
  String get dtcScopeStandard => 'Standaard';

  @override
  String get dtcScopeManufacturer => 'Fabrikant';

  @override
  String get dtcGeneralDb => 'Algemene OBD-II-codes';

  @override
  String get dtcCatalogBrands => 'Catalogusmerken';

  @override
  String get dtcMyVehicles => 'Mijn voertuigen';

  @override
  String get dtcVehicle => 'Voertuig';

  @override
  String get dtcVehicleNotFound => 'Voertuig niet gevonden';

  @override
  String get dtcLoadError => 'Kan foutcodes niet laden';

  @override
  String get notificationOdometerTitle => 'Kilometerteller bijwerken';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days dagen sinds de laatste herinnering.';
  }

  @override
  String get notificationMaintenanceTitle => 'Uitstaand onderhoud';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — controleer je onderhoudsintervallen.';
  }

  @override
  String errorGeneric(String error) {
    return 'Fout: $error';
  }

  @override
  String get deleteFuelUp => 'Tankbeurt verwijderen';

  @override
  String get deleteFuelUpConfirm =>
      'Weet je zeker dat je deze tankbeurt wilt verwijderen?';

  @override
  String get editFuelUp => 'Tankbeurt bewerken';

  @override
  String get deleteDocument => 'Document verwijderen';

  @override
  String get deleteDocumentConfirm =>
      'Weet je zeker dat je dit document wilt verwijderen?';

  @override
  String get editDocument => 'Document bewerken';

  @override
  String get title => 'Titel';

  @override
  String get selectExpiryDate => 'Vervaldatum selecteren';

  @override
  String get addMoreFiles => 'Meer bestanden toevoegen';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Templates';

  @override
  String get templatesTitle => 'Templates';

  @override
  String get templatesSubtitle => 'Blader door de communitytemplatecatalogus';

  @override
  String get createTemplate => 'Template maken';

  @override
  String get createTemplateSubtitle =>
      'Stel een template op en exporteer deze als JSON';

  @override
  String get templatesLoadError => 'Kan de templatecatalogus niet laden.';

  @override
  String get searchTemplatesHint => 'Zoek op merk, model of generatie';

  @override
  String get allMakes => 'Alle merken';

  @override
  String get noTemplatesFound =>
      'Geen templates gevonden die overeenkomen met je zoekopdracht.';

  @override
  String templateItemsCount(int count) {
    return '$count onderhoudsitems';
  }

  @override
  String get templateYearsOpen => 'heden';

  @override
  String get templateNotFound => 'Template niet gevonden';

  @override
  String get templateInfo => 'Template-info';

  @override
  String get templateYears => 'Jaren';

  @override
  String get templateEngine => 'Motor';

  @override
  String get templateAuthor => 'Auteur';

  @override
  String get templateVersion => 'Versie';

  @override
  String get templateSources => 'Bronnen';

  @override
  String get dtcCodesTitle => 'Foutcodes';

  @override
  String dtcCount(int count) {
    return '$count foutcode(s)';
  }

  @override
  String get noPartsFound => 'Geen onderdelen';

  @override
  String get createCopied => 'Template-JSON gekopieerd naar klembord';

  @override
  String get saveTemplate => 'Template opslaan';

  @override
  String savedAt(String path) {
    return 'Opgeslagen op $path';
  }

  @override
  String get createHasErrors => 'Los de fouten op om te exporteren';

  @override
  String get createMake => 'Merk';

  @override
  String get createModel => 'Model';

  @override
  String get createGeneration => 'Generatie';

  @override
  String get createYearFrom => 'Jaar vanaf';

  @override
  String get createYearTo => 'Jaar tot';

  @override
  String get createFuel => 'Brandstof';

  @override
  String get createPowertrain => 'Aandrijving';

  @override
  String get createEngineCode => 'Motorcode';

  @override
  String get createDisplacement => 'Cilinderinhoud (cc)';

  @override
  String get createPower => 'Vermogen (pk)';

  @override
  String get templateMetadata => 'Metadata & overerving';

  @override
  String get createAuthor => 'Auteur';

  @override
  String get createAuthorHint => 'Je GitHub-gebruikersnaam';

  @override
  String get createExtends => 'Uitbreiden (basistemplates)';

  @override
  String get createExtendsHint => 'Deel onderhoudsgegevens overnemen';

  @override
  String get createCustomExtends => 'Aangepaste extends-paden';

  @override
  String get createAddPart => 'Onderdeel toevoegen';

  @override
  String get createNoParts => 'Nog geen onderdelen. Onderdelen zijn optioneel.';

  @override
  String get partSingular => 'Onderdeel';

  @override
  String get createAddItem => 'Onderhoudsitem toevoegen';

  @override
  String get createNoItems => 'Nog geen onderhoudsitems.';

  @override
  String get createPreview => 'Voorbeeld';

  @override
  String createErrorsFound(int count) {
    return '$count validatiefout(en)';
  }

  @override
  String get createCopy => 'Kopiëren';

  @override
  String get createShare => 'Delen';

  @override
  String get createSave => 'Opslaan';

  @override
  String get createQuantity => 'Hoeveelheid';

  @override
  String get createI18nKey => 'i18n-sleutel';

  @override
  String get createDescI18nKey => 'Beschrijvings-i18n-sleutel';

  @override
  String get createIntervalKm => 'Interval (km)';

  @override
  String get createIntervalMonths => 'Interval (maanden)';

  @override
  String get createDescription => 'Beschrijving';

  @override
  String get createAddPartRef => 'Onderdeelverwijzing toevoegen';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Naam';

  @override
  String get createFieldUnit => 'Eenheid';

  @override
  String get createFieldOem => 'OEM-nummer';

  @override
  String get createFieldLabel => 'Label';

  @override
  String get createFieldPart => 'Onderdeel';

  @override
  String get fuelGasoline => 'Benzine';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'LPG';

  @override
  String get fuelCng => 'CNG';

  @override
  String get fuelHydrogen => 'Waterstof';

  @override
  String get fuelEthanol => 'Ethanol';

  @override
  String get powertrainCombustion => 'Verbranding';

  @override
  String get powertrainHybrid => 'Hybride';

  @override
  String get powertrainPluginHybrid => 'Plug-inhybride';

  @override
  String get powertrainElectric => 'Elektrisch';

  @override
  String get catalogDb => 'Catalogusdatabase';

  @override
  String get catalogSourceBuiltin => 'Gebundeld (standaard)';

  @override
  String get catalogSourceOnline => 'Online (GitHub-release)';

  @override
  String get catalogSourcesTitle => 'Beschikbare catalogi';

  @override
  String get catalogCannotDelete =>
      'Standaardcatalogus — kan niet worden verwijderd';

  @override
  String catalogVersionOf(String version) {
    return 'Versie $version';
  }

  @override
  String get catalogVersionUnknown => 'Versie niet beschikbaar';

  @override
  String get catalogRefreshOnline => 'Online catalogus vernieuwen';

  @override
  String get catalogRefreshed => 'Online catalogus vernieuwd';

  @override
  String get catalogRefreshFailed => 'Kan de online catalogus niet vernieuwen';

  @override
  String get catalogNotAvailable => 'Deze catalogus is niet beschikbaar';

  @override
  String get catalogImportDb => 'Lokale DB importeren';

  @override
  String get catalogImported => 'Catalogus geïmporteerd';

  @override
  String get catalogImportFailed => 'Kan de catalogus niet importeren';

  @override
  String get catalogDelete => 'Catalogus verwijderen';

  @override
  String catalogDeleteConfirm(String name) {
    return '$name verwijderen? Dit kan niet ongedaan worden gemaakt.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Kan de online catalogus niet downloaden. Controleer je verbinding en probeer het opnieuw.';

  @override
  String get templateUrlExample =>
      'Voorbeeld: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> wordt vervangen door de laatste release van die repository. Je kunt elke GitHub-repository gebruiken of een directe link plakken. Als de tag niet kan worden opgelost, wordt de link ongewijzigd gebruikt en toont de test de fout.';

  @override
  String get templateUrlUsage =>
      'Wordt gebruikt om de catalogus, de template-index en vertalingen (i18n) op te halen.';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Lost op naar: $url';
  }

  @override
  String get templateUrlVersion => 'Versie';

  @override
  String get templateUrlLatest => 'Nieuwste (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Kan versies niet laden';

  @override
  String get templateUrlHelp => 'URL-hulp';

  @override
  String get moreTemplateSourceUrlLabel => 'Repo-URL';

  @override
  String get moreTemplateSourceVersionLatest => 'Nieuwste';

  @override
  String catalogDbVersion(String version) {
    return 'DB-versie: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Release: $version';
  }

  @override
  String get createInheritedParts => 'Overgenomen onderdelen (vanuit extends)';

  @override
  String get createInheritedItems => 'Overgenomen onderhoud (vanuit extends)';

  @override
  String get templateExtendsNotLoaded =>
      'Sommige extends konden niet worden geladen';

  @override
  String get templateRepoLoading => 'Laden vanuit template-repo…';

  @override
  String get templateRepoError => 'Kan de template-repo niet bereiken';

  @override
  String templateBy(String author) {
    return 'door $author';
  }
}
