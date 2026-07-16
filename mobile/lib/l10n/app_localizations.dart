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

  /// No description provided for @moreUrlError.
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String moreUrlError(Object url);

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
