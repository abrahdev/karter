// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navVehicles => 'Veicoli';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Altro';

  @override
  String get homeEmptyTitle => 'Nessun veicolo';

  @override
  String get homeEmptySubtitle => 'Aggiungi il tuo primo veicolo';

  @override
  String homeError(Object error) {
    return 'Errore: $error';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardComingSoon => 'In arrivo';

  @override
  String get vehicleDetailTitle => 'Veicolo';

  @override
  String get vehicleNotFound => 'Veicolo non trovato';

  @override
  String get plate => 'Targa';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Marca / Modello';

  @override
  String get year => 'Anno';

  @override
  String get odometer => 'Contachilometri';

  @override
  String get update => 'Aggiorna';

  @override
  String get actions => 'Azioni';

  @override
  String get tools => 'Strumenti';

  @override
  String get information => 'Informazioni';

  @override
  String get fuelLogs => 'Rifornimenti';

  @override
  String get maintenanceHistory => 'Cronologia manutenzione';

  @override
  String get configureIntervals => 'Configura intervalli';

  @override
  String get nextMaintenance => 'Prossima manutenzione';

  @override
  String get allIntervalsDisabled => 'Tutti gli intervalli sono disattivati.';

  @override
  String get register => 'Registra';

  @override
  String get registerService => 'Registra intervento';

  @override
  String get noDescriptionAvailable =>
      'Nessuna descrizione disponibile. Vai alle impostazioni di manutenzione per aggiungerne una.';

  @override
  String get close => 'Chiudi';

  @override
  String get retry => 'Riprova';

  @override
  String get overduePerformService => 'In ritardo — esegui l\'intervento';

  @override
  String nextIn(Object parts) {
    return 'Prossimo tra $parts';
  }

  @override
  String get vehicleFormNew => 'Nuovo veicolo';

  @override
  String get vehicleFormEdit => 'Modifica veicolo';

  @override
  String get vehicleFormDetails => 'Dettagli';

  @override
  String get vehicleFormVehicle => 'Veicolo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modello';

  @override
  String get required => 'Obbligatorio';

  @override
  String get invalidYear => 'Anno non valido';

  @override
  String get vehicleType => 'Tipo di veicolo';

  @override
  String get combustion => 'Combustione';

  @override
  String get electric => 'Elettrico';

  @override
  String get motorcycle => 'Moto';

  @override
  String get plateOptional => 'Targa (facoltativa)';

  @override
  String get vinOptional => 'VIN (facoltativo)';

  @override
  String get invalid => 'Non valido';

  @override
  String get aliasOptional => 'Alias (facoltativo)';

  @override
  String get aliasHint => 'Es.: La mia macchina, La belva, ecc.';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get addVehicle => 'Aggiungi veicolo';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Gli interventi risultano in ritardo';

  @override
  String get newVehicleServicesOverdueBody =>
      'Poiché il tuo veicolo ha già più di 500 km, tutti gli interventi di manutenzione risultano in ritardo.\n\nRegistra gli interventi già effettuati. Se non ricordi il chilometraggio esatto, inserisci un valore approssimativo di km per l\'ultimo intervento.';

  @override
  String get deleteVehicle => 'Elimina veicolo';

  @override
  String get deleteVehicleConfirm =>
      'Questa azione non può essere annullata. Tutti i rifornimenti, i registri di manutenzione e gli intervalli associati verranno eliminati.';

  @override
  String get cancel => 'Annulla';

  @override
  String get resetToDefault => 'Ripristina predefiniti';

  @override
  String get delete => 'Elimina';

  @override
  String get dataManagerTitle => 'Esporta / Importa dati';

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get exporting => 'Esportazione...';

  @override
  String get export => 'Esporta';

  @override
  String get importing => 'Importazione...';

  @override
  String get import => 'Importa';

  @override
  String get saveExport => 'Salva esportazione';

  @override
  String exportedAt(Object path) {
    return 'Esportato in $path';
  }

  @override
  String exportError(Object error) {
    return 'Errore di esportazione: $error';
  }

  @override
  String get importData => 'Importa dati';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Trovati:\n• $vehicles veicolo/i\n• $fuelLogs rifornimento/i\n• $maintenanceLogs registro/i di manutenzione\n• $documents documento/i\n\nImportare? I dati esistenti con lo stesso ID verranno sovrascritti.';
  }

  @override
  String get importSuccess => 'Dati importati correttamente';

  @override
  String importError(Object error) {
    return 'Errore di importazione: $error';
  }

  @override
  String get invalidJson => 'File JSON non valido';

  @override
  String exportShareText(Object count) {
    return 'Esportazione Karter — $count veicolo/i';
  }

  @override
  String get maintenanceSettingsTitle => 'Intervalli di manutenzione';

  @override
  String get maintenanceSettingsInstruction =>
      'Attiva o disattiva gli elementi in base alle esigenze del tuo veicolo. Gli intervalli personalizzati possono essere eliminati.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Tempo (mesi)';

  @override
  String get partsTitle => 'Ricambi';

  @override
  String get partUnitUnit => 'unità';

  @override
  String get partUnitSet => 'set';

  @override
  String get partUnitKit => 'kit';

  @override
  String get partUnitCan => 'lattina';

  @override
  String get partUnitLabel => 'Unità';

  @override
  String get localParts => 'Ricambi locali';

  @override
  String get intervalParts => 'Ricambi dell\'intervallo';

  @override
  String get newPart => 'Nuovo ricambio';

  @override
  String get createPart => 'Crea ricambio';

  @override
  String get partsSection => 'Ricambi';

  @override
  String get usedParts => 'Ricambi';

  @override
  String usedInServicesCount(Object count) {
    return '$count intervento/i';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Questo ricambio è utilizzato in $count intervento/i. Eliminarlo comunque?';
  }

  @override
  String get reportPartsHeader => 'Ricambi';

  @override
  String get templateFound => 'Modello trovato';

  @override
  String get templateDisclaimer =>
      'I dati del modello sono solo di riferimento. Verifica sempre gli intervalli sul manuale del tuo veicolo.';

  @override
  String get noTemplate => 'Nessun modello';

  @override
  String get useTemplate => 'Usa modello';

  @override
  String get searchTemplate => 'Cerca modello';

  @override
  String templateWithName(Object name) {
    return 'Modello: $name';
  }

  @override
  String get noResultsTitle => 'Nessun risultato';

  @override
  String get noTemplateFoundDescription =>
      'Nessun modello trovato per i dati inseriti.';

  @override
  String get searchParameters => 'Parametri di ricerca:';

  @override
  String get defaultIntervalsHint =>
      'Il veicolo userà gli intervalli predefiniti.';

  @override
  String get missingTemplateContribute =>
      'Manca un modello? Contribuisci su github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Visualizza tutti i modelli';

  @override
  String get contribute => 'Contribuisci';

  @override
  String get contributeOnGitHub => 'Contribuisci su GitHub';

  @override
  String get gotIt => 'Ok';

  @override
  String get templateUnderConstruction => 'Modello in costruzione';

  @override
  String get templateNotReady =>
      'Questo modello non è ancora pronto.\nCi stiamo lavorando!';

  @override
  String get contributionsWelcome =>
      'I contributi sono benvenuti — aggiungi o correggi modelli per il tuo veicolo:';

  @override
  String requestedParam(Object params) {
    return 'Richiesto: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Vuoi davvero eliminare questo intervallo?';

  @override
  String get addPart => 'Aggiungi ricambio';

  @override
  String get partName => 'Nome ricambio';

  @override
  String get quantity => 'Qtà';

  @override
  String get oemNumber => 'Numero OEM';

  @override
  String get addLink => 'Aggiungi link';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Apri';

  @override
  String get noLinks => 'Nessun link';

  @override
  String get noParts => 'Ancora nessun ricambio';

  @override
  String get invalidUrl => 'URL non valido';

  @override
  String get copied => 'Copiato';

  @override
  String get linksTitle => 'Link di riferimento';

  @override
  String get copy => 'Copia';

  @override
  String get addModeManual => 'Manuale';

  @override
  String get addModeTemplate => 'Modello';

  @override
  String get newFromTemplate => 'Nuovo da modello';

  @override
  String get updatesAvailable => 'Aggiornamenti disponibili';

  @override
  String get restore => 'Ripristina';

  @override
  String get windowMinimize => 'Riduci a icona';

  @override
  String get windowMaximize => 'Ingrandisci';

  @override
  String get windowClose => 'Chiudi';

  @override
  String get syncInstruction =>
      'Sincronizza gli intervalli di manutenzione dal modello del tuo veicolo.';

  @override
  String get upToDate => 'Tutto aggiornato';

  @override
  String get syncAdded => 'Intervallo aggiunto dal modello';

  @override
  String get syncRestored => 'Intervallo ripristinato dal modello';

  @override
  String get months => 'mesi';

  @override
  String get description => 'Descrizione';

  @override
  String get newInterval => 'Nuovo intervallo';

  @override
  String get name => 'Nome';

  @override
  String get add => 'Aggiungi';

  @override
  String get edit => 'Modifica';

  @override
  String get addToDashboard => 'Aggiungi alla dashboard';

  @override
  String get setupNotifications => 'Configura notifiche';

  @override
  String get addToDashboardComingSoon => 'In arrivo';

  @override
  String get deleteInterval => 'Elimina';

  @override
  String get noDescriptionAvailableSettings =>
      'Nessuna descrizione disponibile. Premi \"Modifica\" per aggiungerne una.';

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
    return 'ogni $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months mesi';
  }

  @override
  String get maintenanceLogTitleEdit => 'Modifica intervento';

  @override
  String get maintenanceLogTitleNew => 'Nuovo intervento';

  @override
  String date(Object date) {
    return 'Data: $date';
  }

  @override
  String get descriptionRequired => 'Descrizione';

  @override
  String get odometerAtService =>
      'Contachilometri all\'intervento (facoltativo)';

  @override
  String get resetInterval => 'Reimposta intervallo (facoltativo)';

  @override
  String get saveChangesShort => 'Salva modifiche';

  @override
  String get saveService => 'Salva intervento';

  @override
  String get saveFile => 'Salva file';

  @override
  String get lastService => 'Ultimo';

  @override
  String get addPhoto => 'Aggiungi foto';

  @override
  String get photos => 'foto';

  @override
  String get files => 'file';

  @override
  String get share => 'Condividi';

  @override
  String get deleteService => 'Elimina intervento';

  @override
  String get deleteServiceConfirm =>
      'Vuoi davvero eliminare questo intervento?';

  @override
  String get maintenanceListTitle => 'Manutenzione';

  @override
  String get maintenanceEmpty => 'Nessun intervento registrato';

  @override
  String get maintenanceHistoryTab => 'Cronologia';

  @override
  String get maintenancePdfExportTab => 'Esporta PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count intervento/i in questo periodo';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... e altri $count';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Nessun intervento in questo intervallo di date.';

  @override
  String get maintenanceExportPdf => 'Esporta PDF';

  @override
  String get maintenanceSharePdf => 'Condividi';

  @override
  String get maintenanceReportTitle => 'Report di manutenzione';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Generato $date $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'Nessun registro di manutenzione in questo periodo.';

  @override
  String get maintenanceReportDateHeader => 'Data';

  @override
  String get maintenanceReportDescHeader => 'Descrizione';

  @override
  String get maintenanceReportOdometerHeader => 'Contachilometri';

  @override
  String get addDocument => 'Aggiungi documento';

  @override
  String get documentType => 'Tipo di documento';

  @override
  String get selectFile => 'Seleziona file';

  @override
  String get noFileSelected => 'Nessun file selezionato';

  @override
  String get notesOptional => 'Note (facoltative)';

  @override
  String get expiryDateOptional => 'Data di scadenza (facoltativa)';

  @override
  String get pleaseSelectFile => 'Seleziona un file';

  @override
  String get documentSaved => 'Documento salvato';

  @override
  String get takePhoto => 'Scatta foto';

  @override
  String get chooseFromGallery => 'Scegli dalla galleria';

  @override
  String get browseFiles => 'Sfoglia file';

  @override
  String get docTypeFine => 'Multa';

  @override
  String get docTypeParkingFee => 'Ticket sosta';

  @override
  String get docTypeInsurance => 'Assicurazione';

  @override
  String get docTypeVehicleCheck => 'Revisione';

  @override
  String get docTypeTax => 'Tassa';

  @override
  String get docTypeComplexInsurance => 'Assicurazione complessa';

  @override
  String get docTypeVehicleRegister => 'Registro del veicolo';

  @override
  String get docTypeOther => 'Altro';

  @override
  String get vehicleDocuments => 'Documenti';

  @override
  String get fuelFormTitle => 'Nuovo rifornimento';

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
  String get pricePerUnit => 'Prezzo per unità (facoltativo)';

  @override
  String get fullTank => 'Pieno';

  @override
  String get volumeUnit => 'Unità di volume del carburante';

  @override
  String get currency => 'Valuta';

  @override
  String get cost => 'Costo (facoltativo)';

  @override
  String get saveFuelUp => 'Salva rifornimento';

  @override
  String get fuelListTitle => 'Rifornimenti';

  @override
  String get fuelEmpty => 'Nessun rifornimento registrato';

  @override
  String get moreAbout => 'Informazioni su Karter';

  @override
  String get moreDescription =>
      'Karter è un\'app di manutenzione veicoli open source e locale-first che rispetta la tua privacy.';

  @override
  String get moreExport => 'Esporta / Importa dati';

  @override
  String get moreExportSubtitle =>
      'Esegui il backup o trasferisci le tue informazioni';

  @override
  String get moreDocs => 'Documentazione';

  @override
  String get moreDocsSubtitle => 'Guida all\'uso e funzionalità';

  @override
  String get moreSource => 'Codice sorgente';

  @override
  String get moreSourceSubtitle => 'Repository GitHub';

  @override
  String get moreDonate => 'Dona';

  @override
  String get moreDonateSubtitle => 'Supporta lo sviluppo su GitHub Sponsors';

  @override
  String get moreFooter => 'Fatto con ❤️ da abrahdev';

  @override
  String get moreRate => 'Valuta Karter';

  @override
  String get moreRateSubtitle => 'Lascia una recensione sul Play Store';

  @override
  String get moreFeedback => 'Valuta l\'applicazione';

  @override
  String get moreFeedbackSubtitle => 'Valuta l\'app e configura i promemoria';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Preferenze';

  @override
  String get sectionData => 'Dati';

  @override
  String get sectionFeedbackCommunity => 'Feedback e Community';

  @override
  String get sectionTips => 'Programma mance';

  @override
  String get sectionAbout => 'Informazioni su Karter';

  @override
  String get theme => 'Tema';

  @override
  String get themeAutomatic => 'Automatico';

  @override
  String get themeAutomaticDesc => 'Segui l\'impostazione del dispositivo';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeSystemDesc => 'Segui l\'impostazione del dispositivo';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get colorScheme => 'Colore primario';

  @override
  String get colorCustom => 'Personalizzato';

  @override
  String get colorOfInterface => 'Colore dell\'interfaccia';

  @override
  String get colorOfInterfaceDesc =>
      'Applica il colore primario alle superfici di sfondo';

  @override
  String get customColor => 'Colore personalizzato';

  @override
  String get customColorDesc =>
      'Usa un colore personale invece dell\'accento di sistema';

  @override
  String get selectColor => 'Seleziona un colore';

  @override
  String get hapticFeedback => 'Feedback aptico';

  @override
  String get hapticFeedbackDesc => 'Vibrazione nelle interazioni';

  @override
  String get hapticModeOff => 'Disattivato';

  @override
  String get hapticModeOffDesc => 'Nessuna vibrazione nelle interazioni';

  @override
  String get hapticModeClear => 'Netto';

  @override
  String get hapticModeClearDesc => 'Un tocco netto per ogni azione';

  @override
  String get hapticModeRich => 'Ricco';

  @override
  String get hapticModeRichDesc =>
      'Vibrazioni stratificate con intensità variabile';

  @override
  String get testNotification => 'Notifica di prova';

  @override
  String get testNotificationDesc =>
      'Invia una notifica di prova per verificare la configurazione';

  @override
  String get testNotificationSent => 'Notifica di prova inviata';

  @override
  String get notificationsPermissionTitle => 'Notifiche disattivate';

  @override
  String get notificationsPermissionDesc =>
      'Attiva le notifiche per ricevere promemoria di contachilometri e manutenzione';

  @override
  String get notificationsPermissionAllow => 'Consenti notifiche';

  @override
  String get notificationsPermissionDeniedTitle => 'Notifiche bloccate';

  @override
  String get notificationsPermissionDeniedDesc =>
      'L\'autorizzazione per le notifiche è stata negata definitivamente. Per attivarla, vai su Impostazioni > App > Karter > Notifiche e attivale.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Apri le Impostazioni del dispositivo';

  @override
  String get notificationsPermissionDeniedStep2 => '2. Vai su App > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Tocca Notifiche';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Attiva \"Mostra notifiche\"';

  @override
  String get notificationsPermissionOpenSettings => 'Apri Impostazioni';

  @override
  String get shakeToOdometer => 'Scuoti per aggiornare il contachilometri';

  @override
  String get shakeToOdometerDesc =>
      'Scuoti il dispositivo per aprire l\'aggiornamento del contachilometri nella schermata del veicolo';

  @override
  String get feedbackReminderToggle => 'Promemoria di valutazione';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Mostra un promemoria per valutare l\'app dopo il salvataggio degli interventi';

  @override
  String get feedbackServicesInterval => 'Interventi prima del prompt';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Dopo $count intervento/i';
  }

  @override
  String get feedbackServicesSuffix => 'interventi';

  @override
  String get feedbackRepeatDays => 'Intervallo del promemoria';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Ogni $days giorno/i';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'giorni';

  @override
  String get ratePromptMessage =>
      'Ti piace Karter? Una recensione aiuta altri a scoprire l\'app!';

  @override
  String get rate => 'Valuta';

  @override
  String moreUrlError(Object url) {
    return 'Impossibile aprire $url';
  }

  @override
  String get tipProgram => 'Programma mance';

  @override
  String get tipProgramComingSoon =>
      'Questa funzionalità è in fase di sviluppo e sarà disponibile a breve.';

  @override
  String get tipBadges => 'Distintivi';

  @override
  String get tipBadgesNone => 'Nessuno';

  @override
  String get tipInfo => 'Informazioni';

  @override
  String get tipInfoText =>
      'Il programma mance è un modo per gli utenti di mostrare supporto e apprezzamento extra per il supporto rapido, i miglioramenti costanti e gli aggiornamenti continui che Karter ha offerto.';

  @override
  String get tipOneTime => 'Mancia una tantum';

  @override
  String get tipRecurring => 'Mancia ricorrente';

  @override
  String get tipBronze => 'Bronzo';

  @override
  String get tipSilver => 'Argento';

  @override
  String get tipGold => 'Oro';

  @override
  String get tipBronzePrice => 'Mancia bronzo';

  @override
  String get tipSilverPrice => 'Mancia argento';

  @override
  String get tipGoldPrice => 'Mancia oro';

  @override
  String get tipBronzeMonthly => 'Bronzo / mese';

  @override
  String get tipSilverMonthly => 'Argento / mese';

  @override
  String get tipGoldMonthly => 'Oro / mese';

  @override
  String get officialWebsite => 'Sito ufficiale';

  @override
  String get communityForums => 'Forum della community';

  @override
  String get translations => 'Traduzioni';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get privacyPolicyDesc =>
      'Leggi la nostra informativa sulla privacy online.';

  @override
  String get openPrivacyPolicy => 'Apri informativa sulla privacy';

  @override
  String get version => 'Versione';

  @override
  String get deviceId => 'ID dispositivo';

  @override
  String get changelog => 'Novità';

  @override
  String get openSourceLicenses => 'Licenze open source';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get languageSystem => 'Impostazione di sistema';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get eesti => 'Eesti';

  @override
  String get odometerUpdateTitle => 'Aggiorna contachilometri';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Ultimo: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'Il valore è inferiore all\'ultima registrazione ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Hai percorso $delta $unit dall\'ultima volta. È corretto?';
  }

  @override
  String get odometerSave => 'Salva';

  @override
  String get odometerCancel => 'Annulla';

  @override
  String get moreNotifications => 'Notifiche';

  @override
  String get moreNotificationsSubtitle =>
      'Promemoria di contachilometri e manutenzione';

  @override
  String get notificationSettingsTitle => 'Impostazioni notifiche';

  @override
  String get notificationSettingsSubtitle =>
      'Configura i promemoria per questo veicolo';

  @override
  String get notificationOdometerSection => 'Promemoria contachilometri';

  @override
  String get notificationMaintenanceSection => 'Promemoria manutenzione';

  @override
  String get notificationFreqLabel => 'Frequenza del promemoria';

  @override
  String get notificationFreqOff => 'Disattivato';

  @override
  String notificationFreqValue(Object days) {
    return 'Ogni $days giorni';
  }

  @override
  String get notificationMaintenanceToggle => 'Promemoria di manutenzione';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Ricevi promemoria giornalieri sulla manutenzione in sospeso';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Rimandato per altri $days giorno/i';
  }

  @override
  String get notificationSnoozeCancel => 'Annulla rimando';

  @override
  String get notificationNoVehicles =>
      'Aggiungi un veicolo per configurare le notifiche';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Contachilometri: $freq • Manutenzione: $maint';
  }

  @override
  String get notificationConfigure => 'Configura';

  @override
  String get notificationMaintOn => 'Attivo';

  @override
  String get notificationMaintOff => 'Disattivato';

  @override
  String get notificationSnoozeAction => 'Rimanda di 1 settimana';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Rimandato fino al $date';
  }

  @override
  String get notificationFreqWeekly => 'Ogni 7 giorni';

  @override
  String get notificationFreqMonthly => 'Ogni 30 giorni';

  @override
  String get notificationFreqCustom => 'Personalizzata';

  @override
  String notificationFreqDays(Object days) {
    return '$days giorni';
  }

  @override
  String get notificationMaintenanceSnooze =>
      'Rimanda la manutenzione di 1 settimana';

  @override
  String get notificationSnoozeToggle => 'Rimanda promemoria';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days giorni';
  }

  @override
  String get unsavedChanges => 'Modifiche non salvate';

  @override
  String get discardChangesConfirm =>
      'Hai modifiche non salvate. Vuoi davvero uscire?';

  @override
  String get discard => 'Scarta';

  @override
  String get moreTemplateSource => 'Origine modelli';

  @override
  String get moreTemplateSourceSubtitle =>
      'Scarica i modelli da GitHub o usa le risorse locali';

  @override
  String get moreTemplateSourceOffline => 'Locale (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL repository';

  @override
  String get moreTemplateSourceReset => 'Ripristina predefiniti';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Modifica URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL aggiornato';

  @override
  String get testConnection => 'Test connessione';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Ultima modifica: $date';
  }

  @override
  String get importCheckTranslations => 'Traduzioni';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found di $total disponibili';
  }

  @override
  String get importCheckIndex => 'Indice dei modelli';

  @override
  String importCheckIndexResult(int count) {
    return '$count modelli';
  }

  @override
  String get importCheckDb => 'Database del catalogo (remoto)';

  @override
  String get importCheckDbRemoteFound => 'Disponibile su GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Solo locale (non su GitHub)';

  @override
  String get importCheckDbLocal => 'Dati del database importato';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Versione: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Veicoli: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Elementi di manutenzione: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Ricambi: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Codici OBD: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Impossibile leggere il database importato';

  @override
  String get onboardingSkip => 'Salta';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get onboardingDone => 'Inizia';

  @override
  String get onboardingReplay => 'Rivedi l\'onboarding';

  @override
  String get onboardingReplaySubtitle =>
      'Riproduci la presentazione di benvenuto';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Un tracker di manutenzione veicoli open source che mette la privacy al primo posto. 100% offline — niente account, niente telemetria, niente tracciamento.';

  @override
  String get onboardingVehicleTitle => 'Aggiungi il tuo veicolo';

  @override
  String get onboardingVehicleDesc =>
      'Registra la tua auto, moto o EV. Scegli un modello e Karter compilerà automaticamente gli intervalli di manutenzione per il tuo veicolo.';

  @override
  String get onboardingTrackTitle => 'Monitora carburante e manutenzione';

  @override
  String get onboardingTrackDesc =>
      'Registra i rifornimenti con calcoli automatici dei consumi (MPG, L/100km, km/L). Tieni traccia di riparazioni, ricambi e costi.';

  @override
  String get onboardingRemindersTitle => 'Non perderti la manutenzione';

  @override
  String get onboardingRemindersDesc =>
      'Ricevi notifiche quando è il momento di cambio olio, pastiglie freno e ogni intervallo di manutenzione — per distanza o tempo.';

  @override
  String get supporterBadge => 'Sei un sostenitore di Karter!';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get tipPurchased => 'Grazie!';

  @override
  String get tipSupport => 'Supporto';

  @override
  String get sectionBackup => 'Backup';

  @override
  String get moreBackup => 'Backup';

  @override
  String get moreBackupSubtitle => 'Backup crittografato';

  @override
  String get backupConnect => 'Connetti Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Connesso come $email';
  }

  @override
  String get backupNow => 'Esegui il backup ora';

  @override
  String get backupInProgress => 'Backup in corso…';

  @override
  String backupLast(Object date) {
    return 'Ultimo backup: $date';
  }

  @override
  String get backupNever => 'Nessun backup effettuato';

  @override
  String get backupRestore => 'Ripristina dal backup';

  @override
  String get backupRestoreInProgress => 'Ripristino…';

  @override
  String get backupRestoreConfirm =>
      'Questo sovrascriverà tutti i dati correnti. Sei sicuro?';

  @override
  String backupError(Object error) {
    return 'Errore di backup: $error';
  }

  @override
  String get backupSuccess => 'Backup caricato correttamente';

  @override
  String get backupRestoreSuccess =>
      'Dati ripristinati. Riavvia l\'app per vedere le modifiche.';

  @override
  String get backupDisconnect => 'Disconnetti';

  @override
  String get backupNoBackups => 'Nessun backup trovato';

  @override
  String get backupRestoreBtn => 'Ripristina';

  @override
  String get backupDelete => 'Elimina';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Eliminare il backup $name?';
  }

  @override
  String get backupDeleteSuccess => 'Backup eliminato';

  @override
  String backupCount(Object current, Object max) {
    return 'Backup: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Ricerca codici di guasto';

  @override
  String get dtcSearchHint => 'Inserisci un codice, es. P0171';

  @override
  String get dtcEmptyState => 'Digita un codice per cercarne la descrizione';

  @override
  String get dtcNoMatch => 'Nessun codice corrisponde alla ricerca';

  @override
  String get dtcDescription => 'Descrizione';

  @override
  String get dtcRelatedMaintenance => 'Manutenzione correlata';

  @override
  String get dtcScopeStandard => 'Standard';

  @override
  String get dtcScopeManufacturer => 'Produttore';

  @override
  String get dtcGeneralDb => 'Codici OBD-II generali';

  @override
  String get dtcCatalogBrands => 'Marche del catalogo';

  @override
  String get dtcMyVehicles => 'I miei veicoli';

  @override
  String get dtcVehicle => 'Veicolo';

  @override
  String get dtcVehicleNotFound => 'Veicolo non trovato';

  @override
  String get dtcLoadError => 'Impossibile caricare i codici di guasto';

  @override
  String get notificationOdometerTitle => 'Aggiorna contachilometri';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days giorni dall\'ultimo promemoria.';
  }

  @override
  String get notificationMaintenanceTitle => 'Manutenzione in sospeso';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — controlla gli intervalli di manutenzione.';
  }

  @override
  String errorGeneric(String error) {
    return 'Errore: $error';
  }

  @override
  String get deleteFuelUp => 'Elimina rifornimento';

  @override
  String get deleteFuelUpConfirm =>
      'Vuoi davvero eliminare questo rifornimento?';

  @override
  String get editFuelUp => 'Modifica rifornimento';

  @override
  String get deleteDocument => 'Elimina documento';

  @override
  String get deleteDocumentConfirm =>
      'Vuoi davvero eliminare questo documento?';

  @override
  String get editDocument => 'Modifica documento';

  @override
  String get title => 'Titolo';

  @override
  String get selectExpiryDate => 'Seleziona data di scadenza';

  @override
  String get addMoreFiles => 'Aggiungi altri file';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Modelli';

  @override
  String get templatesTitle => 'Modelli';

  @override
  String get templatesSubtitle =>
      'Sfoglia il catalogo di modelli della community';

  @override
  String get createTemplate => 'Crea modello';

  @override
  String get createTemplateSubtitle => 'Crea un modello ed esportalo come JSON';

  @override
  String get templatesLoadError =>
      'Impossibile caricare il catalogo dei modelli.';

  @override
  String get searchTemplatesHint => 'Cerca per marca, modello o generazione';

  @override
  String get allMakes => 'Tutte le marche';

  @override
  String get noTemplatesFound => 'Nessun modello corrisponde alla ricerca.';

  @override
  String templateItemsCount(int count) {
    return '$count elementi di manutenzione';
  }

  @override
  String get templateYearsOpen => 'presente';

  @override
  String get templateNotFound => 'Modello non trovato';

  @override
  String get templateInfo => 'Info modello';

  @override
  String get templateYears => 'Anni';

  @override
  String get templateEngine => 'Motore';

  @override
  String get templateAuthor => 'Autore';

  @override
  String get templateVersion => 'Versione';

  @override
  String get templateSources => 'Fonti';

  @override
  String get dtcCodesTitle => 'Codici di guasto';

  @override
  String dtcCount(int count) {
    return '$count codice/i di guasto';
  }

  @override
  String get noPartsFound => 'Nessun ricambio';

  @override
  String get createCopied => 'JSON del modello copiato negli appunti';

  @override
  String get saveTemplate => 'Salva modello';

  @override
  String savedAt(String path) {
    return 'Salvato in $path';
  }

  @override
  String get createHasErrors => 'Correggi gli errori per esportare';

  @override
  String get createMake => 'Marca';

  @override
  String get createModel => 'Modello';

  @override
  String get createGeneration => 'Generazione';

  @override
  String get createYearFrom => 'Anno da';

  @override
  String get createYearTo => 'Anno a';

  @override
  String get createFuel => 'Carburante';

  @override
  String get createPowertrain => 'Propulsore';

  @override
  String get createEngineCode => 'Codice motore';

  @override
  String get createDisplacement => 'Cilindrata (cc)';

  @override
  String get createPower => 'Potenza (hp)';

  @override
  String get templateMetadata => 'Metadati ed ereditarietà';

  @override
  String get createAuthor => 'Autore';

  @override
  String get createAuthorHint => 'Il tuo nome utente GitHub';

  @override
  String get createExtends => 'Estende (modelli base)';

  @override
  String get createExtendsHint => 'Eredita dati di manutenzione condivisi';

  @override
  String get createCustomExtends => 'Percorsi extends personalizzati';

  @override
  String get createAddPart => 'Aggiungi ricambio';

  @override
  String get createNoParts =>
      'Ancora nessun ricambio. I ricambi sono facoltativi.';

  @override
  String get partSingular => 'Ricambio';

  @override
  String get createAddItem => 'Aggiungi elemento di manutenzione';

  @override
  String get createNoItems => 'Ancora nessun elemento di manutenzione.';

  @override
  String get createPreview => 'Anteprima';

  @override
  String createErrorsFound(int count) {
    return '$count errore/i di validazione';
  }

  @override
  String get createCopy => 'Copia';

  @override
  String get createShare => 'Condividi';

  @override
  String get createSave => 'Salva';

  @override
  String get createQuantity => 'Quantità';

  @override
  String get createI18nKey => 'Chiave i18n';

  @override
  String get createDescI18nKey => 'Chiave i18n descrizione';

  @override
  String get createIntervalKm => 'Intervallo (km)';

  @override
  String get createIntervalMonths => 'Intervallo (mesi)';

  @override
  String get createDescription => 'Descrizione';

  @override
  String get createAddPartRef => 'Aggiungi riferimento ricambio';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nome';

  @override
  String get createFieldUnit => 'Unità';

  @override
  String get createFieldOem => 'Numero OEM';

  @override
  String get createFieldLabel => 'Etichetta';

  @override
  String get createFieldPart => 'Ricambio';

  @override
  String get fuelGasoline => 'Benzina';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'GPL';

  @override
  String get fuelCng => 'Metano';

  @override
  String get fuelHydrogen => 'Idrogeno';

  @override
  String get fuelEthanol => 'Etanolo';

  @override
  String get powertrainCombustion => 'Combustione';

  @override
  String get powertrainHybrid => 'Ibrido';

  @override
  String get powertrainPluginHybrid => 'Ibrido plug-in';

  @override
  String get powertrainElectric => 'Elettrico';

  @override
  String get catalogDb => 'Database del catalogo';

  @override
  String get catalogSourceBuiltin => 'Incluso (predefinito)';

  @override
  String get catalogSourceOnline => 'Online (release GitHub)';

  @override
  String get catalogSourcesTitle => 'Cataloghi disponibili';

  @override
  String get catalogCannotDelete =>
      'Catalogo predefinito — non può essere eliminato';

  @override
  String catalogVersionOf(String version) {
    return 'Versione $version';
  }

  @override
  String get catalogVersionUnknown => 'Versione non disponibile';

  @override
  String get catalogRefreshOnline => 'Aggiorna catalogo online';

  @override
  String get catalogRefreshed => 'Catalogo online aggiornato';

  @override
  String get catalogRefreshFailed =>
      'Impossibile aggiornare il catalogo online';

  @override
  String get catalogNotAvailable => 'Questo catalogo non è disponibile';

  @override
  String get catalogImportDb => 'Importa DB locale';

  @override
  String get catalogImported => 'Catalogo importato';

  @override
  String get catalogImportFailed => 'Impossibile importare il catalogo';

  @override
  String get catalogDelete => 'Elimina catalogo';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Eliminare $name? Questa operazione non può essere annullata.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Impossibile scaricare il catalogo online. Controlla la connessione e riprova.';

  @override
  String get templateUrlExample =>
      'Esempio: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> viene sostituito dall\'ultima release di quel repository. Puoi usare qualsiasi repository GitHub o incollare un link diretto. Se il tag non può essere risolto, il link viene usato così com\'è e il test mostrerà l\'errore.';

  @override
  String get templateUrlUsage =>
      'Usato per recuperare il catalogo, l\'indice dei modelli e le traduzioni (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Risolve in: $url';
  }

  @override
  String get templateUrlVersion => 'Versione';

  @override
  String get templateUrlLatest => 'Ultima (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Impossibile caricare le versioni';

  @override
  String get templateUrlHelp => 'Aiuto sull\'URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL repository';

  @override
  String get moreTemplateSourceVersionLatest => 'Ultima';

  @override
  String catalogDbVersion(String version) {
    return 'Versione DB: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Release: $version';
  }

  @override
  String get createInheritedParts => 'Ricambi ereditati (da extends)';

  @override
  String get createInheritedItems => 'Manutenzione ereditata (da extends)';

  @override
  String get templateExtendsNotLoaded =>
      'Alcuni extends non possono essere caricati';

  @override
  String get templateRepoLoading => 'Caricamento dal repository dei modelli…';

  @override
  String get templateRepoError =>
      'Impossibile raggiungere il repository dei modelli';

  @override
  String templateBy(String author) {
    return 'di $author';
  }
}
