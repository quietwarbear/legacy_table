// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'Impossible d\'ouvrir la page de suppression du compte';

  @override
  String get settingsFailedToLoadMembers =>
      'Échec du chargement des membres de la famille';

  @override
  String get settingsInviteCodeCopied => 'Code d\'invitation copié !';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Rejoignez ma famille « $name » sur Legacy Table !';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'Code d\'invitation : $code';
  }

  @override
  String get settingsLeaveFamily => 'Quitter la famille';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'Voulez-vous vraiment quitter « $name » ? Vous aurez besoin d\'un code d\'invitation pour la rejoindre à nouveau.';
  }

  @override
  String get settingsCancel => 'Annuler';

  @override
  String get settingsLeave => 'Quitter';

  @override
  String get settingsLeftFamilySuccess =>
      'Vous avez quitté la famille avec succès';

  @override
  String get settingsFailedToLeaveFamily => 'Impossible de quitter la famille';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'Vous devez transférer le rôle de gardien avant de partir';

  @override
  String get settingsTransferKeeperRole => 'Transférer le rôle de gardien';

  @override
  String get settingsTransferKeeperPrompt =>
      'En tant que gardien, vous devez transférer votre rôle à un autre membre avant de partir. Choisissez le membre qui deviendra le nouveau gardien :';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'Rôle de gardien transféré à $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'Quitter la famille ?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'Vous avez transféré le rôle de gardien avec succès. Souhaitez-vous quitter la famille maintenant ?';

  @override
  String get settingsStay => 'Rester';

  @override
  String get settingsFailedToTransferKeeper =>
      'Échec du transfert du rôle de gardien';

  @override
  String get settingsRemoveMember => 'Retirer le membre';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'Voulez-vous vraiment retirer « $name » de « $family » ? Cette personne aura besoin d\'un code d\'invitation pour la rejoindre à nouveau.';
  }

  @override
  String get settingsRemove => 'Retirer';

  @override
  String settingsMemberRemoved(String name) {
    return '$name a été retiré de la famille';
  }

  @override
  String get settingsFailedToRemoveMember => 'Échec du retrait du membre';

  @override
  String get settingsManageSubscription => 'Gérer l\'abonnement';

  @override
  String get settingsUpgradeToPremium => 'Passer à Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection est actif';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper est actif';

  @override
  String get settingsUnlockPremiumFeatures =>
      'Débloquez les forfaits famille, les exports et les fonctionnalités premium';

  @override
  String get settingsKeeperBadge => 'Gardien';

  @override
  String get settingsMemberBadge => 'Membre';

  @override
  String get settingsInviteCodeLabel => 'Code d\'invitation';

  @override
  String get settingsShareInviteCodeButton => 'Partager le code d\'invitation';

  @override
  String get settingsFamilyMembers => 'Membres de la famille';

  @override
  String get settingsNoMembersFound => 'Aucun membre trouvé';

  @override
  String get settingsRemoveMemberTooltip => 'Retirer le membre';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsLightMode => 'Mode clair';

  @override
  String get settingsEditProfile => 'Modifier le profil';

  @override
  String get settingsDeleteAccount => 'Supprimer le compte';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. Tous droits réservés.';

  @override
  String get settingsLogout => 'Déconnexion';

  @override
  String get settingsLogoutConfirm => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get recipeDetailLoadRecipeError =>
      'Échec du chargement de la recette. Veuillez réessayer.';

  @override
  String get recipeDetailLoadCommentsError =>
      'Échec du chargement des commentaires. Veuillez réessayer.';

  @override
  String get recipeDetailLoginToComment =>
      'Veuillez vous connecter pour publier un commentaire';

  @override
  String get recipeDetailCommentPosted => 'Commentaire publié avec succès !';

  @override
  String get recipeDetailPostCommentError =>
      'Échec de la publication du commentaire';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'Échec de la publication du commentaire : $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'Supprimer le commentaire';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'Voulez-vous vraiment supprimer ce commentaire ?';

  @override
  String get recipeDetailCancel => 'Annuler';

  @override
  String get recipeDetailDelete => 'Supprimer';

  @override
  String get recipeDetailCommentDeleted => 'Commentaire supprimé avec succès';

  @override
  String get recipeDetailDeleteCommentError =>
      'Échec de la suppression du commentaire';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'Échec de la suppression du commentaire : $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'Recette mise à jour avec succès !';

  @override
  String get recipeDetailDeleteRecipeTitle => 'Supprimer la recette';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'Voulez-vous vraiment supprimer « $title » ? Cette action est irréversible.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'Recette supprimée avec succès';

  @override
  String get recipeDetailDeleteRecipeError =>
      'Échec de la suppression de la recette';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'Échec de la suppression de la recette : $error';
  }

  @override
  String get recipeDetailNotFound => 'Recette introuvable';

  @override
  String get recipeDetailSharedByLabel => 'Partagée par';

  @override
  String get recipeDetailUnknownAuthor => 'Inconnu';

  @override
  String get recipeDetailEdit => 'Modifier';

  @override
  String get recipeDetailStatTime => 'Durée';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeDetailStatServes => 'Portions';

  @override
  String get recipeDetailStatCategory => 'Catégorie';

  @override
  String get recipeDetailIngredients => 'Ingrédients';

  @override
  String get recipeDetailInstructions => 'Instructions';

  @override
  String get recipeDetailStoryTitle => 'L\'histoire de cette recette';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'Partagée par $author';
  }

  @override
  String get recipeDetailFamilyComments => 'Commentaires de la famille';

  @override
  String get recipeDetailRefreshComments => 'Actualiser les commentaires';

  @override
  String get recipeDetailCommentHint =>
      'Partagez votre avis sur cette recette…';

  @override
  String get recipeDetailClear => 'Effacer';

  @override
  String get recipeDetailPosting => 'Publication…';

  @override
  String get recipeDetailPost => 'Publier';

  @override
  String get recipeDetailNoComments => 'Aucun commentaire pour l\'instant';

  @override
  String get recipeDetailBeFirstToComment =>
      'Soyez le premier à partager votre avis !';

  @override
  String get recipeDetailNoImage => 'Aucune image disponible';

  @override
  String get recipeDetailDeleteCommentTooltip => 'Supprimer le commentaire';

  @override
  String get addRecipePhotoPermissionTitle =>
      'Autorisation d\'accès à la photothèque';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'L\'autorisation d\'accès à la photothèque est requise pour sélectionner des images.\n\nPour l\'activer :\n1. Touchez « Ouvrir les paramètres »\n2. Allez dans « Autorisations »\n3. Activez « Photos et vidéos »';

  @override
  String get addRecipeStoragePermissionTitle => 'Autorisation de stockage';

  @override
  String get addRecipeStoragePermissionMessage =>
      'L\'autorisation de stockage est requise pour sélectionner des images.\n\nPour l\'activer :\n1. Touchez « Ouvrir les paramètres »\n2. Allez dans « Autorisations »\n3. Activez « Stockage » ou « Fichiers et médias »';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'L\'autorisation d\'accès à la photothèque est requise pour sélectionner des images.\n\nPour l\'activer :\n1. Touchez « Ouvrir les paramètres »\n2. Trouvez « Legacy Table »\n3. Touchez « Photos »\n4. Sélectionnez « Toutes les photos » ou « Photos sélectionnées »';

  @override
  String get addRecipeCameraPermissionTitle =>
      'Autorisation d\'accès à l\'appareil photo';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'L\'autorisation d\'accès à l\'appareil photo a été définitivement refusée. Veuillez l\'activer dans les paramètres de l\'application.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'L\'autorisation d\'accès à l\'appareil photo est requise pour prendre des photos';

  @override
  String get addRecipeCancel => 'Annuler';

  @override
  String get addRecipeSettingsHintAndroid =>
      'Recherchez l\'autorisation « Photos et vidéos » ou « Médias » dans les paramètres de l\'application';

  @override
  String get addRecipeSettingsHintIos =>
      'Recherchez l\'autorisation « Photos » dans les paramètres de l\'application';

  @override
  String get addRecipeOpenSettings => 'Ouvrir les paramètres';

  @override
  String get addRecipeImageSelectError =>
      'Impossible de sélectionner les images. Veuillez réessayer.';

  @override
  String get addRecipeTakePhotoError =>
      'Impossible de prendre la photo. Veuillez réessayer.';

  @override
  String get addRecipeSelectCategoryWarning =>
      'Veuillez sélectionner une catégorie';

  @override
  String get addRecipeAddIngredientWarning =>
      'Veuillez ajouter au moins un ingrédient';

  @override
  String get addRecipeUpdatingRecipe => 'Mise à jour de la recette…';

  @override
  String get addRecipeSharingRecipe => 'Partage de la recette…';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'L\'image « $fileName » est trop volumineuse. La taille maximale est de 5 Mo.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'Échec du traitement des images. Veuillez essayer de sélectionner d\'autres images.';

  @override
  String get addRecipeUpdateSuccess => 'Recette mise à jour avec succès !';

  @override
  String get addRecipeShareSuccess => 'Recette partagée avec succès !';

  @override
  String get addRecipeEditTitle => 'Modifier la recette';

  @override
  String get addRecipeShareTitle => 'Partager une recette';

  @override
  String get addRecipeEditSubtitle =>
      'Mettez à jour les détails de votre recette';

  @override
  String get addRecipeShareSubtitle =>
      'Ajoutez un nouveau plat à la collection familiale';

  @override
  String get addRecipePhotosLabel => 'PHOTOS';

  @override
  String get addRecipeTitleLabel => 'TITRE DE LA RECETTE *';

  @override
  String get addRecipeTitlePlaceholder =>
      'ex. : Le riz Jollof spécial de grand-mère';

  @override
  String get addRecipeTitleRequired => 'Le titre de la recette est obligatoire';

  @override
  String get addRecipeCategoryLabel => 'CATÉGORIE *';

  @override
  String get addRecipeCategoryPlaceholder => 'Choisir une catégorie';

  @override
  String get addRecipeCategoryRequired => 'La catégorie est obligatoire';

  @override
  String get addRecipeDifficultyLabel => 'DIFFICULTÉ';

  @override
  String get addRecipeDifficultyPlaceholder => 'Choisir la difficulté';

  @override
  String get addRecipeCookingTimeLabel => 'TEMPS DE CUISSON\n(MINUTES)';

  @override
  String get addRecipeServingsLabel => '\nPORTIONS';

  @override
  String get addRecipeIngredientsLabel => 'INGRÉDIENTS *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'Ingrédient $number';
  }

  @override
  String get addRecipeIngredientRequired => 'L\'ingrédient est obligatoire';

  @override
  String get addRecipeAddIngredient => 'Ajouter un ingrédient';

  @override
  String get addRecipeInstructionsLabel => 'INSTRUCTIONS *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'Rédigez les instructions de préparation étape par étape…';

  @override
  String get addRecipeInstructionsRequired =>
      'Les instructions sont obligatoires';

  @override
  String get addRecipeStoryLabel => 'L\'HISTOIRE DE CETTE RECETTE (facultatif)';

  @override
  String get addRecipeStoryDescription =>
      'Racontez l\'histoire de cette recette… D\'où vient-elle ? Qui l\'a transmise ? Quels souvenirs représente-t-elle pour votre famille ?';

  @override
  String get addRecipeStoryPlaceholder =>
      'Parlez-nous de l\'histoire, des traditions ou des souvenirs particuliers liés à ce plat.';

  @override
  String get addRecipeUpdateButton => 'Mettre à jour la recette';

  @override
  String get addRecipeShareButton => 'Partager la recette';

  @override
  String get addRecipeErrorTitle => 'Une erreur s\'est produite';

  @override
  String get addRecipeErrorMessage =>
      'Veuillez réessayer ou redémarrer l\'application.';

  @override
  String get addRecipeGoBack => 'Retour';

  @override
  String get addRecipeUploadFromGallery => 'Importer depuis la galerie';

  @override
  String get addRecipeTakePhoto => 'Prendre une photo';

  @override
  String get subscriptionNotNow => 'Pas maintenant';

  @override
  String get subscriptionRestoring => 'Restauration…';

  @override
  String get subscriptionRestore => 'Restaurer';

  @override
  String get subscriptionHeaderTitle =>
      'Préservez l\'héritage\nde votre famille';

  @override
  String get subscriptionHeaderSubtitle =>
      'Débloquez les fonctionnalités premium pour transmettre\nles recettes de votre famille aux générations futures.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'Parfait pour commencer';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline =>
      'L\'expérience familiale complète';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'Stockage illimité des recettes de famille';

  @override
  String get subscriptionFeatureFamilySharing =>
      'Partage familial (jusqu\'à 10 membres)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'Import de photos pour chaque recette';

  @override
  String get subscriptionFeatureExportPrint =>
      'Export et impression de livres de recettes';

  @override
  String get subscriptionFeatureCategoriesTags =>
      'Catégories et étiquettes de recettes';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Tout ce que comprend Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers =>
      'Membres de la famille illimités';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'Organisation avancée des recettes';

  @override
  String get subscriptionFeaturePrioritySupport =>
      'Assistance client prioritaire';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'Accès anticipé aux nouvelles fonctionnalités';

  @override
  String get subscriptionFeatureCustomThemes =>
      'Thèmes personnalisés pour le livre de recettes familial';

  @override
  String get subscriptionAutoRenewNotice =>
      'Les abonnements se renouvellent automatiquement jusqu\'à leur annulation. Annulez à tout moment dans les paramètres de votre appareil.';

  @override
  String get subscriptionTermsOfUse => 'Conditions d\'utilisation';

  @override
  String get subscriptionPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get subscriptionMostPopular => 'LE PLUS POPULAIRE';

  @override
  String get subscriptionPerYear => '/an';

  @override
  String get subscriptionPerMonth => '/mois';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/mois';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'Obtenir $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'Impossible de charger les formules d\'abonnement. Veuillez vérifier votre connexion Internet et réessayer.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'Aucune formule d\'abonnement n\'est disponible pour le moment. Veuillez vérifier la configuration de RevenueCat et d\'App Store Connect.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'La tarification annuelle n\'est pas encore disponible pour cette formule.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'La tarification mensuelle n\'est pas encore disponible pour cette formule.';

  @override
  String get subscriptionWelcomePremium =>
      'Bienvenue dans Legacy Table Premium !';

  @override
  String get subscriptionRestoreSuccess => 'Achats restaurés avec succès !';

  @override
  String get subscriptionRestoreNoneFound => 'Aucun achat antérieur trouvé.';

  @override
  String get recipeFeedNotificationsTooltip => 'Notifications';

  @override
  String get recipeFeedSubheading => 'Recettes de famille';

  @override
  String get recipeFeedTagline =>
      'Préservez et partagez avec amour les traditions culinaires de notre famille';

  @override
  String get recipeFeedShareRecipe => 'Partager une recette';

  @override
  String get recipeFeedFamilyCookbook => 'Livre de recettes familial';

  @override
  String get recipeFeedScanRecipe => 'Scanner une recette';

  @override
  String get recipeFeedVoiceRecipe => 'Dicter une recette';

  @override
  String get recipeFeedComingSoon => 'Bientôt disponible';

  @override
  String get recipeFeedSaveFromLink => 'Enregistrer depuis un lien';

  @override
  String recipeFeedLoadError(String error) {
    return 'Échec du chargement des recettes : $error';
  }

  @override
  String get recipeFeedSearchHint =>
      'Rechercher des recettes, des ingrédients ou des catégories…';

  @override
  String get recipeFeedCategoryAll => 'Toutes';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'Aucune recette trouvée';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'Aucune recette pour l\'instant';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'Essayez d\'ajuster votre recherche ou parcourez toutes les recettes';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'Partagez votre première recette de famille et commencez à constituer votre collection !';

  @override
  String get recipeFeedClearSearch => 'Effacer la recherche';

  @override
  String get recipeFeedSmartToolsTitle => 'Outils de recettes intelligents';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'Importez des recettes comme le fait l\'application web : scannez une fiche ou transformez un lien vidéo en brouillon.';

  @override
  String get recipeFeedFeatureScanTitle => 'Scanner une recette';

  @override
  String get recipeFeedFeatureScanDescription =>
      'Utilisez une photo d\'une fiche manuscrite ou d\'une page de livre de cuisine.';

  @override
  String get recipeFeedFeatureLinkTitle => 'Enregistrer depuis un lien';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'Transformez un lien TikTok, Instagram ou YouTube en brouillon.';

  @override
  String get recipeFeedCelebrationHeadquarters =>
      'Quartier général des célébrations';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'Saison $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return 'dans $days jours';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recettes',
      one: '1 recette',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'Veuillez vous connecter pour accéder aux paramètres du profil';

  @override
  String get profileSettingsLoadFailed =>
      'Échec du chargement des données utilisateur. Veuillez réessayer.';

  @override
  String get profileSettingsPhotoSourceTitle => 'Choisir la source de la photo';

  @override
  String get profileSettingsCamera => 'Appareil photo';

  @override
  String get profileSettingsGallery => 'Galerie';

  @override
  String get profileSettingsCancel => 'Annuler';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'L\'autorisation d\'accès à l\'appareil photo est requise pour prendre une photo';

  @override
  String get profileSettingsPickImageFailed =>
      'Échec de la sélection de l\'image. Veuillez réessayer.';

  @override
  String get profileSettingsUpdateSuccess => 'Profil mis à jour avec succès';

  @override
  String get profileSettingsUpdateFailed => 'Échec de la mise à jour du profil';

  @override
  String get profileSettingsTitle => 'Paramètres du profil';

  @override
  String get profileSettingsSubtitle =>
      'Personnalisez la façon dont vous apparaissez auprès de la famille';

  @override
  String get profileSettingsProfilePicture => 'Photo de profil';

  @override
  String get profileSettingsUploadPhotoHint =>
      'Importez une photo pour personnaliser votre profil';

  @override
  String get profileSettingsDisplayName => 'Nom affiché';

  @override
  String get profileSettingsFullName => 'Nom complet';

  @override
  String get profileSettingsNicknameLabel => 'Surnom (facultatif)';

  @override
  String get profileSettingsNicknameHint => 'Saisissez un surnom…';

  @override
  String get profileSettingsNicknameHelper =>
      'Votre surnom sera affiché à la place de votre nom complet sur les recettes et les commentaires.';

  @override
  String get profileSettingsAccountInformation => 'Informations du compte';

  @override
  String get profileSettingsEmail => 'E-mail';

  @override
  String get profileSettingsMemberSince => 'Membre depuis';

  @override
  String get profileSettingsSaveButton => 'Enregistrer les modifications';

  @override
  String get cookbookLoadError =>
      'Échec du chargement des recettes. Veuillez réessayer.';

  @override
  String get cookbookSelectAtLeastOne =>
      'Veuillez sélectionner au moins une recette';

  @override
  String get cookbookGeneratingPdf => 'Génération du PDF…';

  @override
  String get cookbookGeneratePdfError => 'Échec de la génération du PDF';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF généré avec succès !';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Votre livre de recettes contenant $recipeCount recette$_temp0 est prêt. Que souhaitez-vous faire ?';
  }

  @override
  String get cookbookSaveToDevice => 'Enregistrer sur l\'appareil';

  @override
  String get cookbookShare => 'Partager';

  @override
  String get cookbookPreviewPrint => 'Aperçu/Imprimer';

  @override
  String get cookbookCancel => 'Annuler';

  @override
  String get cookbookSavingPdf => 'Enregistrement du PDF…';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF enregistré avec succès dans le dossier Téléchargements !';

  @override
  String get cookbookPdfSharedSuccess => 'PDF partagé avec succès !';

  @override
  String get cookbookSavePdfError => 'Échec de l\'enregistrement du PDF';

  @override
  String get cookbookSharePdfError => 'Échec du partage du PDF';

  @override
  String get cookbookPreviewPdfError => 'Échec de l\'aperçu du PDF';

  @override
  String get cookbookTitle => 'Livre de recettes familial';

  @override
  String get cookbookSubtitle =>
      'Sélectionnez des recettes pour créer un livre de recettes PDF imprimable';

  @override
  String get cookbookClear => 'Effacer';

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
    return '$selectedCount recette$_temp0 sélectionnée$_temp1';
  }

  @override
  String get cookbookReadyToCreate => 'Prêt à créer votre livre de recettes';

  @override
  String get cookbookExportButton => 'Exporter le livre de recettes PDF';

  @override
  String get cookbookNoRecipesTitle => 'Aucune recette pour l\'instant';

  @override
  String get cookbookNoRecipesSubtitle =>
      'Ajoutez des recettes pour créer votre livre de recettes';

  @override
  String get createFamilyAppBarTitle => 'Créer une famille';

  @override
  String get createFamilyHeading => 'Créer une famille';

  @override
  String get createFamilySubtitle =>
      'Commencez à partager des recettes avec les membres de votre famille';

  @override
  String get createFamilyNameLabel => 'NOM DE LA FAMILLE';

  @override
  String get createFamilyNameHint => 'ex. : Famille Dupont';

  @override
  String get createFamilyNameRequired => 'Veuillez saisir un nom de famille';

  @override
  String get createFamilyNameTooShort =>
      'Le nom de la famille doit comporter au moins 2 caractères';

  @override
  String get createFamilyNameTooLong =>
      'Le nom de la famille ne doit pas dépasser 50 caractères';

  @override
  String get createFamilyDescriptionLabel => 'DESCRIPTION (FACULTATIF)';

  @override
  String get createFamilyDescriptionHint => 'Parlez-nous de votre famille…';

  @override
  String get createFamilyDescriptionTooLong =>
      'La description ne doit pas dépasser 500 caractères';

  @override
  String get createFamilySubmitButton => 'Créer une famille';

  @override
  String get createFamilyKeeperInfo =>
      'Vous deviendrez le gardien de la famille et pourrez inviter d\'autres personnes';

  @override
  String get createFamilyErrorGeneric => 'Échec de la création de la famille';

  @override
  String get createFamilyErrorAlreadyMember =>
      'Vous faites déjà partie d\'une famille.';

  @override
  String get createFamilySuccessTitle => 'Famille créée !';

  @override
  String get createFamilyInviteCodeLabel => 'Code d\'invitation';

  @override
  String get createFamilyInviteCodeCopied => 'Code d\'invitation copié !';

  @override
  String get createFamilyShareCodeHint =>
      'Partagez ce code avec les membres de la famille pour les inviter';

  @override
  String get createFamilyShareInviteButton => 'Partager l\'invitation';

  @override
  String get createFamilyDoneButton => 'Terminé';

  @override
  String get loginSubtitle => 'Partagez votre héritage culinaire';

  @override
  String get loginEmailLabel => 'E-MAIL';

  @override
  String get loginEmailHint => 'Saisissez votre e-mail';

  @override
  String get loginEmailRequired => 'Veuillez saisir votre e-mail';

  @override
  String get loginEmailInvalid => 'Veuillez saisir un e-mail valide';

  @override
  String get loginPasswordLabel => 'MOT DE PASSE';

  @override
  String get loginPasswordHint => 'Saisissez votre mot de passe';

  @override
  String get loginPasswordRequired => 'Veuillez saisir votre mot de passe';

  @override
  String get loginPasswordTooShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get loginSignInButton => 'Se connecter';

  @override
  String get loginOrDivider => 'ou';

  @override
  String get loginContinueWithGoogle => 'Continuer avec Google';

  @override
  String get loginContinueWithApple => 'Continuer avec Apple';

  @override
  String get loginContinueWithFacebook => 'Continuer avec Facebook';

  @override
  String get loginNewToFamily => 'Nouveau dans la famille ? ';

  @override
  String get loginCreateAccount => 'Créer un compte';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'L\'autorisation d\'accès au microphone est requise pour enregistrer une recette';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'Échec du démarrage de l\'enregistrement : $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'Échec de l\'arrêt de l\'enregistrement : $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'Fichier d\'enregistrement introuvable';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'Recette transcrite ! Il reste $credits crédits.';
  }

  @override
  String get voiceRecipeTitle => 'Recette vocale';

  @override
  String get voiceRecipeIntro =>
      'Dictez-nous votre recette à voix haute — nous la transcrirons et la transformerons en un brouillon structuré.';

  @override
  String get voiceRecipeUsesCredits => 'Utilise 2 crédits IA';

  @override
  String get voiceRecipeTapToStop => 'Touchez le bouton pour arrêter';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'Enregistrement : $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'Prêt à transcrire';

  @override
  String get voiceRecipeTapToStart => 'Touchez pour démarrer l\'enregistrement';

  @override
  String get voiceRecipeSpeakNaturally =>
      'Énoncez votre recette naturellement — indiquez les ingrédients, les quantités et les étapes.';

  @override
  String get voiceRecipeTipsTitle => 'Conseils pour de meilleurs résultats';

  @override
  String get voiceRecipeTipsBody =>
      '• Commencez par le nom de la recette\n• Énumérez chaque ingrédient avec les quantités\n• Décrivez les étapes dans l\'ordre\n• Mentionnez le temps de cuisson et le nombre de portions';

  @override
  String get voiceRecipeTranscribing => 'Transcription avec l\'IA…';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'Transcrire en brouillon';

  @override
  String get voiceRecipeRecordAgain => 'Enregistrer à nouveau';

  @override
  String get registerSubtitle => 'Partagez votre héritage culinaire';

  @override
  String get registerNameLabel => 'NOM';

  @override
  String get registerNameHint => 'Saisissez votre nom';

  @override
  String get registerNameRequired => 'Veuillez saisir votre nom';

  @override
  String get registerEmailLabel => 'E-MAIL';

  @override
  String get registerEmailHint => 'Saisissez votre e-mail';

  @override
  String get registerEmailRequired => 'Veuillez saisir votre e-mail';

  @override
  String get registerEmailInvalid => 'Veuillez saisir un e-mail valide';

  @override
  String get registerNicknameLabel => 'SURNOM (FACULTATIF)';

  @override
  String get registerNicknameHint => 'Saisissez votre surnom (facultatif)';

  @override
  String get registerNicknameTooLong =>
      'Le surnom ne doit pas dépasser 30 caractères';

  @override
  String get registerPasswordLabel => 'MOT DE PASSE';

  @override
  String get registerPasswordHint => 'Saisissez votre mot de passe';

  @override
  String get registerPasswordRequired => 'Veuillez saisir votre mot de passe';

  @override
  String get registerPasswordTooShort =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get registerCreateAccountButton => 'Créer un compte';

  @override
  String get registerAlreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get registerSignInLink => 'Se connecter';

  @override
  String get registerRegistrationFailed => 'Échec de l\'inscription';

  @override
  String get scanRecipeCameraPermission =>
      'L\'autorisation d\'accès à l\'appareil photo est requise pour scanner une recette';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'Recette scannée ! Il reste $credits crédits.';
  }

  @override
  String get scanRecipeTitle => 'Scanner une recette';

  @override
  String get scanRecipeIntro =>
      'Transformez une fiche manuscrite ou une page de livre de cuisine en un brouillon de recette modifiable.';

  @override
  String get scanRecipeCreditCost => 'Utilise 1 crédit IA';

  @override
  String get scanRecipeEmptyTitle => 'Ajoutez une photo de recette à scanner';

  @override
  String get scanRecipeEmptyHint =>
      'Les meilleurs résultats proviennent d\'une photo nette et bien éclairée où la recette complète est visible.';

  @override
  String get scanRecipeChoosePhoto => 'Choisir une photo';

  @override
  String get scanRecipeTakePhoto => 'Prendre une photo';

  @override
  String get scanRecipeScanning => 'Numérisation avec l\'IA…';

  @override
  String get scanRecipeScanButton => 'Scanner en brouillon';

  @override
  String get notificationsLoadError =>
      'Échec du chargement des notifications. Veuillez réessayer.';

  @override
  String get notificationsAllMarkedRead =>
      'Toutes les notifications ont été marquées comme lues';

  @override
  String get notificationsMarkAllError =>
      'Échec du marquage de toutes les notifications comme lues. Veuillez réessayer.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllButton => 'Tout marquer comme lu';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsEmptySubtitle => 'Vous êtes à jour !';

  @override
  String get joinFamilyAppBarTitle => 'Rejoindre une famille';

  @override
  String get joinFamilyHeading => 'Rejoindre une famille';

  @override
  String get joinFamilySubtitle =>
      'Saisissez le code d\'invitation à 8 caractères fourni par le gardien de votre famille';

  @override
  String get joinFamilyInviteCodeLabel => 'CODE D\'INVITATION';

  @override
  String get joinFamilyButton => 'Rejoindre la famille';

  @override
  String get joinFamilyInfoText =>
      'Demandez le code d\'invitation au gardien de votre famille';

  @override
  String get joinFamilyEmptyCodeError =>
      'Veuillez saisir un code d\'invitation';

  @override
  String get joinFamilyCodeLengthError =>
      'Le code d\'invitation doit comporter 8 caractères';

  @override
  String get joinFamilyGenericError => 'Échec de l\'adhésion à la famille';

  @override
  String get joinFamilyInvalidCodeError =>
      'Code d\'invitation invalide. Veuillez vérifier et réessayer.';

  @override
  String get joinFamilyAlreadyMemberError =>
      'Vous faites déjà partie d\'une famille.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'Vous avez rejoint $familyName avec succès !';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'Collez d\'abord un lien de vidéo de cuisine ou de recette';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'Veuillez saisir une URL valide commençant par http:// ou https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'Recette importée ! Il reste $creditsRemaining crédits.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'Enregistrer depuis un lien';

  @override
  String get saveFromLinkIntro =>
      'Collez un lien TikTok, Instagram, YouTube ou de recette et transformez-le en un brouillon Legacy Table partageable.';

  @override
  String get saveFromLinkCreditCost => 'Utilise 1 crédit IA';

  @override
  String get saveFromLinkDraftInfo =>
      'La recette importée s\'ouvre d\'abord sous forme de brouillon, ce qui vous permet de corriger les ingrédients, d\'ajuster les instructions et d\'ajouter votre propre histoire avant de la partager.';

  @override
  String get saveFromLinkImportingLabel => 'Importation avec l\'IA…';

  @override
  String get saveFromLinkCreateDraftButton =>
      'Créer un brouillon à partir du lien';

  @override
  String get onboardingNextButton => 'Suivant';

  @override
  String get onboardingGetStartedButton => 'Commencer';

  @override
  String get homeUpgradeFab => 'Mettre à niveau';

  @override
  String get homeShareRecipeFab => 'Partager une recette';

  @override
  String get homeNavHome => 'Accueil';

  @override
  String get homeNavCookbook => 'Livre de recettes';

  @override
  String get homeNavMyRecipes => 'Mes recettes';

  @override
  String get homeNavFamily => 'Famille';

  @override
  String get homeNavSettings => 'Paramètres';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Forfait Premium actif';

  @override
  String get homeSubscriptionUnlock =>
      'Débloquez les fonctionnalités familiales premium';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileNoRecipesTitle => 'Aucune recette pour l\'instant';

  @override
  String get profileNoRecipesSubtitle =>
      'Partagez votre première recette de famille !';

  @override
  String profileLoadRecipesError(String error) {
    return 'Échec du chargement des recettes : $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'Aucune recette encore associée à $holidayName';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'Associez un plat favori de la famille à cette fête depuis l\'application web ou les futures améliorations de la version mobile.';

  @override
  String get shareInviteTitle => 'Partager l\'invitation';

  @override
  String get shareInviteLinkTab => 'Lien';

  @override
  String get shareInviteCodeTab => 'Code';

  @override
  String get shareInviteLinkHint =>
      'Ouvre l\'application ou affiche les options de téléchargement';

  @override
  String get shareInviteCodeHint =>
      'Le destinataire saisit ce code dans l\'application';

  @override
  String get shareInviteCopiedSnackbar => 'Copié !';

  @override
  String get shareInviteCopyButton => 'Copier';

  @override
  String get shareInviteShareButton => 'Partager';

  @override
  String get familySettingsInviteCodeCopied => 'Code d\'invitation copié !';

  @override
  String get familySettingsFamilyHeading => 'Famille';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'Rejoignez ou créez une famille pour commencer à partager des recettes';

  @override
  String get familySettingsNoFamilyYet => 'Aucune famille pour l\'instant';

  @override
  String get familySettingsStartSharingRecipes =>
      'Commencez à partager des recettes avec les membres de votre famille';

  @override
  String get familySettingsJoinFamilyButton => 'Rejoindre une famille';

  @override
  String get familySettingsCreateFamilyButton => 'Créer une famille';

  @override
  String get familySettingsTitle => 'Paramètres de la famille';

  @override
  String get familySettingsManageSubtitle =>
      'Gérez votre famille et votre code d\'invitation.';

  @override
  String get familySettingsInviteCodeLabel => 'Code d\'invitation';

  @override
  String get familySettingsCopyButton => 'Copier';

  @override
  String get familySettingsShareCodeHelper =>
      'Partagez ce code pour que d\'autres puissent rejoindre votre famille.';

  @override
  String get familySettingsMembersLabel => 'Membres';

  @override
  String get familySettingsNoMembersYet => 'Aucun membre pour l\'instant';

  @override
  String get familySettingsKeeperBadge => 'Gardien';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeCardServings(int count) {
    return '$count portions';
  }

  @override
  String get styledSnackbarDismiss => 'Ignorer';

  @override
  String get celebrationTitle => 'Quartier général des célébrations';

  @override
  String get celebrationNextUp => ' — À venir : ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return '$emoji $name dans $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'recettes',
      one: 'recette',
    );
    return 'dans $days $_temp0  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count portions';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'par $name';
  }

  @override
  String get familyPromptTitle => 'Rejoindre ou créer une famille';

  @override
  String get familyPromptSubtitle =>
      'Commencez à partager des recettes avec les membres de votre famille';

  @override
  String get familyPromptJoinButton => 'Rejoindre une famille';

  @override
  String get familyPromptCreateButton => 'Créer une famille';

  @override
  String get familyPromptSampleButton =>
      'Envie d\'explorer ? Essayez un livre de recettes d\'exemple';

  @override
  String get familyPromptSampleSuccess =>
      'Bienvenue ! Nous avons ajouté quelques recettes d\'exemple pour commencer.';

  @override
  String get familyPromptSampleFailed =>
      'Impossible de créer le livre d\'exemple. Veuillez réessayer.';

  @override
  String get shareRecipeTitle => 'Partager cette recette';

  @override
  String get shareRecipeAsCard => 'Partager en carte';

  @override
  String get shareRecipeAsText => 'Partager en texte';

  @override
  String get recipeDetailVoiceNote => 'Note vocale';
}
