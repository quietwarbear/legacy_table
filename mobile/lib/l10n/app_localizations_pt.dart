// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'Não foi possível abrir a página de exclusão de conta';

  @override
  String get settingsFailedToLoadMembers =>
      'Falha ao carregar os membros da família';

  @override
  String get settingsInviteCodeCopied => 'Código de convite copiado!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Entre na minha família \"$name\" no Legacy Table!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'Código de convite: $code';
  }

  @override
  String get settingsLeaveFamily => 'Sair da família';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'Tem certeza de que deseja sair de \"$name\"? Você precisará de um código de convite para voltar.';
  }

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsLeave => 'Sair';

  @override
  String get settingsLeftFamilySuccess => 'Você saiu da família com sucesso';

  @override
  String get settingsFailedToLeaveFamily => 'Falha ao sair da família';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'Você precisa transferir o papel de guardião antes de sair';

  @override
  String get settingsTransferKeeperRole => 'Transferir papel de guardião';

  @override
  String get settingsTransferKeeperPrompt =>
      'Como guardião, você precisa transferir seu papel para outro membro antes de sair. Selecione um membro para se tornar o novo guardião:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'Papel de guardião transferido para $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'Sair da família?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'Você transferiu o papel de guardião com sucesso. Deseja sair da família agora?';

  @override
  String get settingsStay => 'Ficar';

  @override
  String get settingsFailedToTransferKeeper =>
      'Falha ao transferir o papel de guardião';

  @override
  String get settingsRemoveMember => 'Remover membro';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'Tem certeza de que deseja remover \"$name\" de \"$family\"? Essa pessoa precisará de um código de convite para voltar.';
  }

  @override
  String get settingsRemove => 'Remover';

  @override
  String settingsMemberRemoved(String name) {
    return '$name foi removido(a) da família';
  }

  @override
  String get settingsFailedToRemoveMember => 'Falha ao remover o membro';

  @override
  String get settingsManageSubscription => 'Gerenciar assinatura';

  @override
  String get settingsUpgradeToPremium => 'Fazer upgrade para o Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection está ativo';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper está ativo';

  @override
  String get settingsUnlockPremiumFeatures =>
      'Desbloqueie planos familiares, exportações e recursos premium';

  @override
  String get settingsKeeperBadge => 'Guardião';

  @override
  String get settingsMemberBadge => 'Membro';

  @override
  String get settingsInviteCodeLabel => 'Código de convite';

  @override
  String get settingsShareInviteCodeButton => 'Compartilhar código de convite';

  @override
  String get settingsFamilyMembers => 'Membros da família';

  @override
  String get settingsNoMembersFound => 'Nenhum membro encontrado';

  @override
  String get settingsRemoveMemberTooltip => 'Remover membro';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsDarkMode => 'Modo escuro';

  @override
  String get settingsLightMode => 'Modo claro';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsDeleteAccount => 'Excluir conta';

  @override
  String get settingsNotifications => 'Notificações';

  @override
  String get settingsTermsOfUse => 'Termos de uso';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidade';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. Todos os direitos reservados.';

  @override
  String get settingsLogout => 'Sair';

  @override
  String get settingsLogoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get recipeDetailLoadRecipeError =>
      'Falha ao carregar a receita. Tente novamente.';

  @override
  String get recipeDetailLoadCommentsError =>
      'Falha ao carregar os comentários. Tente novamente.';

  @override
  String get recipeDetailLoginToComment =>
      'Faça login para publicar um comentário';

  @override
  String get recipeDetailCommentPosted => 'Comentário publicado com sucesso!';

  @override
  String get recipeDetailPostCommentError => 'Falha ao publicar o comentário';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'Falha ao publicar o comentário: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'Excluir comentário';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'Tem certeza de que deseja excluir este comentário?';

  @override
  String get recipeDetailCancel => 'Cancelar';

  @override
  String get recipeDetailDelete => 'Excluir';

  @override
  String get recipeDetailCommentDeleted => 'Comentário excluído com sucesso';

  @override
  String get recipeDetailDeleteCommentError => 'Falha ao excluir o comentário';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'Falha ao excluir o comentário: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'Receita atualizada com sucesso!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'Excluir receita';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'Tem certeza de que deseja excluir \"$title\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'Receita excluída com sucesso';

  @override
  String get recipeDetailDeleteRecipeError => 'Falha ao excluir a receita';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'Falha ao excluir a receita: $error';
  }

  @override
  String get recipeDetailNotFound => 'Receita não encontrada';

  @override
  String get recipeDetailSharedByLabel => 'Compartilhado por';

  @override
  String get recipeDetailUnknownAuthor => 'Desconhecido';

  @override
  String get recipeDetailEdit => 'Editar';

  @override
  String get recipeDetailStatTime => 'Tempo';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeDetailStatServes => 'Serve';

  @override
  String get recipeDetailStatCategory => 'Categoria';

  @override
  String get recipeDetailIngredients => 'Ingredientes';

  @override
  String get recipeDetailInstructions => 'Instruções';

  @override
  String get recipeDetailStoryTitle => 'A história por trás desta receita';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'Compartilhado por $author';
  }

  @override
  String get recipeDetailFamilyComments => 'Comentários da família';

  @override
  String get recipeDetailRefreshComments => 'Atualizar comentários';

  @override
  String get recipeDetailCommentHint =>
      'Compartilhe o que você achou desta receita...';

  @override
  String get recipeDetailClear => 'Limpar';

  @override
  String get recipeDetailPosting => 'Publicando...';

  @override
  String get recipeDetailPost => 'Publicar';

  @override
  String get recipeDetailNoComments => 'Ainda não há comentários';

  @override
  String get recipeDetailBeFirstToComment =>
      'Seja o primeiro a compartilhar o que pensa!';

  @override
  String get recipeDetailNoImage => 'Nenhuma imagem disponível';

  @override
  String get recipeDetailDeleteCommentTooltip => 'Excluir comentário';

  @override
  String get addRecipePhotoPermissionTitle =>
      'Permissão da biblioteca de fotos';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'A permissão da biblioteca de fotos é necessária para selecionar imagens.\n\nPara ativar:\n1. Toque em \"Abrir configurações\"\n2. Acesse \"Permissões\"\n3. Ative \"Fotos e vídeos\"';

  @override
  String get addRecipeStoragePermissionTitle => 'Permissão de armazenamento';

  @override
  String get addRecipeStoragePermissionMessage =>
      'A permissão de armazenamento é necessária para selecionar imagens.\n\nPara ativar:\n1. Toque em \"Abrir configurações\"\n2. Acesse \"Permissões\"\n3. Ative \"Armazenamento\" ou \"Arquivos e mídia\"';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'A permissão da biblioteca de fotos é necessária para selecionar imagens.\n\nPara ativar:\n1. Toque em \"Abrir configurações\"\n2. Encontre \"Legacy Table\"\n3. Toque em \"Fotos\"\n4. Selecione \"Todas as fotos\" ou \"Fotos selecionadas\"';

  @override
  String get addRecipeCameraPermissionTitle => 'Permissão da câmera';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'A permissão da câmera foi negada permanentemente. Ative-a nas configurações do app.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'A permissão da câmera é necessária para tirar fotos';

  @override
  String get addRecipeCancel => 'Cancelar';

  @override
  String get addRecipeSettingsHintAndroid =>
      'Procure a permissão \"Fotos e vídeos\" ou \"Mídia\" nas configurações do app';

  @override
  String get addRecipeSettingsHintIos =>
      'Procure a permissão \"Fotos\" nas configurações do app';

  @override
  String get addRecipeOpenSettings => 'Abrir configurações';

  @override
  String get addRecipeImageSelectError =>
      'Não foi possível selecionar as imagens. Tente novamente.';

  @override
  String get addRecipeTakePhotoError =>
      'Não foi possível tirar a foto. Tente novamente.';

  @override
  String get addRecipeSelectCategoryWarning => 'Selecione uma categoria';

  @override
  String get addRecipeAddIngredientWarning =>
      'Adicione pelo menos um ingrediente';

  @override
  String get addRecipeUpdatingRecipe => 'Atualizando receita...';

  @override
  String get addRecipeSharingRecipe => 'Compartilhando receita...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'A imagem \"$fileName\" é muito grande. O tamanho máximo é 5 MB.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'Falha ao processar as imagens. Tente selecionar outras imagens.';

  @override
  String get addRecipeUpdateSuccess => 'Receita atualizada com sucesso!';

  @override
  String get addRecipeShareSuccess => 'Receita compartilhada com sucesso!';

  @override
  String get addRecipeEditTitle => 'Editar receita';

  @override
  String get addRecipeShareTitle => 'Compartilhar uma receita';

  @override
  String get addRecipeEditSubtitle => 'Atualize os detalhes da sua receita';

  @override
  String get addRecipeShareSubtitle =>
      'Adicione um novo prato à coleção da família';

  @override
  String get addRecipePhotosLabel => 'FOTOS';

  @override
  String get addRecipeTitleLabel => 'TÍTULO DA RECEITA *';

  @override
  String get addRecipeTitlePlaceholder => 'ex.: Arroz Jollof Especial da Vovó';

  @override
  String get addRecipeTitleRequired => 'O título da receita é obrigatório';

  @override
  String get addRecipeCategoryLabel => 'CATEGORIA *';

  @override
  String get addRecipeCategoryPlaceholder => 'Selecionar categoria';

  @override
  String get addRecipeCategoryRequired => 'A categoria é obrigatória';

  @override
  String get addRecipeDifficultyLabel => 'DIFICULDADE';

  @override
  String get addRecipeDifficultyPlaceholder => 'Selecionar dificuldade';

  @override
  String get addRecipeCookingTimeLabel => 'TEMPO DE PREPARO\n(MINUTOS)';

  @override
  String get addRecipeServingsLabel => '\nPORÇÕES';

  @override
  String get addRecipeIngredientsLabel => 'INGREDIENTES *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'Ingrediente $number';
  }

  @override
  String get addRecipeIngredientRequired => 'O ingrediente é obrigatório';

  @override
  String get addRecipeAddIngredient => 'Adicionar ingrediente';

  @override
  String get addRecipeInstructionsLabel => 'INSTRUÇÕES *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'Escreva o modo de preparo passo a passo...';

  @override
  String get addRecipeInstructionsRequired => 'As instruções são obrigatórias';

  @override
  String get addRecipeStoryLabel =>
      'A HISTÓRIA POR TRÁS DESTA RECEITA (opcional)';

  @override
  String get addRecipeStoryDescription =>
      'Compartilhe a história desta receita... De onde ela veio? Quem a passou adiante? Que memórias ela guarda para a sua família?';

  @override
  String get addRecipeStoryPlaceholder =>
      'Conte para a gente a história, as tradições ou as memórias especiais ligadas a este prato.';

  @override
  String get addRecipeUpdateButton => 'Atualizar receita';

  @override
  String get addRecipeShareButton => 'Compartilhar receita';

  @override
  String get addRecipeErrorTitle => 'Algo deu errado';

  @override
  String get addRecipeErrorMessage => 'Tente novamente ou reinicie o app.';

  @override
  String get addRecipeGoBack => 'Voltar';

  @override
  String get addRecipeUploadFromGallery => 'Enviar da galeria';

  @override
  String get addRecipeTakePhoto => 'Tirar foto';

  @override
  String get subscriptionNotNow => 'Agora não';

  @override
  String get subscriptionRestoring => 'Restaurando…';

  @override
  String get subscriptionRestore => 'Restaurar';

  @override
  String get subscriptionHeaderTitle => 'Preserve o\nLegado da Sua Família';

  @override
  String get subscriptionHeaderSubtitle =>
      'Desbloqueie recursos premium para manter as receitas\nda sua família vivas por gerações.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'Perfeito para começar';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'A experiência familiar completa';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'Armazenamento ilimitado de receitas da família';

  @override
  String get subscriptionFeatureFamilySharing =>
      'Compartilhamento familiar (até 10 membros)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'Envio de fotos para cada receita';

  @override
  String get subscriptionFeatureExportPrint =>
      'Exportar e imprimir livros de receitas';

  @override
  String get subscriptionFeatureCategoriesTags =>
      'Categorias e tags de receitas';

  @override
  String get subscriptionFeatureEverythingHeritage => 'Tudo do Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers =>
      'Membros da família ilimitados';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'Organização avançada de receitas';

  @override
  String get subscriptionFeaturePrioritySupport =>
      'Suporte ao cliente prioritário';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'Acesso antecipado a novos recursos';

  @override
  String get subscriptionFeatureCustomThemes =>
      'Temas personalizados para o livro de receitas da família';

  @override
  String get subscriptionAutoRenewNotice =>
      'As assinaturas são renovadas automaticamente até serem canceladas. Cancele quando quiser nas configurações do seu dispositivo.';

  @override
  String get subscriptionTermsOfUse => 'Termos de uso';

  @override
  String get subscriptionPrivacyPolicy => 'Política de privacidade';

  @override
  String get subscriptionMostPopular => 'MAIS POPULAR';

  @override
  String get subscriptionPerYear => '/ano';

  @override
  String get subscriptionPerMonth => '/mês';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/mês';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'Obter $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'Não foi possível carregar os planos de assinatura. Verifique sua conexão com a internet e tente novamente.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'Nenhum plano de assinatura está disponível no momento. Verifique as configurações do RevenueCat e do App Store Connect.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'O preço anual ainda não está disponível para este plano.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'O preço mensal ainda não está disponível para este plano.';

  @override
  String get subscriptionWelcomePremium =>
      'Boas-vindas ao Legacy Table Premium!';

  @override
  String get subscriptionRestoreSuccess => 'Compras restauradas com sucesso!';

  @override
  String get subscriptionRestoreNoneFound =>
      'Nenhuma compra anterior encontrada.';

  @override
  String get recipeFeedNotificationsTooltip => 'Notificações';

  @override
  String get recipeFeedSubheading => 'Receitas da família';

  @override
  String get recipeFeedTagline =>
      'Preserve e compartilhe as tradições culinárias da nossa família com amor';

  @override
  String get recipeFeedShareRecipe => 'Compartilhar uma receita';

  @override
  String get recipeFeedFamilyCookbook => 'Livro de receitas da família';

  @override
  String get recipeFeedScanRecipe => 'Escanear uma receita';

  @override
  String get recipeFeedVoiceRecipe => 'Receita por voz';

  @override
  String get recipeFeedComingSoon => 'Em breve';

  @override
  String get recipeFeedSaveFromLink => 'Salvar de um link';

  @override
  String recipeFeedLoadError(String error) {
    return 'Falha ao carregar as receitas: $error';
  }

  @override
  String get recipeFeedSearchHint =>
      'Pesquise receitas, ingredientes ou categorias...';

  @override
  String get recipeFeedCategoryAll => 'Todas';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'Nenhuma receita encontrada';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'Ainda não há receitas';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'Tente ajustar sua pesquisa ou veja todas as receitas';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'Compartilhe a sua primeira receita de família e comece a montar a sua coleção!';

  @override
  String get recipeFeedClearSearch => 'Limpar pesquisa';

  @override
  String get recipeFeedSmartToolsTitle =>
      'Ferramentas inteligentes de receitas';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'Traga receitas do mesmo jeito que o app web faz: escaneie um cartão ou transforme o link de um vídeo em um rascunho.';

  @override
  String get recipeFeedFeatureScanTitle => 'Escanear receita';

  @override
  String get recipeFeedFeatureScanDescription =>
      'Use a foto de um cartão escrito à mão ou de uma página de livro de receitas.';

  @override
  String get recipeFeedFeatureLinkTitle => 'Salvar de um link';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'Transforme um link do TikTok, Instagram ou YouTube em um rascunho.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'Central de celebrações';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'temporada de $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return 'faltam $days dias';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count receitas',
      one: '1 receita',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'Faça login para acessar as configurações de perfil';

  @override
  String get profileSettingsLoadFailed =>
      'Falha ao carregar os dados do usuário. Tente novamente.';

  @override
  String get profileSettingsPhotoSourceTitle => 'Selecionar origem da foto';

  @override
  String get profileSettingsCamera => 'Câmera';

  @override
  String get profileSettingsGallery => 'Galeria';

  @override
  String get profileSettingsCancel => 'Cancelar';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'A permissão da câmera é necessária para tirar uma foto';

  @override
  String get profileSettingsPickImageFailed =>
      'Falha ao selecionar a imagem. Tente novamente.';

  @override
  String get profileSettingsUpdateSuccess => 'Perfil atualizado com sucesso';

  @override
  String get profileSettingsUpdateFailed => 'Falha ao atualizar o perfil';

  @override
  String get profileSettingsTitle => 'Configurações de perfil';

  @override
  String get profileSettingsSubtitle =>
      'Personalize como você aparece para a família';

  @override
  String get profileSettingsProfilePicture => 'Foto de perfil';

  @override
  String get profileSettingsUploadPhotoHint =>
      'Envie uma foto para personalizar seu perfil';

  @override
  String get profileSettingsDisplayName => 'Nome de exibição';

  @override
  String get profileSettingsFullName => 'Nome completo';

  @override
  String get profileSettingsNicknameLabel => 'Apelido (opcional)';

  @override
  String get profileSettingsNicknameHint => 'Digite um apelido...';

  @override
  String get profileSettingsNicknameHelper =>
      'Seu apelido será exibido em vez do seu nome completo nas receitas e nos comentários.';

  @override
  String get profileSettingsAccountInformation => 'Informações da conta';

  @override
  String get profileSettingsEmail => 'E-mail';

  @override
  String get profileSettingsMemberSince => 'Membro desde';

  @override
  String get profileSettingsSaveButton => 'Salvar alterações';

  @override
  String get cookbookLoadError =>
      'Falha ao carregar as receitas. Tente novamente.';

  @override
  String get cookbookSelectAtLeastOne => 'Selecione pelo menos uma receita';

  @override
  String get cookbookGeneratingPdf => 'Gerando PDF...';

  @override
  String get cookbookGeneratePdfError => 'Falha ao gerar o PDF';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF gerado com sucesso!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Seu livro de receitas com $recipeCount receita$_temp0 está pronto. O que você gostaria de fazer?';
  }

  @override
  String get cookbookSaveToDevice => 'Salvar no dispositivo';

  @override
  String get cookbookShare => 'Compartilhar';

  @override
  String get cookbookPreviewPrint => 'Visualizar/Imprimir';

  @override
  String get cookbookCancel => 'Cancelar';

  @override
  String get cookbookSavingPdf => 'Salvando PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF salvo com sucesso na pasta Downloads!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF compartilhado com sucesso!';

  @override
  String get cookbookSavePdfError => 'Falha ao salvar o PDF';

  @override
  String get cookbookSharePdfError => 'Falha ao compartilhar o PDF';

  @override
  String get cookbookPreviewPdfError => 'Falha ao visualizar o PDF';

  @override
  String get cookbookTitle => 'Livro de receitas da família';

  @override
  String get cookbookSubtitle =>
      'Selecione receitas para criar um livro de receitas em PDF para imprimir';

  @override
  String get cookbookClear => 'Limpar';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$selectedCount receita$_temp0 selecionada$_temp1';
  }

  @override
  String get cookbookReadyToCreate =>
      'Tudo pronto para criar seu livro de receitas';

  @override
  String get cookbookExportButton => 'Exportar livro de receitas em PDF';

  @override
  String get cookbookNoRecipesTitle => 'Ainda não há receitas';

  @override
  String get cookbookNoRecipesSubtitle =>
      'Adicione receitas para criar seu livro de receitas';

  @override
  String get createFamilyAppBarTitle => 'Criar família';

  @override
  String get createFamilyHeading => 'Criar uma família';

  @override
  String get createFamilySubtitle =>
      'Comece a compartilhar receitas com os membros da sua família';

  @override
  String get createFamilyNameLabel => 'NOME DA FAMÍLIA';

  @override
  String get createFamilyNameHint => 'ex.: Família Silva';

  @override
  String get createFamilyNameRequired => 'Digite um nome de família';

  @override
  String get createFamilyNameTooShort =>
      'O nome da família precisa ter pelo menos 2 caracteres';

  @override
  String get createFamilyNameTooLong =>
      'O nome da família deve ter no máximo 50 caracteres';

  @override
  String get createFamilyDescriptionLabel => 'DESCRIÇÃO (OPCIONAL)';

  @override
  String get createFamilyDescriptionHint =>
      'Conte para a gente sobre sua família...';

  @override
  String get createFamilyDescriptionTooLong =>
      'A descrição deve ter no máximo 500 caracteres';

  @override
  String get createFamilySubmitButton => 'Criar família';

  @override
  String get createFamilyKeeperInfo =>
      'Você se tornará o guardião da família e poderá convidar outras pessoas';

  @override
  String get createFamilyErrorGeneric => 'Falha ao criar a família';

  @override
  String get createFamilyErrorAlreadyMember =>
      'Você já faz parte de uma família.';

  @override
  String get createFamilySuccessTitle => 'Família criada!';

  @override
  String get createFamilyInviteCodeLabel => 'Código de convite';

  @override
  String get createFamilyInviteCodeCopied => 'Código de convite copiado!';

  @override
  String get createFamilyShareCodeHint =>
      'Compartilhe este código com os membros da família para convidá-los';

  @override
  String get createFamilyShareInviteButton => 'Compartilhar convite';

  @override
  String get createFamilyDoneButton => 'Concluir';

  @override
  String get loginSubtitle => 'Compartilhe sua herança culinária';

  @override
  String get loginEmailLabel => 'E-MAIL';

  @override
  String get loginEmailHint => 'Digite seu e-mail';

  @override
  String get loginEmailRequired => 'Digite seu e-mail';

  @override
  String get loginEmailInvalid => 'Digite um e-mail válido';

  @override
  String get loginPasswordLabel => 'SENHA';

  @override
  String get loginPasswordHint => 'Digite sua senha';

  @override
  String get loginPasswordRequired => 'Digite sua senha';

  @override
  String get loginPasswordTooShort =>
      'A senha precisa ter pelo menos 6 caracteres';

  @override
  String get loginSignInButton => 'Entrar';

  @override
  String get loginOrDivider => 'ou';

  @override
  String get loginContinueWithGoogle => 'Continuar com o Google';

  @override
  String get loginContinueWithApple => 'Continuar com a Apple';

  @override
  String get loginContinueWithFacebook => 'Continuar com o Facebook';

  @override
  String get loginNewToFamily => 'Novo na família? ';

  @override
  String get loginCreateAccount => 'Criar conta';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'A permissão do microfone é necessária para gravar uma receita';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'Falha ao iniciar a gravação: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'Falha ao parar a gravação: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'Arquivo de gravação não encontrado';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'Receita transcrita! Restam $credits créditos.';
  }

  @override
  String get voiceRecipeTitle => 'Receita por voz';

  @override
  String get voiceRecipeIntro =>
      'Diga sua receita em voz alta — vamos transcrevê-la e transformá-la em um rascunho estruturado.';

  @override
  String get voiceRecipeUsesCredits => 'Usa 2 créditos de IA';

  @override
  String get voiceRecipeTapToStop => 'Toque no botão para parar';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'Gravando: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'Pronto para transcrever';

  @override
  String get voiceRecipeTapToStart => 'Toque para iniciar a gravação';

  @override
  String get voiceRecipeSpeakNaturally =>
      'Diga sua receita de forma natural — inclua ingredientes, quantidades e passos.';

  @override
  String get voiceRecipeTipsTitle => 'Dicas para melhores resultados';

  @override
  String get voiceRecipeTipsBody =>
      '• Comece com o nome da receita\n• Liste cada ingrediente com as quantidades\n• Descreva os passos em ordem\n• Mencione o tempo de preparo e as porções';

  @override
  String get voiceRecipeTranscribing => 'Transcrevendo com IA...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'Transcrever em rascunho';

  @override
  String get voiceRecipeRecordAgain => 'Gravar novamente';

  @override
  String get registerSubtitle => 'Compartilhe sua herança culinária';

  @override
  String get registerNameLabel => 'NOME';

  @override
  String get registerNameHint => 'Digite seu nome';

  @override
  String get registerNameRequired => 'Digite seu nome';

  @override
  String get registerEmailLabel => 'E-MAIL';

  @override
  String get registerEmailHint => 'Digite seu e-mail';

  @override
  String get registerEmailRequired => 'Digite seu e-mail';

  @override
  String get registerEmailInvalid => 'Digite um e-mail válido';

  @override
  String get registerNicknameLabel => 'APELIDO (OPCIONAL)';

  @override
  String get registerNicknameHint => 'Digite seu apelido (opcional)';

  @override
  String get registerNicknameTooLong =>
      'O apelido deve ter no máximo 30 caracteres';

  @override
  String get registerPasswordLabel => 'SENHA';

  @override
  String get registerPasswordHint => 'Digite sua senha';

  @override
  String get registerPasswordRequired => 'Digite sua senha';

  @override
  String get registerPasswordTooShort =>
      'A senha precisa ter pelo menos 6 caracteres';

  @override
  String get registerCreateAccountButton => 'Criar conta';

  @override
  String get registerAlreadyHaveAccount => 'Já tem uma conta? ';

  @override
  String get registerSignInLink => 'Entrar';

  @override
  String get registerRegistrationFailed => 'Falha no cadastro';

  @override
  String get scanRecipeCameraPermission =>
      'A permissão da câmera é necessária para escanear uma receita';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'Receita escaneada! Restam $credits créditos.';
  }

  @override
  String get scanRecipeTitle => 'Escanear receita';

  @override
  String get scanRecipeIntro =>
      'Transforme um cartão escrito à mão ou uma página de livro de receitas em um rascunho de receita editável.';

  @override
  String get scanRecipeCreditCost => 'Usa 1 crédito de IA';

  @override
  String get scanRecipeEmptyTitle =>
      'Adicione uma foto da receita para escanear';

  @override
  String get scanRecipeEmptyHint =>
      'Os melhores resultados vêm de uma foto nítida e bem iluminada com a receita inteira visível.';

  @override
  String get scanRecipeChoosePhoto => 'Escolher foto';

  @override
  String get scanRecipeTakePhoto => 'Tirar foto';

  @override
  String get scanRecipeScanning => 'Escaneando com IA...';

  @override
  String get scanRecipeScanButton => 'Escanear em rascunho';

  @override
  String get notificationsLoadError =>
      'Falha ao carregar as notificações. Tente novamente.';

  @override
  String get notificationsAllMarkedRead =>
      'Todas as notificações foram marcadas como lidas';

  @override
  String get notificationsMarkAllError =>
      'Falha ao marcar todas como lidas. Tente novamente.';

  @override
  String get notificationsTitle => 'Notificações';

  @override
  String get notificationsMarkAllButton => 'Marcar todas como lidas';

  @override
  String get notificationsEmptyTitle => 'Nenhuma notificação';

  @override
  String get notificationsEmptySubtitle => 'Você está em dia!';

  @override
  String get joinFamilyAppBarTitle => 'Entrar em uma família';

  @override
  String get joinFamilyHeading => 'Entrar em uma família';

  @override
  String get joinFamilySubtitle =>
      'Digite o código de convite de 8 caracteres do guardião da sua família';

  @override
  String get joinFamilyInviteCodeLabel => 'CÓDIGO DE CONVITE';

  @override
  String get joinFamilyButton => 'Entrar na família';

  @override
  String get joinFamilyInfoText =>
      'Peça o código de convite ao guardião da sua família';

  @override
  String get joinFamilyEmptyCodeError => 'Digite um código de convite';

  @override
  String get joinFamilyCodeLengthError =>
      'O código de convite precisa ter 8 caracteres';

  @override
  String get joinFamilyGenericError => 'Falha ao entrar na família';

  @override
  String get joinFamilyInvalidCodeError =>
      'Código de convite inválido. Verifique e tente novamente.';

  @override
  String get joinFamilyAlreadyMemberError =>
      'Você já faz parte de uma família.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'Você entrou em $familyName com sucesso!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'Cole primeiro um link de vídeo de culinária ou de receita';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'Digite uma URL válida começando com http:// ou https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'Receita importada! Restam $creditsRemaining créditos.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'Salvar de um link';

  @override
  String get saveFromLinkIntro =>
      'Cole um link do TikTok, Instagram, YouTube ou de uma receita e transforme-o em um rascunho compartilhável do Legacy Table.';

  @override
  String get saveFromLinkCreditCost => 'Usa 1 crédito de IA';

  @override
  String get saveFromLinkDraftInfo =>
      'A receita importada abre primeiro como rascunho, para que você possa ajustar os ingredientes, revisar as instruções e adicionar sua própria história antes de compartilhá-la.';

  @override
  String get saveFromLinkImportingLabel => 'Importando com IA...';

  @override
  String get saveFromLinkCreateDraftButton => 'Criar rascunho a partir do link';

  @override
  String get onboardingNextButton => 'Avançar';

  @override
  String get onboardingGetStartedButton => 'Começar';

  @override
  String get homeUpgradeFab => 'Upgrade';

  @override
  String get homeShareRecipeFab => 'Compartilhar uma receita';

  @override
  String get homeNavHome => 'Início';

  @override
  String get homeNavCookbook => 'Livro de receitas';

  @override
  String get homeNavMyRecipes => 'Minhas receitas';

  @override
  String get homeNavFamily => 'Família';

  @override
  String get homeNavSettings => 'Configurações';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Plano premium ativo';

  @override
  String get homeSubscriptionUnlock =>
      'Desbloqueie recursos premium para a família';

  @override
  String get profileTitle => 'Meu perfil';

  @override
  String get profileNoRecipesTitle => 'Ainda não há receitas';

  @override
  String get profileNoRecipesSubtitle =>
      'Compartilhe a sua primeira receita de família!';

  @override
  String profileLoadRecipesError(String error) {
    return 'Falha ao carregar as receitas: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'Ainda não há receitas marcadas para $holidayName';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'Marque um prato favorito da família para esta data comemorativa pelo app web ou pelas próximas melhorias de detalhes no mobile.';

  @override
  String get shareInviteTitle => 'Compartilhar convite';

  @override
  String get shareInviteLinkTab => 'Link';

  @override
  String get shareInviteCodeTab => 'Código';

  @override
  String get shareInviteLinkHint => 'Abre o app ou mostra opções de download';

  @override
  String get shareInviteCodeHint => 'O destinatário insere este código no app';

  @override
  String get shareInviteCopiedSnackbar => 'Copiado!';

  @override
  String get shareInviteCopyButton => 'Copiar';

  @override
  String get shareInviteShareButton => 'Compartilhar';

  @override
  String get familySettingsInviteCodeCopied => 'Código de convite copiado!';

  @override
  String get familySettingsFamilyHeading => 'Família';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'Entre em uma família ou crie uma para começar a compartilhar receitas';

  @override
  String get familySettingsNoFamilyYet => 'Ainda não há família';

  @override
  String get familySettingsStartSharingRecipes =>
      'Comece a compartilhar receitas com os membros da sua família';

  @override
  String get familySettingsJoinFamilyButton => 'Entrar na família';

  @override
  String get familySettingsCreateFamilyButton => 'Criar família';

  @override
  String get familySettingsTitle => 'Configurações da família';

  @override
  String get familySettingsManageSubtitle =>
      'Gerencie sua família e o código de convite.';

  @override
  String get familySettingsInviteCodeLabel => 'Código de convite';

  @override
  String get familySettingsCopyButton => 'Copiar';

  @override
  String get familySettingsShareCodeHelper =>
      'Compartilhe este código para que outras pessoas possam entrar na sua família.';

  @override
  String get familySettingsMembersLabel => 'Membros';

  @override
  String get familySettingsNoMembersYet => 'Ainda não há membros';

  @override
  String get familySettingsKeeperBadge => 'Guardião';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeCardServings(int count) {
    return '$count porções';
  }

  @override
  String get styledSnackbarDismiss => 'Dispensar';

  @override
  String get celebrationTitle => 'Central de celebrações';

  @override
  String get celebrationNextUp => ' — A seguir: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    return '$emoji $name em $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dias',
      one: 'dia',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'receitas',
      one: 'receita',
    );
    return 'faltam $days $_temp0  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count porções';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'por $name';
  }

  @override
  String get familyPromptTitle => 'Entre em uma família ou crie uma';

  @override
  String get familyPromptSubtitle =>
      'Comece a compartilhar receitas com os membros da sua família';

  @override
  String get familyPromptJoinButton => 'Entrar na família';

  @override
  String get familyPromptCreateButton => 'Criar família';

  @override
  String get familyPromptSampleButton =>
      'Só explorando? Experimente um livro de receitas de exemplo';

  @override
  String get familyPromptSampleSuccess =>
      'Bem-vindo! Adicionamos algumas receitas de exemplo para começar.';

  @override
  String get familyPromptSampleFailed =>
      'Não foi possível criar o livro de exemplo. Tente novamente.';

  @override
  String get shareRecipeTitle => 'Compartilhar esta receita';

  @override
  String get shareRecipeAsCard => 'Compartilhar como cartão';

  @override
  String get shareRecipeAsText => 'Compartilhar como texto';

  @override
  String get recipeDetailVoiceNote => 'Nota de voz';
}
