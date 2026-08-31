// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Karter';

  @override
  String get navDashboard => 'Painel';

  @override
  String get navVehicles => 'Veículos';

  @override
  String get navObd => 'OBD II';

  @override
  String get navMore => 'Mais';

  @override
  String get homeEmptyTitle => 'Nenhum veículo';

  @override
  String get homeEmptySubtitle => 'Adicione seu primeiro veículo';

  @override
  String homeError(Object error) {
    return 'Erro: $error';
  }

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get dashboardComingSoon => 'Em breve';

  @override
  String get vehicleDetailTitle => 'Veículo';

  @override
  String get vehicleNotFound => 'Veículo não encontrado';

  @override
  String get plate => 'Placa';

  @override
  String get vin => 'VIN';

  @override
  String get brandModel => 'Marca / Modelo';

  @override
  String get year => 'Ano';

  @override
  String get odometer => 'Odômetro';

  @override
  String get update => 'Atualizar';

  @override
  String get actions => 'Ações';

  @override
  String get tools => 'Ferramentas';

  @override
  String get information => 'Informações';

  @override
  String get fuelLogs => 'Abastecimentos';

  @override
  String get maintenanceHistory => 'Histórico de manutenção';

  @override
  String get configureIntervals => 'Configurar intervalos';

  @override
  String get nextMaintenance => 'Próxima manutenção';

  @override
  String get allIntervalsDisabled => 'Todos os intervalos estão desativados.';

  @override
  String get register => 'Registrar';

  @override
  String get registerService => 'Registrar serviço';

  @override
  String get noDescriptionAvailable =>
      'Nenhuma descrição disponível. Vá para as configurações de manutenção para adicionar uma.';

  @override
  String get close => 'Fechar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get overduePerformService => 'Atrasado — realize o serviço';

  @override
  String nextIn(Object parts) {
    return 'Em $parts';
  }

  @override
  String get vehicleFormNew => 'Novo veículo';

  @override
  String get vehicleFormEdit => 'Editar veículo';

  @override
  String get vehicleFormDetails => 'Detalhes';

  @override
  String get vehicleFormVehicle => 'Veículo';

  @override
  String get brand => 'Marca';

  @override
  String get model => 'Modelo';

  @override
  String get required => 'Obrigatório';

  @override
  String get invalidYear => 'Ano inválido';

  @override
  String get vehicleType => 'Tipo de veículo';

  @override
  String get combustion => 'Combustão';

  @override
  String get electric => 'Elétrico';

  @override
  String get motorcycle => 'Motocicleta';

  @override
  String get plateOptional => 'Placa (opcional)';

  @override
  String get vinOptional => 'VIN (opcional)';

  @override
  String get invalid => 'Inválido';

  @override
  String get aliasOptional => 'Apelido (opcional)';

  @override
  String get aliasHint => 'Ex.: Minha caranga, A fera, etc.';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get addVehicle => 'Adicionar veículo';

  @override
  String get newVehicleServicesOverdueTitle =>
      'Serviços aparecem como atrasados';

  @override
  String get newVehicleServicesOverdueBody =>
      'Como seu veículo já tem mais de 500 km, todos os serviços de manutenção aparecem como atrasados.\n\nRegistre os serviços que você já realizou. Se não lembrar a quilometragem exata, defina um valor aproximado de km para o último serviço.';

  @override
  String get deleteVehicle => 'Excluir veículo';

  @override
  String get deleteVehicleConfirm =>
      'Esta ação não pode ser desfeita. Todos os abastecimentos, registros de manutenção e intervalos associados serão excluídos.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get resetToDefault => 'Restaurar padrão';

  @override
  String get delete => 'Excluir';

  @override
  String get dataManagerTitle => 'Exportar / Importar dados';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get exporting => 'Exportando...';

  @override
  String get export => 'Exportar';

  @override
  String get importing => 'Importando...';

  @override
  String get import => 'Importar';

  @override
  String get saveExport => 'Salvar exportação';

  @override
  String exportedAt(Object path) {
    return 'Exportado em $path';
  }

  @override
  String exportError(Object error) {
    return 'Erro de exportação: $error';
  }

  @override
  String get importData => 'Importar dados';

  @override
  String importPreview(
    Object documents,
    Object fuelLogs,
    Object maintenanceLogs,
    Object vehicles,
  ) {
    return 'Encontrado:\n• $vehicles veículo(s)\n• $fuelLogs abastecimento(s)\n• $maintenanceLogs registro(s) de manutenção\n• $documents documento(s)\n\nImportar? Os dados existentes com o mesmo ID serão sobrescritos.';
  }

  @override
  String get importSuccess => 'Dados importados com sucesso';

  @override
  String importError(Object error) {
    return 'Erro de importação: $error';
  }

  @override
  String get invalidJson => 'Arquivo JSON inválido';

  @override
  String exportShareText(Object count) {
    return 'Exportação Karter — $count veículo(s)';
  }

  @override
  String get maintenanceSettingsTitle => 'Intervalos de manutenção';

  @override
  String get maintenanceSettingsInstruction =>
      'Ative ou desative itens de acordo com as necessidades do seu veículo. Intervalos personalizados podem ser excluídos.';

  @override
  String get km => 'km';

  @override
  String get timeMonths => 'Tempo (meses)';

  @override
  String get partsTitle => 'Peças';

  @override
  String get partUnitUnit => 'unidade';

  @override
  String get partUnitSet => 'conjunto';

  @override
  String get partUnitKit => 'kit';

  @override
  String get partUnitCan => 'lata';

  @override
  String get partUnitLabel => 'Unidade';

  @override
  String get localParts => 'Peças locais';

  @override
  String get intervalParts => 'Peças do intervalo';

  @override
  String get newPart => 'Nova peça';

  @override
  String get createPart => 'Criar peça';

  @override
  String get partsSection => 'Peças';

  @override
  String get usedParts => 'Peças';

  @override
  String usedInServicesCount(Object count) {
    return '$count serviço(s)';
  }

  @override
  String deletePartConfirm(Object count) {
    return 'Esta peça é usada em $count serviço(s). Excluir mesmo assim?';
  }

  @override
  String get reportPartsHeader => 'Peças';

  @override
  String get templateFound => 'Modelo encontrado';

  @override
  String get templateDisclaimer =>
      'Os dados do modelo são apenas referência. Sempre confira os intervalos no manual do seu veículo.';

  @override
  String get noTemplate => 'Nenhum modelo';

  @override
  String get useTemplate => 'Usar modelo';

  @override
  String get searchTemplate => 'Buscar modelo';

  @override
  String templateWithName(Object name) {
    return 'Modelo: $name';
  }

  @override
  String get noResultsTitle => 'Sem resultados';

  @override
  String get noTemplateFoundDescription =>
      'Nenhum modelo encontrado para os dados informados.';

  @override
  String get searchParameters => 'Parâmetros de busca:';

  @override
  String get defaultIntervalsHint => 'O veículo usará os intervalos padrão.';

  @override
  String get missingTemplateContribute =>
      'Faltou um modelo? Contribua em github.com/abrahdev/karter';

  @override
  String get viewAllTemplates => 'Ver todos os modelos';

  @override
  String get contribute => 'Contribuir';

  @override
  String get contributeOnGitHub => 'Contribuir no GitHub';

  @override
  String get gotIt => 'Entendi';

  @override
  String get templateUnderConstruction => 'Modelo em construção';

  @override
  String get templateNotReady =>
      'Este modelo ainda não está pronto.\nEstamos trabalhando nisso!';

  @override
  String get contributionsWelcome =>
      'Contribuições são bem-vindas — adicione ou corrija modelos para o seu veículo:';

  @override
  String requestedParam(Object params) {
    return 'Solicitado: $params';
  }

  @override
  String get deleteIntervalConfirm =>
      'Tem certeza de que deseja excluir este intervalo?';

  @override
  String get addPart => 'Adicionar peça';

  @override
  String get partName => 'Nome da peça';

  @override
  String get quantity => 'Qtd';

  @override
  String get oemNumber => 'Número OEM';

  @override
  String get addLink => 'Adicionar link';

  @override
  String get linkUrl => 'URL';

  @override
  String get openLink => 'Abrir';

  @override
  String get noLinks => 'Sem links';

  @override
  String get noParts => 'Nenhuma peça ainda';

  @override
  String get invalidUrl => 'URL inválida';

  @override
  String get copied => 'Copiado';

  @override
  String get linksTitle => 'Links de referência';

  @override
  String get copy => 'Copiar';

  @override
  String get addModeManual => 'Manual';

  @override
  String get addModeTemplate => 'Modelo';

  @override
  String get newFromTemplate => 'Novo a partir de modelo';

  @override
  String get updatesAvailable => 'Atualizações disponíveis';

  @override
  String get restore => 'Restaurar';

  @override
  String get windowMinimize => 'Minimizar';

  @override
  String get windowMaximize => 'Maximizar';

  @override
  String get windowClose => 'Fechar';

  @override
  String get syncInstruction =>
      'Sincronize os intervalos de manutenção com o modelo do seu veículo.';

  @override
  String get upToDate => 'Tudo atualizado';

  @override
  String get syncAdded => 'Intervalo adicionado do modelo';

  @override
  String get syncRestored => 'Intervalo restaurado do modelo';

  @override
  String get months => 'meses';

  @override
  String get description => 'Descrição';

  @override
  String get newInterval => 'Novo intervalo';

  @override
  String get name => 'Nome';

  @override
  String get add => 'Adicionar';

  @override
  String get edit => 'Editar';

  @override
  String get addToDashboard => 'Adicionar ao painel';

  @override
  String get setupNotifications => 'Configurar notificações';

  @override
  String get addToDashboardComingSoon => 'Em breve';

  @override
  String get deleteInterval => 'Excluir';

  @override
  String get noDescriptionAvailableSettings =>
      'Nenhuma descrição disponível. Pressione \"Editar\" para adicionar uma.';

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
    return 'a cada $km';
  }

  @override
  String intervalSubtitleMonths(Object months) {
    return '$months meses';
  }

  @override
  String get maintenanceLogTitleEdit => 'Editar serviço';

  @override
  String get maintenanceLogTitleNew => 'Novo serviço';

  @override
  String date(Object date) {
    return 'Data: $date';
  }

  @override
  String get descriptionRequired => 'Descrição';

  @override
  String get odometerAtService => 'Odômetro no serviço (opcional)';

  @override
  String get resetInterval => 'Redefinir intervalo (opcional)';

  @override
  String get saveChangesShort => 'Salvar alterações';

  @override
  String get saveService => 'Salvar serviço';

  @override
  String get saveFile => 'Salvar arquivo';

  @override
  String get lastService => 'Último';

  @override
  String get addPhoto => 'Adicionar foto';

  @override
  String get photos => 'fotos';

  @override
  String get files => 'arquivos';

  @override
  String get share => 'Compartilhar';

  @override
  String get deleteService => 'Excluir serviço';

  @override
  String get deleteServiceConfirm =>
      'Tem certeza de que deseja excluir este serviço?';

  @override
  String get maintenanceListTitle => 'Manutenção';

  @override
  String get maintenanceEmpty => 'Nenhum serviço registrado';

  @override
  String get maintenanceHistoryTab => 'Histórico';

  @override
  String get maintenancePdfExportTab => 'Exportar PDF';

  @override
  String maintenanceServicesInPeriod(Object count) {
    return '$count serviço(s) neste período';
  }

  @override
  String maintenanceMoreServices(Object count) {
    return '... e mais $count';
  }

  @override
  String get maintenanceNoServicesInRange =>
      'Nenhum serviço neste intervalo de datas.';

  @override
  String get maintenanceExportPdf => 'Exportar PDF';

  @override
  String get maintenanceSharePdf => 'Compartilhar';

  @override
  String get maintenanceReportTitle => 'Relatório de manutenção';

  @override
  String maintenanceReportGenerated(Object date, Object time) {
    return 'Gerado em $date $time';
  }

  @override
  String get maintenanceReportEmpty =>
      'Nenhum registro de manutenção neste período.';

  @override
  String get maintenanceReportDateHeader => 'Data';

  @override
  String get maintenanceReportDescHeader => 'Descrição';

  @override
  String get maintenanceReportOdometerHeader => 'Odômetro';

  @override
  String get addDocument => 'Adicionar documento';

  @override
  String get documentType => 'Tipo de documento';

  @override
  String get selectFile => 'Selecionar arquivo';

  @override
  String get noFileSelected => 'Nenhum arquivo selecionado';

  @override
  String get notesOptional => 'Notas (opcional)';

  @override
  String get expiryDateOptional => 'Data de validade (opcional)';

  @override
  String get pleaseSelectFile => 'Selecione um arquivo';

  @override
  String get documentSaved => 'Documento salvo';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get browseFiles => 'Procurar arquivos';

  @override
  String get docTypeFine => 'Multa';

  @override
  String get docTypeParkingFee => 'Taxa de estacionamento';

  @override
  String get docTypeInsurance => 'Seguro';

  @override
  String get docTypeVehicleCheck => 'Vistoria do veículo';

  @override
  String get docTypeTax => 'Imposto';

  @override
  String get docTypeComplexInsurance => 'Seguro abrangente';

  @override
  String get docTypeVehicleRegister => 'Registro do veículo';

  @override
  String get docTypeOther => 'Outro';

  @override
  String get vehicleDocuments => 'Documentos';

  @override
  String get fuelFormTitle => 'Novo abastecimento';

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
  String get pricePerUnit => 'Preço por unidade (opcional)';

  @override
  String get fullTank => 'Tanque cheio';

  @override
  String get volumeUnit => 'Unidade de volume do combustível';

  @override
  String get currency => 'Moeda';

  @override
  String get cost => 'Custo (opcional)';

  @override
  String get saveFuelUp => 'Salvar abastecimento';

  @override
  String get fuelListTitle => 'Abastecimentos';

  @override
  String get fuelEmpty => 'Nenhum abastecimento registrado';

  @override
  String get moreAbout => 'Sobre o Karter';

  @override
  String get moreDescription =>
      'O Karter é um aplicativo de manutenção de veículos de código aberto, local-first, que respeita sua privacidade.';

  @override
  String get moreExport => 'Exportar / Importar dados';

  @override
  String get moreExportSubtitle => 'Faça backup ou transfira suas informações';

  @override
  String get moreDocs => 'Documentação';

  @override
  String get moreDocsSubtitle => 'Guia de uso e recursos';

  @override
  String get moreSource => 'Código-fonte';

  @override
  String get moreSourceSubtitle => 'Repositório no GitHub';

  @override
  String get moreDonate => 'Doar';

  @override
  String get moreDonateSubtitle => 'Ajude o desenvolvimento no GitHub Sponsors';

  @override
  String get moreFooter => 'Feito com ❤️ por abrahdev';

  @override
  String get moreRate => 'Avalie o Karter';

  @override
  String get moreRateSubtitle => 'Deixe uma avaliação na Play Store';

  @override
  String get moreFeedback => 'Avalie o aplicativo';

  @override
  String get moreFeedbackSubtitle => 'Avalie o app e configure lembretes';

  @override
  String get feedbackTitle => 'Feedback';

  @override
  String get sectionPreferences => 'Preferências';

  @override
  String get sectionData => 'Dados';

  @override
  String get sectionFeedbackCommunity => 'Feedback e comunidade';

  @override
  String get sectionTips => 'Programa de gorjetas';

  @override
  String get sectionAbout => 'Sobre o Karter';

  @override
  String get theme => 'Tema';

  @override
  String get themeAutomatic => 'Automático';

  @override
  String get themeAutomaticDesc => 'Seguir configuração do dispositivo';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeSystemDesc => 'Seguir configuração do dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get colorScheme => 'Cor primária';

  @override
  String get colorCustom => 'Personalizada';

  @override
  String get colorOfInterface => 'Cor da interface';

  @override
  String get colorOfInterfaceDesc =>
      'Aplicar a cor primária às superfícies de fundo';

  @override
  String get customColor => 'Cor personalizada';

  @override
  String get customColorDesc =>
      'Use uma cor pessoal em vez do acento do sistema';

  @override
  String get selectColor => 'Selecione uma cor';

  @override
  String get hapticFeedback => 'Feedback tátil';

  @override
  String get hapticFeedbackDesc => 'Vibrar nas interações';

  @override
  String get hapticModeOff => 'Desativado';

  @override
  String get hapticModeOffDesc => 'Sem vibração nas interações';

  @override
  String get hapticModeClear => 'Nítido';

  @override
  String get hapticModeClearDesc => 'Uma vibração curta por ação';

  @override
  String get hapticModeRich => 'Rico';

  @override
  String get hapticModeRichDesc =>
      'Vibrações em camadas com intensidade variada';

  @override
  String get testNotification => 'Testar notificação';

  @override
  String get testNotificationDesc =>
      'Envie uma notificação de teste para verificar a configuração';

  @override
  String get testNotificationSent => 'Notificação de teste enviada';

  @override
  String get notificationsPermissionTitle => 'Notificações desativadas';

  @override
  String get notificationsPermissionDesc =>
      'Ative as notificações para receber lembretes de odômetro e manutenção';

  @override
  String get notificationsPermissionAllow => 'Permitir notificações';

  @override
  String get notificationsPermissionDeniedTitle => 'Notificações bloqueadas';

  @override
  String get notificationsPermissionDeniedDesc =>
      'A permissão de notificação foi negada permanentemente. Para ativá-la, vá em Configurações > Apps > Karter > Notificações e ligue.';

  @override
  String get notificationsPermissionDeniedStep1 =>
      '1. Abra as Configurações do dispositivo';

  @override
  String get notificationsPermissionDeniedStep2 => '2. Vá em Apps > Karter';

  @override
  String get notificationsPermissionDeniedStep3 => '3. Toque em Notificações';

  @override
  String get notificationsPermissionDeniedStep4 =>
      '4. Ative \"Mostrar notificações\"';

  @override
  String get notificationsPermissionOpenSettings => 'Abrir Configurações';

  @override
  String get shakeToOdometer => 'Agitar para atualizar o odômetro';

  @override
  String get shakeToOdometerDesc =>
      'Agite o dispositivo para abrir a atualização do odômetro na tela do veículo';

  @override
  String get feedbackReminderToggle => 'Lembrete de avaliação';

  @override
  String get feedbackReminderToggleSubtitle =>
      'Mostrar um lembrete para avaliar o app após salvar serviços';

  @override
  String get feedbackServicesInterval => 'Serviços antes do aviso';

  @override
  String feedbackServicesIntervalValue(Object count) {
    return 'Após $count serviço(s)';
  }

  @override
  String get feedbackServicesSuffix => 'serviços';

  @override
  String get feedbackRepeatDays => 'Intervalo do lembrete';

  @override
  String feedbackRepeatDaysValue(Object days) {
    return 'A cada $days dia(s)';
  }

  @override
  String get feedbackRepeatDaysSuffix => 'dias';

  @override
  String get ratePromptMessage =>
      'Gostando do Karter? Uma avaliação ajuda outras pessoas a descobrirem o app!';

  @override
  String get rate => 'Avaliar';

  @override
  String moreUrlError(Object url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get tipProgram => 'Programa de gorjetas';

  @override
  String get tipProgramComingSoon =>
      'Este recurso está em desenvolvimento e estará disponível em breve.';

  @override
  String get tipBadges => 'Distintivos';

  @override
  String get tipBadgesNone => 'Nenhum';

  @override
  String get tipInfo => 'Informações';

  @override
  String get tipInfoText =>
      'O programa de gorjetas é uma forma de os usuários demonstrarem apoio e apreço extra pelo suporte rápido, melhorias constantes e atualizações contínuas que o Karter oferece.';

  @override
  String get tipOneTime => 'Gorjeta única';

  @override
  String get tipRecurring => 'Gorjeta recorrente';

  @override
  String get tipBronze => 'Bronze';

  @override
  String get tipSilver => 'Prata';

  @override
  String get tipGold => 'Ouro';

  @override
  String get tipBronzePrice => 'Gorjeta Bronze';

  @override
  String get tipSilverPrice => 'Gorjeta Prata';

  @override
  String get tipGoldPrice => 'Gorjeta Ouro';

  @override
  String get tipBronzeMonthly => 'Bronze / mês';

  @override
  String get tipSilverMonthly => 'Prata / mês';

  @override
  String get tipGoldMonthly => 'Ouro / mês';

  @override
  String get officialWebsite => 'Site oficial';

  @override
  String get communityForums => 'Fóruns da comunidade';

  @override
  String get translations => 'Traduções';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyPolicyDesc => 'Leia nossa política de privacidade online.';

  @override
  String get openPrivacyPolicy => 'Abrir política de privacidade';

  @override
  String get version => 'Versão';

  @override
  String get deviceId => 'ID do dispositivo';

  @override
  String get changelog => 'Changelog';

  @override
  String get openSourceLicenses => 'Licenças de código aberto';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get eesti => 'Eesti';

  @override
  String get odometerUpdateTitle => 'Atualizar odômetro';

  @override
  String odometerLastReading(Object unit, Object value) {
    return 'Última: $value $unit';
  }

  @override
  String odometerLowerWarning(Object unit, Object value) {
    return 'O valor é menor do que o último registro ($value $unit).';
  }

  @override
  String odometerDeltaWarning(Object delta, Object unit) {
    return 'Você dirigiu $delta $unit desde a última vez. Está correto?';
  }

  @override
  String get odometerSave => 'Salvar';

  @override
  String get odometerCancel => 'Cancelar';

  @override
  String get moreNotifications => 'Notificações';

  @override
  String get moreNotificationsSubtitle => 'Lembretes de odômetro e manutenção';

  @override
  String get notificationSettingsTitle => 'Configurações de notificação';

  @override
  String get notificationSettingsSubtitle =>
      'Configure lembretes para este veículo';

  @override
  String get notificationOdometerSection => 'Lembrete de odômetro';

  @override
  String get notificationMaintenanceSection => 'Lembrete de manutenção';

  @override
  String get notificationFreqLabel => 'Frequência do lembrete';

  @override
  String get notificationFreqOff => 'Desativado';

  @override
  String notificationFreqValue(Object days) {
    return 'A cada $days dias';
  }

  @override
  String get notificationMaintenanceToggle => 'Lembretes de manutenção';

  @override
  String get notificationMaintenanceToggleSubtitle =>
      'Receba lembretes diários sobre manutenções pendentes';

  @override
  String notificationSnoozedBanner(Object days) {
    return 'Adiado por mais $days dia(s)';
  }

  @override
  String get notificationSnoozeCancel => 'Cancelar adiamento';

  @override
  String get notificationNoVehicles =>
      'Adicione um veículo para configurar notificações';

  @override
  String notificationVehicleSubtitle(Object freq, Object maint) {
    return 'Odômetro: $freq • Manutenção: $maint';
  }

  @override
  String get notificationConfigure => 'Configurar';

  @override
  String get notificationMaintOn => 'Ativado';

  @override
  String get notificationMaintOff => 'Desativado';

  @override
  String get notificationSnoozeAction => 'Adiar por 1 semana';

  @override
  String notificationSnoozeConfirm(Object date) {
    return 'Adiado até $date';
  }

  @override
  String get notificationFreqWeekly => 'A cada 7 dias';

  @override
  String get notificationFreqMonthly => 'A cada 30 dias';

  @override
  String get notificationFreqCustom => 'Personalizado';

  @override
  String notificationFreqDays(Object days) {
    return '$days dias';
  }

  @override
  String get notificationMaintenanceSnooze => 'Adiar manutenção por 1 semana';

  @override
  String get notificationSnoozeToggle => 'Adiar lembretes';

  @override
  String notificationSnoozeDays(Object days) {
    return '$days dias';
  }

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get discardChangesConfirm =>
      'Você tem alterações não salvas. Tem certeza de que deseja sair?';

  @override
  String get discard => 'Descartar';

  @override
  String get moreTemplateSource => 'Origem dos modelos';

  @override
  String get moreTemplateSourceSubtitle =>
      'Buscar modelos do GitHub ou usar recursos locais';

  @override
  String get moreTemplateSourceOffline => 'Local (offline)';

  @override
  String get moreTemplateSourceOnline => 'Online (GitHub)';

  @override
  String get moreTemplateSourceUrl => 'URL do repositório';

  @override
  String get moreTemplateSourceReset => 'Restaurar padrão';

  @override
  String get moreTemplateSourceUrlHint =>
      'https://github.com/abrahdev/karter/templates';

  @override
  String get moreTemplateSourceEditUrl => 'Editar URL';

  @override
  String get moreTemplateSourceUrlSaved => 'URL atualizada';

  @override
  String get testConnection => 'Testar conexão';

  @override
  String catalogDbModifiedAt(String date) {
    return 'Última modificação: $date';
  }

  @override
  String get importCheckTranslations => 'Traduções';

  @override
  String importCheckTranslationsResult(int found, int total) {
    return '$found de $total disponíveis';
  }

  @override
  String get importCheckIndex => 'Índice de modelos';

  @override
  String importCheckIndexResult(int count) {
    return '$count modelos';
  }

  @override
  String get importCheckDb => 'Banco de dados do catálogo (remoto)';

  @override
  String get importCheckDbRemoteFound => 'Disponível no GitHub';

  @override
  String get importCheckDbRemoteNotFound => 'Somente local (não no GitHub)';

  @override
  String get importCheckDbLocal => 'Dados do banco de dados importado';

  @override
  String importCheckCatalogVersion(String version) {
    return 'Versão: $version';
  }

  @override
  String importCheckVehicles(int count) {
    return 'Veículos: $count';
  }

  @override
  String importCheckMaintenanceItems(int count) {
    return 'Itens de manutenção: $count';
  }

  @override
  String importCheckParts(int count) {
    return 'Peças: $count';
  }

  @override
  String importCheckObdCodes(int count) {
    return 'Códigos OBD: $count';
  }

  @override
  String get importCheckDbLocalFailed =>
      'Não foi possível ler o banco de dados importado';

  @override
  String get onboardingSkip => 'Pular';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingDone => 'Começar';

  @override
  String get onboardingReplay => 'Ver introdução';

  @override
  String get onboardingReplaySubtitle =>
      'Reexibir a apresentação de boas-vindas';

  @override
  String get onboardingWelcomeTitle => 'Bem-vindo ao Karter';

  @override
  String get onboardingWelcomeDesc =>
      'Um aplicativo de manutenção de veículos de código aberto, focado em privacidade. 100% offline — sem contas, sem telemetria, sem rastreamento.';

  @override
  String get onboardingVehicleTitle => 'Adicione seu veículo';

  @override
  String get onboardingVehicleDesc =>
      'Registre seu carro, moto ou elétrico. Escolha um modelo e o Karter preenche automaticamente os intervalos de manutenção para o seu modelo.';

  @override
  String get onboardingTrackTitle => 'Acompanhe combustível e manutenção';

  @override
  String get onboardingTrackDesc =>
      'Registre abastecimentos com cálculo automático de consumo (MPG, L/100km, km/L). Acompanhe reparos, peças e custos.';

  @override
  String get onboardingRemindersTitle => 'Fique em dia com o serviço';

  @override
  String get onboardingRemindersDesc =>
      'Receba notificações quando chegar a hora de trocar o óleo, pastilhas de freio e de cada intervalo de manutenção — por distância ou tempo.';

  @override
  String get supporterBadge => 'Você é um apoiador do Karter!';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get tipPurchased => 'Obrigado!';

  @override
  String get tipSupport => 'Apoio';

  @override
  String get sectionBackup => 'Backup';

  @override
  String get moreBackup => 'Backup';

  @override
  String get moreBackupSubtitle => 'Backup criptografado';

  @override
  String get backupConnect => 'Conectar ao Google Drive';

  @override
  String backupConnected(Object email) {
    return 'Conectado como $email';
  }

  @override
  String get backupNow => 'Fazer backup agora';

  @override
  String get backupInProgress => 'Fazendo backup…';

  @override
  String backupLast(Object date) {
    return 'Último backup: $date';
  }

  @override
  String get backupNever => 'Nunca foi feito backup';

  @override
  String get backupRestore => 'Restaurar do backup';

  @override
  String get backupRestoreInProgress => 'Restaurando…';

  @override
  String get backupRestoreConfirm =>
      'Isso sobrescreverá todos os dados atuais. Tem certeza?';

  @override
  String backupError(Object error) {
    return 'Erro de backup: $error';
  }

  @override
  String get backupSuccess => 'Backup enviado com sucesso';

  @override
  String get backupRestoreSuccess =>
      'Dados restaurados. Reinicie o app para ver as alterações.';

  @override
  String get backupDisconnect => 'Desconectar';

  @override
  String get backupNoBackups => 'Nenhum backup encontrado';

  @override
  String get backupRestoreBtn => 'Restaurar';

  @override
  String get backupDelete => 'Excluir';

  @override
  String backupDeleteConfirm(Object name) {
    return 'Excluir o backup $name?';
  }

  @override
  String get backupDeleteSuccess => 'Backup excluído';

  @override
  String backupCount(Object current, Object max) {
    return 'Backups: $current/$max';
  }

  @override
  String get dtcLookupTitle => 'Consulta de códigos de falha';

  @override
  String get dtcSearchHint => 'Digite um código, ex. P0171';

  @override
  String get dtcEmptyState => 'Digite um código para consultar sua descrição';

  @override
  String get dtcNoMatch => 'Nenhum código corresponde à sua busca';

  @override
  String get dtcDescription => 'Descrição';

  @override
  String get dtcRelatedMaintenance => 'Manutenção relacionada';

  @override
  String get dtcScopeStandard => 'Padrão';

  @override
  String get dtcScopeManufacturer => 'Fabricante';

  @override
  String get dtcGeneralDb => 'Códigos OBD-II gerais';

  @override
  String get dtcCatalogBrands => 'Marcas do catálogo';

  @override
  String get dtcMyVehicles => 'Meus veículos';

  @override
  String get dtcVehicle => 'Veículo';

  @override
  String get dtcVehicleNotFound => 'Veículo não encontrado';

  @override
  String get dtcLoadError => 'Não foi possível carregar os códigos de falha';

  @override
  String get notificationOdometerTitle => 'Atualizar odômetro';

  @override
  String notificationOdometerBody(String name, int days) {
    return '$name — $days dias desde o último lembrete.';
  }

  @override
  String get notificationMaintenanceTitle => 'Manutenção pendente';

  @override
  String notificationMaintenanceBody(String name) {
    return '$name — confira seus intervalos de manutenção.';
  }

  @override
  String errorGeneric(String error) {
    return 'Erro: $error';
  }

  @override
  String get deleteFuelUp => 'Excluir abastecimento';

  @override
  String get deleteFuelUpConfirm =>
      'Tem certeza de que deseja excluir este abastecimento?';

  @override
  String get editFuelUp => 'Editar abastecimento';

  @override
  String get deleteDocument => 'Excluir documento';

  @override
  String get deleteDocumentConfirm =>
      'Tem certeza de que deseja excluir este documento?';

  @override
  String get editDocument => 'Editar documento';

  @override
  String get title => 'Título';

  @override
  String get selectExpiryDate => 'Selecionar data de validade';

  @override
  String get addMoreFiles => 'Adicionar mais arquivos';

  @override
  String get consumptionUnit => 'L/100km';

  @override
  String get sectionTemplates => 'Modelos';

  @override
  String get templatesTitle => 'Modelos';

  @override
  String get templatesSubtitle => 'Explore o catálogo de modelos da comunidade';

  @override
  String get createTemplate => 'Criar modelo';

  @override
  String get createTemplateSubtitle => 'Crie um modelo e exporte como JSON';

  @override
  String get templatesLoadError =>
      'Não foi possível carregar o catálogo de modelos.';

  @override
  String get searchTemplatesHint => 'Busque por marca, modelo ou geração';

  @override
  String get allMakes => 'Todas as marcas';

  @override
  String get noTemplatesFound => 'Nenhum modelo corresponde à sua busca.';

  @override
  String templateItemsCount(int count) {
    return '$count itens de manutenção';
  }

  @override
  String get templateYearsOpen => 'presente';

  @override
  String get templateNotFound => 'Modelo não encontrado';

  @override
  String get templateInfo => 'Informações do modelo';

  @override
  String get templateYears => 'Anos';

  @override
  String get templateEngine => 'Motor';

  @override
  String get templateAuthor => 'Autor';

  @override
  String get templateVersion => 'Versão';

  @override
  String get templateSources => 'Fontes';

  @override
  String get dtcCodesTitle => 'Códigos de falha';

  @override
  String dtcCount(int count) {
    return '$count código(s) de falha';
  }

  @override
  String get noPartsFound => 'Nenhuma peça';

  @override
  String get createCopied =>
      'JSON do modelo copiado para a área de transferência';

  @override
  String get saveTemplate => 'Salvar modelo';

  @override
  String savedAt(String path) {
    return 'Salvo em $path';
  }

  @override
  String get createHasErrors => 'Corrija os erros para exportar';

  @override
  String get createMake => 'Marca';

  @override
  String get createModel => 'Modelo';

  @override
  String get createGeneration => 'Geração';

  @override
  String get createYearFrom => 'Ano inicial';

  @override
  String get createYearTo => 'Ano final';

  @override
  String get createFuel => 'Combustível';

  @override
  String get createPowertrain => 'Motorização';

  @override
  String get createEngineCode => 'Código do motor';

  @override
  String get createDisplacement => 'Cilindrada (cc)';

  @override
  String get createPower => 'Potência (cv)';

  @override
  String get templateMetadata => 'Metadados e herança';

  @override
  String get createAuthor => 'Autor';

  @override
  String get createAuthorHint => 'Seu nome de usuário no GitHub';

  @override
  String get createExtends => 'Estende (modelos base)';

  @override
  String get createExtendsHint => 'Herdar dados de manutenção compartilhados';

  @override
  String get createCustomExtends => 'Caminhos de extends personalizados';

  @override
  String get createAddPart => 'Adicionar peça';

  @override
  String get createNoParts => 'Nenhuma peça ainda. Peças são opcionais.';

  @override
  String get partSingular => 'Peça';

  @override
  String get createAddItem => 'Adicionar item de manutenção';

  @override
  String get createNoItems => 'Nenhum item de manutenção ainda.';

  @override
  String get createPreview => 'Pré-visualização';

  @override
  String createErrorsFound(int count) {
    return '$count erro(s) de validação';
  }

  @override
  String get createCopy => 'Copiar';

  @override
  String get createShare => 'Compartilhar';

  @override
  String get createSave => 'Salvar';

  @override
  String get createQuantity => 'Quantidade';

  @override
  String get createI18nKey => 'chave i18n';

  @override
  String get createDescI18nKey => 'chave i18n da descrição';

  @override
  String get createIntervalKm => 'Intervalo (km)';

  @override
  String get createIntervalMonths => 'Intervalo (meses)';

  @override
  String get createDescription => 'Descrição';

  @override
  String get createAddPartRef => 'Adicionar referência de peça';

  @override
  String get createFieldId => 'ID';

  @override
  String get createFieldName => 'Nome';

  @override
  String get createFieldUnit => 'Unidade';

  @override
  String get createFieldOem => 'Número OEM';

  @override
  String get createFieldLabel => 'Rótulo';

  @override
  String get createFieldPart => 'Peça';

  @override
  String get fuelGasoline => 'Gasolina';

  @override
  String get fuelDiesel => 'Diesel';

  @override
  String get fuelLpg => 'GLP';

  @override
  String get fuelCng => 'GNV';

  @override
  String get fuelHydrogen => 'Hidrogênio';

  @override
  String get fuelEthanol => 'Etanol';

  @override
  String get powertrainCombustion => 'Combustão';

  @override
  String get powertrainHybrid => 'Híbrido';

  @override
  String get powertrainPluginHybrid => 'Híbrido plug-in';

  @override
  String get powertrainElectric => 'Elétrico';

  @override
  String get catalogDb => 'Banco de dados do catálogo';

  @override
  String get catalogSourceBuiltin => 'Incluído (padrão)';

  @override
  String get catalogSourceOnline => 'Online (release do GitHub)';

  @override
  String get catalogSourcesTitle => 'Catálogos disponíveis';

  @override
  String get catalogCannotDelete => 'Catálogo padrão — não pode ser excluído';

  @override
  String catalogVersionOf(String version) {
    return 'Versão $version';
  }

  @override
  String get catalogVersionUnknown => 'Versão indisponível';

  @override
  String get catalogRefreshOnline => 'Atualizar catálogo online';

  @override
  String get catalogRefreshed => 'Catálogo online atualizado';

  @override
  String get catalogRefreshFailed =>
      'Não foi possível atualizar o catálogo online';

  @override
  String get catalogNotAvailable => 'Este catálogo não está disponível';

  @override
  String get catalogImportDb => 'Importar banco de dados local';

  @override
  String get catalogImported => 'Catálogo importado';

  @override
  String get catalogImportFailed => 'Não foi possível importar o catálogo';

  @override
  String get catalogDelete => 'Excluir catálogo';

  @override
  String catalogDeleteConfirm(String name) {
    return 'Excluir $name? Esta ação não pode ser desfeita.';
  }

  @override
  String get catalogOnlineUnavailable =>
      'Não foi possível baixar o catálogo online. Verifique sua conexão e tente novamente.';

  @override
  String get templateUrlExample =>
      'Exemplo: https://raw.githubusercontent.com/abrahdev/karter/<tag>/templates';

  @override
  String get templateUrlTagExplanation =>
      '<tag> é substituído pela versão mais recente daquele repositório. Você pode usar qualquer repositório do GitHub ou colar um link direto. Se a tag não puder ser resolvida, o link é usado como está e o teste mostrará a falha.';

  @override
  String get templateUrlUsage =>
      'Usado para buscar o catálogo, o índice de modelos e as traduções (i18n).';

  @override
  String templateUrlResolvesTo(String url) {
    return 'Resolve para: $url';
  }

  @override
  String get templateUrlVersion => 'Versão';

  @override
  String get templateUrlLatest => 'Mais recente (<tag>)';

  @override
  String get templateUrlVersionsFailed =>
      'Não foi possível carregar as versões';

  @override
  String get templateUrlHelp => 'Ajuda da URL';

  @override
  String get moreTemplateSourceUrlLabel => 'URL do repositório';

  @override
  String get moreTemplateSourceVersionLatest => 'Mais recente';

  @override
  String catalogDbVersion(String version) {
    return 'Versão do banco de dados: $version';
  }

  @override
  String templateSourceRelease(String version) {
    return 'Release: $version';
  }

  @override
  String get createInheritedParts => 'Peças herdadas (de extends)';

  @override
  String get createInheritedItems => 'Manutenção herdada (de extends)';

  @override
  String get templateExtendsNotLoaded =>
      'Alguns extends não puderam ser carregados';

  @override
  String get templateRepoLoading => 'Carregando do repositório de modelos…';

  @override
  String get templateRepoError =>
      'Não foi possível acessar o repositório de modelos';

  @override
  String templateBy(String author) {
    return 'por $author';
  }
}
