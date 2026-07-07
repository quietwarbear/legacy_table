// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'No se pudo abrir la página para eliminar la cuenta';

  @override
  String get settingsFailedToLoadMembers =>
      'No se pudieron cargar los miembros de la familia';

  @override
  String get settingsInviteCodeCopied => '¡Código de invitación copiado!';

  @override
  String settingsShareInviteJoin(String name) {
    return '¡Únete a mi familia \"$name\" en Legacy Table!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'Código de invitación: $code';
  }

  @override
  String get settingsLeaveFamily => 'Salir de la familia';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return '¿Está seguro de que desea salir de \"$name\"? Necesitará un código de invitación para volver a unirse.';
  }

  @override
  String get settingsCancel => 'Cancelar';

  @override
  String get settingsLeave => 'Salir';

  @override
  String get settingsLeftFamilySuccess => 'Salió de la familia correctamente';

  @override
  String get settingsFailedToLeaveFamily => 'No se pudo salir de la familia';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'Debe transferir el rol de guardián antes de salir';

  @override
  String get settingsTransferKeeperRole => 'Transferir rol de guardián';

  @override
  String get settingsTransferKeeperPrompt =>
      'Como guardián, debe transferir su rol a otro miembro antes de salir. Seleccione un miembro para que sea el nuevo guardián:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'Rol de guardián transferido a $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => '¿Salir de la familia?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'Transfirió el rol de guardián correctamente. ¿Desea salir de la familia ahora?';

  @override
  String get settingsStay => 'Quedarse';

  @override
  String get settingsFailedToTransferKeeper =>
      'No se pudo transferir el rol de guardián';

  @override
  String get settingsRemoveMember => 'Eliminar miembro';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return '¿Está seguro de que desea eliminar a \"$name\" de \"$family\"? Necesitará un código de invitación para volver a unirse.';
  }

  @override
  String get settingsRemove => 'Eliminar';

  @override
  String settingsMemberRemoved(String name) {
    return '$name fue eliminado de la familia';
  }

  @override
  String get settingsFailedToRemoveMember => 'No se pudo eliminar el miembro';

  @override
  String get settingsManageSubscription => 'Administrar suscripción';

  @override
  String get settingsUpgradeToPremium => 'Mejorar a Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection está activo';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper está activo';

  @override
  String get settingsUnlockPremiumFeatures =>
      'Desbloquee planes familiares, exportaciones y funciones premium';

  @override
  String get settingsKeeperBadge => 'Guardián';

  @override
  String get settingsMemberBadge => 'Miembro';

  @override
  String get settingsInviteCodeLabel => 'Código de invitación';

  @override
  String get settingsShareInviteCodeButton => 'Compartir código de invitación';

  @override
  String get settingsFamilyMembers => 'Miembros de la familia';

  @override
  String get settingsNoMembersFound => 'No se encontraron miembros';

  @override
  String get settingsRemoveMemberTooltip => 'Eliminar miembro';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsDarkMode => 'Modo oscuro';

  @override
  String get settingsLightMode => 'Modo claro';

  @override
  String get settingsEditProfile => 'Editar perfil';

  @override
  String get settingsDeleteAccount => 'Eliminar cuenta';

  @override
  String get settingsNotifications => 'Notificaciones';

  @override
  String get settingsTermsOfUse => 'Términos de uso';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. Todos los derechos reservados.';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsLogoutConfirm =>
      '¿Está seguro de que desea cerrar sesión?';

  @override
  String get recipeDetailLoadRecipeError =>
      'No se pudo cargar la receta. Intente de nuevo.';

  @override
  String get recipeDetailLoadCommentsError =>
      'No se pudieron cargar los comentarios. Intente de nuevo.';

  @override
  String get recipeDetailLoginToComment =>
      'Inicie sesión para publicar un comentario';

  @override
  String get recipeDetailCommentPosted =>
      '¡Comentario publicado correctamente!';

  @override
  String get recipeDetailPostCommentError =>
      'No se pudo publicar el comentario';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'No se pudo publicar el comentario: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'Eliminar comentario';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      '¿Está seguro de que desea eliminar este comentario?';

  @override
  String get recipeDetailCancel => 'Cancelar';

  @override
  String get recipeDetailDelete => 'Eliminar';

  @override
  String get recipeDetailCommentDeleted => 'Comentario eliminado correctamente';

  @override
  String get recipeDetailDeleteCommentError =>
      'No se pudo eliminar el comentario';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'No se pudo eliminar el comentario: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => '¡Receta actualizada correctamente!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'Eliminar receta';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return '¿Está seguro de que desea eliminar \"$title\"? Esta acción no se puede deshacer.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'Receta eliminada correctamente';

  @override
  String get recipeDetailDeleteRecipeError => 'No se pudo eliminar la receta';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'No se pudo eliminar la receta: $error';
  }

  @override
  String get recipeDetailNotFound => 'Receta no encontrada';

  @override
  String get recipeDetailSharedByLabel => 'Compartida por';

  @override
  String get recipeDetailUnknownAuthor => 'Desconocido';

  @override
  String get recipeDetailEdit => 'Editar';

  @override
  String get recipeDetailStatTime => 'Tiempo';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeDetailStatServes => 'Porciones';

  @override
  String get recipeDetailStatCategory => 'Categoría';

  @override
  String get recipeDetailIngredients => 'Ingredientes';

  @override
  String get recipeDetailInstructions => 'Instrucciones';

  @override
  String get recipeDetailStoryTitle => 'La historia detrás de esta receta';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'Compartida por $author';
  }

  @override
  String get recipeDetailFamilyComments => 'Comentarios de la familia';

  @override
  String get recipeDetailRefreshComments => 'Actualizar comentarios';

  @override
  String get recipeDetailCommentHint =>
      'Comparta su opinión sobre esta receta...';

  @override
  String get recipeDetailClear => 'Borrar';

  @override
  String get recipeDetailPosting => 'Publicando...';

  @override
  String get recipeDetailPost => 'Publicar';

  @override
  String get recipeDetailNoComments => 'Aún no hay comentarios';

  @override
  String get recipeDetailBeFirstToComment =>
      '¡Sea el primero en compartir su opinión!';

  @override
  String get recipeDetailNoImage => 'Imagen no disponible';

  @override
  String get recipeDetailDeleteCommentTooltip => 'Eliminar comentario';

  @override
  String get addRecipePhotoPermissionTitle => 'Permiso de galería de fotos';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'Se requiere permiso de la galería de fotos para seleccionar imágenes.\n\nPara habilitarlo:\n1. Toque \"Abrir ajustes\"\n2. Vaya a \"Permisos\"\n3. Active \"Fotos y videos\"';

  @override
  String get addRecipeStoragePermissionTitle => 'Permiso de almacenamiento';

  @override
  String get addRecipeStoragePermissionMessage =>
      'Se requiere permiso de almacenamiento para seleccionar imágenes.\n\nPara habilitarlo:\n1. Toque \"Abrir ajustes\"\n2. Vaya a \"Permisos\"\n3. Active \"Almacenamiento\" o \"Archivos y multimedia\"';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'Se requiere permiso de la galería de fotos para seleccionar imágenes.\n\nPara habilitarlo:\n1. Toque \"Abrir ajustes\"\n2. Busque \"Legacy Table\"\n3. Toque \"Fotos\"\n4. Seleccione \"Todas las fotos\" o \"Fotos seleccionadas\"';

  @override
  String get addRecipeCameraPermissionTitle => 'Permiso de cámara';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'El permiso de cámara está denegado permanentemente. Habilítelo desde los ajustes de la aplicación.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'Se requiere permiso de cámara para tomar fotos';

  @override
  String get addRecipeCancel => 'Cancelar';

  @override
  String get addRecipeSettingsHintAndroid =>
      'Busque el permiso \"Fotos y videos\" o \"Multimedia\" en los ajustes de la aplicación';

  @override
  String get addRecipeSettingsHintIos =>
      'Busque el permiso \"Fotos\" en los ajustes de la aplicación';

  @override
  String get addRecipeOpenSettings => 'Abrir ajustes';

  @override
  String get addRecipeImageSelectError =>
      'No se pudieron seleccionar las imágenes. Inténtelo de nuevo.';

  @override
  String get addRecipeTakePhotoError =>
      'No se pudo tomar la foto. Inténtelo de nuevo.';

  @override
  String get addRecipeSelectCategoryWarning => 'Seleccione una categoría';

  @override
  String get addRecipeAddIngredientWarning => 'Agregue al menos un ingrediente';

  @override
  String get addRecipeUpdatingRecipe => 'Actualizando receta...';

  @override
  String get addRecipeSharingRecipe => 'Compartiendo receta...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'La imagen \"$fileName\" es demasiado grande. El tamaño máximo es de 5 MB.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'No se pudieron procesar las imágenes. Intente seleccionar otras imágenes.';

  @override
  String get addRecipeUpdateSuccess => '¡Receta actualizada correctamente!';

  @override
  String get addRecipeShareSuccess => '¡Receta compartida correctamente!';

  @override
  String get addRecipeEditTitle => 'Editar receta';

  @override
  String get addRecipeShareTitle => 'Compartir una receta';

  @override
  String get addRecipeEditSubtitle => 'Actualice los detalles de su receta';

  @override
  String get addRecipeShareSubtitle =>
      'Agregue un nuevo plato a la colección de la familia';

  @override
  String get addRecipePhotosLabel => 'FOTOS';

  @override
  String get addRecipeTitleLabel => 'TÍTULO DE LA RECETA *';

  @override
  String get addRecipeTitlePlaceholder =>
      'p. ej., Arroz Jollof especial de la abuela';

  @override
  String get addRecipeTitleRequired => 'El título de la receta es obligatorio';

  @override
  String get addRecipeCategoryLabel => 'CATEGORÍA *';

  @override
  String get addRecipeCategoryPlaceholder => 'Seleccione una categoría';

  @override
  String get addRecipeCategoryRequired => 'La categoría es obligatoria';

  @override
  String get addRecipeDifficultyLabel => 'DIFICULTAD';

  @override
  String get addRecipeDifficultyPlaceholder => 'Seleccione la dificultad';

  @override
  String get addRecipeCookingTimeLabel => 'TIEMPO DE COCCIÓN\n(MINUTOS)';

  @override
  String get addRecipeServingsLabel => '\nPORCIONES';

  @override
  String get addRecipeIngredientsLabel => 'INGREDIENTES *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'Ingrediente $number';
  }

  @override
  String get addRecipeIngredientRequired => 'El ingrediente es obligatorio';

  @override
  String get addRecipeAddIngredient => 'Agregar ingrediente';

  @override
  String get addRecipeInstructionsLabel => 'INSTRUCCIONES *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'Escriba las instrucciones de preparación paso a paso...';

  @override
  String get addRecipeInstructionsRequired =>
      'Las instrucciones son obligatorias';

  @override
  String get addRecipeStoryLabel =>
      'LA HISTORIA DETRÁS DE ESTA RECETA (opcional)';

  @override
  String get addRecipeStoryDescription =>
      'Comparta la historia de esta receta... ¿De dónde viene? ¿Quién la transmitió? ¿Qué recuerdos guarda para su familia?';

  @override
  String get addRecipeStoryPlaceholder =>
      'Cuéntenos sobre la historia, las tradiciones o los recuerdos especiales relacionados con este plato.';

  @override
  String get addRecipeUpdateButton => 'Actualizar receta';

  @override
  String get addRecipeShareButton => 'Compartir receta';

  @override
  String get addRecipeErrorTitle => 'Algo salió mal';

  @override
  String get addRecipeErrorMessage =>
      'Inténtelo de nuevo o reinicie la aplicación.';

  @override
  String get addRecipeGoBack => 'Volver';

  @override
  String get addRecipeUploadFromGallery => 'Subir desde la galería';

  @override
  String get addRecipeTakePhoto => 'Tomar foto';

  @override
  String get subscriptionNotNow => 'Ahora no';

  @override
  String get subscriptionRestoring => 'Restaurando…';

  @override
  String get subscriptionRestore => 'Restaurar';

  @override
  String get subscriptionHeaderTitle => 'Preserve el legado\nde su familia';

  @override
  String get subscriptionHeaderSubtitle =>
      'Desbloquee funciones premium para mantener vivas\nlas recetas de su familia por generaciones.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'Ideal para comenzar';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline =>
      'La experiencia familiar completa';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'Almacenamiento ilimitado de recetas familiares';

  @override
  String get subscriptionFeatureFamilySharing =>
      'Uso compartido en familia (hasta 10 miembros)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'Carga de fotos para cada receta';

  @override
  String get subscriptionFeatureExportPrint =>
      'Exportar e imprimir libros de recetas';

  @override
  String get subscriptionFeatureCategoriesTags =>
      'Categorías y etiquetas de recetas';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Todo lo de Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers =>
      'Miembros de la familia ilimitados';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'Organización avanzada de recetas';

  @override
  String get subscriptionFeaturePrioritySupport =>
      'Soporte prioritario al cliente';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'Acceso anticipado a nuevas funciones';

  @override
  String get subscriptionFeatureCustomThemes =>
      'Temas personalizados para el recetario familiar';

  @override
  String get subscriptionAutoRenewNotice =>
      'Las suscripciones se renuevan automáticamente hasta que se cancelen. Cancele cuando quiera en los ajustes de su dispositivo.';

  @override
  String get subscriptionTermsOfUse => 'Términos de uso';

  @override
  String get subscriptionPrivacyPolicy => 'Política de privacidad';

  @override
  String get subscriptionMostPopular => 'MÁS POPULAR';

  @override
  String get subscriptionPerYear => '/año';

  @override
  String get subscriptionPerMonth => '/mes';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/mes';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'Obtener $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'No se pudieron cargar los planes de suscripción. Verifique su conexión a internet e inténtelo de nuevo.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'No hay planes de suscripción disponibles en este momento. Verifique la configuración de RevenueCat y App Store Connect.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'El precio anual aún no está disponible para este plan.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'El precio mensual aún no está disponible para este plan.';

  @override
  String get subscriptionWelcomePremium =>
      '¡Bienvenido a Legacy Table Premium!';

  @override
  String get subscriptionRestoreSuccess =>
      '¡Compras restauradas correctamente!';

  @override
  String get subscriptionRestoreNoneFound =>
      'No se encontraron compras anteriores.';

  @override
  String get recipeFeedNotificationsTooltip => 'Notificaciones';

  @override
  String get recipeFeedSubheading => 'Recetas familiares';

  @override
  String get recipeFeedTagline =>
      'Conserve y comparta con amor las tradiciones culinarias de nuestra familia';

  @override
  String get recipeFeedShareRecipe => 'Compartir una receta';

  @override
  String get recipeFeedFamilyCookbook => 'Recetario familiar';

  @override
  String get recipeFeedScanRecipe => 'Escanear una receta';

  @override
  String get recipeFeedVoiceRecipe => 'Dictar una receta';

  @override
  String get recipeFeedComingSoon => 'Próximamente';

  @override
  String get recipeFeedSaveFromLink => 'Guardar desde un enlace';

  @override
  String recipeFeedLoadError(String error) {
    return 'No se pudieron cargar las recetas: $error';
  }

  @override
  String get recipeFeedSearchHint =>
      'Busque recetas, ingredientes o categorías...';

  @override
  String get recipeFeedCategoryAll => 'Todas';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'No se encontraron recetas';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'Aún no hay recetas';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'Intente ajustar su búsqueda o explore todas las recetas';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      '¡Comparta su primera receta familiar y comience a crear su colección!';

  @override
  String get recipeFeedClearSearch => 'Borrar búsqueda';

  @override
  String get recipeFeedSmartToolsTitle =>
      'Herramientas inteligentes de recetas';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'Agregue recetas igual que en la aplicación web: escanee una tarjeta o convierta el enlace de un video en un borrador.';

  @override
  String get recipeFeedFeatureScanTitle => 'Escanear receta';

  @override
  String get recipeFeedFeatureScanDescription =>
      'Use una foto de una tarjeta escrita a mano o de la página de un recetario.';

  @override
  String get recipeFeedFeatureLinkTitle => 'Guardar desde un enlace';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'Convierta un enlace de TikTok, Instagram o YouTube en un borrador.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'Centro de celebraciones';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'Temporada de $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return 'Faltan $days días';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recetas',
      one: '1 receta',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'Inicie sesión para acceder a los ajustes del perfil';

  @override
  String get profileSettingsLoadFailed =>
      'No se pudieron cargar los datos del usuario. Inténtelo de nuevo.';

  @override
  String get profileSettingsPhotoSourceTitle => 'Seleccionar origen de la foto';

  @override
  String get profileSettingsCamera => 'Cámara';

  @override
  String get profileSettingsGallery => 'Galería';

  @override
  String get profileSettingsCancel => 'Cancelar';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'Se requiere permiso de la cámara para tomar una foto';

  @override
  String get profileSettingsPickImageFailed =>
      'No se pudo seleccionar la imagen. Inténtelo de nuevo.';

  @override
  String get profileSettingsUpdateSuccess => 'Perfil actualizado correctamente';

  @override
  String get profileSettingsUpdateFailed => 'No se pudo actualizar el perfil';

  @override
  String get profileSettingsTitle => 'Ajustes del perfil';

  @override
  String get profileSettingsSubtitle =>
      'Personalice cómo aparece ante la familia';

  @override
  String get profileSettingsProfilePicture => 'Foto de perfil';

  @override
  String get profileSettingsUploadPhotoHint =>
      'Suba una foto para personalizar su perfil';

  @override
  String get profileSettingsDisplayName => 'Nombre para mostrar';

  @override
  String get profileSettingsFullName => 'Nombre completo';

  @override
  String get profileSettingsNicknameLabel => 'Apodo (opcional)';

  @override
  String get profileSettingsNicknameHint => 'Escriba un apodo...';

  @override
  String get profileSettingsNicknameHelper =>
      'Su apodo se mostrará en lugar de su nombre completo en las recetas y los comentarios.';

  @override
  String get profileSettingsAccountInformation => 'Información de la cuenta';

  @override
  String get profileSettingsEmail => 'Correo electrónico';

  @override
  String get profileSettingsMemberSince => 'Miembro desde';

  @override
  String get profileSettingsSaveButton => 'Guardar cambios';

  @override
  String get cookbookLoadError =>
      'No se pudieron cargar las recetas. Inténtelo de nuevo.';

  @override
  String get cookbookSelectAtLeastOne => 'Seleccione al menos una receta';

  @override
  String get cookbookGeneratingPdf => 'Generando PDF...';

  @override
  String get cookbookGeneratePdfError => 'No se pudo generar el PDF';

  @override
  String get cookbookPdfGeneratedTitle => '¡PDF generado correctamente!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Su libro de cocina con $recipeCount receta$_temp0 está listo. ¿Qué desea hacer?';
  }

  @override
  String get cookbookSaveToDevice => 'Guardar en el dispositivo';

  @override
  String get cookbookShare => 'Compartir';

  @override
  String get cookbookPreviewPrint => 'Vista previa/Imprimir';

  @override
  String get cookbookCancel => 'Cancelar';

  @override
  String get cookbookSavingPdf => 'Guardando PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      '¡PDF guardado correctamente en la carpeta de Descargas!';

  @override
  String get cookbookPdfSharedSuccess => '¡PDF compartido correctamente!';

  @override
  String get cookbookSavePdfError => 'No se pudo guardar el PDF';

  @override
  String get cookbookSharePdfError => 'No se pudo compartir el PDF';

  @override
  String get cookbookPreviewPdfError => 'No se pudo previsualizar el PDF';

  @override
  String get cookbookTitle => 'Libro de cocina familiar';

  @override
  String get cookbookSubtitle =>
      'Seleccione recetas para crear un libro de cocina en PDF imprimible';

  @override
  String get cookbookClear => 'Limpiar';

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
    return '$selectedCount receta$_temp0 seleccionada$_temp1';
  }

  @override
  String get cookbookReadyToCreate => 'Listo para crear su libro de cocina';

  @override
  String get cookbookExportButton => 'Exportar libro de cocina en PDF';

  @override
  String get cookbookNoRecipesTitle => 'Aún no hay recetas';

  @override
  String get cookbookNoRecipesSubtitle =>
      'Agregue recetas para crear su libro de cocina';

  @override
  String get createFamilyAppBarTitle => 'Crear familia';

  @override
  String get createFamilyHeading => 'Crear una familia';

  @override
  String get createFamilySubtitle =>
      'Empiece a compartir recetas con los miembros de su familia';

  @override
  String get createFamilyNameLabel => 'NOMBRE DE LA FAMILIA';

  @override
  String get createFamilyNameHint => 'p. ej., Familia García';

  @override
  String get createFamilyNameRequired => 'Ingrese un nombre de familia';

  @override
  String get createFamilyNameTooShort =>
      'El nombre de la familia debe tener al menos 2 caracteres';

  @override
  String get createFamilyNameTooLong =>
      'El nombre de la familia debe tener 50 caracteres o menos';

  @override
  String get createFamilyDescriptionLabel => 'DESCRIPCIÓN (OPCIONAL)';

  @override
  String get createFamilyDescriptionHint => 'Cuéntenos sobre su familia...';

  @override
  String get createFamilyDescriptionTooLong =>
      'La descripción debe tener 500 caracteres o menos';

  @override
  String get createFamilySubmitButton => 'Crear familia';

  @override
  String get createFamilyKeeperInfo =>
      'Usted se convertirá en el guardián de la familia y podrá invitar a otros';

  @override
  String get createFamilyErrorGeneric => 'No se pudo crear la familia';

  @override
  String get createFamilyErrorAlreadyMember =>
      'Usted ya forma parte de una familia.';

  @override
  String get createFamilySuccessTitle => '¡Familia creada!';

  @override
  String get createFamilyInviteCodeLabel => 'Código de invitación';

  @override
  String get createFamilyInviteCodeCopied => '¡Código de invitación copiado!';

  @override
  String get createFamilyShareCodeHint =>
      'Comparta este código con los miembros de la familia para invitarlos';

  @override
  String get createFamilyShareInviteButton => 'Compartir invitación';

  @override
  String get createFamilyDoneButton => 'Listo';

  @override
  String get loginSubtitle => 'Comparta su herencia culinaria';

  @override
  String get loginEmailLabel => 'CORREO ELECTRÓNICO';

  @override
  String get loginEmailHint => 'Ingrese su correo electrónico';

  @override
  String get loginEmailRequired => 'Por favor ingrese su correo electrónico';

  @override
  String get loginEmailInvalid =>
      'Por favor ingrese un correo electrónico válido';

  @override
  String get loginPasswordLabel => 'CONTRASEÑA';

  @override
  String get loginPasswordHint => 'Ingrese su contraseña';

  @override
  String get loginPasswordRequired => 'Por favor ingrese su contraseña';

  @override
  String get loginPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get loginSignInButton => 'Iniciar sesión';

  @override
  String get loginOrDivider => 'o';

  @override
  String get loginContinueWithGoogle => 'Continuar con Google';

  @override
  String get loginContinueWithApple => 'Continuar con Apple';

  @override
  String get loginContinueWithFacebook => 'Continuar con Facebook';

  @override
  String get loginNewToFamily => '¿Nuevo en la familia? ';

  @override
  String get loginCreateAccount => 'Crear cuenta';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'Se requiere permiso del micrófono para grabar una receta';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'No se pudo iniciar la grabación: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'No se pudo detener la grabación: $error';
  }

  @override
  String get voiceRecipeFileNotFound =>
      'No se encontró el archivo de grabación';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return '¡Receta transcrita! Quedan $credits créditos.';
  }

  @override
  String get voiceRecipeTitle => 'Receta por voz';

  @override
  String get voiceRecipeIntro =>
      'Cuéntenos su receta en voz alta — la transcribiremos y la convertiremos en un borrador estructurado.';

  @override
  String get voiceRecipeUsesCredits => 'Usa 2 créditos de IA';

  @override
  String get voiceRecipeTapToStop => 'Toque el botón para detener';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'Grabación: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'Lista para transcribir';

  @override
  String get voiceRecipeTapToStart => 'Toque para empezar a grabar';

  @override
  String get voiceRecipeSpeakNaturally =>
      'Diga su receta con naturalidad — incluya ingredientes, cantidades y pasos.';

  @override
  String get voiceRecipeTipsTitle => 'Consejos para mejores resultados';

  @override
  String get voiceRecipeTipsBody =>
      '• Comience con el nombre de la receta\n• Liste cada ingrediente con sus cantidades\n• Describa los pasos en orden\n• Mencione el tiempo de cocción y las porciones';

  @override
  String get voiceRecipeTranscribing => 'Transcribiendo con IA...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'Transcribir en borrador';

  @override
  String get voiceRecipeRecordAgain => 'Grabar de nuevo';

  @override
  String get registerSubtitle => 'Comparta su herencia culinaria';

  @override
  String get registerNameLabel => 'NOMBRE';

  @override
  String get registerNameHint => 'Ingrese su nombre';

  @override
  String get registerNameRequired => 'Por favor ingrese su nombre';

  @override
  String get registerEmailLabel => 'CORREO ELECTRÓNICO';

  @override
  String get registerEmailHint => 'Ingrese su correo electrónico';

  @override
  String get registerEmailRequired => 'Por favor ingrese su correo electrónico';

  @override
  String get registerEmailInvalid =>
      'Por favor ingrese un correo electrónico válido';

  @override
  String get registerNicknameLabel => 'APODO (OPCIONAL)';

  @override
  String get registerNicknameHint => 'Ingrese su apodo (opcional)';

  @override
  String get registerNicknameTooLong =>
      'El apodo debe tener 30 caracteres o menos';

  @override
  String get registerPasswordLabel => 'CONTRASEÑA';

  @override
  String get registerPasswordHint => 'Ingrese su contraseña';

  @override
  String get registerPasswordRequired => 'Por favor ingrese su contraseña';

  @override
  String get registerPasswordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get registerCreateAccountButton => 'Crear cuenta';

  @override
  String get registerAlreadyHaveAccount => '¿Ya tiene una cuenta? ';

  @override
  String get registerSignInLink => 'Iniciar sesión';

  @override
  String get registerRegistrationFailed => 'Error al registrarse';

  @override
  String get scanRecipeCameraPermission =>
      'Se requiere permiso de la cámara para escanear una receta';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return '¡Receta escaneada! Quedan $credits créditos.';
  }

  @override
  String get scanRecipeTitle => 'Escanear receta';

  @override
  String get scanRecipeIntro =>
      'Convierta una tarjeta escrita a mano o una página de un libro de cocina en un borrador de receta editable.';

  @override
  String get scanRecipeCreditCost => 'Usa 1 crédito de IA';

  @override
  String get scanRecipeEmptyTitle =>
      'Agregue una foto de la receta para escanear';

  @override
  String get scanRecipeEmptyHint =>
      'Los mejores resultados se obtienen con una foto clara y bien iluminada donde se vea toda la receta.';

  @override
  String get scanRecipeChoosePhoto => 'Elegir foto';

  @override
  String get scanRecipeTakePhoto => 'Tomar foto';

  @override
  String get scanRecipeScanning => 'Escaneando con IA...';

  @override
  String get scanRecipeScanButton => 'Escanear en borrador';

  @override
  String get notificationsLoadError =>
      'No se pudieron cargar las notificaciones. Intente de nuevo.';

  @override
  String get notificationsAllMarkedRead =>
      'Todas las notificaciones se marcaron como leídas';

  @override
  String get notificationsMarkAllError =>
      'No se pudieron marcar todas como leídas. Intente de nuevo.';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get notificationsMarkAllButton => 'Marcar todas como leídas';

  @override
  String get notificationsEmptyTitle => 'No hay notificaciones';

  @override
  String get notificationsEmptySubtitle => '¡Está al día!';

  @override
  String get joinFamilyAppBarTitle => 'Unirse a una familia';

  @override
  String get joinFamilyHeading => 'Unirse a una familia';

  @override
  String get joinFamilySubtitle =>
      'Ingrese el código de invitación de 8 caracteres que le dio el guardián de su familia';

  @override
  String get joinFamilyInviteCodeLabel => 'CÓDIGO DE INVITACIÓN';

  @override
  String get joinFamilyButton => 'Unirse a la familia';

  @override
  String get joinFamilyInfoText =>
      'Solicite el código de invitación al guardián de su familia';

  @override
  String get joinFamilyEmptyCodeError => 'Ingrese un código de invitación';

  @override
  String get joinFamilyCodeLengthError =>
      'El código de invitación debe tener 8 caracteres';

  @override
  String get joinFamilyGenericError => 'No se pudo unir a la familia';

  @override
  String get joinFamilyInvalidCodeError =>
      'Código de invitación no válido. Verifíquelo e intente de nuevo.';

  @override
  String get joinFamilyAlreadyMemberError =>
      'Usted ya pertenece a una familia.';

  @override
  String joinFamilySuccess(String familyName) {
    return '¡Se unió correctamente a $familyName!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'Pegue primero un enlace de video de cocina o de receta';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'Ingrese una URL válida que empiece por http:// o https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return '¡Receta importada! Quedan $creditsRemaining créditos.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'Guardar desde enlace';

  @override
  String get saveFromLinkIntro =>
      'Pegue un enlace de TikTok, Instagram, YouTube o de una receta y conviértalo en un borrador de Legacy Table que pueda compartir.';

  @override
  String get saveFromLinkCreditCost => 'Usa 1 crédito de IA';

  @override
  String get saveFromLinkDraftInfo =>
      'La receta importada se abre primero como borrador, para que pueda depurar los ingredientes, ajustar las instrucciones y agregar su propia historia antes de compartirla.';

  @override
  String get saveFromLinkImportingLabel => 'Importando con IA...';

  @override
  String get saveFromLinkCreateDraftButton => 'Crear borrador desde enlace';

  @override
  String get onboardingNextButton => 'Siguiente';

  @override
  String get onboardingGetStartedButton => 'Comenzar';

  @override
  String get homeUpgradeFab => 'Mejorar plan';

  @override
  String get homeShareRecipeFab => 'Compartir una receta';

  @override
  String get homeNavHome => 'Inicio';

  @override
  String get homeNavCookbook => 'Recetario';

  @override
  String get homeNavMyRecipes => 'Mis recetas';

  @override
  String get homeNavFamily => 'Familia';

  @override
  String get homeNavSettings => 'Ajustes';

  @override
  String get homeTierLegacyCollection => 'Colección Legacy';

  @override
  String get homeTierHeritageKeeper => 'Guardián de Herencia';

  @override
  String get homeSubscriptionActive => 'Plan premium activo';

  @override
  String get homeSubscriptionUnlock =>
      'Desbloquea funciones premium para la familia';

  @override
  String get profileTitle => 'Mi perfil';

  @override
  String get profileNoRecipesTitle => 'Aún no hay recetas';

  @override
  String get profileNoRecipesSubtitle =>
      '¡Comparta su primera receta familiar!';

  @override
  String profileLoadRecipesError(String error) {
    return 'No se pudieron cargar las recetas: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'Aún no hay recetas etiquetadas para $holidayName';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'Etiquete una receta favorita de la familia para esta fecha desde la aplicación web o las próximas mejoras de detalle en el móvil.';

  @override
  String get shareInviteTitle => 'Compartir invitación';

  @override
  String get shareInviteLinkTab => 'Enlace';

  @override
  String get shareInviteCodeTab => 'Código';

  @override
  String get shareInviteLinkHint =>
      'Abre la app o muestra las opciones de descarga';

  @override
  String get shareInviteCodeHint =>
      'El destinatario ingresa este código en la app';

  @override
  String get shareInviteCopiedSnackbar => '¡Copiado!';

  @override
  String get shareInviteCopyButton => 'Copiar';

  @override
  String get shareInviteShareButton => 'Compartir';

  @override
  String get familySettingsInviteCodeCopied => '¡Código de invitación copiado!';

  @override
  String get familySettingsFamilyHeading => 'Familia';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'Únase o cree una familia para empezar a compartir recetas';

  @override
  String get familySettingsNoFamilyYet => 'Aún no tiene familia';

  @override
  String get familySettingsStartSharingRecipes =>
      'Empiece a compartir recetas con los miembros de su familia';

  @override
  String get familySettingsJoinFamilyButton => 'Unirse a una familia';

  @override
  String get familySettingsCreateFamilyButton => 'Crear familia';

  @override
  String get familySettingsTitle => 'Ajustes de la familia';

  @override
  String get familySettingsManageSubtitle =>
      'Administre su familia y su código de invitación.';

  @override
  String get familySettingsInviteCodeLabel => 'Código de invitación';

  @override
  String get familySettingsCopyButton => 'Copiar';

  @override
  String get familySettingsShareCodeHelper =>
      'Comparta este código para que otros puedan unirse a su familia.';

  @override
  String get familySettingsMembersLabel => 'Miembros';

  @override
  String get familySettingsNoMembersYet => 'Aún no hay miembros';

  @override
  String get familySettingsKeeperBadge => 'Guardián';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeCardServings(int count) {
    return '$count porciones';
  }

  @override
  String get styledSnackbarDismiss => 'Descartar';

  @override
  String get celebrationTitle => 'Central de Celebraciones';

  @override
  String get celebrationNextUp => ' — A continuación: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return '$emoji $name en $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'recetas',
      one: 'receta',
    );
    return 'Faltan $days $_temp0  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count porciones';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'por $name';
  }

  @override
  String get familyPromptTitle => 'Únete o crea una familia';

  @override
  String get familyPromptSubtitle =>
      'Empieza a compartir recetas con los miembros de tu familia';

  @override
  String get familyPromptJoinButton => 'Unirse a familia';

  @override
  String get familyPromptCreateButton => 'Crear familia';

  @override
  String get familyPromptSampleButton =>
      '¿Solo explorando? Prueba un recetario de ejemplo';

  @override
  String get familyPromptSampleSuccess =>
      '¡Bienvenido! Añadimos algunas recetas de ejemplo para empezar.';

  @override
  String get familyPromptSampleFailed =>
      'No se pudo crear el recetario de ejemplo. Inténtalo de nuevo.';

  @override
  String get shareRecipeTitle => 'Compartir esta receta';

  @override
  String get shareRecipeAsCard => 'Compartir como tarjeta';

  @override
  String get shareRecipeAsText => 'Compartir como texto';
}
