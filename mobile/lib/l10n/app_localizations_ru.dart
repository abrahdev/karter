// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Главная';

  @override
  String get navVehicles => 'Транспорт';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Ещё';

  @override
  String get homeEmptyTitle => 'Нет транспортных средств';

  @override
  String get homeEmptySubtitle => 'Добавьте свой первый автомобиль';

  @override
  String homeError(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get dashboardTitle => 'Главная';

  @override
  String get dashboardComingSoon => 'Скоро';

  @override
  String get vehicleDetailTitle => 'Автомобиль';

  @override
  String get vehicleNotFound => 'Автомобиль не найден';

  @override
  String get plate => 'Гос. номер';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Марка / Модель';

  @override
  String get year => 'Год';

  @override
  String get odometer => 'Одометр';

  @override
  String get update => 'Обновить';

  @override
  String get actions => 'Действия';

  @override
  String get tools => 'Инструменты';

  @override
  String get information => 'Информация';

  @override
  String get fuelLogs => 'Заправки';

  @override
  String get maintenanceHistory => 'История обслуживания';

  @override
  String get configureIntervals => 'Настроить интервалы';

  @override
  String get nextMaintenance => 'Следующее ТО';

  @override
  String get allIntervalsDisabled => 'Все интервалы отключены.';

  @override
  String get register => 'Зарегистрировать';

  @override
  String get registerService => 'Записать обслуживание';

  @override
  String get noDescriptionAvailable =>
      'Описание недоступно. Перейдите в настройки обслуживания, чтобы добавить его.';

  @override
  String get close => 'Закрыть';

  @override
  String get retry => 'Повторить';

  @override
  String get overduePerformService => 'Просрочено — выполните обслуживание';

  @override
  String nextIn(Object parts) {
    return 'Следующее через $parts';
  }

  @override
  String get vehicleFormNew => 'Новый автомобиль';

  @override
  String get vehicleFormEdit => 'Редактировать автомобиль';

  @override
  String get vehicleFormDetails => 'Детали';

  @override
  String get vehicleFormVehicle => 'Автомобиль';

  @override
  String get brand => 'Марка';

  @override
  String get model => 'Модель';

  @override
  String get required => 'Обязательно';

  @override
  String get invalidYear => 'Некорректный год';

  @override
  String get vehicleType => 'Тип транспортного средства';

  @override
  String get combustion => 'ДВС';

  @override
  String get electric => 'Электрический';

  @override
  String get motorcycle => 'Мотоцикл';

  @override
  String get plateOptional => 'Номер (необязательно)';

  @override
  String get vinOptional => 'VIN (необязательно)';

  @override
  String get invalid => 'Некорректно';

  @override
  String get aliasOptional => 'Псевдоним (необязательно)';

  @override
  String get aliasHint => 'Например: Моя ласточка, Зверь и т.д.';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get addVehicle => 'Добавить автомобиль';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Обслуживания отображаются как просроченные';

  @override
  String get newVehicleServicesOverdueBody =>
      'Поскольку ваш автомобиль уже проехал более 500 км, все обслуживания отображаются как просроченные.\n\nЗарегистрируйте уже выполненные услуги. Если вы не помните точный пробег, укажите примерное значение км для последнего обслуживания.';

  @override
  String get deleteVehicle => 'Удалить автомобиль';

  @override
  String get deleteVehicleConfirm =>
      'Это действие нельзя отменить. Все записи о заправках, обслуживании и связанные интервалы будут удалены.';

  @override
  String get cancel => 'Отмена';

  @override
  String get resetToDefault => 'Сбросить к значениям по умолчанию';

  @override
  String get delete => 'Удалить';

  @override
  String get dataManagerTitle => 'Экспорт / Импорт данных';

  @override
  String get selectAll => 'Выбрать всё';

  @override
  String get exporting => 'Экспорт...';

  @override
  String get export => 'Экспорт';

  @override
  String get importing => 'Импорт...';

  @override
  String get import => 'Импорт';

  @override
  String get saveExport => 'Сохранить экспорт';

  @override
  String exportedAt(Object path) {
    return 'Экспортировано в $path';
  }

  @override
  String exportError(Object error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String get importData => 'Импорт данных';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Найдено:\n• $vehicles транспортных средств\n• $fuelLogs заправок\n• $maintenanceLogs записей об обслуживании\n• $documents документов\n\nИмпортировать? Существующие данные с тем же ID будут перезаписаны.';
  }

  @override
  String get importSuccess => 'Данные успешно импортированы';

  @override
  String importError(Object error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get invalidJson => 'Некорректный JSON-файл';

  @override
  String exportShareText(Object count) {
    return 'Экспорт Karter — $count транспортных средств';
  }

  @override
  String get maintenanceSettingsTitle => 'Интервалы обслуживания';

  @override
  String get maintenanceSettingsInstruction =>
      'Включайте или отключайте пункты в соответствии с потребностями вашего автомобиля. Пользовательские интервалы можно удалять.';

  @override
  String get km => 'км';

  @override
  String get timeMonths => 'Время (месяцы)';

  @override
  String get partsTitle => 'Запчасти';

  @override
  String get partUnitUnit => 'шт.';

  @override
  String get partUnitSet => 'комплект';

  @override
  String get partUnitKit => 'набор';

  @override
  String get partUnitCan => 'канистра';

  @override
  String get partUnitLabel => 'Единица';

  @override
  String get localParts => 'Локальные запчасти';

  @override
  String get intervalParts => 'Запчасти интервала';

  @override
  String get newPart => 'Новая запчасть';

  @override
  String get createPart => 'Создать запчасть';

  @override
  String get partsSection => 'Запчасти';

  @override
  String get usedParts => 'Запчасти';

  @override
  String usedInServicesCount(Object count) {
    return '$count услуг';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Эта запчасть используется в $count услугах. Всё равно удалить?';
  }

  @override
  String get reportPartsHeader => 'Запчасти';

  @override
  String get templateFound => 'Шаблон найден';

  @override
  String get templateDisclaimer =>
      'Данные шаблона приведены только для справки. Всегда сверяйте интервалы с руководством по эксплуатации вашего автомобиля.';

  @override
  String get noTemplate => 'Без шаблона';

  @override
  String get useTemplate => 'Использовать шаблон';

  @override
  String get searchTemplate => 'Поиск шаблона';

  @override
  String templateWithName(Object name) {
    return 'Шаблон: $name';
  }

  @override
  String get noResultsTitle => 'Ничего не найдено';

  @override
  String get noTemplateFoundDescription =>
      'Для введённых данных шаблон не найден.';

  @override
  String get searchParameters => 'Параметры поиска:';

  @override
  String get defaultIntervalsHint =>
      'Автомобиль будет использовать интервалы по умолчанию.';

  @override
  String get missingTemplateContribute =>
      'Не хватает шаблона? Внесите вклад на github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Показать все шаблоны';

  @override
  String get contribute => 'Внести вклад';

  @override
  String get contributeOnGitHub => 'Внести вклад на GitHub';

  @override
  String get gotIt => 'Понятно';

  @override
  String get templateUnderConstruction => 'Шаблон в разработке';

  @override
  String get templateNotReady =>
      'Этот шаблон ещё не готов.\nМы над ним работаем!';

  @override
  String get contributionsWelcome =>
      'Вклад приветствуется — добавьте или исправьте шаблоны для вашего автомобиля:';

  @override
  String requestedParam(Object params) {
    return 'Запрошено: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Вы уверены, что хотите удалить этот интервал?';

  @override
  String get addPart => 'Добавить запчасть';

  @override
  String get partName => 'Название запчасти';

  @override
  String get quantity => 'Кол-во';

  @override
  String get oemNumber => 'Номер OEM';

  @override
  String get addLink => 'Добавить ссылку';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Открыть';

  @override
  String get noLinks => 'Нет ссылок';

  @override
  String get noParts => 'Запчастей пока нет';

  @override
  String get invalidUrl => 'Некорректный URL';

  @override
  String get copied => 'Скопировано';

  @override
  String get linksTitle => 'Справочные ссылки';

  @override
  String get copy => 'Копировать';

  @override
  String get addModeManual => 'Вручную';

  @override
  String get addModeTemplate => 'Шаблон';

  @override
  String get newFromTemplate => 'Новый из шаблона';

  @override
  String get updatesAvailable => 'Доступны обновления';

  @override
  String get restore => 'Восстановить';

  @override
  String get windowMinimize => 'Свернуть';

  @override
  String get windowMaximize => 'Развернуть';

  @override
  String get windowClose => 'Закрыть';

  @override
  String get syncInstruction =>
      'Синхронизируйте интервалы обслуживания с шаблоном вашего автомобиля.';

  @override
  String get upToDate => 'Всё актуально';

  @override
  String get syncAdded => 'Интервал добавлен из шаблона';

  @override
  String get syncRestored => 'Интервал восстановлен из шаблона';

  @override
  String get months => 'мес.';

  @override
  String get description => 'Описание';

  @override
  String get newInterval => 'Новый интервал';

  @override
  String get name => 'Название';

  @override
  String get add => 'Добавить';

  @override
  String get edit => 'Изменить';

  @override
  String get addToDashboard => 'Добавить на панель';

  @override
  String get setupNotifications => 'Настроить уведомления';

  @override
  String get addToDashboardComingSoon => 'Скоро';

  @override
  String get deleteInterval => 'Удалить';

  @override
  String get noDescriptionAvailableSettings =>
      'Описание недоступно. Нажмите «Изменить», чтобы добавить его.';

  @override
  String formattedKmK(Object km) {
    return '${km}k км';
  }

  @override
  String formattedKm(Object km) {
    return '$km км';
  }

  @override
  String intervalSubtitleKm(Object km) {
    return 'каждые $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months мес.';
  }

  @override
  String get maintenanceLogTitleEdit => 'Редактировать обслуживание';

  @override
  String get maintenanceLogTitleNew => 'Новое обслуживание';

  @override
  String date(Object date) {
    return 'Дата: $date';
  }

  @override
  String get descriptionRequired => 'Описание';

  @override
  String get odometerAtService => 'Пробег при обслуживании (необязательно)';

  @override
  String get resetInterval => 'Сбросить интервал (необязательно)';

  @override
  String get saveChangesShort => 'Сохранить изменения';

  @override
  String get saveService => 'Сохранить обслуживание';

  @override
  String get saveFile => 'Сохранить файл';

  @override
  String get lastService => 'Последнее';

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get photos => 'фото';

  @override
  String get files => 'файлы';

  @override
  String get share => 'Поделиться';

  @override
  String get deleteService => 'Удалить обслуживание';

  @override
  String get deleteServiceConfirm =>
      'Вы уверены, что хотите удалить это обслуживание?';

  @override
  String get maintenanceListTitle => 'Обслуживание';

  @override
  String get maintenanceEmpty => 'Нет записей об обслуживании';

  @override
  String get maintenanceHistoryTab => 'История';

  @override
  String get maintenancePdfExportTab => 'Экспорт PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count услуг за этот период';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... и ещё $count';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'В этом диапазоне дат нет обслуживаний.';

  @override
  String get maintenanceExportPdf => 'Экспорт PDF';

  @override
  String get maintenanceSharePdf => 'Поделиться';

  @override
  String get maintenanceReportTitle => 'Отчёт об обслуживании';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Создано $date $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'В этом периоде нет записей об обслуживании.';

  @override
  String get maintenanceReportDateHeader => 'Дата';

  @override
  String get maintenanceReportDescHeader => 'Описание';

  @override
  String get maintenanceReportOdometerHeader => 'Пробег';

  @override
  String get addDocument => 'Добавить документ';

  @override
  String get documentType => 'Тип документа';

  @override
  String get selectFile => 'Выбрать файл';

  @override
  String get noFileSelected => 'Файл не выбран';

  @override
  String get notesOptional => 'Заметки (необязательно)';

  @override
  String get expiryDateOptional => 'Срок действия (необязательно)';

  @override
  String get pleaseSelectFile => 'Пожалуйста, выберите файл';

  @override
  String get documentSaved => 'Документ сохранён';

  @override
  String get takePhoto => 'Сделать фото';

  @override
  String get chooseFromGallery => 'Выбрать из галереи';

  @override
  String get browseFiles => 'Обзор файлов';

  @override
  String get docTypeFine => 'Штраф';

  @override
  String get docTypeParkingFee => 'Парковка';

  @override
  String get docTypeInsurance => 'Страховка';

  @override
  String get docTypeVehicleCheck => 'Техосмотр';

  @override
  String get docTypeTax => 'Налог';

  @override
  String get docTypeComplexInsurance => 'Комплексное страхование';

  @override
  String get docTypeVehicleRegister => 'Регистрация ТС';

  @override
  String get docTypeOther => 'Другое';

  @override
  String get vehicleDocuments => 'Документы';

  @override
  String get fuelFormTitle => 'Новая заправка';

  @override
  String get volume => 'Объём';

  @override
  String get unitL => 'л';

  @override
  String get unitGal => 'гал';

  @override
  String get unitKm => 'км';

  @override
  String get unitMi => 'ми';

  @override
  String get pricePerUnit => 'Цена за единицу (необязательно)';

  @override
  String get fullTank => 'Полный бак';

  @override
  String get volumeUnit => 'Единица объёма топлива';

  @override
  String get currency => 'Валюта';

  @override
  String get cost => 'Стоимость (необязательно)';

  @override
  String get saveFuelUp => 'Сохранить заправку';

  @override
  String get fuelListTitle => 'Заправки';

  @override
  String get fuelEmpty => 'Нет записей о заправках';

  @override
  String get moreAbout => 'О Karter';

  @override
  String get moreDescription =>
      'Karter — это локальное приложение с открытым исходным кодом для обслуживания автомобилей, которое уважает вашу конфиденциальность.';

  @override
  String get moreExport => 'Экспорт / Импорт данных';

  @override
  String get moreExportSubtitle =>
      'Создайте резервную копию или перенесите свои данные';

  @override
  String get moreDocs => 'Документация';

  @override
  String get moreDocsSubtitle => 'Руководство по использованию и функции';

  @override
  String get moreSource => 'Исходный код';

  @override
  String get moreSourceSubtitle => 'Репозиторий GitHub';

  @override
  String get moreDonate => 'Пожертвовать';

  @override
  String get moreDonateSubtitle => 'Поддержите разработку на GitHub Sponsors';

  @override
  String get moreFooter => 'Сделано с ❤️ abrahdev';

  @override
  String get moreRate => 'Оценить Karter';

  @override
  String get moreRateSubtitle => 'Оставьте отзыв в Play Store';

  @override
  String get moreFeedback => 'Оценить приложение';

  @override
  String get moreFeedbackSubtitle =>
      'Оцените приложение и настройте напоминания';

  @override
  String get feedbackTitle => 'Обратная связь';

  @override
  String get sectionPreferences => 'Настройки';

  @override
  String get sectionData => 'Данные';

  @override
  String get sectionFeedbackCommunity => 'Обратная связь и сообщество';

  @override
  String get sectionTips => 'Программа чаевых';

  @override
  String get sectionAbout => 'О Karter';

  @override
  String get theme => 'Тема';

  @override
  String get themeAutomatic => 'Автоматически';

  @override
  String get themeAutomaticDesc => 'Следовать настройкам устройства';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeSystemDesc => 'Следовать настройкам устройства';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get colorScheme => 'Основной цвет';

  @override
  String get colorCustom => 'Свой';

  @override
  String get colorOfInterface => 'Цвет интерфейса';

  @override
  String get colorOfInterfaceDesc =>
      'Применять основной цвет к фоновым поверхностям';

  @override
  String get customColor => 'Свой цвет';

  @override
  String get customColorDesc =>
      'Использовать свой цвет вместо системного акцента';

  @override
  String get selectColor => 'Выберите цвет';

  @override
  String get hapticFeedback => 'Тактильная отдача';

  @override
  String get hapticFeedbackDesc => 'Вибрация при взаимодействии';

  @override
  String get hapticModeOff => 'Выкл.';

  @override
  String get hapticModeOffDesc => 'Без вибрации при взаимодействии';

  @override
  String get hapticModeClear => 'Чёткая';

  @override
  String get hapticModeClearDesc => 'Один чёткий отклик на действие';

  @override
  String get hapticModeRich => 'Богатая';

  @override
  String get hapticModeRichDesc =>
      'Многослойная вибрация с разной интенсивностью';

  @override
  String get testNotification => 'Тестовое уведомление';

  @override
  String get testNotificationDesc =>
      'Отправить тестовое уведомление для проверки настроек';

  @override
  String get testNotificationSent => 'Тестовое уведомление отправлено';

  @override
  String get notificationsPermissionTitle => 'Уведомления отключены';

  @override
  String get notificationsPermissionDesc =>
      'Включите уведомления, чтобы получать напоминания о пробеге и обслуживании';

  @override
  String get notificationsPermissionAllow => 'Разрешить уведомления';

  @override
  String get notificationsPermissionDeniedTitle => 'Уведомления заблокированы';

  @override
  String get notificationsPermissionDeniedDesc =>
      'Разрешение на уведомления было отклонено навсегда. Чтобы включить их, перейдите в Настройки > Приложения > Karter > Уведомления и включите их.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Откройте настройки устройства';

  @override
  String get notificationsPermissionDeniedStep2 =>
      '2. Перейдите в Приложения > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Нажмите Уведомления';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Включите «Показывать уведомления»';

  @override
  String get notificationsPermissionOpenSettings => 'Открыть настройки';

  @override
  String get shakeToOdometer => 'Встряхнуть для обновления одометра';

  @override
  String get shakeToOdometerDesc =>
      'Встряхните устройство, чтобы открыть обновление одометра на экране автомобиля';

  @override
  String get feedbackReminderToggle => 'Напоминание об оценке';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Показывать напоминание об оценке приложения после сохранения обслуживаний';

  @override
  String get feedbackServicesInterval => 'Обслуживаний до подсказки';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'После $count услуг';
  }

  @override
  String get feedbackServicesSuffix => 'услуг';

  @override
  String get feedbackRepeatDays => 'Интервал напоминания';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'Каждые $days дн.';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'дн.';

  @override
  String get ratePromptMessage =>
      'Нравится Karter? Отзыв поможет другим открыть для себя это приложение!';

  @override
  String get rate => 'Оценить';

  @override
  String moreUrlError(Object url) {
    return 'Не удалось открыть $url';
  }

  @override
  String get tipProgram => 'Программа чаевых';

  @override
  String get tipProgramComingSoon =>
      'Эта функция находится в разработке и будет доступна в ближайшее время.';

  @override
  String get tipBadges => 'Значки';

  @override
  String get tipBadgesNone => 'Нет';

  @override
  String get tipInfo => 'Информация';

  @override
  String get tipInfoText =>
      'Программа чаевых — это способ для пользователей выразить дополнительную поддержку и благодарность за быструю поддержку, постоянные улучшения и регулярные обновления, которые предлагает Karter.';

  @override
  String get tipOneTime => 'Разовое чаевое';

  @override
  String get tipRecurring => 'Регулярное чаевое';

  @override
  String get tipBronze => 'Бронза';

  @override
  String get tipSilver => 'Серебро';

  @override
  String get tipGold => 'Золото';

  @override
  String get tipBronzePrice => 'Бронзовое чаевое';

  @override
  String get tipSilverPrice => 'Серебряное чаевое';

  @override
  String get tipGoldPrice => 'Золотое чаевое';

  @override
  String get tipBronzeMonthly => 'Бронза / месяц';

  @override
  String get tipSilverMonthly => 'Серебро / месяц';

  @override
  String get tipGoldMonthly => 'Золото / месяц';

  @override
  String get officialWebsite => 'Официальный сайт';

  @override
  String get communityForums => 'Форумы сообщества';

  @override
  String get translations => 'Переводы';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyDesc =>
      'Прочитайте нашу политику конфиденциальности онлайн.';

  @override
  String get openPrivacyPolicy => 'Открыть политику конфиденциальности';

  @override
  String get version => 'Версия';

  @override
  String get deviceId => 'ID устройства';

  @override
  String get changelog => 'Журнал изменений';

  @override
  String get openSourceLicenses => 'Лицензии с открытым исходным кодом';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get languageSystem => 'Системный язык';

  @override
  String get english => 'Английский';

  @override
  String get spanish => 'Испанский';

  @override
  String get eesti => 'Эстонский';

  @override
  String get german => 'Немецкий';

  @override
  String get portuguese => 'Португальский';

  @override
  String get russian => 'Русский';

  @override
  String get french => 'Французский';

  @override
  String get polish => 'Польский';

  @override
  String get italian => 'Итальянский';

  @override
  String get dutch => 'Голландский';

  @override
  String get odometerUpdateTitle => 'Обновить одометр';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Последнее: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'Значение ниже последней записи ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Вы проехали $delta $unit с прошлого раза. Всё верно?';
  }

  @override
  String get odometerSave => 'Сохранить';

  @override
  String get odometerCancel => 'Отмена';

  @override
  String get moreNotifications => 'Уведомления';

  @override
  String get moreNotificationsSubtitle =>
      'Напоминания о пробеге и обслуживании';

  @override
  String get notificationSettingsTitle => 'Настройки уведомлений';

  @override
  String get notificationSettingsSubtitle =>
      'Настройте напоминания для этого автомобиля';

  @override
  String get notificationOdometerSection => 'Напоминание о пробеге';

  @override
  String get notificationMaintenanceSection => 'Напоминание об обслуживании';

  @override
  String get notificationFreqLabel => 'Частота напоминаний';

  @override
  String get notificationFreqOff => 'Выкл.';

  @override
  String notificationFreqValue(Object days) {
    return 'Каждые $days дн.';
  }

  @override
  String get notificationMaintenanceToggle => 'Напоминания об обслуживании';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Получать ежедневные напоминания о предстоящем обслуживании';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Отложено ещё на $days дн.';
  }

  @override
  String get notificationSnoozeCancel => 'Отменить откладывание';

  @override
  String get notificationNoVehicles =>
      'Добавьте автомобиль, чтобы настроить уведомления';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Пробег: $freq • Обслуживание: $maint';
  }

  @override
  String get notificationConfigure => 'Настроить';

  @override
  String get notificationMaintOn => 'Вкл.';

  @override
  String get notificationMaintOff => 'Выкл.';

  @override
  String get notificationSnoozeAction => 'Отложить на 1 неделю';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Отложено до $date';
  }

  @override
  String get notificationFreqWeekly => 'Каждые 7 дней';

  @override
  String get notificationFreqMonthly => 'Каждые 30 дней';

  @override
  String get notificationFreqCustom => 'Своя';

  @override
  String notificationFreqDays(Object days) {
    return '$days дн.';
  }

  @override
  String get notificationMaintenanceSnooze =>
      'Отложить обслуживание на 1 неделю';

  @override
  String get notificationSnoozeToggle => 'Отложить напоминания';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days дн.';
  }

  @override
  String get unsavedChanges => 'Несохранённые изменения';

  @override
  String get discardChangesConfirm =>
      'У вас есть несохранённые изменения. Вы уверены, что хотите выйти?';

  @override
  String get discard => 'Не сохранять';

  @override
  String get moreTemplateSource => 'Источник шаблонов';

  @override
  String get moreTemplateSourceSubtitle =>
      'Загружать шаблоны с GitHub или использовать локальные ресурсы';

  @override
  String get moreTemplateSourceOffline => 'Локальный (офлайн)';

  @override
  String get moreTemplateSourceOnline => 'Онлайн (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL репозитория';

  @override
  String get moreTemplateSourceReset => 'Сбросить по умолчанию';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Изменить URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL обновлён';

  @override
  String get testConnection => 'Проверить соединение';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Изменено: $date';
  }

  @override
  String get importCheckTranslations => 'Переводы';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found из $total доступно';
  }

  @override
  String get importCheckIndex => 'Индекс шаблонов';

  @override
  String importCheckIndexResult(int count) {
    return '$count шаблонов';
  }

  @override
  String get importCheckDb => 'База данных каталога (удалённая)';

  @override
  String get importCheckDbRemoteFound => 'Доступна на GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Только локальная (нет на GitHub)';

  @override
  String get importCheckDbLocal => 'Данные импортированной базы данных';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Версия: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Автомобили: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Пункты обслуживания: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Запчасти: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Коды OBD: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Не удалось прочитать импортированную базу данных';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingDone => 'Начать';

  @override
  String get onboardingReplay => 'Просмотр введения';

  @override
  String get onboardingReplaySubtitle => 'Повторить приветственный тур';

  @override
  String get onboardingWelcomeTitle => 'Добро пожаловать в Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Приватный трекер обслуживания автомобилей с открытым исходным кодом. 100% офлайн — без аккаунтов, телеметрии и отслеживания.';

  @override
  String get onboardingVehicleTitle => 'Добавьте свой автомобиль';

  @override
  String get onboardingVehicleDesc =>
      'Зарегистрируйте автомобиль, мотоцикл или электромобиль. Выберите шаблон, и Karter автоматически заполнит интервалы обслуживания для вашей модели.';

  @override
  String get onboardingTrackTitle => 'Отслеживайте топливо и обслуживание';

  @override
  String get onboardingTrackDesc =>
      'Записывайте заправки с автоматическим расчётом расхода (MPG, л/100 км, км/л). Отслеживайте ремонты, запчасти и расходы.';

  @override
  String get onboardingRemindersTitle => 'Будьте в курсе обслуживания';

  @override
  String get onboardingRemindersDesc =>
      'Получайте уведомления, когда приходит время менять масло, тормозные колодки и проходить каждый интервал обслуживания — по пробегу или времени.';

  @override
  String get supporterBadge => 'Вы — сторонник Karter!';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get tipPurchased => 'Спасибо!';

  @override
  String get tipSupport => 'Поддержать';

  @override
  String get sectionBackup => 'Резервная копия';

  @override
  String get moreBackup => 'Резервная копия';

  @override
  String get moreBackupSubtitle => 'Зашифрованная резервная копия';

  @override
  String get backupConnect => 'Подключить Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Подключено: $email';
  }

  @override
  String get backupNow => 'Создать копию';

  @override
  String get backupInProgress => 'Создание копии…';

  @override
  String backupLast(Object date) {
    return 'Последняя копия: $date';
  }

  @override
  String get backupNever => 'Копий ещё не было';

  @override
  String get backupRestore => 'Восстановить из копии';

  @override
  String get backupRestoreInProgress => 'Восстановление…';

  @override
  String get backupRestoreConfirm =>
      'Это перезапишет все текущие данные. Вы уверены?';

  @override
  String backupError(Object error) {
    return 'Ошибка резервного копирования: $error';
  }

  @override
  String get backupSuccess => 'Резервная копия успешно загружена';

  @override
  String get backupRestoreSuccess =>
      'Данные восстановлены. Перезапустите приложение, чтобы увидеть изменения.';

  @override
  String get backupDisconnect => 'Отключить';

  @override
  String get backupNoBackups => 'Резервные копии не найдены';

  @override
  String get backupRestoreBtn => 'Восстановить';

  @override
  String get backupDelete => 'Удалить';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Удалить резервную копию $name?';
  }

  @override
  String get backupDeleteSuccess => 'Резервная копия удалена';

  @override
  String backupCount(Object current, Object max) {
    return 'Копии: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Поиск кода неисправности';

  @override
  String get dtcSearchHint => 'Введите код, например P0171';

  @override
  String get dtcEmptyState => 'Введите код, чтобы узнать его описание';

  @override
  String get dtcNoMatch => 'По вашему запросу коды не найдены';

  @override
  String get dtcDescription => 'Описание';

  @override
  String get dtcRelatedMaintenance => 'Связанное обслуживание';

  @override
  String get dtcScopeStandard => 'Стандартные';

  @override
  String get dtcScopeManufacturer => 'Производителя';

  @override
  String get dtcGeneralDb => 'Общие коды OBD-II';

  @override
  String get dtcCatalogBrands => 'Марки из каталога';

  @override
  String get dtcMyVehicles => 'Мои автомобили';

  @override
  String get dtcVehicle => 'Автомобиль';

  @override
  String get dtcVehicleNotFound => 'Автомобиль не найден';

  @override
  String get dtcLoadError => 'Не удалось загрузить коды неисправностей';

  @override
  String get notificationOdometerTitle => 'Обновить одометр';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — прошло $days дн. с последнего напоминания.';
  }

  @override
  String get notificationMaintenanceTitle => 'Предстоящее обслуживание';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — проверьте интервалы обслуживания.';
  }

  @override
  String errorGeneric(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get deleteFuelUp => 'Удалить заправку';

  @override
  String get deleteFuelUpConfirm =>
      'Вы уверены, что хотите удалить эту заправку?';

  @override
  String get editFuelUp => 'Изменить заправку';

  @override
  String get deleteDocument => 'Удалить документ';

  @override
  String get deleteDocumentConfirm =>
      'Вы уверены, что хотите удалить этот документ?';

  @override
  String get editDocument => 'Изменить документ';

  @override
  String get title => 'Название';

  @override
  String get selectExpiryDate => 'Выберите дату окончания срока действия';

  @override
  String get addMoreFiles => 'Добавить ещё файлы';

  @override
  String get consumptionUnit => 'л/100 км';

  @override
  String get sectionTemplates => 'Шаблоны';

  @override
  String get templatesTitle => 'Шаблоны';

  @override
  String get templatesSubtitle => 'Просмотрите каталог шаблонов сообщества';

  @override
  String get createTemplate => 'Создать шаблон';

  @override
  String get createTemplateSubtitle =>
      'Создайте шаблон и экспортируйте его в JSON';

  @override
  String get templatesLoadError => 'Не удалось загрузить каталог шаблонов.';

  @override
  String get searchTemplatesHint => 'Поиск по марке, модели или поколению';

  @override
  String get allMakes => 'Все марки';

  @override
  String get noTemplatesFound => 'По вашему запросу шаблоны не найдены.';

  @override
  String templateItemsCount(int count) {
    return '$count пунктов обслуживания';
  }

  @override
  String get templateYearsOpen => 'наст. время';

  @override
  String get templateNotFound => 'Шаблон не найден';

  @override
  String get templateInfo => 'Информация о шаблоне';

  @override
  String get templateYears => 'Годы';

  @override
  String get templateEngine => 'Двигатель';

  @override
  String get templateAuthor => 'Автор';

  @override
  String get templateVersion => 'Версия';

  @override
  String get templateSources => 'Источники';

  @override
  String get dtcCodesTitle => 'Коды неисправностей';

  @override
  String dtcCount(int count) {
    return '$count кодов неисправности';
  }

  @override
  String get noPartsFound => 'Запчастей нет';

  @override
  String get createCopied => 'JSON шаблона скопирован в буфер обмена';

  @override
  String get saveTemplate => 'Сохранить шаблон';

  @override
  String savedAt(String path) {
    return 'Сохранено в $path';
  }

  @override
  String get createHasErrors => 'Исправьте ошибки, чтобы экспортировать';

  @override
  String get createMake => 'Марка';

  @override
  String get createModel => 'Модель';

  @override
  String get createGeneration => 'Поколение';

  @override
  String get createYearFrom => 'Год с';

  @override
  String get createYearTo => 'Год по';

  @override
  String get createFuel => 'Топливо';

  @override
  String get createPowertrain => 'Силовая установка';

  @override
  String get createEngineCode => 'Код двигателя';

  @override
  String get createDisplacement => 'Объём (см³)';

  @override
  String get createPower => 'Мощность (л.с.)';

  @override
  String get templateMetadata => 'Метаданные и наследование';

  @override
  String get createAuthor => 'Автор';

  @override
  String get createAuthorHint => 'Ваше имя пользователя GitHub';

  @override
  String get createExtends => 'Расширяет (базовые шаблоны)';

  @override
  String get createExtendsHint => 'Наследовать общие данные обслуживания';

  @override
  String get createCustomExtends => 'Свои пути расширения';

  @override
  String get createAddPart => 'Добавить запчасть';

  @override
  String get createNoParts => 'Запчастей пока нет. Запчасти необязательны.';

  @override
  String get partSingular => 'Запчасть';

  @override
  String get createAddItem => 'Добавить пункт обслуживания';

  @override
  String get createNoItems => 'Пунктов обслуживания пока нет.';

  @override
  String get createPreview => 'Предпросмотр';

  @override
  String createErrorsFound(int count) {
    return '$count ошибок валидации';
  }

  @override
  String get createCopy => 'Копировать';

  @override
  String get createShare => 'Поделиться';

  @override
  String get createSave => 'Сохранить';

  @override
  String get createQuantity => 'Количество';

  @override
  String get createI18nKey => 'ключ i18n';

  @override
  String get createDescI18nKey => 'ключ i18n описания';

  @override
  String get createIntervalKm => 'Интервал (км)';

  @override
  String get createIntervalMonths => 'Интервал (месяцы)';

  @override
  String get createDescription => 'Описание';

  @override
  String get createAddPartRef => 'Добавить ссылку на запчасть';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Название';

  @override
  String get createFieldUnit => 'Единица';

  @override
  String get createFieldOem => 'Номер OEM';

  @override
  String get createFieldLabel => 'Метка';

  @override
  String get createFieldPart => 'Запчасть';

  @override
  String get fuelGasoline => 'Бензин';

  @override
  String get fuelDiesel => 'Дизель';

  @override
  String get fuelLpg => 'СУГ';

  @override
  String get fuelCng => 'КПГ';

  @override
  String get fuelHydrogen => 'Водород';

  @override
  String get fuelEthanol => 'Этанол';

  @override
  String get powertrainCombustion => 'ДВС';

  @override
  String get powertrainHybrid => 'Гибрид';

  @override
  String get powertrainPluginHybrid => 'Подзаряжаемый гибрид';

  @override
  String get powertrainElectric => 'Электро';

  @override
  String get catalogDb => 'База данных каталога';

  @override
  String get catalogSourceBuiltin => 'Встроенная (по умолчанию)';

  @override
  String get catalogSourceOnline => 'Онлайн (релиз GitHub)';

  @override
  String get catalogSourcesTitle => 'Доступные каталоги';

  @override
  String get catalogCannotDelete => 'Каталог по умолчанию — нельзя удалить';

  @override
  String catalogVersionOf(String version) {
    return 'Версия $version';
  }

  @override
  String get catalogVersionUnknown => 'Версия недоступна';

  @override
  String get catalogRefreshOnline => 'Обновить онлайн-каталог';

  @override
  String get catalogRefreshed => 'Онлайн-каталог обновлён';

  @override
  String get catalogRefreshFailed => 'Не удалось обновить онлайн-каталог';

  @override
  String get catalogNotAvailable => 'Этот каталог недоступен';

  @override
  String get catalogImportDb => 'Импортировать локальную БД';

  @override
  String get catalogImported => 'Каталог импортирован';

  @override
  String get catalogImportFailed => 'Не удалось импортировать каталог';

  @override
  String get catalogDelete => 'Удалить каталог';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Удалить $name? Это действие нельзя отменить.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Не удалось загрузить онлайн-каталог. Проверьте соединение и попробуйте снова.';

  @override
  String get templateUrlExample =>
      'Пример: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> заменяется на последний релиз этого репозитория. Вы можете использовать любой репозиторий GitHub или вставить прямую ссылку. Если тег не удаётся определить, ссылка используется как есть, и тест покажет ошибку.';

  @override
  String get templateUrlUsage =>
      'Используется для получения каталога, индекса шаблонов и переводов (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Разрешается в: $url';
  }

  @override
  String get templateUrlVersion => 'Версия';

  @override
  String get templateUrlLatest => 'Последняя (<tag>)';

  @override
  String get templateUrlVersionsFailed => 'Не удалось загрузить версии';

  @override
  String get templateUrlHelp => 'Справка по URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL репозитория';

  @override
  String get moreTemplateSourceVersionLatest => 'Последняя';

  @override
  String catalogDbVersion(String version) {
    return 'Версия БД: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Релиз: $version';
  }

  @override
  String get createInheritedParts => 'Наследуемые запчасти (из extends)';

  @override
  String get createInheritedItems => 'Наследуемое обслуживание (из extends)';

  @override
  String get templateExtendsNotLoaded =>
      'Некоторые расширения не удалось загрузить';

  @override
  String get templateRepoLoading => 'Загрузка из репозитория шаблонов…';

  @override
  String get templateRepoError =>
      'Не удалось связаться с репозиторием шаблонов';

  @override
  String templateBy(String author) {
    return 'от $author';
  }
}
