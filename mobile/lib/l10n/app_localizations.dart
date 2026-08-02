import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_et.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
    Locale('et'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Karter'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navVehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get navVehicles;

  /// No description provided for @navObd.
  ///
  /// In en, this message translates to:
  /// **'OBD II'**
  String get navObd;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle'**
  String get homeEmptySubtitle;

  /// No description provided for @homeError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String homeError(Object error);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get dashboardComingSoon;

  /// No description provided for @vehicleDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleDetailTitle;

  /// No description provided for @vehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not found'**
  String get vehicleNotFound;

  /// No description provided for @plate.
  ///
  /// In en, this message translates to:
  /// **'Plate'**
  String get plate;

  /// No description provided for @vin.
  ///
  /// In en, this message translates to:
  /// **'VIN'**
  String get vin;

  /// No description provided for @brandModel.
  ///
  /// In en, this message translates to:
  /// **'Brand / Model'**
  String get brandModel;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @odometer.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get odometer;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @fuelLogs.
  ///
  /// In en, this message translates to:
  /// **'Fuel logs'**
  String get fuelLogs;

  /// No description provided for @maintenanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Maintenance history'**
  String get maintenanceHistory;

  /// No description provided for @configureIntervals.
  ///
  /// In en, this message translates to:
  /// **'Configure intervals'**
  String get configureIntervals;

  /// No description provided for @nextMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Next Maintenance'**
  String get nextMaintenance;

  /// No description provided for @allIntervalsDisabled.
  ///
  /// In en, this message translates to:
  /// **'All intervals are disabled.'**
  String get allIntervalsDisabled;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerService.
  ///
  /// In en, this message translates to:
  /// **'Register service'**
  String get registerService;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No description available. Go to Maintenance settings to add one.'**
  String get noDescriptionAvailable;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @overduePerformService.
  ///
  /// In en, this message translates to:
  /// **'Overdue — perform service'**
  String get overduePerformService;

  /// No description provided for @nextIn.
  ///
  /// In en, this message translates to:
  /// **'Next in {parts}'**
  String nextIn(Object parts);

  /// No description provided for @vehicleFormNew.
  ///
  /// In en, this message translates to:
  /// **'New vehicle'**
  String get vehicleFormNew;

  /// No description provided for @vehicleFormEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle'**
  String get vehicleFormEdit;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidYear.
  ///
  /// In en, this message translates to:
  /// **'Invalid year'**
  String get invalidYear;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get vehicleType;

  /// No description provided for @combustion.
  ///
  /// In en, this message translates to:
  /// **'Combustion'**
  String get combustion;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @plateOptional.
  ///
  /// In en, this message translates to:
  /// **'Plate (optional)'**
  String get plateOptional;

  /// No description provided for @vinOptional.
  ///
  /// In en, this message translates to:
  /// **'VIN (optional)'**
  String get vinOptional;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @aliasOptional.
  ///
  /// In en, this message translates to:
  /// **'Alias (optional)'**
  String get aliasOptional;

  /// No description provided for @aliasHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: My ride, The beast, etc.'**
  String get aliasHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @addVehicle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get addVehicle;

  /// No description provided for @deleteVehicle.
  ///
  /// In en, this message translates to:
  /// **'Delete vehicle'**
  String get deleteVehicle;

  /// No description provided for @deleteVehicleConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All fuel logs, maintenance records, and intervals associated will be deleted.'**
  String get deleteVehicleConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dataManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Export / Import data'**
  String get dataManagerTitle;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @saveExport.
  ///
  /// In en, this message translates to:
  /// **'Save export'**
  String get saveExport;

  /// No description provided for @exportedAt.
  ///
  /// In en, this message translates to:
  /// **'Exported at {path}'**
  String exportedAt(Object path);

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export error: {error}'**
  String exportError(Object error);

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get importData;

  /// No description provided for @importPreview.
  ///
  /// In en, this message translates to:
  /// **'Found:\n• {vehicles} vehicle(s)\n• {fuelLogs} fuel log(s)\n• {maintenanceLogs} maintenance log(s)\n• {documents} document(s)\n\nImport? Existing data with the same ID will be overwritten.'**
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  );

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error: {error}'**
  String importError(Object error);

  /// No description provided for @invalidJson.
  ///
  /// In en, this message translates to:
  /// **'Invalid JSON file'**
  String get invalidJson;

  /// No description provided for @exportShareText.
  ///
  /// In en, this message translates to:
  /// **'Karter Export — {count} vehicle(s)'**
  String exportShareText(Object count);

  /// No description provided for @maintenanceSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance intervals'**
  String get maintenanceSettingsTitle;

  /// No description provided for @maintenanceSettingsInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable items according to your vehicle\'s needs. Custom intervals can be deleted.'**
  String get maintenanceSettingsInstruction;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @timeMonths.
  ///
  /// In en, this message translates to:
  /// **'Time (months)'**
  String get timeMonths;

  /// No description provided for @partsTitle.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get partsTitle;

  /// No description provided for @partUnitUnit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get partUnitUnit;

  /// No description provided for @partUnitSet.
  ///
  /// In en, this message translates to:
  /// **'set'**
  String get partUnitSet;

  /// No description provided for @partUnitKit.
  ///
  /// In en, this message translates to:
  /// **'kit'**
  String get partUnitKit;

  /// No description provided for @partUnitCan.
  ///
  /// In en, this message translates to:
  /// **'can'**
  String get partUnitCan;

  /// No description provided for @templateFound.
  ///
  /// In en, this message translates to:
  /// **'Template found'**
  String get templateFound;

  /// No description provided for @noTemplate.
  ///
  /// In en, this message translates to:
  /// **'No template'**
  String get noTemplate;

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use template'**
  String get useTemplate;

  /// No description provided for @searchTemplate.
  ///
  /// In en, this message translates to:
  /// **'Search template'**
  String get searchTemplate;

  /// No description provided for @templateWithName.
  ///
  /// In en, this message translates to:
  /// **'Template: {name}'**
  String templateWithName(Object name);

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResultsTitle;

  /// No description provided for @noTemplateFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'No template found for the entered data.'**
  String get noTemplateFoundDescription;

  /// No description provided for @searchParameters.
  ///
  /// In en, this message translates to:
  /// **'Search parameters:'**
  String get searchParameters;

  /// No description provided for @defaultIntervalsHint.
  ///
  /// In en, this message translates to:
  /// **'The vehicle will use default intervals.'**
  String get defaultIntervalsHint;

  /// No description provided for @missingTemplateContribute.
  ///
  /// In en, this message translates to:
  /// **'Missing a template? Contribute at github.com/abrahdev/karter'**
  String get missingTemplateContribute;

  /// No description provided for @viewAllTemplates.
  ///
  /// In en, this message translates to:
  /// **'View all templates'**
  String get viewAllTemplates;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @contributeOnGitHub.
  ///
  /// In en, this message translates to:
  /// **'Contribute on GitHub'**
  String get contributeOnGitHub;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @templateUnderConstruction.
  ///
  /// In en, this message translates to:
  /// **'Template under construction'**
  String get templateUnderConstruction;

  /// No description provided for @templateNotReady.
  ///
  /// In en, this message translates to:
  /// **'This template is not ready yet.\nWe\'re working on it!'**
  String get templateNotReady;

  /// No description provided for @contributionsWelcome.
  ///
  /// In en, this message translates to:
  /// **'Contributions are welcome — add or fix templates for your vehicle:'**
  String get contributionsWelcome;

  /// No description provided for @requestedParam.
  ///
  /// In en, this message translates to:
  /// **'Requested: {params}'**
  String requestedParam(Object params);

  /// No description provided for @deleteIntervalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this interval?'**
  String get deleteIntervalConfirm;

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add part'**
  String get addPart;

  /// No description provided for @partName.
  ///
  /// In en, this message translates to:
  /// **'Part name'**
  String get partName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantity;

  /// No description provided for @oemNumber.
  ///
  /// In en, this message translates to:
  /// **'OEM number'**
  String get oemNumber;

  /// No description provided for @addLink.
  ///
  /// In en, this message translates to:
  /// **'Add link'**
  String get addLink;

  /// No description provided for @linkUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get linkUrl;

  /// No description provided for @openLink.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLink;

  /// No description provided for @noLinks.
  ///
  /// In en, this message translates to:
  /// **'No links'**
  String get noLinks;

  /// No description provided for @noParts.
  ///
  /// In en, this message translates to:
  /// **'No parts yet'**
  String get noParts;

  /// No description provided for @invalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalidUrl;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @linksTitle.
  ///
  /// In en, this message translates to:
  /// **'Reference links'**
  String get linksTitle;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @addModeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get addModeManual;

  /// No description provided for @addModeTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get addModeTemplate;

  /// No description provided for @newFromTemplate.
  ///
  /// In en, this message translates to:
  /// **'New from template'**
  String get newFromTemplate;

  /// No description provided for @updatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Updates available'**
  String get updatesAvailable;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @syncInstruction.
  ///
  /// In en, this message translates to:
  /// **'Sync maintenance intervals from your vehicle\'s template.'**
  String get syncInstruction;

  /// No description provided for @upToDate.
  ///
  /// In en, this message translates to:
  /// **'All up to date'**
  String get upToDate;

  /// No description provided for @syncAdded.
  ///
  /// In en, this message translates to:
  /// **'Interval added from template'**
  String get syncAdded;

  /// No description provided for @syncRestored.
  ///
  /// In en, this message translates to:
  /// **'Interval restored from template'**
  String get syncRestored;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @newInterval.
  ///
  /// In en, this message translates to:
  /// **'New interval'**
  String get newInterval;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Add to dashboard'**
  String get addToDashboard;

  /// No description provided for @setupNotifications.
  ///
  /// In en, this message translates to:
  /// **'Setup notifications'**
  String get setupNotifications;

  /// No description provided for @addToDashboardComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get addToDashboardComingSoon;

  /// No description provided for @deleteInterval.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteInterval;

  /// No description provided for @noDescriptionAvailableSettings.
  ///
  /// In en, this message translates to:
  /// **'No description available. Press \"Edit\" to add one.'**
  String get noDescriptionAvailableSettings;

  /// No description provided for @formattedKmK.
  ///
  /// In en, this message translates to:
  /// **'{km}k km'**
  String formattedKmK(Object km);

  /// No description provided for @formattedKm.
  ///
  /// In en, this message translates to:
  /// **'{km} km'**
  String formattedKm(Object km);

  /// No description provided for @intervalSubtitleKm.
  ///
  /// In en, this message translates to:
  /// **'every {km}'**
  String intervalSubtitleKm(Object km);

  /// No description provided for @intervalSubtitleMonths.
  ///
  /// In en, this message translates to:
  /// **'{months} months'**
  String intervalSubtitleMonths(Object months);

  /// No description provided for @maintenanceLogTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get maintenanceLogTitleEdit;

  /// No description provided for @maintenanceLogTitleNew.
  ///
  /// In en, this message translates to:
  /// **'New service'**
  String get maintenanceLogTitleNew;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String date(Object date);

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionRequired;

  /// No description provided for @odometerAtService.
  ///
  /// In en, this message translates to:
  /// **'Odometer at service (optional)'**
  String get odometerAtService;

  /// No description provided for @resetInterval.
  ///
  /// In en, this message translates to:
  /// **'Reset interval (optional)'**
  String get resetInterval;

  /// No description provided for @saveChangesShort.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChangesShort;

  /// No description provided for @saveService.
  ///
  /// In en, this message translates to:
  /// **'Save service'**
  String get saveService;

  /// No description provided for @saveFile.
  ///
  /// In en, this message translates to:
  /// **'Save file'**
  String get saveFile;

  /// No description provided for @lastService.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get lastService;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'photos'**
  String get photos;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'files'**
  String get files;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @deleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete service'**
  String get deleteService;

  /// No description provided for @deleteServiceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this service?'**
  String get deleteServiceConfirm;

  /// No description provided for @maintenanceListTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceListTitle;

  /// No description provided for @maintenanceEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services recorded'**
  String get maintenanceEmpty;

  /// No description provided for @maintenanceHistoryTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get maintenanceHistoryTab;

  /// No description provided for @maintenancePdfExportTab.
  ///
  /// In en, this message translates to:
  /// **'PDF Export'**
  String get maintenancePdfExportTab;

  /// No description provided for @maintenanceServicesInPeriod.
  ///
  /// In en, this message translates to:
  /// **'{count} service(s) in this period'**
  String maintenanceServicesInPeriod(Object count);

  /// No description provided for @maintenanceMoreServices.
  ///
  /// In en, this message translates to:
  /// **'... and {count} more'**
  String maintenanceMoreServices(Object count);

  /// No description provided for @maintenanceNoServicesInRange.
  ///
  /// In en, this message translates to:
  /// **'No services in this date range.'**
  String get maintenanceNoServicesInRange;

  /// No description provided for @maintenanceExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get maintenanceExportPdf;

  /// No description provided for @maintenanceSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get maintenanceSharePdf;

  /// No description provided for @maintenanceReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Report'**
  String get maintenanceReportTitle;

  /// No description provided for @maintenanceReportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated {date} {time}'**
  String maintenanceReportGenerated(Object date, Object time);

  /// No description provided for @maintenanceReportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No maintenance logs in this period.'**
  String get maintenanceReportEmpty;

  /// No description provided for @maintenanceReportDateHeader.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get maintenanceReportDateHeader;

  /// No description provided for @maintenanceReportDescHeader.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get maintenanceReportDescHeader;

  /// No description provided for @maintenanceReportOdometerHeader.
  ///
  /// In en, this message translates to:
  /// **'Odometer'**
  String get maintenanceReportOdometerHeader;

  /// No description provided for @addDocument.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get addDocument;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentType;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get selectFile;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @expiryDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Expiry date (optional)'**
  String get expiryDateOptional;

  /// No description provided for @pleaseSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Please select a file'**
  String get pleaseSelectFile;

  /// No description provided for @documentSaved.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSaved;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @browseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse files'**
  String get browseFiles;

  /// No description provided for @docTypeFine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get docTypeFine;

  /// No description provided for @docTypeParkingFee.
  ///
  /// In en, this message translates to:
  /// **'Parking fee'**
  String get docTypeParkingFee;

  /// No description provided for @docTypeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get docTypeInsurance;

  /// No description provided for @docTypeVehicleCheck.
  ///
  /// In en, this message translates to:
  /// **'Vehicle check'**
  String get docTypeVehicleCheck;

  /// No description provided for @docTypeTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get docTypeTax;

  /// No description provided for @docTypeComplexInsurance.
  ///
  /// In en, this message translates to:
  /// **'Complex insurance'**
  String get docTypeComplexInsurance;

  /// No description provided for @docTypeVehicleRegister.
  ///
  /// In en, this message translates to:
  /// **'Vehicle register'**
  String get docTypeVehicleRegister;

  /// No description provided for @docTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get docTypeOther;

  /// No description provided for @vehicleDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get vehicleDocuments;

  /// No description provided for @fuelFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New fuel-up'**
  String get fuelFormTitle;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @unitL.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitL;

  /// No description provided for @unitGal.
  ///
  /// In en, this message translates to:
  /// **'gal'**
  String get unitGal;

  /// No description provided for @unitKm.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get unitKm;

  /// No description provided for @unitMi.
  ///
  /// In en, this message translates to:
  /// **'mi'**
  String get unitMi;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per unit (optional)'**
  String get pricePerUnit;

  /// No description provided for @fullTank.
  ///
  /// In en, this message translates to:
  /// **'Full tank'**
  String get fullTank;

  /// No description provided for @volumeUnit.
  ///
  /// In en, this message translates to:
  /// **'Fuel volume unit'**
  String get volumeUnit;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost (optional)'**
  String get cost;

  /// No description provided for @saveFuelUp.
  ///
  /// In en, this message translates to:
  /// **'Save fuel-up'**
  String get saveFuelUp;

  /// No description provided for @fuelListTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel logs'**
  String get fuelListTitle;

  /// No description provided for @fuelEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fuel-ups recorded'**
  String get fuelEmpty;

  /// No description provided for @moreAbout.
  ///
  /// In en, this message translates to:
  /// **'About Karter'**
  String get moreAbout;

  /// No description provided for @moreDescription.
  ///
  /// In en, this message translates to:
  /// **'Karter is a local-first, open source vehicle maintenance app that respects your privacy.'**
  String get moreDescription;

  /// No description provided for @moreExport.
  ///
  /// In en, this message translates to:
  /// **'Export / Import data'**
  String get moreExport;

  /// No description provided for @moreExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Back up or transfer your information'**
  String get moreExportSubtitle;

  /// No description provided for @moreDocs.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get moreDocs;

  /// No description provided for @moreDocsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Usage guide and features'**
  String get moreDocsSubtitle;

  /// No description provided for @moreSource.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get moreSource;

  /// No description provided for @moreSourceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository'**
  String get moreSourceSubtitle;

  /// No description provided for @moreDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate'**
  String get moreDonate;

  /// No description provided for @moreDonateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support development on GitHub Sponsors'**
  String get moreDonateSubtitle;

  /// No description provided for @moreFooter.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by abrahdev'**
  String get moreFooter;

  /// No description provided for @moreRate.
  ///
  /// In en, this message translates to:
  /// **'Rate Karter'**
  String get moreRate;

  /// No description provided for @moreRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a review on the Play Store'**
  String get moreRateSubtitle;

  /// No description provided for @moreFeedback.
  ///
  /// In en, this message translates to:
  /// **'Rate the application'**
  String get moreFeedback;

  /// No description provided for @moreFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rate the app and configure reminders'**
  String get moreFeedbackSubtitle;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedbackTitle;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @sectionFeedbackCommunity.
  ///
  /// In en, this message translates to:
  /// **'Feedback & Community'**
  String get sectionFeedbackCommunity;

  /// No description provided for @sectionTips.
  ///
  /// In en, this message translates to:
  /// **'Tip program'**
  String get sectionTips;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About Karter'**
  String get sectionAbout;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get themeAutomatic;

  /// No description provided for @themeAutomaticDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device setting'**
  String get themeAutomaticDesc;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeSystemDesc.
  ///
  /// In en, this message translates to:
  /// **'Follow device setting'**
  String get themeSystemDesc;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Primary color'**
  String get colorScheme;

  /// No description provided for @colorCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get colorCustom;

  /// No description provided for @colorOfInterface.
  ///
  /// In en, this message translates to:
  /// **'Interface color'**
  String get colorOfInterface;

  /// No description provided for @colorOfInterfaceDesc.
  ///
  /// In en, this message translates to:
  /// **'Apply primary color to background surfaces'**
  String get colorOfInterfaceDesc;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom color'**
  String get customColor;

  /// No description provided for @customColorDesc.
  ///
  /// In en, this message translates to:
  /// **'Use a personal color instead of the system accent'**
  String get customColorDesc;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select a color'**
  String get selectColor;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on interactions'**
  String get hapticFeedbackDesc;

  /// No description provided for @hapticModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get hapticModeOff;

  /// No description provided for @hapticModeOffDesc.
  ///
  /// In en, this message translates to:
  /// **'No vibration on interactions'**
  String get hapticModeOffDesc;

  /// No description provided for @hapticModeClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get hapticModeClear;

  /// No description provided for @hapticModeClearDesc.
  ///
  /// In en, this message translates to:
  /// **'Single crisp tap per action'**
  String get hapticModeClearDesc;

  /// No description provided for @hapticModeRich.
  ///
  /// In en, this message translates to:
  /// **'Rich'**
  String get hapticModeRich;

  /// No description provided for @hapticModeRichDesc.
  ///
  /// In en, this message translates to:
  /// **'Layered vibrations with varying intensity'**
  String get hapticModeRichDesc;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get testNotification;

  /// No description provided for @testNotificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification to verify setup'**
  String get testNotificationDesc;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// No description provided for @notificationsPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsPermissionTitle;

  /// No description provided for @notificationsPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive odometer and maintenance reminders'**
  String get notificationsPermissionDesc;

  /// No description provided for @notificationsPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notificationsPermissionAllow;

  /// No description provided for @notificationsPermissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications blocked'**
  String get notificationsPermissionDeniedTitle;

  /// No description provided for @notificationsPermissionDeniedDesc.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was permanently denied. To enable it, go to Settings > Apps > Karter > Notifications and turn them on.'**
  String get notificationsPermissionDeniedDesc;

  /// No description provided for @notificationsPermissionDeniedStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Open device Settings'**
  String get notificationsPermissionDeniedStep1;

  /// No description provided for @notificationsPermissionDeniedStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Go to Apps > Karter'**
  String get notificationsPermissionDeniedStep2;

  /// No description provided for @notificationsPermissionDeniedStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Tap Notifications'**
  String get notificationsPermissionDeniedStep3;

  /// No description provided for @notificationsPermissionDeniedStep4.
  ///
  /// In en, this message translates to:
  /// **'4. Enable \"Show notifications\"'**
  String get notificationsPermissionDeniedStep4;

  /// No description provided for @notificationsPermissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get notificationsPermissionOpenSettings;

  /// No description provided for @shakeToOdometer.
  ///
  /// In en, this message translates to:
  /// **'Shake to update odometer'**
  String get shakeToOdometer;

  /// No description provided for @shakeToOdometerDesc.
  ///
  /// In en, this message translates to:
  /// **'Shake device to open odometer update on vehicle screen'**
  String get shakeToOdometerDesc;

  /// No description provided for @feedbackReminderToggle.
  ///
  /// In en, this message translates to:
  /// **'Rating reminder'**
  String get feedbackReminderToggle;

  /// No description provided for @feedbackReminderToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a reminder to rate the app after saving services'**
  String get feedbackReminderToggleSubtitle;

  /// No description provided for @feedbackServicesInterval.
  ///
  /// In en, this message translates to:
  /// **'Services before prompt'**
  String get feedbackServicesInterval;

  /// No description provided for @feedbackServicesIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'After {count} service(s)'**
  String feedbackServicesIntervalValue(Object count);

  /// No description provided for @feedbackServicesSuffix.
  ///
  /// In en, this message translates to:
  /// **'services'**
  String get feedbackServicesSuffix;

  /// No description provided for @feedbackRepeatDays.
  ///
  /// In en, this message translates to:
  /// **'Reminder interval'**
  String get feedbackRepeatDays;

  /// No description provided for @feedbackRepeatDaysValue.
  ///
  /// In en, this message translates to:
  /// **'Every {days} day(s)'**
  String feedbackRepeatDaysValue(Object days);

  /// No description provided for @feedbackRepeatDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get feedbackRepeatDaysSuffix;

  /// No description provided for @ratePromptMessage.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Karter? A review helps others discover the app!'**
  String get ratePromptMessage;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @moreUrlError.
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String moreUrlError(Object url);

  /// No description provided for @tipProgram.
  ///
  /// In en, this message translates to:
  /// **'Tip program'**
  String get tipProgram;

  /// No description provided for @tipProgramComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is under development and will be available soon.'**
  String get tipProgramComingSoon;

  /// No description provided for @tipBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get tipBadges;

  /// No description provided for @tipBadgesNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get tipBadgesNone;

  /// No description provided for @tipInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get tipInfo;

  /// No description provided for @tipInfoText.
  ///
  /// In en, this message translates to:
  /// **'The tip program is a way for users to show extra support and appreciation for the fast support, constant improvements, and continuous updates that Karter has offered.'**
  String get tipInfoText;

  /// No description provided for @tipOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time tip'**
  String get tipOneTime;

  /// No description provided for @tipRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring tip'**
  String get tipRecurring;

  /// No description provided for @tipBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get tipBronze;

  /// No description provided for @tipSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get tipSilver;

  /// No description provided for @tipGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get tipGold;

  /// No description provided for @tipBronzePrice.
  ///
  /// In en, this message translates to:
  /// **'Bronze tip'**
  String get tipBronzePrice;

  /// No description provided for @tipSilverPrice.
  ///
  /// In en, this message translates to:
  /// **'Silver tip'**
  String get tipSilverPrice;

  /// No description provided for @tipGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'Gold tip'**
  String get tipGoldPrice;

  /// No description provided for @tipBronzeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Bronze / month'**
  String get tipBronzeMonthly;

  /// No description provided for @tipSilverMonthly.
  ///
  /// In en, this message translates to:
  /// **'Silver / month'**
  String get tipSilverMonthly;

  /// No description provided for @tipGoldMonthly.
  ///
  /// In en, this message translates to:
  /// **'Gold / month'**
  String get tipGoldMonthly;

  /// No description provided for @officialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Official website'**
  String get officialWebsite;

  /// No description provided for @communityForums.
  ///
  /// In en, this message translates to:
  /// **'Community forums'**
  String get communityForums;

  /// No description provided for @translations.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get translations;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our privacy policy online.'**
  String get privacyPolicyDesc;

  /// No description provided for @openPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Open privacy policy'**
  String get openPrivacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// No description provided for @changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get openSourceLicenses;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @eesti.
  ///
  /// In en, this message translates to:
  /// **'Eesti'**
  String get eesti;

  /// No description provided for @odometerUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update odometer'**
  String get odometerUpdateTitle;

  /// No description provided for @odometerLastReading.
  ///
  /// In en, this message translates to:
  /// **'Last: {value} {unit}'**
  String odometerLastReading(Object unit, Object value);

  /// No description provided for @odometerLowerWarning.
  ///
  /// In en, this message translates to:
  /// **'The value is lower than the last record ({value} {unit}).'**
  String odometerLowerWarning(Object unit, Object value);

  /// No description provided for @odometerDeltaWarning.
  ///
  /// In en, this message translates to:
  /// **'You drove {delta} {unit} since last time. Is this correct?'**
  String odometerDeltaWarning(Object delta, Object unit);

  /// No description provided for @odometerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get odometerSave;

  /// No description provided for @odometerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get odometerCancel;

  /// No description provided for @moreNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get moreNotifications;

  /// No description provided for @moreNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Odometer and maintenance reminders'**
  String get moreNotificationsSubtitle;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure reminders for this vehicle'**
  String get notificationSettingsSubtitle;

  /// No description provided for @notificationOdometerSection.
  ///
  /// In en, this message translates to:
  /// **'Odometer reminder'**
  String get notificationOdometerSection;

  /// No description provided for @notificationMaintenanceSection.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminder'**
  String get notificationMaintenanceSection;

  /// No description provided for @notificationFreqLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder frequency'**
  String get notificationFreqLabel;

  /// No description provided for @notificationFreqOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notificationFreqOff;

  /// No description provided for @notificationFreqValue.
  ///
  /// In en, this message translates to:
  /// **'Every {days} days'**
  String notificationFreqValue(Object days);

  /// No description provided for @notificationMaintenanceToggle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance reminders'**
  String get notificationMaintenanceToggle;

  /// No description provided for @notificationMaintenanceToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive daily reminders about pending maintenance'**
  String get notificationMaintenanceToggleSubtitle;

  /// No description provided for @notificationSnoozedBanner.
  ///
  /// In en, this message translates to:
  /// **'Snoozed for {days} more day(s)'**
  String notificationSnoozedBanner(Object days);

  /// No description provided for @notificationSnoozeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel snooze'**
  String get notificationSnoozeCancel;

  /// No description provided for @notificationNoVehicles.
  ///
  /// In en, this message translates to:
  /// **'Add a vehicle to configure notifications'**
  String get notificationNoVehicles;

  /// No description provided for @notificationVehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Odometer: {freq} • Maintenance: {maint}'**
  String notificationVehicleSubtitle(Object freq, Object maint);

  /// No description provided for @notificationConfigure.
  ///
  /// In en, this message translates to:
  /// **'Configure'**
  String get notificationConfigure;

  /// No description provided for @notificationMaintOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get notificationMaintOn;

  /// No description provided for @notificationMaintOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notificationMaintOff;

  /// No description provided for @notificationSnoozeAction.
  ///
  /// In en, this message translates to:
  /// **'Snooze for 1 week'**
  String get notificationSnoozeAction;

  /// No description provided for @notificationSnoozeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Snoozed until {date}'**
  String notificationSnoozeConfirm(Object date);

  /// No description provided for @notificationFreqWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every 7 days'**
  String get notificationFreqWeekly;

  /// No description provided for @notificationFreqMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every 30 days'**
  String get notificationFreqMonthly;

  /// No description provided for @notificationFreqCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get notificationFreqCustom;

  /// No description provided for @notificationFreqDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String notificationFreqDays(Object days);

  /// No description provided for @notificationMaintenanceSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze maintenance for 1 week'**
  String get notificationMaintenanceSnooze;

  /// No description provided for @notificationSnoozeToggle.
  ///
  /// In en, this message translates to:
  /// **'Snooze reminders'**
  String get notificationSnoozeToggle;

  /// No description provided for @notificationSnoozeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String notificationSnoozeDays(Object days);

  /// Title for unsaved changes dialog
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// Confirmation message for discarding unsaved changes
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get discardChangesConfirm;

  /// Discard / discard changes button label
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @moreTemplateSource.
  ///
  /// In en, this message translates to:
  /// **'Template source'**
  String get moreTemplateSource;

  /// No description provided for @moreTemplateSourceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fetch templates from GitHub or use local assets'**
  String get moreTemplateSourceSubtitle;

  /// No description provided for @moreTemplateSourceOffline.
  ///
  /// In en, this message translates to:
  /// **'Local (offline)'**
  String get moreTemplateSourceOffline;

  /// No description provided for @moreTemplateSourceOnline.
  ///
  /// In en, this message translates to:
  /// **'Online (GitHub)'**
  String get moreTemplateSourceOnline;

  /// No description provided for @moreTemplateSourceUrl.
  ///
  /// In en, this message translates to:
  /// **'Repo URL'**
  String get moreTemplateSourceUrl;

  /// No description provided for @moreTemplateSourceReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get moreTemplateSourceReset;

  /// No description provided for @moreTemplateSourceUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://raw.githubusercontent.com/...'**
  String get moreTemplateSourceUrlHint;

  /// No description provided for @moreTemplateSourceEditUrl.
  ///
  /// In en, this message translates to:
  /// **'Edit URL'**
  String get moreTemplateSourceEditUrl;

  /// No description provided for @moreTemplateSourceUrlSaved.
  ///
  /// In en, this message translates to:
  /// **'URL updated'**
  String get moreTemplateSourceUrlSaved;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingDone;

  /// No description provided for @onboardingReplay.
  ///
  /// In en, this message translates to:
  /// **'View onboarding'**
  String get onboardingReplay;

  /// No description provided for @onboardingReplaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Replay the welcome walkthrough'**
  String get onboardingReplaySubtitle;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Karter'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'A privacy-first, open source vehicle maintenance tracker. 100% offline — no accounts, no telemetry, no tracking.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingVehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your vehicle'**
  String get onboardingVehicleTitle;

  /// No description provided for @onboardingVehicleDesc.
  ///
  /// In en, this message translates to:
  /// **'Register your car, motorcycle, or EV. Pick a template and Karter auto-fills the maintenance intervals for your model.'**
  String get onboardingVehicleDesc;

  /// No description provided for @onboardingTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track fuel & maintenance'**
  String get onboardingTrackTitle;

  /// No description provided for @onboardingTrackDesc.
  ///
  /// In en, this message translates to:
  /// **'Log fill-ups with automatic economy calculations (MPG, L/100km, km/L). Track repairs, parts, and costs.'**
  String get onboardingTrackDesc;

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of service'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when it\'s time for oil changes, brake pads, and every maintenance interval — by distance or time.'**
  String get onboardingRemindersDesc;

  /// No description provided for @supporterBadge.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Karter supporter!'**
  String get supporterBadge;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// No description provided for @tipPurchased.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get tipPurchased;

  /// No description provided for @tipSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get tipSupport;

  /// No description provided for @sectionBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get sectionBackup;

  /// No description provided for @moreBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get moreBackup;

  /// No description provided for @moreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Encrypted backup'**
  String get moreBackupSubtitle;

  /// No description provided for @backupConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Drive'**
  String get backupConnect;

  /// No description provided for @backupConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected as {email}'**
  String backupConnected(Object email);

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @backupInProgress.
  ///
  /// In en, this message translates to:
  /// **'Backing up…'**
  String get backupInProgress;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String backupLast(Object date);

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'Never backed up'**
  String get backupNever;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestore;

  /// No description provided for @backupRestoreInProgress.
  ///
  /// In en, this message translates to:
  /// **'Restoring…'**
  String get backupRestoreInProgress;

  /// No description provided for @backupRestoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will overwrite all current data. Are you sure?'**
  String get backupRestoreConfirm;

  /// No description provided for @backupError.
  ///
  /// In en, this message translates to:
  /// **'Backup error: {error}'**
  String backupError(Object error);

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded successfully'**
  String get backupSuccess;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restored. Restart the app to see changes.'**
  String get backupRestoreSuccess;

  /// No description provided for @backupDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get backupDisconnect;

  /// No description provided for @backupNoBackups.
  ///
  /// In en, this message translates to:
  /// **'No backups found'**
  String get backupNoBackups;

  /// No description provided for @backupRestoreBtn.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreBtn;

  /// No description provided for @backupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get backupDelete;

  /// No description provided for @backupDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete backup {name}?'**
  String backupDeleteConfirm(Object name);

  /// No description provided for @backupDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup deleted'**
  String get backupDeleteSuccess;

  /// No description provided for @backupCount.
  ///
  /// In en, this message translates to:
  /// **'Backups: {current}/{max}'**
  String backupCount(Object current, Object max);

  /// No description provided for @dtcLookupTitle.
  ///
  /// In en, this message translates to:
  /// **'Fault code lookup'**
  String get dtcLookupTitle;

  /// No description provided for @dtcSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a code, e.g. P0171'**
  String get dtcSearchHint;

  /// No description provided for @dtcEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Type a code to look up its description'**
  String get dtcEmptyState;

  /// No description provided for @dtcNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No codes match your search'**
  String get dtcNoMatch;

  /// No description provided for @dtcDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get dtcDescription;

  /// No description provided for @dtcRelatedMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Related maintenance'**
  String get dtcRelatedMaintenance;

  /// No description provided for @dtcScopeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get dtcScopeStandard;

  /// No description provided for @dtcScopeManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get dtcScopeManufacturer;

  /// No description provided for @dtcGeneralDb.
  ///
  /// In en, this message translates to:
  /// **'General OBD-II codes'**
  String get dtcGeneralDb;

  /// No description provided for @dtcVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get dtcVehicle;

  /// No description provided for @dtcVehicleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Vehicle not found'**
  String get dtcVehicleNotFound;

  /// No description provided for @dtcLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load fault codes'**
  String get dtcLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'et'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'et':
      return AppLocalizationsEt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
