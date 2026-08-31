// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVehicles => 'Fahrzeuge';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Mehr';

  @override
  String get homeEmptyTitle => 'Keine Fahrzeuge';

  @override
  String get homeEmptySubtitle => 'Füge dein erstes Fahrzeug hinzu';

  @override
  String homeError(Object error) {
    return 'Fehler: $error';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardComingSoon => 'Bald verfügbar';

  @override
  String get vehicleDetailTitle => 'Fahrzeug';

  @override
  String get vehicleNotFound => 'Fahrzeug nicht gefunden';

  @override
  String get plate => 'Kennzeichen';

  @override
  String get vin => 'FIN';

  @override
  String get brandModel => 'Marke / Modell';

  @override
  String get year => 'Jahr';

  @override
  String get odometer => 'Kilometerstand';

  @override
  String get update => 'Aktualisieren';

  @override
  String get actions => 'Aktionen';

  @override
  String get tools => 'Werkzeuge';

  @override
  String get information => 'Informationen';

  @override
  String get fuelLogs => 'Tankfüllungen';

  @override
  String get maintenanceHistory => 'Wartungshistorie';

  @override
  String get configureIntervals => 'Intervalle konfigurieren';

  @override
  String get nextMaintenance => 'Nächste Wartung';

  @override
  String get allIntervalsDisabled => 'Alle Intervalle sind deaktiviert.';

  @override
  String get register => 'Registrieren';

  @override
  String get registerService => 'Service registrieren';

  @override
  String get noDescriptionAvailable =>
      'Keine Beschreibung verfügbar. Gehe zu den Wartungseinstellungen, um eine hinzuzufügen.';

  @override
  String get close => 'Schließen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get overduePerformService => 'Überfällig – Service durchführen';

  @override
  String nextIn(Object parts) {
    return 'In $parts';
  }

  @override
  String get vehicleFormNew => 'Neues Fahrzeug';

  @override
  String get vehicleFormEdit => 'Fahrzeug bearbeiten';

  @override
  String get vehicleFormDetails => 'Details';

  @override
  String get vehicleFormVehicle => 'Fahrzeug';

  @override
  String get brand => 'Marke';

  @override
  String get model => 'Modell';

  @override
  String get required => 'Erforderlich';

  @override
  String get invalidYear => 'Ungültiges Jahr';

  @override
  String get vehicleType => 'Fahrzeugtyp';

  @override
  String get combustion => 'Verbrenner';

  @override
  String get electric => 'Elektrisch';

  @override
  String get motorcycle => 'Motorrad';

  @override
  String get plateOptional => 'Kennzeichen (optional)';

  @override
  String get vinOptional => 'FIN (optional)';

  @override
  String get invalid => 'Ungültig';

  @override
  String get aliasOptional => 'Alias (optional)';

  @override
  String get aliasHint => 'Z. B.: Meine Karre, Das Biest usw.';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get addVehicle => 'Fahrzeug hinzufügen';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Services erscheinen als überfällig';

  @override
  String get newVehicleServicesOverdueBody =>
      'Da dein Fahrzeug bereits mehr als 500 km hat, erscheinen alle Wartungsservices als überfällig.\n\nRegistriere die Services, die du bereits durchgeführt hast. Wenn du dich nicht an den genauen Kilometerstand erinnerst, gib einen ungefähren km-Wert für den letzten Service an.';

  @override
  String get deleteVehicle => 'Fahrzeug löschen';

  @override
  String get deleteVehicleConfirm =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Alle zugehörigen Tankfüllungen, Wartungsaufzeichnungen und Intervalle werden gelöscht.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get resetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get delete => 'Löschen';

  @override
  String get dataManagerTitle => 'Daten exportieren / importieren';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get exporting => 'Exportieren...';

  @override
  String get export => 'Exportieren';

  @override
  String get importing => 'Importieren...';

  @override
  String get import => 'Importieren';

  @override
  String get saveExport => 'Export speichern';

  @override
  String exportedAt(Object path) {
    return 'Exportiert unter $path';
  }

  @override
  String exportError(Object error) {
    return 'Exportfehler: $error';
  }

  @override
  String get importData => 'Daten importieren';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Gefunden:\n• $vehicles Fahrzeug(e)\n• $fuelLogs Tankfüllung(en)\n• $maintenanceLogs Wartungslog(s)\n• $documents Dokument(e)\n\nImportieren? Vorhandene Daten mit derselben ID werden überschrieben.';
  }

  @override
  String get importSuccess => 'Daten erfolgreich importiert';

  @override
  String importError(Object error) {
    return 'Importfehler: $error';
  }

  @override
  String get invalidJson => 'Ungültige JSON-Datei';

  @override
  String exportShareText(Object count) {
    return 'Karter-Export — $count Fahrzeug(e)';
  }

  @override
  String get maintenanceSettingsTitle => 'Wartungsintervalle';

  @override
  String get maintenanceSettingsInstruction =>
      'Aktiviere oder deaktiviere Punkte je nach den Bedürfnissen deines Fahrzeugs. Eigene Intervalle können gelöscht werden.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Zeit (Monate)';

  @override
  String get partsTitle => 'Teile';

  @override
  String get partUnitUnit => 'Stück';

  @override
  String get partUnitSet => 'Satz';

  @override
  String get partUnitKit => 'Kit';

  @override
  String get partUnitCan => 'Dose';

  @override
  String get partUnitLabel => 'Einheit';

  @override
  String get localParts => 'Lokale Teile';

  @override
  String get intervalParts => 'Intervall-Teile';

  @override
  String get newPart => 'Neues Teil';

  @override
  String get createPart => 'Teil erstellen';

  @override
  String get partsSection => 'Teile';

  @override
  String get usedParts => 'Teile';

  @override
  String usedInServicesCount(Object count) {
    return 'In $count Service(s) verwendet';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Dieses Teil wird in $count Service(s) verwendet. Trotzdem löschen?';
  }

  @override
  String get reportPartsHeader => 'Teile';

  @override
  String get templateFound => 'Vorlage gefunden';

  @override
  String get templateDisclaimer =>
      'Vorlagendaten dienen nur als Referenz. Überprüfe die Intervalle immer anhand des Handbuchs deines Fahrzeugs.';

  @override
  String get noTemplate => 'Keine Vorlage';

  @override
  String get useTemplate => 'Vorlage verwenden';

  @override
  String get searchTemplate => 'Vorlage suchen';

  @override
  String templateWithName(Object name) {
    return 'Vorlage: $name';
  }

  @override
  String get noResultsTitle => 'Keine Ergebnisse';

  @override
  String get noTemplateFoundDescription =>
      'Für die eingegebenen Daten wurde keine Vorlage gefunden.';

  @override
  String get searchParameters => 'Suchparameter:';

  @override
  String get defaultIntervalsHint =>
      'Das Fahrzeug verwendet Standardintervalle.';

  @override
  String get missingTemplateContribute =>
      'Vorlage fehlt? Trage unter github.com/abrahdev/karter bei';

  @override
  String get viewAllTemplates => 'Alle Vorlagen anzeigen';

  @override
  String get contribute => 'Beitragen';

  @override
  String get contributeOnGitHub => 'Auf GitHub beitragen';

  @override
  String get gotIt => 'Verstanden';

  @override
  String get templateUnderConstruction => 'Vorlage in Bearbeitung';

  @override
  String get templateNotReady =>
      'Diese Vorlage ist noch nicht fertig.\nWir arbeiten daran!';

  @override
  String get contributionsWelcome =>
      'Beiträge sind willkommen – füge Vorlagen für dein Fahrzeug hinzu oder korrigiere sie:';

  @override
  String requestedParam(Object params) {
    return 'Angefragt: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Bist du sicher, dass du dieses Intervall löschen möchtest?';

  @override
  String get addPart => 'Teil hinzufügen';

  @override
  String get partName => 'Teilename';

  @override
  String get quantity => 'Menge';

  @override
  String get oemNumber => 'OEM-Nummer';

  @override
  String get addLink => 'Link hinzufügen';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Öffnen';

  @override
  String get noLinks => 'Keine Links';

  @override
  String get noParts => 'Noch keine Teile';

  @override
  String get invalidUrl => 'Ungültige URL';

  @override
  String get copied => 'Kopiert';

  @override
  String get linksTitle => 'Referenzlinks';

  @override
  String get copy => 'Kopieren';

  @override
  String get addModeManual => 'Manuell';

  @override
  String get addModeTemplate => 'Vorlage';

  @override
  String get newFromTemplate => 'Neu aus Vorlage';

  @override
  String get updatesAvailable => 'Updates verfügbar';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get windowMinimize => 'Minimieren';

  @override
  String get windowMaximize => 'Maximieren';

  @override
  String get windowClose => 'Schließen';

  @override
  String get syncInstruction =>
      'Synchronisiere Wartungsintervalle aus der Vorlage deines Fahrzeugs.';

  @override
  String get upToDate => 'Alles aktuell';

  @override
  String get syncAdded => 'Intervall aus Vorlage hinzugefügt';

  @override
  String get syncRestored => 'Intervall aus Vorlage wiederhergestellt';

  @override
  String get months => 'Monate';

  @override
  String get description => 'Beschreibung';

  @override
  String get newInterval => 'Neues Intervall';

  @override
  String get name => 'Name';

  @override
  String get add => 'Hinzufügen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get addToDashboard => 'Zum Dashboard hinzufügen';

  @override
  String get setupNotifications => 'Benachrichtigungen einrichten';

  @override
  String get addToDashboardComingSoon => 'Bald verfügbar';

  @override
  String get deleteInterval => 'Löschen';

  @override
  String get noDescriptionAvailableSettings =>
      'Keine Beschreibung verfügbar. Drücke auf „Bearbeiten“, um eine hinzuzufügen.';

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
    return 'alle $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months Monate';
  }

  @override
  String get maintenanceLogTitleEdit => 'Service bearbeiten';

  @override
  String get maintenanceLogTitleNew => 'Neuer Service';

  @override
  String date(Object date) {
    return 'Datum: $date';
  }

  @override
  String get descriptionRequired => 'Beschreibung';

  @override
  String get odometerAtService => 'Kilometerstand beim Service (optional)';

  @override
  String get resetInterval => 'Intervall zurücksetzen (optional)';

  @override
  String get saveChangesShort => 'Änderungen speichern';

  @override
  String get saveService => 'Service speichern';

  @override
  String get saveFile => 'Datei speichern';

  @override
  String get lastService => 'Letzter';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get photos => 'Fotos';

  @override
  String get files => 'Dateien';

  @override
  String get share => 'Teilen';

  @override
  String get deleteService => 'Service löschen';

  @override
  String get deleteServiceConfirm =>
      'Bist du sicher, dass du diesen Service löschen möchtest?';

  @override
  String get maintenanceListTitle => 'Wartung';

  @override
  String get maintenanceEmpty => 'Keine Services aufgezeichnet';

  @override
  String get maintenanceHistoryTab => 'Verlauf';

  @override
  String get maintenancePdfExportTab => 'PDF-Export';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count Service(s) in diesem Zeitraum';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... und $count weitere';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Keine Services in diesem Datumsbereich.';

  @override
  String get maintenanceExportPdf => 'PDF exportieren';

  @override
  String get maintenanceSharePdf => 'Teilen';

  @override
  String get maintenanceReportTitle => 'Wartungsbericht';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Erstellt am $date $time';
  }

  @override
  String get maintenanceReportEmpty => 'Keine Wartungslogs in diesem Zeitraum.';

  @override
  String get maintenanceReportDateHeader => 'Datum';

  @override
  String get maintenanceReportDescHeader => 'Beschreibung';

  @override
  String get maintenanceReportOdometerHeader => 'Kilometerstand';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get documentType => 'Dokumenttyp';

  @override
  String get selectFile => 'Datei auswählen';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt';

  @override
  String get notesOptional => 'Notizen (optional)';

  @override
  String get expiryDateOptional => 'Ablaufdatum (optional)';

  @override
  String get pleaseSelectFile => 'Bitte wähle eine Datei';

  @override
  String get documentSaved => 'Dokument gespeichert';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get browseFiles => 'Dateien durchsuchen';

  @override
  String get docTypeFine => 'Bußgeld';

  @override
  String get docTypeParkingFee => 'Parkgebühr';

  @override
  String get docTypeInsurance => 'Versicherung';

  @override
  String get docTypeVehicleCheck => 'Fahrzeugprüfung';

  @override
  String get docTypeTax => 'Steuer';

  @override
  String get docTypeComplexInsurance => 'Komplexe Versicherung';

  @override
  String get docTypeVehicleRegister => 'Fahrzeugzulassung';

  @override
  String get docTypeOther => 'Sonstiges';

  @override
  String get vehicleDocuments => 'Dokumente';

  @override
  String get fuelFormTitle => 'Neuer Tankvorgang';

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
  String get pricePerUnit => 'Preis pro Einheit (optional)';

  @override
  String get fullTank => 'Voller Tank';

  @override
  String get volumeUnit => 'Einheit für das Kraftstoffvolumen';

  @override
  String get currency => 'Währung';

  @override
  String get cost => 'Kosten (optional)';

  @override
  String get saveFuelUp => 'Tankvorgang speichern';

  @override
  String get fuelListTitle => 'Tankfüllungen';

  @override
  String get fuelEmpty => 'Keine Tankvorgänge aufgezeichnet';

  @override
  String get moreAbout => 'Über Karter';

  @override
  String get moreDescription =>
      'Karter ist eine lokal gespeicherte, quelloffene Fahrzeugwartungs-App, die deine Privatsphäre respektiert.';

  @override
  String get moreExport => 'Daten exportieren / importieren';

  @override
  String get moreExportSubtitle => 'Sichere oder übertrage deine Daten';

  @override
  String get moreDocs => 'Dokumentation';

  @override
  String get moreDocsSubtitle => 'Anleitung und Funktionen';

  @override
  String get moreSource => 'Quellcode';

  @override
  String get moreSourceSubtitle => 'GitHub-Repository';

  @override
  String get moreDonate => 'Spenden';

  @override
  String get moreDonateSubtitle =>
      'Unterstütze die Entwicklung auf GitHub Sponsors';

  @override
  String get moreFooter => 'Mit ❤️ von abrahdev erstellt';

  @override
  String get moreRate => 'Karter bewerten';

  @override
  String get moreRateSubtitle => 'Hinterlasse eine Bewertung im Play Store';

  @override
  String get moreFeedback => 'App bewerten';

  @override
  String get moreFeedbackSubtitle =>
      'Bewerte die App und konfiguriere Erinnerungen';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Einstellungen';

  @override
  String get sectionData => 'Daten';

  @override
  String get sectionFeedbackCommunity => 'Feedback & Community';

  @override
  String get sectionTips => 'Trinkgeld-Programm';

  @override
  String get sectionAbout => 'Über Karter';

  @override
  String get theme => 'Design';

  @override
  String get themeAutomatic => 'Automatisch';

  @override
  String get themeAutomaticDesc => 'Geräteeinstellung folgen';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemDesc => 'Geräteeinstellung folgen';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get colorScheme => 'Primärfarbe';

  @override
  String get colorCustom => 'Benutzerdefiniert';

  @override
  String get colorOfInterface => 'Oberflächenfarbe';

  @override
  String get colorOfInterfaceDesc =>
      'Primärfarbe auf Hintergrundflächen anwenden';

  @override
  String get customColor => 'Eigene Farbe';

  @override
  String get customColorDesc =>
      'Eine persönliche Farbe statt des System-Akzents verwenden';

  @override
  String get selectColor => 'Farbe auswählen';

  @override
  String get hapticFeedback => 'Haptisches Feedback';

  @override
  String get hapticFeedbackDesc => 'Bei Interaktionen vibrieren';

  @override
  String get hapticModeOff => 'Aus';

  @override
  String get hapticModeOffDesc => 'Keine Vibration bei Interaktionen';

  @override
  String get hapticModeClear => 'Deutlich';

  @override
  String get hapticModeClearDesc => 'Ein klarer Tipp pro Aktion';

  @override
  String get hapticModeRich => 'Reichhaltig';

  @override
  String get hapticModeRichDesc =>
      'Mehrschichtige Vibrationen mit unterschiedlicher Intensität';

  @override
  String get testNotification => 'Testbenachrichtigung';

  @override
  String get testNotificationDesc =>
      'Sende eine Testbenachrichtigung zur Überprüfung der Einrichtung';

  @override
  String get testNotificationSent => 'Testbenachrichtigung gesendet';

  @override
  String get notificationsPermissionTitle => 'Benachrichtigungen deaktiviert';

  @override
  String get notificationsPermissionDesc =>
      'Aktiviere Benachrichtigungen, um Erinnerungen an Kilometerstand und Wartung zu erhalten';

  @override
  String get notificationsPermissionAllow => 'Benachrichtigungen erlauben';

  @override
  String get notificationsPermissionDeniedTitle =>
      'Benachrichtigungen blockiert';

  @override
  String get notificationsPermissionDeniedDesc =>
      'Die Benachrichtigungsberechtigung wurde dauerhaft verweigert. Um sie zu aktivieren, gehe zu Einstellungen > Apps > Karter > Benachrichtigungen und aktiviere sie.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Öffne die Geräteeinstellungen';

  @override
  String get notificationsPermissionDeniedStep2 => '2. Gehe zu Apps > Karter';

  @override
  String get notificationsPermissionDeniedStep3 =>
      '3. Tippe auf Benachrichtigungen';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Aktiviere „Benachrichtigungen anzeigen“';

  @override
  String get notificationsPermissionOpenSettings => 'Einstellungen öffnen';

  @override
  String get shakeToOdometer =>
      'Schütteln zum Aktualisieren des Kilometerstands';

  @override
  String get shakeToOdometerDesc =>
      'Schüttle das Gerät, um die Kilometerstand-Aktualisierung auf dem Fahrzeugbildschirm zu öffnen';

  @override
  String get feedbackReminderToggle => 'Bewertungserinnerung';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Nach dem Speichern von Services eine Erinnerung zur Bewertung der App anzeigen';

  @override
  String get feedbackServicesInterval => 'Services vor Abfrage';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Nach $count Service(s)';
  }

  @override
  String get feedbackServicesSuffix => 'Services';

  @override
  String get feedbackRepeatDays => 'Erinnerungsintervall';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Alle $days Tag(e)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'Tage';

  @override
  String get ratePromptMessage =>
      'Gefällt dir Karter? Eine Bewertung hilft anderen, die App zu entdecken!';

  @override
  String get rate => 'Bewerten';

  @override
  String moreUrlError(Object url) {
    return 'Konnte $url nicht öffnen';
  }

  @override
  String get tipProgram => 'Trinkgeld-Programm';

  @override
  String get tipProgramComingSoon =>
      'Diese Funktion wird gerade entwickelt und ist bald verfügbar.';

  @override
  String get tipBadges => 'Abzeichen';

  @override
  String get tipBadgesNone => 'Keine';

  @override
  String get tipInfo => 'Informationen';

  @override
  String get tipInfoText =>
      'Das Trinkgeld-Programm ist eine Möglichkeit für Nutzer, zusätzliche Unterstützung und Wertschätzung für den schnellen Support, die ständigen Verbesserungen und die kontinuierlichen Updates zu zeigen, die Karter bietet.';

  @override
  String get tipOneTime => 'Einmaliges Trinkgeld';

  @override
  String get tipRecurring => 'Wiederkehrendes Trinkgeld';

  @override
  String get tipBronze => 'Bronze';

  @override
  String get tipSilver => 'Silber';

  @override
  String get tipGold => 'Gold';

  @override
  String get tipBronzePrice => 'Bronze-Trinkgeld';

  @override
  String get tipSilverPrice => 'Silber-Trinkgeld';

  @override
  String get tipGoldPrice => 'Gold-Trinkgeld';

  @override
  String get tipBronzeMonthly => 'Bronze / Monat';

  @override
  String get tipSilverMonthly => 'Silber / Monat';

  @override
  String get tipGoldMonthly => 'Gold / Monat';

  @override
  String get officialWebsite => 'Offizielle Website';

  @override
  String get communityForums => 'Community-Foren';

  @override
  String get translations => 'Übersetzungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get privacyPolicyDesc => 'Lies unsere Datenschutzerklärung online.';

  @override
  String get openPrivacyPolicy => 'Datenschutzerklärung öffnen';

  @override
  String get version => 'Version';

  @override
  String get deviceId => 'Geräte-ID';

  @override
  String get changelog => 'Änderungsprotokoll';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get english => 'Englisch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get eesti => 'Eesti';

  @override
  String get odometerUpdateTitle => 'Kilometerstand aktualisieren';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Letzter: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'Der Wert ist niedriger als der letzte Eintrag ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Du bist seit dem letzten Mal $delta $unit gefahren. Ist das korrekt?';
  }

  @override
  String get odometerSave => 'Speichern';

  @override
  String get odometerCancel => 'Abbrechen';

  @override
  String get moreNotifications => 'Benachrichtigungen';

  @override
  String get moreNotificationsSubtitle =>
      'Kilometerstand- und Wartungserinnerungen';

  @override
  String get notificationSettingsTitle => 'Benachrichtigungseinstellungen';

  @override
  String get notificationSettingsSubtitle =>
      'Konfiguriere Erinnerungen für dieses Fahrzeug';

  @override
  String get notificationOdometerSection => 'Kilometerstand-Erinnerung';

  @override
  String get notificationMaintenanceSection => 'Wartungserinnerung';

  @override
  String get notificationFreqLabel => 'Erinnerungshäufigkeit';

  @override
  String get notificationFreqOff => 'Aus';

  @override
  String notificationFreqValue(Object days) {
    return 'Alle $days Tage';
  }

  @override
  String get notificationMaintenanceToggle => 'Wartungserinnerungen';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Tägliche Erinnerungen an anstehende Wartungen erhalten';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Für $days weitere Tag(e) geschlummert';
  }

  @override
  String get notificationSnoozeCancel => 'Schlummern abbrechen';

  @override
  String get notificationNoVehicles =>
      'Füge ein Fahrzeug hinzu, um Benachrichtigungen zu konfigurieren';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Kilometerstand: $freq • Wartung: $maint';
  }

  @override
  String get notificationConfigure => 'Konfigurieren';

  @override
  String get notificationMaintOn => 'An';

  @override
  String get notificationMaintOff => 'Aus';

  @override
  String get notificationSnoozeAction => '1 Woche schlummern';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Geschlummert bis $date';
  }

  @override
  String get notificationFreqWeekly => 'Alle 7 Tage';

  @override
  String get notificationFreqMonthly => 'Alle 30 Tage';

  @override
  String get notificationFreqCustom => 'Benutzerdefiniert';

  @override
  String notificationFreqDays(Object days) {
    return '$days Tage';
  }

  @override
  String get notificationMaintenanceSnooze => 'Wartung 1 Woche schlummern';

  @override
  String get notificationSnoozeToggle => 'Erinnerungen schlummern';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days Tage';
  }

  @override
  String get unsavedChanges => 'Ungespeicherte Änderungen';

  @override
  String get discardChangesConfirm =>
      'Du hast ungespeicherte Änderungen. Möchtest du wirklich gehen?';

  @override
  String get discard => 'Verwerfen';

  @override
  String get moreTemplateSource => 'Vorlagenquelle';

  @override
  String get moreTemplateSourceSubtitle =>
      'Vorlagen von GitHub abrufen oder lokale Assets verwenden';

  @override
  String get moreTemplateSourceOffline => 'Lokal (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'Repo-URL';

  @override
  String get moreTemplateSourceReset => 'Auf Standard zurücksetzen';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'URL bearbeiten';

  @override
  String get moreTemplateSourceUrlSaved => 'URL aktualisiert';

  @override
  String get testConnection => 'Verbindung testen';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Zuletzt geändert: $date';
  }

  @override
  String get importCheckTranslations => 'Übersetzungen';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found von $total verfügbar';
  }

  @override
  String get importCheckIndex => 'Vorlagenindex';

  @override
  String importCheckIndexResult(int count) {
    return '$count Vorlagen';
  }

  @override
  String get importCheckDb => 'Katalogdatenbank (remote)';

  @override
  String get importCheckDbRemoteFound => 'Auf GitHub verfügbar';

  @override
  String get importCheckDbRemoteNotFound => 'Nur lokal (nicht auf GitHub)';

  @override
  String get importCheckDbLocal => 'Importierte Datenbankdaten';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Version: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Fahrzeuge: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Wartungspunkte: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Teile: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'OBD-Codes: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Die importierte Datenbank konnte nicht gelesen werden';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingNext => 'Weiter';

  @override
  String get onboardingDone => 'Los geht\'s';

  @override
  String get onboardingReplay => 'Onboarding ansehen';

  @override
  String get onboardingReplaySubtitle => 'Die Begrüßungsführung erneut ansehen';

  @override
  String get onboardingWelcomeTitle => 'Willkommen bei Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Ein datenschutzorientierter, quelloffener Fahrzeugwartungs-Tracker. 100 % offline – keine Konten, keine Telemetrie, kein Tracking.';

  @override
  String get onboardingVehicleTitle => 'Füge dein Fahrzeug hinzu';

  @override
  String get onboardingVehicleDesc =>
      'Registriere dein Auto, Motorrad oder E-Auto. Wähle eine Vorlage und Karter füllt die Wartungsintervalle für dein Modell automatisch aus.';

  @override
  String get onboardingTrackTitle => 'Kraftstoff & Wartung tracken';

  @override
  String get onboardingTrackDesc =>
      'Protokolliere Tankvorgänge mit automatischer Verbrauchsberechnung (MPG, L/100km, km/L). Tracke Reparaturen, Teile und Kosten.';

  @override
  String get onboardingRemindersTitle =>
      'Bleibe bei Serviceleistungen auf dem Laufenden';

  @override
  String get onboardingRemindersDesc =>
      'Erhalte Benachrichtigungen, wenn es Zeit für Ölwechsel, Bremsbeläge und jedes Wartungsintervall ist – nach Distanz oder Zeit.';

  @override
  String get supporterBadge => 'Du bist ein Karter-Unterstützer!';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get tipPurchased => 'Danke!';

  @override
  String get tipSupport => 'Unterstützen';

  @override
  String get sectionBackup => 'Backup';

  @override
  String get moreBackup => 'Backup';

  @override
  String get moreBackupSubtitle => 'Verschlüsseltes Backup';

  @override
  String get backupConnect => 'Google Drive verbinden';

  @override
  String backupConnected(Object email) {
    return 'Verbunden als $email';
  }

  @override
  String get backupNow => 'Jetzt sichern';

  @override
  String get backupInProgress => 'Sichere…';

  @override
  String backupLast(Object date) {
    return 'Letztes Backup: $date';
  }

  @override
  String get backupNever => 'Nie gesichert';

  @override
  String get backupRestore => 'Aus Backup wiederherstellen';

  @override
  String get backupRestoreInProgress => 'Wiederherstellen…';

  @override
  String get backupRestoreConfirm =>
      'Dies überschreibt alle aktuellen Daten. Bist du sicher?';

  @override
  String backupError(Object error) {
    return 'Backup-Fehler: $error';
  }

  @override
  String get backupSuccess => 'Backup erfolgreich hochgeladen';

  @override
  String get backupRestoreSuccess =>
      'Daten wiederhergestellt. Starte die App neu, um die Änderungen zu sehen.';

  @override
  String get backupDisconnect => 'Trennen';

  @override
  String get backupNoBackups => 'Keine Backups gefunden';

  @override
  String get backupRestoreBtn => 'Wiederherstellen';

  @override
  String get backupDelete => 'Löschen';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Backup $name löschen?';
  }

  @override
  String get backupDeleteSuccess => 'Backup gelöscht';

  @override
  String backupCount(Object current, Object max) {
    return 'Backups: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Fehlercode-Suche';

  @override
  String get dtcSearchHint => 'Gib einen Code ein, z. B. P0171';

  @override
  String get dtcEmptyState =>
      'Gib einen Code ein, um die Beschreibung zu suchen';

  @override
  String get dtcNoMatch => 'Keine Codes passen zu deiner Suche';

  @override
  String get dtcDescription => 'Beschreibung';

  @override
  String get dtcRelatedMaintenance => 'Zugehörige Wartung';

  @override
  String get dtcScopeStandard => 'Standard';

  @override
  String get dtcScopeManufacturer => 'Hersteller';

  @override
  String get dtcGeneralDb => 'Allgemeine OBD-II-Codes';

  @override
  String get dtcCatalogBrands => 'Katalogmarken';

  @override
  String get dtcMyVehicles => 'Meine Fahrzeuge';

  @override
  String get dtcVehicle => 'Fahrzeug';

  @override
  String get dtcVehicleNotFound => 'Fahrzeug nicht gefunden';

  @override
  String get dtcLoadError => 'Fehlercodes konnten nicht geladen werden';

  @override
  String get notificationOdometerTitle => 'Kilometerstand aktualisieren';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name – $days Tage seit der letzten Erinnerung.';
  }

  @override
  String get notificationMaintenanceTitle => 'Anstehende Wartung';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name – prüfe deine Wartungsintervalle.';
  }

  @override
  String errorGeneric(String error) {
    return 'Fehler: $error';
  }

  @override
  String get deleteFuelUp => 'Tankvorgang löschen';

  @override
  String get deleteFuelUpConfirm =>
      'Bist du sicher, dass du diesen Tankvorgang löschen möchtest?';

  @override
  String get editFuelUp => 'Tankvorgang bearbeiten';

  @override
  String get deleteDocument => 'Dokument löschen';

  @override
  String get deleteDocumentConfirm =>
      'Bist du sicher, dass du dieses Dokument löschen möchtest?';

  @override
  String get editDocument => 'Dokument bearbeiten';

  @override
  String get title => 'Titel';

  @override
  String get selectExpiryDate => 'Ablaufdatum auswählen';

  @override
  String get addMoreFiles => 'Weitere Dateien hinzufügen';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Vorlagen';

  @override
  String get templatesTitle => 'Vorlagen';

  @override
  String get templatesSubtitle => 'Durchsuche den Community-Vorlagenkatalog';

  @override
  String get createTemplate => 'Vorlage erstellen';

  @override
  String get createTemplateSubtitle =>
      'Eine Vorlage erstellen und als JSON exportieren';

  @override
  String get templatesLoadError =>
      'Der Vorlagenkatalog konnte nicht geladen werden.';

  @override
  String get searchTemplatesHint => 'Nach Marke, Modell oder Generation suchen';

  @override
  String get allMakes => 'Alle Marken';

  @override
  String get noTemplatesFound => 'Keine Vorlagen passen zu deiner Suche.';

  @override
  String templateItemsCount(int count) {
    return '$count Wartungspunkte';
  }

  @override
  String get templateYearsOpen => 'heute';

  @override
  String get templateNotFound => 'Vorlage nicht gefunden';

  @override
  String get templateInfo => 'Vorlageninfo';

  @override
  String get templateYears => 'Jahre';

  @override
  String get templateEngine => 'Motor';

  @override
  String get templateAuthor => 'Autor';

  @override
  String get templateVersion => 'Version';

  @override
  String get templateSources => 'Quellen';

  @override
  String get dtcCodesTitle => 'Fehlercodes';

  @override
  String dtcCount(int count) {
    return '$count Fehlercode(s)';
  }

  @override
  String get noPartsFound => 'Keine Teile';

  @override
  String get createCopied => 'Vorlagen-JSON in die Zwischenablage kopiert';

  @override
  String get saveTemplate => 'Vorlage speichern';

  @override
  String savedAt(String path) {
    return 'Gespeichert unter $path';
  }

  @override
  String get createHasErrors => 'Behebe die Fehler, um zu exportieren';

  @override
  String get createMake => 'Marke';

  @override
  String get createModel => 'Modell';

  @override
  String get createGeneration => 'Generation';

  @override
  String get createYearFrom => 'Jahr von';

  @override
  String get createYearTo => 'Jahr bis';

  @override
  String get createFuel => 'Kraftstoff';

  @override
  String get createPowertrain => 'Antrieb';

  @override
  String get createEngineCode => 'Motorkennung';

  @override
  String get createDisplacement => 'Hubraum (cc)';

  @override
  String get createPower => 'Leistung (PS)';

  @override
  String get templateMetadata => 'Metadaten & Vererbung';

  @override
  String get createAuthor => 'Autor';

  @override
  String get createAuthorHint => 'Dein GitHub-Benutzername';

  @override
  String get createExtends => 'Erweitert (Basisvorlagen)';

  @override
  String get createExtendsHint => 'Gemeinsame Wartungsdaten übernehmen';

  @override
  String get createCustomExtends => 'Eigene Extends-Pfade';

  @override
  String get createAddPart => 'Teil hinzufügen';

  @override
  String get createNoParts => 'Noch keine Teile. Teile sind optional.';

  @override
  String get partSingular => 'Teil';

  @override
  String get createAddItem => 'Wartungspunkt hinzufügen';

  @override
  String get createNoItems => 'Noch keine Wartungspunkte.';

  @override
  String get createPreview => 'Vorschau';

  @override
  String createErrorsFound(int count) {
    return '$count Validierungsfehler';
  }

  @override
  String get createCopy => 'Kopieren';

  @override
  String get createShare => 'Teilen';

  @override
  String get createSave => 'Speichern';

  @override
  String get createQuantity => 'Menge';

  @override
  String get createI18nKey => 'i18n-Schlüssel';

  @override
  String get createDescI18nKey => 'Beschreibungs-i18n-Schlüssel';

  @override
  String get createIntervalKm => 'Intervall (km)';

  @override
  String get createIntervalMonths => 'Intervall (Monate)';

  @override
  String get createDescription => 'Beschreibung';

  @override
  String get createAddPartRef => 'Teilverweis hinzufügen';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Name';

  @override
  String get createFieldUnit => 'Einheit';

  @override
  String get createFieldOem => 'OEM-Nummer';

  @override
  String get createFieldLabel => 'Bezeichnung';

  @override
  String get createFieldPart => 'Teil';

  @override
  String get fuelGasoline => 'Benzin';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'LPG';

  @override
  String get fuelCng => 'CNG';

  @override
  String get fuelHydrogen => 'Wasserstoff';

  @override
  String get fuelEthanol => 'Ethanol';

  @override
  String get powertrainCombustion => 'Verbrenner';

  @override
  String get powertrainHybrid => 'Hybrid';

  @override
  String get powertrainPluginHybrid => 'Plug-in-Hybrid';

  @override
  String get powertrainElectric => 'Elektrisch';

  @override
  String get catalogDb => 'Katalogdatenbank';

  @override
  String get catalogSourceBuiltin => 'Gebündelt (Standard)';

  @override
  String get catalogSourceOnline => 'Online (GitHub-Release)';

  @override
  String get catalogSourcesTitle => 'Verfügbare Kataloge';

  @override
  String get catalogCannotDelete =>
      'Standardkatalog – kann nicht gelöscht werden';

  @override
  String catalogVersionOf(String version) {
    return 'Version $version';
  }

  @override
  String get catalogVersionUnknown => 'Version nicht verfügbar';

  @override
  String get catalogRefreshOnline => 'Online-Katalog aktualisieren';

  @override
  String get catalogRefreshed => 'Online-Katalog aktualisiert';

  @override
  String get catalogRefreshFailed =>
      'Der Online-Katalog konnte nicht aktualisiert werden';

  @override
  String get catalogNotAvailable => 'Dieser Katalog ist nicht verfügbar';

  @override
  String get catalogImportDb => 'Lokale DB importieren';

  @override
  String get catalogImported => 'Katalog importiert';

  @override
  String get catalogImportFailed =>
      'Der Katalog konnte nicht importiert werden';

  @override
  String get catalogDelete => 'Katalog löschen';

  @override
  String catalogDeleteConfirm(String name) {
    return '$name löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Der Online-Katalog konnte nicht heruntergeladen werden. Überprüfe deine Verbindung und versuche es erneut.';

  @override
  String get templateUrlExample =>
      'Beispiel: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> wird durch die neueste Version dieses Repositories ersetzt. Du kannst jedes GitHub-Repository verwenden oder einen direkten Link einfügen. Wenn der Tag nicht aufgelöst werden kann, wird der Link unverändert verwendet und der Test zeigt den Fehler an.';

  @override
  String get templateUrlUsage =>
      'Wird verwendet, um den Katalog, den Vorlagenindex und die Übersetzungen (i18n) abzurufen.';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Wird aufgelöst zu: $url';
  }

  @override
  String get templateUrlVersion => 'Version';

  @override
  String get templateUrlLatest => 'Neueste (<tag>)';

  @override
  String get templateUrlVersionsFailed =>
      'Versionen konnten nicht geladen werden';

  @override
  String get templateUrlHelp => 'URL-Hilfe';

  @override
  String get moreTemplateSourceUrlLabel => 'Repo-URL';

  @override
  String get moreTemplateSourceVersionLatest => 'Neueste';

  @override
  String catalogDbVersion(String version) {
    return 'DB-Version: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Release: $version';
  }

  @override
  String get createInheritedParts => 'Geerbte Teile (aus extends)';

  @override
  String get createInheritedItems => 'Geerbte Wartung (aus extends)';

  @override
  String get templateExtendsNotLoaded =>
      'Einige extends konnten nicht geladen werden';

  @override
  String get templateRepoLoading => 'Lade aus Vorlagen-Repository…';

  @override
  String get templateRepoError =>
      'Das Vorlagen-Repository konnte nicht erreicht werden';

  @override
  String templateBy(String author) {
    return 'von $author';
  }
}
