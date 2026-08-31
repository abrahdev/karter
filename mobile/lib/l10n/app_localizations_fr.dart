// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navVehicles => 'Véhicules';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Plus';

  @override
  String get homeEmptyTitle => 'Aucun véhicule';

  @override
  String get homeEmptySubtitle => 'Ajoute ton premier véhicule';

  @override
  String homeError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get dashboardComingSoon => 'Bientôt disponible';

  @override
  String get vehicleDetailTitle => 'Véhicule';

  @override
  String get vehicleNotFound => 'Véhicule introuvable';

  @override
  String get plate => 'Plaque';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Marque / Modèle';

  @override
  String get year => 'Année';

  @override
  String get odometer => 'Compteur';

  @override
  String get update => 'Mettre à jour';

  @override
  String get actions => 'Actions';

  @override
  String get tools => 'Outils';

  @override
  String get information => 'Informations';

  @override
  String get fuelLogs => 'Pleins de carburant';

  @override
  String get maintenanceHistory => 'Historique d\'entretien';

  @override
  String get configureIntervals => 'Configurer les intervalles';

  @override
  String get nextMaintenance => 'Prochain entretien';

  @override
  String get allIntervalsDisabled => 'Tous les intervalles sont désactivés.';

  @override
  String get register => 'Enregistrer';

  @override
  String get registerService => 'Enregistrer un entretien';

  @override
  String get noDescriptionAvailable =>
      'Aucune description disponible. Va dans les paramètres d\'entretien pour en ajouter une.';

  @override
  String get close => 'Fermer';

  @override
  String get retry => 'Réessayer';

  @override
  String get overduePerformService => 'En retard — effectuer l\'entretien';

  @override
  String nextIn(Object parts) {
    return 'Prochain dans $parts';
  }

  @override
  String get vehicleFormNew => 'Nouveau véhicule';

  @override
  String get vehicleFormEdit => 'Modifier le véhicule';

  @override
  String get vehicleFormDetails => 'Détails';

  @override
  String get vehicleFormVehicle => 'Véhicule';

  @override
  String get brand => 'Marque';

  @override
  String get model => 'Modèle';

  @override
  String get required => 'Obligatoire';

  @override
  String get invalidYear => 'Année invalide';

  @override
  String get vehicleType => 'Type de véhicule';

  @override
  String get combustion => 'Thermique';

  @override
  String get electric => 'Électrique';

  @override
  String get motorcycle => 'Moto';

  @override
  String get plateOptional => 'Plaque (facultatif)';

  @override
  String get vinOptional => 'VIN (facultatif)';

  @override
  String get invalid => 'Invalide';

  @override
  String get aliasOptional => 'Surnom (facultatif)';

  @override
  String get aliasHint => 'Ex. : Ma voiture, La bête, etc.';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get addVehicle => 'Ajouter un véhicule';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Les entretiens apparaissent comme en retard';

  @override
  String get newVehicleServicesOverdueBody =>
      'Comme ton véhicule a déjà plus de 500 km, tous les entretiens apparaissent comme en retard.\n\nEnregistre les entretiens déjà effectués. Si tu ne te souviens pas du kilométrage exact, définis une valeur approximative en km pour le dernier entretien.';

  @override
  String get deleteVehicle => 'Supprimer le véhicule';

  @override
  String get deleteVehicleConfirm =>
      'Cette action est irréversible. Tous les pleins de carburant, les enregistrements d\'entretien et les intervalles associés seront supprimés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get resetToDefault => 'Rétablir les valeurs par défaut';

  @override
  String get delete => 'Supprimer';

  @override
  String get dataManagerTitle => 'Exporter / Importer des données';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get exporting => 'Export en cours…';

  @override
  String get export => 'Exporter';

  @override
  String get importing => 'Import en cours…';

  @override
  String get import => 'Importer';

  @override
  String get saveExport => 'Enregistrer l\'export';

  @override
  String exportedAt(Object path) {
    return 'Exporté à l\'emplacement $path';
  }

  @override
  String exportError(Object error) {
    return 'Erreur d\'export : $error';
  }

  @override
  String get importData => 'Importer des données';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Trouvé :\n• $vehicles véhicule(s)\n• $fuelLogs plein(s) de carburant\n• $maintenanceLogs entretien(s)\n• $documents document(s)\n\nImporter ? Les données existantes portant le même ID seront écrasées.';
  }

  @override
  String get importSuccess => 'Données importées avec succès';

  @override
  String importError(Object error) {
    return 'Erreur d\'import : $error';
  }

  @override
  String get invalidJson => 'Fichier JSON invalide';

  @override
  String exportShareText(Object count) {
    return 'Export Karter — $count véhicule(s)';
  }

  @override
  String get maintenanceSettingsTitle => 'Intervalles d\'entretien';

  @override
  String get maintenanceSettingsInstruction =>
      'Active ou désactive les éléments selon les besoins de ton véhicule. Les intervalles personnalisés peuvent être supprimés.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Temps (mois)';

  @override
  String get partsTitle => 'Pièces';

  @override
  String get partUnitUnit => 'unité';

  @override
  String get partUnitSet => 'jeu';

  @override
  String get partUnitKit => 'kit';

  @override
  String get partUnitCan => 'bidon';

  @override
  String get partUnitLabel => 'Unité';

  @override
  String get localParts => 'Pièces locales';

  @override
  String get intervalParts => 'Pièces de l\'intervalle';

  @override
  String get newPart => 'Nouvelle pièce';

  @override
  String get createPart => 'Créer la pièce';

  @override
  String get partsSection => 'Pièces';

  @override
  String get usedParts => 'Pièces';

  @override
  String usedInServicesCount(Object count) {
    return '$count entretien(s)';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Cette pièce est utilisée dans $count entretien(s). La supprimer quand même ?';
  }

  @override
  String get reportPartsHeader => 'Pièces';

  @override
  String get templateFound => 'Modèle trouvé';

  @override
  String get templateDisclaimer =>
      'Les données du modèle sont fournies à titre indicatif. Vérifie toujours les intervalles dans le manuel de ton véhicule.';

  @override
  String get noTemplate => 'Aucun modèle';

  @override
  String get useTemplate => 'Utiliser le modèle';

  @override
  String get searchTemplate => 'Rechercher un modèle';

  @override
  String templateWithName(Object name) {
    return 'Modèle : $name';
  }

  @override
  String get noResultsTitle => 'Aucun résultat';

  @override
  String get noTemplateFoundDescription =>
      'Aucun modèle trouvé pour les données saisies.';

  @override
  String get searchParameters => 'Paramètres de recherche :';

  @override
  String get defaultIntervalsHint =>
      'Le véhicule utilisera les intervalles par défaut.';

  @override
  String get missingTemplateContribute =>
      'Il manque un modèle ? Contribue sur github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Voir tous les modèles';

  @override
  String get contribute => 'Contribuer';

  @override
  String get contributeOnGitHub => 'Contribuer sur GitHub';

  @override
  String get gotIt => 'Compris';

  @override
  String get templateUnderConstruction => 'Modèle en cours de construction';

  @override
  String get templateNotReady =>
      'Ce modèle n\'est pas encore prêt.\nNous y travaillons !';

  @override
  String get contributionsWelcome =>
      'Les contributions sont les bienvenues — ajoute ou corrige des modèles pour ton véhicule :';

  @override
  String requestedParam(Object params) {
    return 'Demandé : $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Voulez-vous vraiment supprimer cet intervalle ?';

  @override
  String get addPart => 'Ajouter une pièce';

  @override
  String get partName => 'Nom de la pièce';

  @override
  String get quantity => 'Qté';

  @override
  String get oemNumber => 'Référence OEM';

  @override
  String get addLink => 'Ajouter un lien';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Ouvrir';

  @override
  String get noLinks => 'Aucun lien';

  @override
  String get noParts => 'Aucune pièce pour l\'instant';

  @override
  String get invalidUrl => 'URL invalide';

  @override
  String get copied => 'Copié';

  @override
  String get linksTitle => 'Liens de référence';

  @override
  String get copy => 'Copier';

  @override
  String get addModeManual => 'Manuel';

  @override
  String get addModeTemplate => 'Modèle';

  @override
  String get newFromTemplate => 'Nouveau depuis un modèle';

  @override
  String get updatesAvailable => 'Des mises à jour sont disponibles';

  @override
  String get restore => 'Restaurer';

  @override
  String get windowMinimize => 'Réduire';

  @override
  String get windowMaximize => 'Agrandir';

  @override
  String get windowClose => 'Fermer';

  @override
  String get syncInstruction =>
      'Synchronise les intervalles d\'entretien depuis le modèle de ton véhicule.';

  @override
  String get upToDate => 'Tout est à jour';

  @override
  String get syncAdded => 'Intervalle ajouté depuis le modèle';

  @override
  String get syncRestored => 'Intervalle restauré depuis le modèle';

  @override
  String get months => 'mois';

  @override
  String get description => 'Description';

  @override
  String get newInterval => 'Nouvel intervalle';

  @override
  String get name => 'Nom';

  @override
  String get add => 'Ajouter';

  @override
  String get edit => 'Modifier';

  @override
  String get addToDashboard => 'Ajouter au tableau de bord';

  @override
  String get setupNotifications => 'Configurer les notifications';

  @override
  String get addToDashboardComingSoon => 'Bientôt disponible';

  @override
  String get deleteInterval => 'Supprimer';

  @override
  String get noDescriptionAvailableSettings =>
      'Aucune description disponible. Appuie sur « Modifier » pour en ajouter une.';

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
    return 'tous les $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months mois';
  }

  @override
  String get maintenanceLogTitleEdit => 'Modifier l\'entretien';

  @override
  String get maintenanceLogTitleNew => 'Nouvel entretien';

  @override
  String date(Object date) {
    return 'Date : $date';
  }

  @override
  String get descriptionRequired => 'Description';

  @override
  String get odometerAtService => 'Compteur lors de l\'entretien (facultatif)';

  @override
  String get resetInterval => 'Réinitialiser l\'intervalle (facultatif)';

  @override
  String get saveChangesShort => 'Enregistrer les modifications';

  @override
  String get saveService => 'Enregistrer l\'entretien';

  @override
  String get saveFile => 'Enregistrer le fichier';

  @override
  String get lastService => 'Dernier';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get photos => 'photos';

  @override
  String get files => 'fichiers';

  @override
  String get share => 'Partager';

  @override
  String get deleteService => 'Supprimer l\'entretien';

  @override
  String get deleteServiceConfirm =>
      'Voulez-vous vraiment supprimer cet entretien ?';

  @override
  String get maintenanceListTitle => 'Entretien';

  @override
  String get maintenanceEmpty => 'Aucun entretien enregistré';

  @override
  String get maintenanceHistoryTab => 'Historique';

  @override
  String get maintenancePdfExportTab => 'Export PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count entretien(s) sur cette période';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... et $count de plus';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Aucun entretien sur cette période.';

  @override
  String get maintenanceExportPdf => 'Exporter en PDF';

  @override
  String get maintenanceSharePdf => 'Partager';

  @override
  String get maintenanceReportTitle => 'Rapport d\'entretien';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Généré le $date à $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'Aucun enregistrement d\'entretien sur cette période.';

  @override
  String get maintenanceReportDateHeader => 'Date';

  @override
  String get maintenanceReportDescHeader => 'Description';

  @override
  String get maintenanceReportOdometerHeader => 'Compteur';

  @override
  String get addDocument => 'Ajouter un document';

  @override
  String get documentType => 'Type de document';

  @override
  String get selectFile => 'Sélectionner un fichier';

  @override
  String get noFileSelected => 'Aucun fichier sélectionné';

  @override
  String get notesOptional => 'Notes (facultatif)';

  @override
  String get expiryDateOptional => 'Date d\'expiration (facultatif)';

  @override
  String get pleaseSelectFile => 'Veuillez sélectionner un fichier';

  @override
  String get documentSaved => 'Document enregistré';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get chooseFromGallery => 'Choisir depuis la galerie';

  @override
  String get browseFiles => 'Parcourir les fichiers';

  @override
  String get docTypeFine => 'Amende';

  @override
  String get docTypeParkingFee => 'Frais de stationnement';

  @override
  String get docTypeInsurance => 'Assurance';

  @override
  String get docTypeVehicleCheck => 'Contrôle technique';

  @override
  String get docTypeTax => 'Taxe';

  @override
  String get docTypeComplexInsurance => 'Assurance tous risques';

  @override
  String get docTypeVehicleRegister => 'Carte grise';

  @override
  String get docTypeOther => 'Autre';

  @override
  String get vehicleDocuments => 'Documents';

  @override
  String get fuelFormTitle => 'Nouveau plein';

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
  String get pricePerUnit => 'Prix par unité (facultatif)';

  @override
  String get fullTank => 'Plein complet';

  @override
  String get volumeUnit => 'Unité de volume de carburant';

  @override
  String get currency => 'Devise';

  @override
  String get cost => 'Coût (facultatif)';

  @override
  String get saveFuelUp => 'Enregistrer le plein';

  @override
  String get fuelListTitle => 'Pleins de carburant';

  @override
  String get fuelEmpty => 'Aucun plein enregistré';

  @override
  String get moreAbout => 'À propos de Karter';

  @override
  String get moreDescription =>
      'Karter est une application d\'entretien de véhicules open source et locale d\'abord qui respecte ta vie privée.';

  @override
  String get moreExport => 'Exporter / Importer des données';

  @override
  String get moreExportSubtitle => 'Sauvegarde ou transfère tes informations';

  @override
  String get moreDocs => 'Documentation';

  @override
  String get moreDocsSubtitle => 'Guide d\'utilisation et fonctionnalités';

  @override
  String get moreSource => 'Code source';

  @override
  String get moreSourceSubtitle => 'Dépôt GitHub';

  @override
  String get moreDonate => 'Faire un don';

  @override
  String get moreDonateSubtitle =>
      'Soutiens le développement sur GitHub Sponsors';

  @override
  String get moreFooter => 'Fait avec ❤️ par abrahdev';

  @override
  String get moreRate => 'Noter Karter';

  @override
  String get moreRateSubtitle => 'Laisse un avis sur le Play Store';

  @override
  String get moreFeedback => 'Noter l\'application';

  @override
  String get moreFeedbackSubtitle =>
      'Note l\'application et configure les rappels';

  @override
  String get feedbackTitle => 'Commentaires';

  @override
  String get sectionPreferences => 'Préférences';

  @override
  String get sectionData => 'Données';

  @override
  String get sectionFeedbackCommunity => 'Commentaires & Communauté';

  @override
  String get sectionTips => 'Programme de pourboires';

  @override
  String get sectionAbout => 'À propos de Karter';

  @override
  String get theme => 'Thème';

  @override
  String get themeAutomatic => 'Automatique';

  @override
  String get themeAutomaticDesc => 'Suivre le réglage de l\'appareil';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeSystemDesc => 'Suivre le réglage de l\'appareil';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get colorScheme => 'Couleur principale';

  @override
  String get colorCustom => 'Personnalisée';

  @override
  String get colorOfInterface => 'Couleur de l\'interface';

  @override
  String get colorOfInterfaceDesc =>
      'Appliquer la couleur principale aux surfaces d\'arrière-plan';

  @override
  String get customColor => 'Couleur personnalisée';

  @override
  String get customColorDesc =>
      'Utilise une couleur personnelle à la place de l\'accent système';

  @override
  String get selectColor => 'Choisir une couleur';

  @override
  String get hapticFeedback => 'Retour haptique';

  @override
  String get hapticFeedbackDesc => 'Vibrer lors des interactions';

  @override
  String get hapticModeOff => 'Désactivé';

  @override
  String get hapticModeOffDesc => 'Aucune vibration lors des interactions';

  @override
  String get hapticModeClear => 'Net';

  @override
  String get hapticModeClearDesc => 'Une seule vibration nette par action';

  @override
  String get hapticModeRich => 'Riche';

  @override
  String get hapticModeRichDesc =>
      'Vibrations en couches avec une intensité variable';

  @override
  String get testNotification => 'Notification de test';

  @override
  String get testNotificationDesc =>
      'Envoie une notification de test pour vérifier la configuration';

  @override
  String get testNotificationSent => 'Notification de test envoyée';

  @override
  String get notificationsPermissionTitle => 'Notifications désactivées';

  @override
  String get notificationsPermissionDesc =>
      'Active les notifications pour recevoir des rappels de compteur et d\'entretien';

  @override
  String get notificationsPermissionAllow => 'Autoriser les notifications';

  @override
  String get notificationsPermissionDeniedTitle => 'Notifications bloquées';

  @override
  String get notificationsPermissionDeniedDesc =>
      'L\'autorisation de notification a été refusée de façon permanente. Pour l\'activer, va dans Paramètres > Applications > Karter > Notifications et active-les.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Ouvre les Paramètres de l\'appareil';

  @override
  String get notificationsPermissionDeniedStep2 =>
      '2. Va dans Applications > Karter';

  @override
  String get notificationsPermissionDeniedStep3 =>
      '3. Appuie sur Notifications';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Active « Afficher les notifications »';

  @override
  String get notificationsPermissionOpenSettings => 'Ouvrir les Paramètres';

  @override
  String get shakeToOdometer => 'Secouer pour mettre à jour le compteur';

  @override
  String get shakeToOdometerDesc =>
      'Secoue l\'appareil pour ouvrir la mise à jour du compteur sur l\'écran du véhicule';

  @override
  String get feedbackReminderToggle => 'Rappel de notation';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Affiche un rappel pour noter l\'application après l\'enregistrement d\'entretiens';

  @override
  String get feedbackServicesInterval => 'Entretiens avant la demande';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Après $count entretien(s)';
  }

  @override
  String get feedbackServicesSuffix => 'entretiens';

  @override
  String get feedbackRepeatDays => 'Intervalle des rappels';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Tous les $days jour(s)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'jours';

  @override
  String get ratePromptMessage =>
      'Tu apprécies Karter ? Un avis aide d\'autres personnes à découvrir l\'application !';

  @override
  String get rate => 'Noter';

  @override
  String moreUrlError(Object url) {
    return 'Impossible d\'ouvrir $url';
  }

  @override
  String get tipProgram => 'Programme de pourboires';

  @override
  String get tipProgramComingSoon =>
      'Cette fonctionnalité est en cours de développement et sera bientôt disponible.';

  @override
  String get tipBadges => 'Badges';

  @override
  String get tipBadgesNone => 'Aucun';

  @override
  String get tipInfo => 'Informations';

  @override
  String get tipInfoText =>
      'Le programme de pourboires est un moyen pour les utilisateurs de montrer un soutien et une reconnaissance supplémentaires pour le support rapide, les améliorations constantes et les mises à jour continues proposés par Karter.';

  @override
  String get tipOneTime => 'Pourboire unique';

  @override
  String get tipRecurring => 'Pourboire récurrent';

  @override
  String get tipBronze => 'Bronze';

  @override
  String get tipSilver => 'Argent';

  @override
  String get tipGold => 'Or';

  @override
  String get tipBronzePrice => 'Pourboire Bronze';

  @override
  String get tipSilverPrice => 'Pourboire Argent';

  @override
  String get tipGoldPrice => 'Pourboire Or';

  @override
  String get tipBronzeMonthly => 'Bronze / mois';

  @override
  String get tipSilverMonthly => 'Argent / mois';

  @override
  String get tipGoldMonthly => 'Or / mois';

  @override
  String get officialWebsite => 'Site web officiel';

  @override
  String get communityForums => 'Forums de la communauté';

  @override
  String get translations => 'Traductions';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyDesc =>
      'Lisez notre politique de confidentialité en ligne.';

  @override
  String get openPrivacyPolicy => 'Ouvrir la politique de confidentialité';

  @override
  String get version => 'Version';

  @override
  String get deviceId => 'ID de l\'appareil';

  @override
  String get changelog => 'Journal des modifications';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get eesti => 'Eesti';

  @override
  String get odometerUpdateTitle => 'Mettre à jour le compteur';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Dernier : $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'La valeur est inférieure au dernier relevé ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Tu as parcouru $delta $unit depuis la dernière fois. Est-ce correct ?';
  }

  @override
  String get odometerSave => 'Enregistrer';

  @override
  String get odometerCancel => 'Annuler';

  @override
  String get moreNotifications => 'Notifications';

  @override
  String get moreNotificationsSubtitle => 'Rappels de compteur et d\'entretien';

  @override
  String get notificationSettingsTitle => 'Paramètres de notification';

  @override
  String get notificationSettingsSubtitle =>
      'Configure les rappels pour ce véhicule';

  @override
  String get notificationOdometerSection => 'Rappel de compteur';

  @override
  String get notificationMaintenanceSection => 'Rappel d\'entretien';

  @override
  String get notificationFreqLabel => 'Fréquence des rappels';

  @override
  String get notificationFreqOff => 'Désactivé';

  @override
  String notificationFreqValue(Object days) {
    return 'Tous les $days jours';
  }

  @override
  String get notificationMaintenanceToggle => 'Rappels d\'entretien';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Reçois des rappels quotidiens sur les entretiens en attente';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Reporté pour $days jour(s) supplémentaire(s)';
  }

  @override
  String get notificationSnoozeCancel => 'Annuler le report';

  @override
  String get notificationNoVehicles =>
      'Ajoute un véhicule pour configurer les notifications';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Compteur : $freq • Entretien : $maint';
  }

  @override
  String get notificationConfigure => 'Configurer';

  @override
  String get notificationMaintOn => 'Activé';

  @override
  String get notificationMaintOff => 'Désactivé';

  @override
  String get notificationSnoozeAction => 'Reporter d\'une semaine';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Reporté jusqu\'au $date';
  }

  @override
  String get notificationFreqWeekly => 'Tous les 7 jours';

  @override
  String get notificationFreqMonthly => 'Tous les 30 jours';

  @override
  String get notificationFreqCustom => 'Personnalisé';

  @override
  String notificationFreqDays(Object days) {
    return '$days jours';
  }

  @override
  String get notificationMaintenanceSnooze =>
      'Reporter l\'entretien d\'une semaine';

  @override
  String get notificationSnoozeToggle => 'Reporter les rappels';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days jours';
  }

  @override
  String get unsavedChanges => 'Modifications non enregistrées';

  @override
  String get discardChangesConfirm =>
      'Tu as des modifications non enregistrées. Voulez-vous vraiment quitter ?';

  @override
  String get discard => 'Abandonner';

  @override
  String get moreTemplateSource => 'Source des modèles';

  @override
  String get moreTemplateSourceSubtitle =>
      'Récupérer les modèles depuis GitHub ou utiliser les ressources locales';

  @override
  String get moreTemplateSourceOffline => 'Local (hors ligne)';

  @override
  String get moreTemplateSourceOnline => 'En ligne (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL du dépôt';

  @override
  String get moreTemplateSourceReset => 'Rétablir les valeurs par défaut';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Modifier l\'URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL mise à jour';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Dernière modification : $date';
  }

  @override
  String get importCheckTranslations => 'Traductions';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found sur $total disponibles';
  }

  @override
  String get importCheckIndex => 'Index des modèles';

  @override
  String importCheckIndexResult(int count) {
    return '$count modèles';
  }

  @override
  String get importCheckDb => 'Base de données du catalogue (à distance)';

  @override
  String get importCheckDbRemoteFound => 'Disponible sur GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Uniquement local (pas sur GitHub)';

  @override
  String get importCheckDbLocal => 'Données de la base importée';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Version : $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Véhicules : $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Éléments d\'entretien : $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Pièces : $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Codes OBD : $count';
  }

  @override
  String get importCheckDbLocalFailed => 'Impossible de lire la base importée';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingDone => 'Commencer';

  @override
  String get onboardingReplay => 'Revoir l\'introduction';

  @override
  String get onboardingReplaySubtitle => 'Rejoue la visite de bienvenue';

  @override
  String get onboardingWelcomeTitle => 'Bienvenue sur Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Un outil de suivi d\'entretien de véhicules open source, axé sur la confidentialité. 100 % hors ligne — aucun compte, aucune télémétrie, aucun suivi.';

  @override
  String get onboardingVehicleTitle => 'Ajoute ton véhicule';

  @override
  String get onboardingVehicleDesc =>
      'Enregistre ta voiture, ta moto ou ton VE. Choisis un modèle et Karter remplit automatiquement les intervalles d\'entretien pour ton modèle.';

  @override
  String get onboardingTrackTitle => 'Suis le carburant et l\'entretien';

  @override
  String get onboardingTrackDesc =>
      'Enregistre tes pleins avec des calculs automatiques de consommation (MPG, L/100 km, km/L). Suis les réparations, les pièces et les coûts.';

  @override
  String get onboardingRemindersTitle => 'Reste à jour sur l\'entretien';

  @override
  String get onboardingRemindersDesc =>
      'Sois notifié quand il est temps de changer l\'huile, les plaquettes de frein et chaque intervalle d\'entretien — selon la distance ou le temps.';

  @override
  String get supporterBadge => 'Tu es un supporter de Karter !';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get tipPurchased => 'Merci !';

  @override
  String get tipSupport => 'Soutien';

  @override
  String get sectionBackup => 'Sauvegarde';

  @override
  String get moreBackup => 'Sauvegarde';

  @override
  String get moreBackupSubtitle => 'Sauvegarde chiffrée';

  @override
  String get backupConnect => 'Connecter Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Connecté en tant que $email';
  }

  @override
  String get backupNow => 'Sauvegarder maintenant';

  @override
  String get backupInProgress => 'Sauvegarde en cours…';

  @override
  String backupLast(Object date) {
    return 'Dernière sauvegarde : $date';
  }

  @override
  String get backupNever => 'Jamais sauvegardé';

  @override
  String get backupRestore => 'Restaurer depuis une sauvegarde';

  @override
  String get backupRestoreInProgress => 'Restauration en cours…';

  @override
  String get backupRestoreConfirm =>
      'Cela écrasera toutes les données actuelles. Es-tu sûr ?';

  @override
  String backupError(Object error) {
    return 'Erreur de sauvegarde : $error';
  }

  @override
  String get backupSuccess => 'Sauvegarde envoyée avec succès';

  @override
  String get backupRestoreSuccess =>
      'Données restaurées. Redémarre l\'application pour voir les changements.';

  @override
  String get backupDisconnect => 'Se déconnecter';

  @override
  String get backupNoBackups => 'Aucune sauvegarde trouvée';

  @override
  String get backupRestoreBtn => 'Restaurer';

  @override
  String get backupDelete => 'Supprimer';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Supprimer la sauvegarde $name ?';
  }

  @override
  String get backupDeleteSuccess => 'Sauvegarde supprimée';

  @override
  String backupCount(Object current, Object max) {
    return 'Sauvegardes : $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Recherche de code défaut';

  @override
  String get dtcSearchHint => 'Saisissez un code, ex. P0171';

  @override
  String get dtcEmptyState => 'Saisis un code pour rechercher sa description';

  @override
  String get dtcNoMatch => 'Aucun code ne correspond à votre recherche';

  @override
  String get dtcDescription => 'Description';

  @override
  String get dtcRelatedMaintenance => 'Entretien lié';

  @override
  String get dtcScopeStandard => 'Standard';

  @override
  String get dtcScopeManufacturer => 'Constructeur';

  @override
  String get dtcGeneralDb => 'Codes OBD-II généraux';

  @override
  String get dtcCatalogBrands => 'Marques du catalogue';

  @override
  String get dtcMyVehicles => 'Mes véhicules';

  @override
  String get dtcVehicle => 'Véhicule';

  @override
  String get dtcVehicleNotFound => 'Véhicule introuvable';

  @override
  String get dtcLoadError => 'Impossible de charger les codes défaut';

  @override
  String get notificationOdometerTitle => 'Mettre à jour le compteur';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days jours depuis le dernier rappel.';
  }

  @override
  String get notificationMaintenanceTitle => 'Entretien en attente';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — vérifie tes intervalles d\'entretien.';
  }

  @override
  String errorGeneric(String error) {
    return 'Erreur : $error';
  }

  @override
  String get deleteFuelUp => 'Supprimer le plein';

  @override
  String get deleteFuelUpConfirm => 'Voulez-vous vraiment supprimer ce plein ?';

  @override
  String get editFuelUp => 'Modifier le plein';

  @override
  String get deleteDocument => 'Supprimer le document';

  @override
  String get deleteDocumentConfirm =>
      'Voulez-vous vraiment supprimer ce document ?';

  @override
  String get editDocument => 'Modifier le document';

  @override
  String get title => 'Titre';

  @override
  String get selectExpiryDate => 'Sélectionner la date d\'expiration';

  @override
  String get addMoreFiles => 'Ajouter d\'autres fichiers';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Modèles';

  @override
  String get templatesTitle => 'Modèles';

  @override
  String get templatesSubtitle =>
      'Parcours le catalogue de modèles de la communauté';

  @override
  String get createTemplate => 'Créer un modèle';

  @override
  String get createTemplateSubtitle => 'Créez un modèle et exportez-le en JSON';

  @override
  String get templatesLoadError =>
      'Impossible de charger le catalogue de modèles.';

  @override
  String get searchTemplatesHint =>
      'Recherche par marque, modèle ou génération';

  @override
  String get allMakes => 'Toutes les marques';

  @override
  String get noTemplatesFound =>
      'Aucun modèle ne correspond à votre recherche.';

  @override
  String templateItemsCount(int count) {
    return '$count éléments d\'entretien';
  }

  @override
  String get templateYearsOpen => 'présent';

  @override
  String get templateNotFound => 'Modèle introuvable';

  @override
  String get templateInfo => 'Infos du modèle';

  @override
  String get templateYears => 'Années';

  @override
  String get templateEngine => 'Moteur';

  @override
  String get templateAuthor => 'Auteur';

  @override
  String get templateVersion => 'Version';

  @override
  String get templateSources => 'Sources';

  @override
  String get dtcCodesTitle => 'Codes défaut';

  @override
  String dtcCount(int count) {
    return '$count code(s) défaut';
  }

  @override
  String get noPartsFound => 'Aucune pièce';

  @override
  String get createCopied => 'JSON du modèle copié dans le presse-papiers';

  @override
  String get saveTemplate => 'Enregistrer le modèle';

  @override
  String savedAt(String path) {
    return 'Enregistré à l\'emplacement $path';
  }

  @override
  String get createHasErrors => 'Corrige les erreurs pour exporter';

  @override
  String get createMake => 'Marque';

  @override
  String get createModel => 'Modèle';

  @override
  String get createGeneration => 'Génération';

  @override
  String get createYearFrom => 'Année de début';

  @override
  String get createYearTo => 'Année de fin';

  @override
  String get createFuel => 'Carburant';

  @override
  String get createPowertrain => 'Motorisation';

  @override
  String get createEngineCode => 'Code moteur';

  @override
  String get createDisplacement => 'Cylindrée (cm³)';

  @override
  String get createPower => 'Puissance (ch)';

  @override
  String get templateMetadata => 'Métadonnées et héritage';

  @override
  String get createAuthor => 'Auteur';

  @override
  String get createAuthorHint => 'Ton nom d\'utilisateur GitHub';

  @override
  String get createExtends => 'Étend (modèles de base)';

  @override
  String get createExtendsHint => 'Hériter des données d\'entretien partagées';

  @override
  String get createCustomExtends => 'Chemins d\'extension personnalisés';

  @override
  String get createAddPart => 'Ajouter une pièce';

  @override
  String get createNoParts =>
      'Aucune pièce pour l\'instant. Les pièces sont facultatives.';

  @override
  String get partSingular => 'Pièce';

  @override
  String get createAddItem => 'Ajouter un élément d\'entretien';

  @override
  String get createNoItems => 'Aucun élément d\'entretien pour l\'instant.';

  @override
  String get createPreview => 'Aperçu';

  @override
  String createErrorsFound(int count) {
    return '$count erreur(s) de validation';
  }

  @override
  String get createCopy => 'Copier';

  @override
  String get createShare => 'Partager';

  @override
  String get createSave => 'Enregistrer';

  @override
  String get createQuantity => 'Quantité';

  @override
  String get createI18nKey => 'Clé i18n';

  @override
  String get createDescI18nKey => 'Clé i18n de description';

  @override
  String get createIntervalKm => 'Intervalle (km)';

  @override
  String get createIntervalMonths => 'Intervalle (mois)';

  @override
  String get createDescription => 'Description';

  @override
  String get createAddPartRef => 'Ajouter une référence de pièce';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nom';

  @override
  String get createFieldUnit => 'Unité';

  @override
  String get createFieldOem => 'Référence OEM';

  @override
  String get createFieldLabel => 'Libellé';

  @override
  String get createFieldPart => 'Pièce';

  @override
  String get fuelGasoline => 'Essence';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'GPL';

  @override
  String get fuelCng => 'GNV';

  @override
  String get fuelHydrogen => 'Hydrogène';

  @override
  String get fuelEthanol => 'Éthanol';

  @override
  String get powertrainCombustion => 'Thermique';

  @override
  String get powertrainHybrid => 'Hybride';

  @override
  String get powertrainPluginHybrid => 'Hybride rechargeable';

  @override
  String get powertrainElectric => 'Électrique';

  @override
  String get catalogDb => 'Base de données du catalogue';

  @override
  String get catalogSourceBuiltin => 'Intégrée (par défaut)';

  @override
  String get catalogSourceOnline => 'En ligne (version GitHub)';

  @override
  String get catalogSourcesTitle => 'Catalogues disponibles';

  @override
  String get catalogCannotDelete =>
      'Catalogue par défaut — ne peut pas être supprimé';

  @override
  String catalogVersionOf(String version) {
    return 'Version $version';
  }

  @override
  String get catalogVersionUnknown => 'Version indisponible';

  @override
  String get catalogRefreshOnline => 'Actualiser le catalogue en ligne';

  @override
  String get catalogRefreshed => 'Catalogue en ligne actualisé';

  @override
  String get catalogRefreshFailed =>
      'Impossible d\'actualiser le catalogue en ligne';

  @override
  String get catalogNotAvailable => 'Ce catalogue n\'est pas disponible';

  @override
  String get catalogImportDb => 'Importer une base locale';

  @override
  String get catalogImported => 'Catalogue importé';

  @override
  String get catalogImportFailed => 'Impossible d\'importer le catalogue';

  @override
  String get catalogDelete => 'Supprimer le catalogue';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Supprimer $name ? Cette action est irréversible.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Impossible de télécharger le catalogue en ligne. Vérifiez votre connexion et réessayez.';

  @override
  String get templateUrlExample =>
      'Exemple : https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> est remplacé par la dernière version de ce dépôt. Vous pouvez utiliser n\'importe quel dépôt GitHub ou coller un lien direct. Si le tag ne peut pas être résolu, le lien est utilisé tel quel et le test affichera l\'échec.';

  @override
  String get templateUrlUsage =>
      'Utilisé pour récupérer le catalogue, l\'index des modèles et les traductions (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Se résout en : $url';
  }

  @override
  String get templateUrlVersion => 'Version';

  @override
  String get templateUrlLatest => 'Dernière (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Impossible de charger les versions';

  @override
  String get templateUrlHelp => 'Aide sur l\'URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL du dépôt';

  @override
  String get moreTemplateSourceVersionLatest => 'Dernière';

  @override
  String catalogDbVersion(String version) {
    return 'Version de la base : $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Version : $version';
  }

  @override
  String get createInheritedParts => 'Pièces héritées (des extensions)';

  @override
  String get createInheritedItems => 'Entretiens hérités (des extensions)';

  @override
  String get templateExtendsNotLoaded =>
      'Certaines extensions n\'ont pas pu être chargées';

  @override
  String get templateRepoLoading => 'Chargement depuis le dépôt de modèles…';

  @override
  String get templateRepoError => 'Impossible d\'atteindre le dépôt de modèles';

  @override
  String templateBy(String author) {
    return 'par $author';
  }
}
