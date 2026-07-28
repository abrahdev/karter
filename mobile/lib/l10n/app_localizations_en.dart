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
  String get information => 'Information';

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
  String get resetToDefault => 'Reset to default';

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
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Found:\n• $vehicles vehicle(s)\n• $fuelLogs fuel log(s)\n• $maintenanceLogs maintenance log(s)\n• $documents document(s)\n\nImport? Existing data with the same ID will be overwritten.';
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
  String get addToDashboard => 'Add to dashboard';

  @override
  String get setupNotifications => 'Setup notifications';

  @override
  String get addToDashboardComingSoon => 'Coming soon';

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
  String get saveFile => 'Save file';

  @override
  String get lastService => 'Last';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get photos => 'photos';

  @override
  String get files => 'files';

  @override
  String get share => 'Share';

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
  String get pleaseSelectFile => 'Please select a file';

  @override
  String get documentSaved => 'Document saved';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get browseFiles => 'Browse files';

  @override
  String get docTypeFine => 'Fine';

  @override
  String get docTypeParkingFee => 'Parking fee';

  @override
  String get docTypeInsurance => 'Insurance';

  @override
  String get docTypeVehicleCheck => 'Vehicle check';

  @override
  String get docTypeTax => 'Tax';

  @override
  String get docTypeComplexInsurance => 'Complex insurance';

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
  String get moreRate => 'Rate Karter';

  @override
  String get moreRateSubtitle => 'Leave a review on the Play Store';

  @override
  String get moreFeedback => 'Rate the application';

  @override
  String get moreFeedbackSubtitle => 'Rate the app and configure reminders';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get sectionData => 'Data';

  @override
  String get sectionFeedbackCommunity => 'Feedback & Community';

  @override
  String get sectionTips => 'Tip program';

  @override
  String get sectionAbout => 'About Karter';

  @override
  String get theme => 'Theme';

  @override
  String get themeAutomatic => 'Automatic';

  @override
  String get themeAutomaticDesc => 'Follow device setting';

  @override
  String get themeSystem => 'System';

  @override
  String get themeSystemDesc => 'Follow device setting';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get colorScheme => 'Primary color';

  @override
  String get colorCustom => 'Custom';

  @override
  String get colorOfInterface => 'Interface color';

  @override
  String get colorOfInterfaceDesc =>
      'Apply primary color to background surfaces';

  @override
  String get customColor => 'Custom color';

  @override
  String get customColorDesc =>
      'Use a personal color instead of the system accent';

  @override
  String get selectColor => 'Select a color';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get hapticFeedbackDesc => 'Vibrate on interactions';

  @override
  String get hapticModeOff => 'Off';

  @override
  String get hapticModeOffDesc => 'No vibration on interactions';

  @override
  String get hapticModeClear => 'Clear';

  @override
  String get hapticModeClearDesc => 'Single crisp tap per action';

  @override
  String get hapticModeRich => 'Rich';

  @override
  String get hapticModeRichDesc => 'Layered vibrations with varying intensity';

  @override
  String get testNotification => 'Test notification';

  @override
  String get testNotificationDesc => 'Send a test notification to verify setup';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String get notificationsPermissionTitle => 'Notifications disabled';

  @override
  String get notificationsPermissionDesc =>
      'Enable notifications to receive odometer and maintenance reminders';

  @override
  String get notificationsPermissionAllow => 'Allow notifications';

  @override
  String get notificationsPermissionDeniedTitle => 'Notifications blocked';

  @override
  String get notificationsPermissionDeniedDesc =>
      'Notification permission was permanently denied. To enable it, go to Settings > Apps > Karter > Notifications and turn them on.';

  @override
  String get notificationsPermissionDeniedStep1 => '1. Open device Settings';

  @override
  String get notificationsPermissionDeniedStep2 => '2. Go to Apps > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Tap Notifications';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Enable \"Show notifications\"';

  @override
  String get notificationsPermissionOpenSettings => 'Open Settings';

  @override
  String get shakeToOdometer => 'Shake to update odometer';

  @override
  String get shakeToOdometerDesc =>
      'Shake device to open odometer update on vehicle screen';

  @override
  String get feedbackReminderToggle => 'Rating reminder';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Show a reminder to rate the app after saving services';

  @override
  String get feedbackServicesInterval => 'Services before prompt';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'After $count service(s)';
  }

  @override
  String get feedbackServicesSuffix => 'services';

  @override
  String get feedbackRepeatDays => 'Reminder interval';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Every $days day(s)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'days';

  @override
  String get ratePromptMessage =>
      'Enjoying Karter? A review helps others discover the app!';

  @override
  String get rate => 'Rate';

  @override
  String moreUrlError(Object url) {
    return 'Could not open $url';
  }

  @override
  String get tipProgram => 'Tip program';

  @override
  String get tipProgramComingSoon =>
      'This feature is under development and will be available soon.';

  @override
  String get tipBadges => 'Badges';

  @override
  String get tipBadgesNone => 'None';

  @override
  String get tipInfo => 'Information';

  @override
  String get tipInfoText =>
      'The tip program is a way for users to show extra support and appreciation for the fast support, constant improvements, and continuous updates that Karter has offered.';

  @override
  String get tipOneTime => 'One-time tip';

  @override
  String get tipRecurring => 'Recurring tip';

  @override
  String get tipBronze => 'Bronze';

  @override
  String get tipSilver => 'Silver';

  @override
  String get tipGold => 'Gold';

  @override
  String get tipBronzePrice => 'Bronze tip';

  @override
  String get tipSilverPrice => 'Silver tip';

  @override
  String get tipGoldPrice => 'Gold tip';

  @override
  String get tipBronzeMonthly => 'Bronze / month';

  @override
  String get tipSilverMonthly => 'Silver / month';

  @override
  String get tipGoldMonthly => 'Gold / month';

  @override
  String get officialWebsite => 'Official website';

  @override
  String get communityForums => 'Community forums';

  @override
  String get translations => 'Translations';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get privacyPolicyDesc => 'Read our privacy policy online.';

  @override
  String get openPrivacyPolicy => 'Open privacy policy';

  @override
  String get version => 'Version';

  @override
  String get deviceId => 'Device ID';

  @override
  String get changelog => 'Changelog';

  @override
  String get openSourceLicenses => 'Open-source licenses';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get languageSystem => 'System default';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get eesti => 'Eesti';

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
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingDone => 'Get started';

  @override
  String get onboardingReplay => 'View onboarding';

  @override
  String get onboardingReplaySubtitle => 'Replay the welcome walkthrough';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Karter';

  @override
  String get onboardingWelcomeDesc =>
      'A privacy-first, open source vehicle maintenance tracker. 100% offline — no accounts, no telemetry, no tracking.';

  @override
  String get onboardingVehicleTitle => 'Add your vehicle';

  @override
  String get onboardingVehicleDesc =>
      'Register your car, motorcycle, or EV. Pick a template and Karter auto-fills the maintenance intervals for your model.';

  @override
  String get onboardingTrackTitle => 'Track fuel & maintenance';

  @override
  String get onboardingTrackDesc =>
      'Log fill-ups with automatic economy calculations (MPG, L/100km, km/L). Track repairs, parts, and costs.';

  @override
  String get onboardingRemindersTitle => 'Stay on top of service';

  @override
  String get onboardingRemindersDesc =>
      'Get notified when it\'s time for oil changes, brake pads, and every maintenance interval — by distance or time.';

  @override
  String get supporterBadge => 'You\'re a Karter supporter!';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get tipPurchased => 'Thank you!';

  @override
  String get tipSupport => 'Support';

  @override
  String get sectionBackup => 'Backup';

  @override
  String get moreBackup => 'Backup';

  @override
  String get moreBackupSubtitle => 'Encrypted backup';

  @override
  String get backupConnect => 'Connect Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Connected as $email';
  }

  @override
  String get backupNow => 'Back up now';

  @override
  String get backupInProgress => 'Backing up…';

  @override
  String backupLast(Object date) {
    return 'Last backup: $date';
  }

  @override
  String get backupNever => 'Never backed up';

  @override
  String get backupRestore => 'Restore from backup';

  @override
  String get backupRestoreInProgress => 'Restoring…';

  @override
  String get backupRestoreConfirm =>
      'This will replace all current data with the backup. Continue?';

  @override
  String backupError(Object error) {
    return 'Backup error: $error';
  }

  @override
  String get backupSuccess => 'Backup uploaded successfully';

  @override
  String get backupRestoreSuccess =>
      'Data restored. Restart the app to see changes.';

  @override
  String get backupDisconnect => 'Disconnect';

  @override
  String get backupNoBackups => 'No backups found';

  @override
  String get backupRestoreBtn => 'Restore';
}
