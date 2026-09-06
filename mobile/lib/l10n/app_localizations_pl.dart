// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Pulpit';

  @override
  String get navVehicles => 'Pojazdy';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Więcej';

  @override
  String get homeEmptyTitle => 'Brak pojazdów';

  @override
  String get homeEmptySubtitle => 'Dodaj swój pierwszy pojazd';

  @override
  String homeError(Object error) {
    return 'Błąd: $error';
  }

  @override
  String get dashboardTitle => 'Pulpit';

  @override
  String get dashboardComingSoon => 'Wkrótce';

  @override
  String get vehicleDetailTitle => 'Pojazd';

  @override
  String get vehicleNotFound => 'Nie znaleziono pojazdu';

  @override
  String get plate => 'Nr rejestracyjny';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Marka / Model';

  @override
  String get year => 'Rok';

  @override
  String get odometer => 'Przebieg';

  @override
  String get update => 'Aktualizuj';

  @override
  String get actions => 'Akcje';

  @override
  String get tools => 'Narzędzia';

  @override
  String get information => 'Informacje';

  @override
  String get fuelLogs => 'Tankowania';

  @override
  String get maintenanceHistory => 'Historia serwisowa';

  @override
  String get configureIntervals => 'Skonfiguruj interwały';

  @override
  String get nextMaintenance => 'Następny serwis';

  @override
  String get allIntervalsDisabled => 'Wszystkie interwały są wyłączone.';

  @override
  String get register => 'Zarejestruj';

  @override
  String get registerService => 'Zarejestruj serwis';

  @override
  String get noDescriptionAvailable =>
      'Brak opisu. Przejdź do ustawień serwisu, aby go dodać.';

  @override
  String get close => 'Zamknij';

  @override
  String get retry => 'Ponów';

  @override
  String get overduePerformService => 'Zaległy — wykonaj serwis';

  @override
  String nextIn(Object parts) {
    return 'Następny za $parts';
  }

  @override
  String get vehicleFormNew => 'Nowy pojazd';

  @override
  String get vehicleFormEdit => 'Edytuj pojazd';

  @override
  String get vehicleFormDetails => 'Szczegóły';

  @override
  String get vehicleFormVehicle => 'Pojazd';

  @override
  String get brand => 'Marka';

  @override
  String get model => 'Model';

  @override
  String get required => 'Wymagane';

  @override
  String get invalidYear => 'Nieprawidłowy rok';

  @override
  String get vehicleType => 'Typ pojazdu';

  @override
  String get combustion => 'Spalinowy';

  @override
  String get electric => 'Elektryczny';

  @override
  String get motorcycle => 'Motocykl';

  @override
  String get plateOptional => 'Nr rejestracyjny (opcjonalnie)';

  @override
  String get vinOptional => 'VIN (opcjonalnie)';

  @override
  String get invalid => 'Nieprawidłowy';

  @override
  String get aliasOptional => 'Pseudonim (opcjonalnie)';

  @override
  String get aliasHint => 'Np.: Moja bryka, Bestia itp.';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get addVehicle => 'Dodaj pojazd';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Serwisy pojawiają się jako zaległe';

  @override
  String get newVehicleServicesOverdueBody =>
      'Ponieważ Twój pojazd ma już ponad 500 km, wszystkie usługi serwisowe pojawiają się jako zaległe.\n\nZarejestruj usługi, które już wykonałeś. Jeśli nie pamiętasz dokładnego przebiegu, ustaw przybliżoną liczbę km dla ostatniego serwisu.';

  @override
  String get deleteVehicle => 'Usuń pojazd';

  @override
  String get deleteVehicleConfirm =>
      'Tej operacji nie można cofnąć. Wszystkie tankowania, rekordy serwisowe i interwały powiązane z pojazdem zostaną usunięte.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get resetToDefault => 'Przywróć domyślne';

  @override
  String get delete => 'Usuń';

  @override
  String get dataManagerTitle => 'Eksport / import danych';

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get exporting => 'Eksportowanie...';

  @override
  String get export => 'Eksport';

  @override
  String get importing => 'Importowanie...';

  @override
  String get import => 'Import';

  @override
  String get saveExport => 'Zapisz eksport';

  @override
  String exportedAt(Object path) {
    return 'Wyeksportowano do $path';
  }

  @override
  String exportError(Object error) {
    return 'Błąd eksportu: $error';
  }

  @override
  String get importData => 'Importuj dane';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Znaleziono:\n• $vehicles pojazd(y)\n• $fuelLogs tankowanie(ń)\n• $maintenanceLogs wpis(y) serwisowe\n• $documents dokument(y)\n\nImportować? Istniejące dane z tym samym ID zostaną nadpisane.';
  }

  @override
  String get importSuccess => 'Dane zaimportowano pomyślnie';

  @override
  String importError(Object error) {
    return 'Błąd importu: $error';
  }

  @override
  String get invalidJson => 'Nieprawidłowy plik JSON';

  @override
  String exportShareText(Object count) {
    return 'Eksport Karter — $count pojazd(y)';
  }

  @override
  String get maintenanceSettingsTitle => 'Interwały serwisowe';

  @override
  String get maintenanceSettingsInstruction =>
      'Włącz lub wyłącz pozycje zgodnie z potrzebami Twojego pojazdu. Niestandardowe interwały można usunąć.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Czas (miesiące)';

  @override
  String get partsTitle => 'Części';

  @override
  String get partUnitUnit => 'szt.';

  @override
  String get partUnitSet => 'zestaw';

  @override
  String get partUnitKit => 'komplet';

  @override
  String get partUnitCan => 'kanister';

  @override
  String get partUnitLabel => 'Jednostka';

  @override
  String get localParts => 'Części lokalne';

  @override
  String get intervalParts => 'Części interwału';

  @override
  String get newPart => 'Nowa część';

  @override
  String get createPart => 'Utwórz część';

  @override
  String get partsSection => 'Części';

  @override
  String get usedParts => 'Części';

  @override
  String usedInServicesCount(Object count) {
    return '$count usługa(y)';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Ta część jest używana w $count usługach. Usunąć mimo to?';
  }

  @override
  String get reportPartsHeader => 'Części';

  @override
  String get templateFound => 'Znaleziono szablon';

  @override
  String get templateDisclaimer =>
      'Dane szablonu mają charakter wyłącznie informacyjny. Zawsze weryfikuj interwały zgodnie z instrukcją obsługi pojazdu.';

  @override
  String get noTemplate => 'Brak szablonu';

  @override
  String get useTemplate => 'Użyj szablonu';

  @override
  String get searchTemplate => 'Szukaj szablonu';

  @override
  String templateWithName(Object name) {
    return 'Szablon: $name';
  }

  @override
  String get noResultsTitle => 'Brak wyników';

  @override
  String get noTemplateFoundDescription =>
      'Nie znaleziono szablonu dla podanych danych.';

  @override
  String get searchParameters => 'Parametry wyszukiwania:';

  @override
  String get defaultIntervalsHint =>
      'Pojazd będzie używał domyślnych interwałów.';

  @override
  String get missingTemplateContribute =>
      'Brakuje szablonu? Dołóż swoją cegiełkę na github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Zobacz wszystkie szablony';

  @override
  String get contribute => 'Współtwórz';

  @override
  String get contributeOnGitHub => 'Współtwórz na GitHub';

  @override
  String get gotIt => 'Rozumiem';

  @override
  String get templateUnderConstruction => 'Szablon w budowie';

  @override
  String get templateNotReady =>
      'Ten szablon nie jest jeszcze gotowy.\nPracujemy nad nim!';

  @override
  String get contributionsWelcome =>
      'Współtworzenie jest mile widziane — dodawaj lub poprawiaj szablony dla swojego pojazdu:';

  @override
  String requestedParam(Object params) {
    return 'Zapytano: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Czy na pewno chcesz usunąć ten interwał?';

  @override
  String get addPart => 'Dodaj część';

  @override
  String get partName => 'Nazwa części';

  @override
  String get quantity => 'Ilość';

  @override
  String get oemNumber => 'Numer OEM';

  @override
  String get addLink => 'Dodaj link';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Otwórz';

  @override
  String get noLinks => 'Brak linków';

  @override
  String get noParts => 'Brak części';

  @override
  String get invalidUrl => 'Nieprawidłowy URL';

  @override
  String get copied => 'Skopiowano';

  @override
  String get linksTitle => 'Linki referencyjne';

  @override
  String get copy => 'Kopiuj';

  @override
  String get addModeManual => 'Ręcznie';

  @override
  String get addModeTemplate => 'Szablon';

  @override
  String get newFromTemplate => 'Nowy z szablonu';

  @override
  String get updatesAvailable => 'Dostępne aktualizacje';

  @override
  String get restore => 'Przywróć';

  @override
  String get windowMinimize => 'Minimalizuj';

  @override
  String get windowMaximize => 'Maksymalizuj';

  @override
  String get windowClose => 'Zamknij';

  @override
  String get syncInstruction =>
      'Zsynchronizuj interwały serwisowe z szablonu Twojego pojazdu.';

  @override
  String get upToDate => 'Wszystko aktualne';

  @override
  String get syncAdded => 'Dodano interwał z szablonu';

  @override
  String get syncRestored => 'Przywrócono interwał z szablonu';

  @override
  String get months => 'mies.';

  @override
  String get description => 'Opis';

  @override
  String get newInterval => 'Nowy interwał';

  @override
  String get name => 'Nazwa';

  @override
  String get add => 'Dodaj';

  @override
  String get edit => 'Edytuj';

  @override
  String get addToDashboard => 'Dodaj do pulpitu';

  @override
  String get setupNotifications => 'Konfiguruj powiadomienia';

  @override
  String get addToDashboardComingSoon => 'Wkrótce';

  @override
  String get deleteInterval => 'Usuń';

  @override
  String get noDescriptionAvailableSettings =>
      'Brak opisu. Naciśnij „Edytuj”, aby go dodać.';

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
    return 'co $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months mies.';
  }

  @override
  String get maintenanceLogTitleEdit => 'Edytuj serwis';

  @override
  String get maintenanceLogTitleNew => 'Nowy serwis';

  @override
  String date(Object date) {
    return 'Data: $date';
  }

  @override
  String get descriptionRequired => 'Opis';

  @override
  String get odometerAtService => 'Przebieg przy serwisie (opcjonalnie)';

  @override
  String get resetInterval => 'Resetuj interwał (opcjonalnie)';

  @override
  String get saveChangesShort => 'Zapisz zmiany';

  @override
  String get saveService => 'Zapisz serwis';

  @override
  String get saveFile => 'Zapisz plik';

  @override
  String get lastService => 'Ostatni';

  @override
  String get addPhoto => 'Dodaj zdjęcie';

  @override
  String get photos => 'zdjęć';

  @override
  String get files => 'plików';

  @override
  String get share => 'Udostępnij';

  @override
  String get deleteService => 'Usuń serwis';

  @override
  String get deleteServiceConfirm => 'Czy na pewno chcesz usunąć ten serwis?';

  @override
  String get maintenanceListTitle => 'Serwis';

  @override
  String get maintenanceEmpty => 'Brak zarejestrowanych serwisów';

  @override
  String get maintenanceHistoryTab => 'Historia';

  @override
  String get maintenancePdfExportTab => 'Eksport PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count usługa(y) w tym okresie';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... i $count więcej';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Brak serwisów w tym zakresie dat.';

  @override
  String get maintenanceExportPdf => 'Eksportuj PDF';

  @override
  String get maintenanceSharePdf => 'Udostępnij';

  @override
  String get maintenanceReportTitle => 'Raport serwisowy';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Wygenerowano $date $time';
  }

  @override
  String get maintenanceReportEmpty => 'Brak wpisów serwisowych w tym okresie.';

  @override
  String get maintenanceReportDateHeader => 'Data';

  @override
  String get maintenanceReportDescHeader => 'Opis';

  @override
  String get maintenanceReportOdometerHeader => 'Przebieg';

  @override
  String get addDocument => 'Dodaj dokument';

  @override
  String get documentType => 'Typ dokumentu';

  @override
  String get selectFile => 'Wybierz plik';

  @override
  String get noFileSelected => 'Nie wybrano pliku';

  @override
  String get notesOptional => 'Notatki (opcjonalnie)';

  @override
  String get expiryDateOptional => 'Data ważności (opcjonalnie)';

  @override
  String get pleaseSelectFile => 'Wybierz plik';

  @override
  String get documentSaved => 'Dokument zapisany';

  @override
  String get takePhoto => 'Zrób zdjęcie';

  @override
  String get chooseFromGallery => 'Wybierz z galerii';

  @override
  String get browseFiles => 'Przeglądaj pliki';

  @override
  String get docTypeFine => 'Mandat';

  @override
  String get docTypeParkingFee => 'Opłata parkingowa';

  @override
  String get docTypeInsurance => 'Ubezpieczenie';

  @override
  String get docTypeVehicleCheck => 'Przegląd pojazdu';

  @override
  String get docTypeTax => 'Podatek';

  @override
  String get docTypeComplexInsurance => 'Ubezpieczenie kompleksowe';

  @override
  String get docTypeVehicleRegister => 'Dowód rejestracyjny';

  @override
  String get docTypeOther => 'Inne';

  @override
  String get vehicleDocuments => 'Dokumenty';

  @override
  String get fuelFormTitle => 'Nowe tankowanie';

  @override
  String get volume => 'Objętość';

  @override
  String get unitL => 'l';

  @override
  String get unitGal => 'gal';

  @override
  String get unitKm => 'km';

  @override
  String get unitMi => 'mi';

  @override
  String get pricePerUnit => 'Cena za jednostkę (opcjonalnie)';

  @override
  String get fullTank => 'Pełny zbiornik';

  @override
  String get volumeUnit => 'Jednostka objętości paliwa';

  @override
  String get currency => 'Waluta';

  @override
  String get cost => 'Koszt (opcjonalnie)';

  @override
  String get saveFuelUp => 'Zapisz tankowanie';

  @override
  String get fuelListTitle => 'Tankowania';

  @override
  String get fuelEmpty => 'Brak zarejestrowanych tankowań';

  @override
  String get moreAbout => 'O aplikacji Karter';

  @override
  String get moreDescription =>
      'Karter to lokalna, open source aplikacja do obsługi pojazdów, która szanuje Twoją prywatność.';

  @override
  String get moreExport => 'Eksport / import danych';

  @override
  String get moreExportSubtitle =>
      'Utwórz kopię zapasową lub przenieś swoje dane';

  @override
  String get moreDocs => 'Dokumentacja';

  @override
  String get moreDocsSubtitle => 'Poradnik obsługi i funkcje';

  @override
  String get moreSource => 'Kod źródłowy';

  @override
  String get moreSourceSubtitle => 'Repozytorium GitHub';

  @override
  String get moreDonate => 'Wesprzyj';

  @override
  String get moreDonateSubtitle => 'Wesprzyj rozwój na GitHub Sponsors';

  @override
  String get moreFooter => 'Stworzone z ❤️ przez abrahdev';

  @override
  String get moreRate => 'Oceń aplikację Karter';

  @override
  String get moreRateSubtitle => 'Zostaw opinię w Sklepie Play';

  @override
  String get moreFeedback => 'Oceń aplikację';

  @override
  String get moreFeedbackSubtitle =>
      'Oceń aplikację i skonfiguruj przypomnienia';

  @override
  String get feedbackTitle => 'Opinia';

  @override
  String get sectionPreferences => 'Preferencje';

  @override
  String get sectionData => 'Dane';

  @override
  String get sectionFeedbackCommunity => 'Opinia i społeczność';

  @override
  String get sectionTips => 'Program napiwków';

  @override
  String get sectionAbout => 'O aplikacji Karter';

  @override
  String get theme => 'Motyw';

  @override
  String get themeAutomatic => 'Automatyczny';

  @override
  String get themeAutomaticDesc => 'Zgodnie z ustawieniami urządzenia';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemDesc => 'Zgodnie z ustawieniami urządzenia';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get colorScheme => 'Kolor podstawowy';

  @override
  String get colorCustom => 'Własny';

  @override
  String get colorOfInterface => 'Kolor interfejsu';

  @override
  String get colorOfInterfaceDesc =>
      'Zastosuj kolor podstawowy do powierzchni tła';

  @override
  String get customColor => 'Własny kolor';

  @override
  String get customColorDesc =>
      'Użyj osobistego koloru zamiast akcentu systemowego';

  @override
  String get selectColor => 'Wybierz kolor';

  @override
  String get hapticFeedback => 'Wibracje dotykowe';

  @override
  String get hapticFeedbackDesc => 'Wibruj przy interakcjach';

  @override
  String get hapticModeOff => 'Wyłączone';

  @override
  String get hapticModeOffDesc => 'Brak wibracji przy interakcjach';

  @override
  String get hapticModeClear => 'Wyraźne';

  @override
  String get hapticModeClearDesc => 'Jedno wyraźne stuknięcie na akcję';

  @override
  String get hapticModeRich => 'Bogate';

  @override
  String get hapticModeRichDesc =>
      'Wielowarstwowe wibracje o różnej intensywności';

  @override
  String get testNotification => 'Testowe powiadomienie';

  @override
  String get testNotificationDesc =>
      'Wyślij testowe powiadomienie, aby sprawdzić konfigurację';

  @override
  String get testNotificationSent => 'Wysłano testowe powiadomienie';

  @override
  String get notificationsPermissionTitle => 'Powiadomienia wyłączone';

  @override
  String get notificationsPermissionDesc =>
      'Włącz powiadomienia, aby otrzymywać przypomnienia o przebiegu i serwisie';

  @override
  String get notificationsPermissionAllow => 'Zezwól na powiadomienia';

  @override
  String get notificationsPermissionDeniedTitle => 'Powiadomienia zablokowane';

  @override
  String get notificationsPermissionDeniedDesc =>
      'Uprawnienie do powiadomień zostało trwale odrzucone. Aby je włączyć, przejdź do Ustawienia > Aplikacje > Karter > Powiadomienia i włącz je.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Otwórz ustawienia urządzenia';

  @override
  String get notificationsPermissionDeniedStep2 =>
      '2. Przejdź do Aplikacje > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Dotknij Powiadomienia';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Włącz „Pokaż powiadomienia”';

  @override
  String get notificationsPermissionOpenSettings => 'Otwórz ustawienia';

  @override
  String get shakeToOdometer => 'Potrząśnij, aby zaktualizować przebieg';

  @override
  String get shakeToOdometerDesc =>
      'Potrząśnij urządzeniem, aby otworzyć aktualizację przebiegu na ekranie pojazdu';

  @override
  String get feedbackReminderToggle => 'Przypomnienie o ocenie';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Pokazuj przypomnienie o ocenie aplikacji po zapisaniu serwisów';

  @override
  String get feedbackServicesInterval => 'Serwisy przed monitem';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Po $count usługa(y)';
  }

  @override
  String get feedbackServicesSuffix => 'serwisów';

  @override
  String get feedbackRepeatDays => 'Częstotliwość przypomnień';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Co $days dni';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'dni';

  @override
  String get ratePromptMessage =>
      'Podoba Ci się Karter? Opinia pomoże innym odkryć aplikację!';

  @override
  String get rate => 'Oceń';

  @override
  String moreUrlError(Object url) {
    return 'Nie można otworzyć $url';
  }

  @override
  String get tipProgram => 'Program napiwków';

  @override
  String get tipProgramComingSoon =>
      'Ta funkcja jest w trakcie opracowywania i będzie dostępna wkrótce.';

  @override
  String get tipBadges => 'Odznaki';

  @override
  String get tipBadgesNone => 'Brak';

  @override
  String get tipInfo => 'Informacje';

  @override
  String get tipInfoText =>
      'Program napiwków to sposób, w jaki użytkownicy mogą okazać dodatkowe wsparcie i wdzięczność za szybką pomoc, ciągłe ulepszenia i regularne aktualizacje, które oferuje Karter.';

  @override
  String get tipOneTime => 'Napiwek jednorazowy';

  @override
  String get tipRecurring => 'Napiwek cykliczny';

  @override
  String get tipBronze => 'Brąz';

  @override
  String get tipSilver => 'Srebro';

  @override
  String get tipGold => 'Złoto';

  @override
  String get tipBronzePrice => 'Napiwek brązowy';

  @override
  String get tipSilverPrice => 'Napiwek srebrny';

  @override
  String get tipGoldPrice => 'Napiwek złoty';

  @override
  String get tipBronzeMonthly => 'Brąz / miesiąc';

  @override
  String get tipSilverMonthly => 'Srebro / miesiąc';

  @override
  String get tipGoldMonthly => 'Złoto / miesiąc';

  @override
  String get officialWebsite => 'Oficjalna strona';

  @override
  String get communityForums => 'Forum społeczności';

  @override
  String get translations => 'Tłumaczenia';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get privacyPolicyDesc =>
      'Przeczytaj naszą politykę prywatności online.';

  @override
  String get openPrivacyPolicy => 'Otwórz politykę prywatności';

  @override
  String get version => 'Wersja';

  @override
  String get deviceId => 'Identyfikator urządzenia';

  @override
  String get changelog => 'Dziennik zmian';

  @override
  String get openSourceLicenses => 'Licencje open source';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get languageSystem => 'Domyślny systemowy';

  @override
  String get english => 'Angielski';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get eesti => 'Eesti';

  @override
  String get german => 'Niemiecki';

  @override
  String get portuguese => 'Portugalski';

  @override
  String get russian => 'Rosyjski';

  @override
  String get french => 'Francuski';

  @override
  String get polish => 'Polski';

  @override
  String get italian => 'Włoski';

  @override
  String get dutch => 'Holenderski';

  @override
  String get odometerUpdateTitle => 'Aktualizuj przebieg';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Ostatni: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'Wartość jest niższa niż ostatni zapis ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Przejechałeś $delta $unit od ostatniego razu. Czy to na pewno poprawne?';
  }

  @override
  String get odometerSave => 'Zapisz';

  @override
  String get odometerCancel => 'Anuluj';

  @override
  String get moreNotifications => 'Powiadomienia';

  @override
  String get moreNotificationsSubtitle =>
      'Przypomnienia o przebiegu i serwisie';

  @override
  String get notificationSettingsTitle => 'Ustawienia powiadomień';

  @override
  String get notificationSettingsSubtitle =>
      'Skonfiguruj przypomnienia dla tego pojazdu';

  @override
  String get notificationOdometerSection => 'Przypomnienie o przebiegu';

  @override
  String get notificationMaintenanceSection => 'Przypomnienie o serwisie';

  @override
  String get notificationFreqLabel => 'Częstotliwość przypomnień';

  @override
  String get notificationFreqOff => 'Wyłączone';

  @override
  String notificationFreqValue(Object days) {
    return 'Co $days dni';
  }

  @override
  String get notificationMaintenanceToggle => 'Przypomnienia o serwisie';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Otrzymuj codzienne przypomnienia o oczekujących serwisach';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Odroczono o $days dni';
  }

  @override
  String get notificationSnoozeCancel => 'Anuluj odroczenie';

  @override
  String get notificationNoVehicles =>
      'Dodaj pojazd, aby skonfigurować powiadomienia';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Przebieg: $freq • Serwis: $maint';
  }

  @override
  String get notificationConfigure => 'Konfiguruj';

  @override
  String get notificationMaintOn => 'Włączone';

  @override
  String get notificationMaintOff => 'Wyłączone';

  @override
  String get notificationSnoozeAction => 'Odrocz o 1 tydzień';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Odroczono do $date';
  }

  @override
  String get notificationFreqWeekly => 'Co 7 dni';

  @override
  String get notificationFreqMonthly => 'Co 30 dni';

  @override
  String get notificationFreqCustom => 'Własna';

  @override
  String notificationFreqDays(Object days) {
    return '$days dni';
  }

  @override
  String get notificationMaintenanceSnooze => 'Odrocz serwis o 1 tydzień';

  @override
  String get notificationSnoozeToggle => 'Odrocz przypomnienia';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days dni';
  }

  @override
  String get unsavedChanges => 'Niezapisane zmiany';

  @override
  String get discardChangesConfirm =>
      'Masz niezapisane zmiany. Czy na pewno chcesz wyjść?';

  @override
  String get discard => 'Odrzuć';

  @override
  String get moreTemplateSource => 'Źródło szablonów';

  @override
  String get moreTemplateSourceSubtitle =>
      'Pobieraj szablony z GitHub lub korzystaj z lokalnych zasobów';

  @override
  String get moreTemplateSourceOffline => 'Lokalne (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL repozytorium';

  @override
  String get moreTemplateSourceReset => 'Przywróć domyślne';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Edytuj URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL zaktualizowany';

  @override
  String get testConnection => 'Testuj połączenie';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Ostatnia modyfikacja: $date';
  }

  @override
  String get importCheckTranslations => 'Tłumaczenia';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found z $total dostępnych';
  }

  @override
  String get importCheckIndex => 'Indeks szablonów';

  @override
  String importCheckIndexResult(int count) {
    return '$count szablonów';
  }

  @override
  String get importCheckDb => 'Baza katalogu (zdalna)';

  @override
  String get importCheckDbRemoteFound => 'Dostępna na GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Tylko lokalnie (nie na GitHub)';

  @override
  String get importCheckDbLocal => 'Zaimportowane dane bazy';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Wersja: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Pojazdy: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Pozycje serwisowe: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Części: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Kody OBD: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Nie można odczytać zaimportowanej bazy danych';

  @override
  String get onboardingSkip => 'Pomiń';

  @override
  String get onboardingNext => 'Dalej';

  @override
  String get onboardingDone => 'Zaczynajmy';

  @override
  String get onboardingReplay => 'Zobacz przewodnik';

  @override
  String get onboardingReplaySubtitle => 'Odtwórz powitalny przewodnik';

  @override
  String get onboardingWelcomeTitle => 'Witaj w Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Skoncentrowany na prywatności, open source tracker serwisowy pojazdów. W 100% offline — bez kont, bez telemetrii, bez śledzenia.';

  @override
  String get onboardingVehicleTitle => 'Dodaj swój pojazd';

  @override
  String get onboardingVehicleDesc =>
      'Zarejestruj swój samochód, motocykl lub auto elektryczne. Wybierz szablon, a Karter automatycznie wypełni interwały serwisowe dla Twojego modelu.';

  @override
  String get onboardingTrackTitle => 'Śledź paliwo i serwis';

  @override
  String get onboardingTrackDesc =>
      'Rejestruj tankowania z automatycznym obliczaniem spalania (MPG, l/100 km, km/l). Śledź naprawy, części i koszty.';

  @override
  String get onboardingRemindersTitle => 'Nie przegap serwisu';

  @override
  String get onboardingRemindersDesc =>
      'Otrzymuj powiadomienia, gdy nadejdzie czas na wymianę oleju, klocki hamulcowe i każdy interwał serwisowy — według przebiegu lub czasu.';

  @override
  String get supporterBadge => 'Jesteś zwolennikiem Karter!';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get tipPurchased => 'Dziękujemy!';

  @override
  String get tipSupport => 'Wsparcie';

  @override
  String get sectionBackup => 'Kopia zapasowa';

  @override
  String get moreBackup => 'Kopia zapasowa';

  @override
  String get moreBackupSubtitle => 'Zaszyfrowana kopia zapasowa';

  @override
  String get backupConnect => 'Połącz z Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Połączono jako $email';
  }

  @override
  String get backupNow => 'Wykonaj kopię teraz';

  @override
  String get backupInProgress => 'Tworzenie kopii...';

  @override
  String backupLast(Object date) {
    return 'Ostatnia kopia: $date';
  }

  @override
  String get backupNever => 'Nigdy nie tworzono kopii';

  @override
  String get backupRestore => 'Przywróć z kopii';

  @override
  String get backupRestoreInProgress => 'Przywracanie...';

  @override
  String get backupRestoreConfirm =>
      'Spowoduje to nadpisanie wszystkich bieżących danych. Czy na pewno?';

  @override
  String backupError(Object error) {
    return 'Błąd kopii zapasowej: $error';
  }

  @override
  String get backupSuccess => 'Kopia zapasowa została pomyślnie przesłana';

  @override
  String get backupRestoreSuccess =>
      'Dane przywrócone. Uruchom ponownie aplikację, aby zobaczyć zmiany.';

  @override
  String get backupDisconnect => 'Rozłącz';

  @override
  String get backupNoBackups => 'Nie znaleziono kopii zapasowych';

  @override
  String get backupRestoreBtn => 'Przywróć';

  @override
  String get backupDelete => 'Usuń';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Usunąć kopię zapasową $name?';
  }

  @override
  String get backupDeleteSuccess => 'Kopia zapasowa usunięta';

  @override
  String backupCount(Object current, Object max) {
    return 'Kopie: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Wyszukiwarka kodów błędów';

  @override
  String get dtcSearchHint => 'Wpisz kod, np. P0171';

  @override
  String get dtcEmptyState => 'Wpisz kod, aby sprawdzić jego opis';

  @override
  String get dtcNoMatch => 'Żaden kod nie pasuje do wyszukiwania';

  @override
  String get dtcDescription => 'Opis';

  @override
  String get dtcRelatedMaintenance => 'Powiązany serwis';

  @override
  String get dtcScopeStandard => 'Standard';

  @override
  String get dtcScopeManufacturer => 'Producent';

  @override
  String get dtcGeneralDb => 'Ogólne kody OBD-II';

  @override
  String get dtcCatalogBrands => 'Marki z katalogu';

  @override
  String get dtcMyVehicles => 'Moje pojazdy';

  @override
  String get dtcVehicle => 'Pojazd';

  @override
  String get dtcVehicleNotFound => 'Nie znaleziono pojazdu';

  @override
  String get dtcLoadError => 'Nie można wczytać kodów błędów';

  @override
  String get notificationOdometerTitle => 'Aktualizuj przebieg';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days dni od ostatniego przypomnienia.';
  }

  @override
  String get notificationMaintenanceTitle => 'Oczekujący serwis';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — sprawdź interwały serwisowe.';
  }

  @override
  String errorGeneric(String error) {
    return 'Błąd: $error';
  }

  @override
  String get deleteFuelUp => 'Usuń tankowanie';

  @override
  String get deleteFuelUpConfirm => 'Czy na pewno chcesz usunąć to tankowanie?';

  @override
  String get editFuelUp => 'Edytuj tankowanie';

  @override
  String get deleteDocument => 'Usuń dokument';

  @override
  String get deleteDocumentConfirm =>
      'Czy na pewno chcesz usunąć ten dokument?';

  @override
  String get editDocument => 'Edytuj dokument';

  @override
  String get title => 'Tytuł';

  @override
  String get selectExpiryDate => 'Wybierz datę ważności';

  @override
  String get addMoreFiles => 'Dodaj więcej plików';

  @override
  String get consumptionUnit => 'l/100km';

  @override
  String get sectionTemplates => 'Szablony';

  @override
  String get templatesTitle => 'Szablony';

  @override
  String get templatesSubtitle => 'Przeglądaj katalog szablonów społeczności';

  @override
  String get createTemplate => 'Utwórz szablon';

  @override
  String get createTemplateSubtitle =>
      'Utwórz szablon i wyeksportuj go jako JSON';

  @override
  String get templatesLoadError => 'Nie można wczytać katalogu szablonów.';

  @override
  String get searchTemplatesHint => 'Szukaj według marki, modelu lub generacji';

  @override
  String get allMakes => 'Wszystkie marki';

  @override
  String get noTemplatesFound => 'Żaden szablon nie pasuje do wyszukiwania.';

  @override
  String templateItemsCount(int count) {
    return '$count pozycje serwisowe';
  }

  @override
  String get templateYearsOpen => 'obecnie';

  @override
  String get templateNotFound => 'Nie znaleziono szablonu';

  @override
  String get templateInfo => 'Informacje o szablonie';

  @override
  String get templateYears => 'Lata';

  @override
  String get templateEngine => 'Silnik';

  @override
  String get templateAuthor => 'Autor';

  @override
  String get templateVersion => 'Wersja';

  @override
  String get templateSources => 'Źródła';

  @override
  String get dtcCodesTitle => 'Kody błędów';

  @override
  String dtcCount(int count) {
    return '$count kod(y) błędu';
  }

  @override
  String get noPartsFound => 'Brak części';

  @override
  String get createCopied => 'JSON szablonu skopiowany do schowka';

  @override
  String get saveTemplate => 'Zapisz szablon';

  @override
  String savedAt(String path) {
    return 'Zapisano w $path';
  }

  @override
  String get createHasErrors => 'Popraw błędy, aby wyeksportować';

  @override
  String get createMake => 'Marka';

  @override
  String get createModel => 'Model';

  @override
  String get createGeneration => 'Generacja';

  @override
  String get createYearFrom => 'Rok od';

  @override
  String get createYearTo => 'Rok do';

  @override
  String get createFuel => 'Paliwo';

  @override
  String get createPowertrain => 'Napęd';

  @override
  String get createEngineCode => 'Kod silnika';

  @override
  String get createDisplacement => 'Pojemność (cm³)';

  @override
  String get createPower => 'Moc (KM)';

  @override
  String get templateMetadata => 'Metadane i dziedziczenie';

  @override
  String get createAuthor => 'Autor';

  @override
  String get createAuthorHint => 'Twoja nazwa użytkownika GitHub';

  @override
  String get createExtends => 'Rozszerza (szablony bazowe)';

  @override
  String get createExtendsHint => 'Dziedzicz wspólne dane serwisowe';

  @override
  String get createCustomExtends => 'Własne ścieżki extends';

  @override
  String get createAddPart => 'Dodaj część';

  @override
  String get createNoParts => 'Brak części. Części są opcjonalne.';

  @override
  String get partSingular => 'Część';

  @override
  String get createAddItem => 'Dodaj pozycję serwisową';

  @override
  String get createNoItems => 'Brak pozycji serwisowych.';

  @override
  String get createPreview => 'Podgląd';

  @override
  String createErrorsFound(int count) {
    return '$count błąd(y) walidacji';
  }

  @override
  String get createCopy => 'Kopiuj';

  @override
  String get createShare => 'Udostępnij';

  @override
  String get createSave => 'Zapisz';

  @override
  String get createQuantity => 'Ilość';

  @override
  String get createI18nKey => 'klucz i18n';

  @override
  String get createDescI18nKey => 'klucz i18n opisu';

  @override
  String get createIntervalKm => 'Interwał (km)';

  @override
  String get createIntervalMonths => 'Interwał (miesiące)';

  @override
  String get createDescription => 'Opis';

  @override
  String get createAddPartRef => 'Dodaj odniesienie do części';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nazwa';

  @override
  String get createFieldUnit => 'Jednostka';

  @override
  String get createFieldOem => 'Numer OEM';

  @override
  String get createFieldLabel => 'Etykieta';

  @override
  String get createFieldPart => 'Część';

  @override
  String get fuelGasoline => 'Benzyna';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'LPG';

  @override
  String get fuelCng => 'CNG';

  @override
  String get fuelHydrogen => 'Wodór';

  @override
  String get fuelEthanol => 'Etanol';

  @override
  String get powertrainCombustion => 'Spalinowy';

  @override
  String get powertrainHybrid => 'Hybryda';

  @override
  String get powertrainPluginHybrid => 'Hybryda plug-in';

  @override
  String get powertrainElectric => 'Elektryczny';

  @override
  String get catalogDb => 'Baza katalogu';

  @override
  String get catalogSourceBuiltin => 'Wbudowana (domyślna)';

  @override
  String get catalogSourceOnline => 'Online (wydanie GitHub)';

  @override
  String get catalogSourcesTitle => 'Dostępne katalogi';

  @override
  String get catalogCannotDelete => 'Domyślny katalog — nie można usunąć';

  @override
  String catalogVersionOf(String version) {
    return 'Wersja $version';
  }

  @override
  String get catalogVersionUnknown => 'Wersja niedostępna';

  @override
  String get catalogRefreshOnline => 'Odśwież katalog online';

  @override
  String get catalogRefreshed => 'Katalog online odświeżony';

  @override
  String get catalogRefreshFailed => 'Nie można odświeżyć katalogu online';

  @override
  String get catalogNotAvailable => 'Ten katalog nie jest dostępny';

  @override
  String get catalogImportDb => 'Importuj lokalną bazę';

  @override
  String get catalogImported => 'Katalog zaimportowany';

  @override
  String get catalogImportFailed => 'Nie można zaimportować katalogu';

  @override
  String get catalogDelete => 'Usuń katalog';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Usunąć $name? Tej operacji nie można cofnąć.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Nie można pobrać katalogu online. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get templateUrlExample =>
      'Przykład: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> jest zastępowany najnowszym wydaniem tego repozytorium. Możesz użyć dowolnego repozytorium GitHub lub wkleić bezpośredni link. Jeśli tag nie może zostać rozwiązany, link jest używany bez zmian, a test pokaże błąd.';

  @override
  String get templateUrlUsage =>
      'Używane do pobierania katalogu, indeksu szablonów i tłumaczeń (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Rozwiązuje się do: $url';
  }

  @override
  String get templateUrlVersion => 'Wersja';

  @override
  String get templateUrlLatest => 'Najnowsza (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Nie można wczytać wersji';

  @override
  String get templateUrlHelp => 'Pomoc dotycząca URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL repozytorium';

  @override
  String get moreTemplateSourceVersionLatest => 'Najnowsza';

  @override
  String catalogDbVersion(String version) {
    return 'Wersja bazy: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Wydanie: $version';
  }

  @override
  String get createInheritedParts => 'Części dziedziczone (z extends)';

  @override
  String get createInheritedItems => 'Serwisy dziedziczone (z extends)';

  @override
  String get templateExtendsNotLoaded => 'Niektórych extends nie można wczytać';

  @override
  String get templateRepoLoading => 'Wczytywanie z repozytorium szablonów...';

  @override
  String get templateRepoError =>
      'Nie można połączyć się z repozytorium szablonów';

  @override
  String templateBy(String author) {
    return 'autor: $author';
  }
}
