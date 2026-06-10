// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Yoruba (`yo`).
class AppLocalizationsYo extends AppLocalizations {
  AppLocalizationsYo([String locale = 'yo']) : super(locale);

  @override
  String get settingsLanguage => 'Èdè';

  @override
  String get selectLanguage => 'Yan Èdè';

  @override
  String get languageEnglish => 'Gẹ̀ẹ́sì';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'Ìṣàtúntò';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'Kò lè ṣí ojú-ìwé ìparẹ́ àkàǹtì';

  @override
  String get settingsFailedToLoadMembers => 'Kò lè gbé àwọn ọmọ ìdílé wọlé';

  @override
  String get settingsInviteCodeCopied => 'A ti ṣàdàkọ kóòdù ìpè!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Wá darapọ̀ mọ́ ìdílé mi \"$name\" lórí Legacy Table!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'Kóòdù Ìpè: $code';
  }

  @override
  String get settingsLeaveFamily => 'Fi Ìdílé Sílẹ̀';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'Ṣé ó dájú pé o fẹ́ fi \"$name\" sílẹ̀? Ìwọ yóò nílò kóòdù ìpè láti tún darapọ̀.';
  }

  @override
  String get settingsCancel => 'Fagilé';

  @override
  String get settingsLeave => 'Kúrò';

  @override
  String get settingsLeftFamilySuccess => 'O ti fi ìdílé sílẹ̀ ní àṣeyọrí';

  @override
  String get settingsFailedToLeaveFamily => 'Kò lè fi ìdílé sílẹ̀';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'O gbọ́dọ̀ gbé ipa olùtọ́jú lọ kí o tó kúrò';

  @override
  String get settingsTransferKeeperRole => 'Gbé Ipa Olùtọ́jú Lọ';

  @override
  String get settingsTransferKeeperPrompt =>
      'Gẹ́gẹ́ bí olùtọ́jú, o gbọ́dọ̀ gbé ipa rẹ lọ sí ọmọ ẹgbẹ́ mìíràn kí o tó kúrò. Yan ọmọ ẹgbẹ́ kan láti di olùtọ́jú tuntun:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'A ti gbé ipa olùtọ́jú lọ sí $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'Fi Ìdílé Sílẹ̀?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'O ti gbé ipa olùtọ́jú lọ ní àṣeyọrí. Ṣé o fẹ́ fi ìdílé sílẹ̀ nísinsìnyí?';

  @override
  String get settingsStay => 'Dúró';

  @override
  String get settingsFailedToTransferKeeper => 'Kò lè gbé ipa olùtọ́jú lọ';

  @override
  String get settingsRemoveMember => 'Yọ Ọmọ Ẹgbẹ́ Kúrò';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'Ṣé ó dájú pé o fẹ́ yọ \"$name\" kúrò nínú \"$family\"? Wọn yóò nílò kóòdù ìpè láti tún darapọ̀.';
  }

  @override
  String get settingsRemove => 'Yọ Kúrò';

  @override
  String settingsMemberRemoved(String name) {
    return 'A ti yọ $name kúrò nínú ìdílé';
  }

  @override
  String get settingsFailedToRemoveMember => 'Kò lè yọ ọmọ ẹgbẹ́ kúrò';

  @override
  String get settingsManageSubscription => 'Ṣàkóso Ìforúkọsílẹ̀';

  @override
  String get settingsUpgradeToPremium => 'Gbéga sí Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection ti ń ṣiṣẹ́';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper ti ń ṣiṣẹ́';

  @override
  String get settingsUnlockPremiumFeatures =>
      'Ṣí àwọn ètò ìdílé, ìkójáde, àti àwọn ẹ̀yà premium';

  @override
  String get settingsKeeperBadge => 'Olùtọ́jú';

  @override
  String get settingsMemberBadge => 'Ọmọ Ẹgbẹ́';

  @override
  String get settingsInviteCodeLabel => 'Kóòdù Ìpè';

  @override
  String get settingsShareInviteCodeButton => 'Pín Kóòdù Ìpè';

  @override
  String get settingsFamilyMembers => 'Àwọn Ọmọ Ìdílé';

  @override
  String get settingsNoMembersFound => 'Kò sí ọmọ ẹgbẹ́ tí a rí';

  @override
  String get settingsRemoveMemberTooltip => 'Yọ ọmọ ẹgbẹ́ kúrò';

  @override
  String get settingsTheme => 'Àwòrán Àtòjọ';

  @override
  String get settingsDarkMode => 'Ipò Dúdú';

  @override
  String get settingsLightMode => 'Ipò Mọ́lẹ̀';

  @override
  String get settingsEditProfile => 'Ṣàtúnṣe Profáìlì';

  @override
  String get settingsDeleteAccount => 'Pa Àkàǹtì Rẹ́';

  @override
  String get settingsNotifications => 'Àwọn Ìfìtọ́nilẹ́tí';

  @override
  String get settingsTermsOfUse => 'Àwọn Òfin Ìlò';

  @override
  String get settingsPrivacyPolicy => 'Òfin Ìpamọ́';

  @override
  String get settingsAbout => 'Nípa';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. A pa gbogbo ẹ̀tọ́ mọ́.';

  @override
  String get settingsLogout => 'Jáde';

  @override
  String get settingsLogoutConfirm => 'Ṣé ó dájú pé o fẹ́ jáde?';

  @override
  String get recipeDetailLoadRecipeError =>
      'Kò lè gbé ìlànà oúnjẹ wọlé. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get recipeDetailLoadCommentsError =>
      'Kò lè gbé àwọn àríwí wọlé. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get recipeDetailLoginToComment => 'Jọ̀wọ́ wọlé láti fi àríwí sílẹ̀';

  @override
  String get recipeDetailCommentPosted => 'A ti fi àríwí sílẹ̀ ní àṣeyọrí!';

  @override
  String get recipeDetailPostCommentError => 'Kò lè fi àríwí sílẹ̀';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'Kò lè fi àríwí sílẹ̀: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'Pa Àríwí Rẹ́';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'Ṣé ó dájú pé o fẹ́ pa àríwí yìí rẹ́?';

  @override
  String get recipeDetailCancel => 'Fagilé';

  @override
  String get recipeDetailDelete => 'Parẹ́';

  @override
  String get recipeDetailCommentDeleted => 'A ti pa àríwí rẹ́ ní àṣeyọrí';

  @override
  String get recipeDetailDeleteCommentError => 'Kò lè pa àríwí rẹ́';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'Kò lè pa àríwí rẹ́: $error';
  }

  @override
  String get recipeDetailRecipeUpdated =>
      'A ti ṣàtúnṣe ìlànà oúnjẹ ní àṣeyọrí!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'Pa Ìlànà Oúnjẹ Rẹ́';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'Ṣé ó dájú pé o fẹ́ pa \"$title\" rẹ́? Ìṣe yìí kò lè yí padà.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'A ti pa ìlànà oúnjẹ rẹ́ ní àṣeyọrí';

  @override
  String get recipeDetailDeleteRecipeError => 'Kò lè pa ìlànà oúnjẹ rẹ́';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'Kò lè pa ìlànà oúnjẹ rẹ́: $error';
  }

  @override
  String get recipeDetailNotFound => 'A kò rí ìlànà oúnjẹ náà';

  @override
  String get recipeDetailSharedByLabel => 'Ẹni tó pín in';

  @override
  String get recipeDetailUnknownAuthor => 'Àìmọ̀';

  @override
  String get recipeDetailEdit => 'Ṣàtúnṣe';

  @override
  String get recipeDetailStatTime => 'Àkókò';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return 'ìṣẹ́jú $minutes';
  }

  @override
  String get recipeDetailStatServes => 'Ìpín Àbọ̀';

  @override
  String get recipeDetailStatCategory => 'Ẹ̀ka';

  @override
  String get recipeDetailIngredients => 'Àwọn Èròjà';

  @override
  String get recipeDetailInstructions => 'Àwọn Ìtọ́sọ́nà';

  @override
  String get recipeDetailStoryTitle => 'Ìtàn Tó Wà Lẹ́yìn Ìlànà Oúnjẹ Yìí';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'Ẹni tó pín in $author';
  }

  @override
  String get recipeDetailFamilyComments => 'Àwọn Àríwí Ìdílé';

  @override
  String get recipeDetailRefreshComments => 'Tún àwọn àríwí ṣe';

  @override
  String get recipeDetailCommentHint =>
      'Pín ohun tó wà lọ́kàn rẹ nípa ìlànà oúnjẹ yìí...';

  @override
  String get recipeDetailClear => 'Nù Ún Dànù';

  @override
  String get recipeDetailPosting => 'Ń fi sílẹ̀...';

  @override
  String get recipeDetailPost => 'Fi Sílẹ̀';

  @override
  String get recipeDetailNoComments => 'Kò sí àríwí kankan síbẹ̀';

  @override
  String get recipeDetailBeFirstToComment =>
      'Jẹ́ ẹni àkọ́kọ́ láti pín ohun tó wà lọ́kàn rẹ!';

  @override
  String get recipeDetailNoImage => 'Kò sí àwòrán';

  @override
  String get recipeDetailDeleteCommentTooltip => 'Pa àríwí rẹ́';

  @override
  String get addRecipePhotoPermissionTitle => 'Àṣẹ Ilé-ìkàwé Àwòrán';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'Àṣẹ ilé-ìkàwé àwòrán pọn dandan láti yan àwọn àwòrán.\n\nLáti mu ṣiṣẹ́:\n1. Tẹ \"Ṣí Ìṣàtúntò\"\n2. Lọ sí \"Àwọn Àṣẹ\"\n3. Mu \"Àwòrán àti fídíò\" ṣiṣẹ́';

  @override
  String get addRecipeStoragePermissionTitle => 'Àṣẹ Ibi Ìfipamọ́';

  @override
  String get addRecipeStoragePermissionMessage =>
      'Àṣẹ ibi ìfipamọ́ pọn dandan láti yan àwọn àwòrán.\n\nLáti mu ṣiṣẹ́:\n1. Tẹ \"Ṣí Ìṣàtúntò\"\n2. Lọ sí \"Àwọn Àṣẹ\"\n3. Mu \"Ibi Ìfipamọ́\" tàbí \"Àwọn fáìlì àti mídíà\" ṣiṣẹ́';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'Àṣẹ ilé-ìkàwé àwòrán pọn dandan láti yan àwọn àwòrán.\n\nLáti mu ṣiṣẹ́:\n1. Tẹ \"Ṣí Ìṣàtúntò\"\n2. Wá \"Legacy Table\"\n3. Tẹ \"Àwòrán\"\n4. Yan \"Gbogbo Àwòrán\" tàbí \"Àwòrán Tí A Yàn\"';

  @override
  String get addRecipeCameraPermissionTitle => 'Àṣẹ Kámẹ́rà';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'A ti kọ àṣẹ kámẹ́rà pátápátá. Jọ̀wọ́ mu un ṣiṣẹ́ láti inú ìṣàtúntò app.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'Àṣẹ kámẹ́rà pọn dandan láti ya àwòrán';

  @override
  String get addRecipeCancel => 'Fagilé';

  @override
  String get addRecipeSettingsHintAndroid =>
      'Wá àṣẹ \"Àwòrán àti fídíò\" tàbí \"Mídíà\" nínú Ìṣàtúntò App';

  @override
  String get addRecipeSettingsHintIos => 'Wá àṣẹ \"Àwòrán\" nínú Ìṣàtúntò App';

  @override
  String get addRecipeOpenSettings => 'Ṣí Ìṣàtúntò';

  @override
  String get addRecipeImageSelectError =>
      'Kò lè yan àwọn àwòrán. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get addRecipeTakePhotoError => 'Kò lè ya àwòrán. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get addRecipeSelectCategoryWarning => 'Jọ̀wọ́ yan ẹ̀ka kan';

  @override
  String get addRecipeAddIngredientWarning =>
      'Jọ̀wọ́ fi èròjà kan kún ún ó kéré jù';

  @override
  String get addRecipeUpdatingRecipe => 'Ń ṣàtúnṣe ìlànà oúnjẹ...';

  @override
  String get addRecipeSharingRecipe => 'Ń pín ìlànà oúnjẹ...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'Àwòrán \"$fileName\" tóbi jù. Ìwọ̀n títóbi jù ni 5MB.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'Kò lè ṣàmúlò àwọn àwòrán. Jọ̀wọ́ gbìyànjú láti yan àwọn àwòrán mìíràn.';

  @override
  String get addRecipeUpdateSuccess => 'A ti ṣàtúnṣe ìlànà oúnjẹ ní àṣeyọrí!';

  @override
  String get addRecipeShareSuccess => 'A ti pín ìlànà oúnjẹ ní àṣeyọrí!';

  @override
  String get addRecipeEditTitle => 'Ṣàtúnṣe Ìlànà Oúnjẹ';

  @override
  String get addRecipeShareTitle => 'Pín Ìlànà Oúnjẹ Kan';

  @override
  String get addRecipeEditSubtitle => 'Ṣàtúnṣe àwọn àlàyé ìlànà oúnjẹ rẹ';

  @override
  String get addRecipeShareSubtitle => 'Fi oúnjẹ tuntun kún àkójọ ìdílé';

  @override
  String get addRecipePhotosLabel => 'ÀWỌN ÀWÒRÁN';

  @override
  String get addRecipeTitleLabel => 'ORÚKỌ ÌLÀNÀ OÚNJẸ *';

  @override
  String get addRecipeTitlePlaceholder =>
      'f.a., Ìrẹsì Jollof Pàtàkì ti Ìyá Àgbà';

  @override
  String get addRecipeTitleRequired => 'Orúkọ ìlànà oúnjẹ pọn dandan';

  @override
  String get addRecipeCategoryLabel => 'Ẹ̀KA *';

  @override
  String get addRecipeCategoryPlaceholder => 'Yan ẹ̀ka';

  @override
  String get addRecipeCategoryRequired => 'Ẹ̀ka pọn dandan';

  @override
  String get addRecipeDifficultyLabel => 'ÌṢÒRO';

  @override
  String get addRecipeDifficultyPlaceholder => 'Yan ìṣòro';

  @override
  String get addRecipeCookingTimeLabel => 'ÀKÓKÒ ÌSÈ\n(ÌṢẸ́JÚ)';

  @override
  String get addRecipeServingsLabel => '\nÌPÍN ÀBỌ̀';

  @override
  String get addRecipeIngredientsLabel => 'ÀWỌN ÈRÒJÀ *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'Èròjà $number';
  }

  @override
  String get addRecipeIngredientRequired => 'Èròjà pọn dandan';

  @override
  String get addRecipeAddIngredient => 'Fi èròjà kún ún';

  @override
  String get addRecipeInstructionsLabel => 'ÀWỌN ÌTỌ́SỌ́NÀ *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'Kọ àwọn ìtọ́sọ́nà ìsè oúnjẹ ní ìgbésẹ̀ kọ̀ọ̀kan...';

  @override
  String get addRecipeInstructionsRequired => 'Àwọn ìtọ́sọ́nà pọn dandan';

  @override
  String get addRecipeStoryLabel => 'ÌTÀN TÓ WÀ LẸ́YÌN ÌLÀNÀ OÚNJẸ YÌÍ (yíyàn)';

  @override
  String get addRecipeStoryDescription =>
      'Pín ìtàn ìlànà oúnjẹ yìí... Níbo ni ó ti wá? Ta ni ó gbé e kalẹ̀? Ìrántí wo ni ó di mú fún ìdílé rẹ?';

  @override
  String get addRecipeStoryPlaceholder =>
      'Sọ fún wa nípa ìtàn, àṣà, tàbí àwọn ìrántí pàtàkì tí ó so mọ́ oúnjẹ yìí.';

  @override
  String get addRecipeUpdateButton => 'Ṣàtúnṣe Ìlànà Oúnjẹ';

  @override
  String get addRecipeShareButton => 'Pín Ìlànà Oúnjẹ';

  @override
  String get addRecipeErrorTitle => 'Ohun kan ṣàṣìṣe';

  @override
  String get addRecipeErrorMessage =>
      'Jọ̀wọ́ tún gbìyànjú tàbí tún app náà bẹ̀rẹ̀.';

  @override
  String get addRecipeGoBack => 'Padà Sẹ́yìn';

  @override
  String get addRecipeUploadFromGallery => 'Gbé wọlé láti inú gálárì';

  @override
  String get addRecipeTakePhoto => 'Ya Àwòrán';

  @override
  String get subscriptionNotNow => 'Kì í ṣe nísinsìnyí';

  @override
  String get subscriptionRestoring => 'Ń mú padà bọ̀sípò…';

  @override
  String get subscriptionRestore => 'Mú Padà Bọ̀sípò';

  @override
  String get subscriptionHeaderTitle => 'Pa Ogún\nÌdílé Rẹ Mọ́';

  @override
  String get subscriptionHeaderSubtitle =>
      'Ṣí àwọn ẹ̀yà premium láti jẹ́ kí àwọn\nìlànà oúnjẹ ìdílé rẹ wà láàyè fún ìran-dé-ìran.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'Pípé fún ìbẹ̀rẹ̀';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'Ìrírí ìdílé pípé';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'Ibi ìfipamọ́ ìlànà oúnjẹ ìdílé tí kò lópin';

  @override
  String get subscriptionFeatureFamilySharing =>
      'Ìpínkiri ìdílé (dé ọmọ ẹgbẹ́ 10)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'Ìgbéwọlé àwòrán fún ìlànà oúnjẹ kọ̀ọ̀kan';

  @override
  String get subscriptionFeatureExportPrint =>
      'Ìkójáde àti ìtẹ̀wé àwọn ìwé ìlànà oúnjẹ';

  @override
  String get subscriptionFeatureCategoriesTags =>
      'Àwọn ẹ̀ka àti àmì ìlànà oúnjẹ';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Gbogbo ohun tó wà nínú Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers =>
      'Àwọn ọmọ ìdílé tí kò lópin';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'Ìṣètò ìlànà oúnjẹ tó ní ìlọsíwájú';

  @override
  String get subscriptionFeaturePrioritySupport =>
      'Ìrànlọ́wọ́ oníbàárà tó ní ààyò';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'Ìwọlé kíákíá sí àwọn ẹ̀yà tuntun';

  @override
  String get subscriptionFeatureCustomThemes =>
      'Àwọn àwòrán àtòjọ ìwé oúnjẹ ìdílé tí a ṣe àkànṣe';

  @override
  String get subscriptionAutoRenewNotice =>
      'Àwọn ìforúkọsílẹ̀ máa ń tún ara wọn ṣe títí di ìgbà tí a bá fagilé. Fagilé nígbàkígbà nínú ìṣàtúntò ẹrọ rẹ.';

  @override
  String get subscriptionTermsOfUse => 'Àwọn Òfin Ìlò';

  @override
  String get subscriptionPrivacyPolicy => 'Òfin Ìpamọ́';

  @override
  String get subscriptionMostPopular => 'TÓ GBAJÚMỌ̀ JÙ';

  @override
  String get subscriptionPerYear => '/ọdún';

  @override
  String get subscriptionPerMonth => '/oṣù';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/oṣù';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'Gba $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'Kò lè gbé àwọn ètò ìforúkọsílẹ̀ wọlé. Jọ̀wọ́ ṣàyẹ̀wò ìsopọ̀ íńtánẹ́ẹ̀tì rẹ kí o sì tún gbìyànjú.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'Kò sí ètò ìforúkọsílẹ̀ kankan tó wà nísinsìnyí. Jọ̀wọ́ ṣàyẹ̀wò ètò RevenueCat àti App Store Connect.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'Iye ọdọọdún kò tíì wà fún ètò yìí.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'Iye oṣooṣù kò tíì wà fún ètò yìí.';

  @override
  String get subscriptionWelcomePremium => 'Káàbọ̀ sí Legacy Table Premium!';

  @override
  String get subscriptionRestoreSuccess =>
      'A ti mú àwọn rírà padà bọ̀sípò ní àṣeyọrí!';

  @override
  String get subscriptionRestoreNoneFound => 'A kò rí rírà àtẹ̀yìnwá kankan.';

  @override
  String get recipeFeedNotificationsTooltip => 'Àwọn Ìfìtọ́nilẹ́tí';

  @override
  String get recipeFeedSubheading => 'Àwọn Ìlànà Oúnjẹ Ìdílé';

  @override
  String get recipeFeedTagline =>
      'Pa àti pín àwọn àṣà ìdáná ìdílé wa pẹ̀lú ìfẹ́';

  @override
  String get recipeFeedShareRecipe => 'Pín Ìlànà Oúnjẹ Kan';

  @override
  String get recipeFeedFamilyCookbook => 'Ìwé Oúnjẹ Ìdílé';

  @override
  String get recipeFeedScanRecipe => 'Ṣàwárí Ìlànà Oúnjẹ';

  @override
  String get recipeFeedVoiceRecipe => 'Sọ Ìlànà Oúnjẹ';

  @override
  String get recipeFeedComingSoon => 'Ó ń bọ̀ láìpẹ́';

  @override
  String get recipeFeedSaveFromLink => 'Fipamọ́ Láti Ọ̀nà Ìjápọ̀';

  @override
  String recipeFeedLoadError(String error) {
    return 'Kò lè gbé àwọn ìlànà oúnjẹ wọlé: $error';
  }

  @override
  String get recipeFeedSearchHint => 'Wá ìlànà oúnjẹ, èròjà, tàbí ẹ̀ka...';

  @override
  String get recipeFeedCategoryAll => 'Gbogbo Rẹ̀';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'A kò rí ìlànà oúnjẹ kankan';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'Kò sí ìlànà oúnjẹ síbẹ̀';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'Gbìyànjú láti ṣàtúnṣe ìwáàrí rẹ tàbí ṣàwárí gbogbo ìlànà oúnjẹ';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'Pín ìlànà oúnjẹ ìdílé àkọ́kọ́ rẹ kí o sì bẹ̀rẹ̀ àkójọ rẹ!';

  @override
  String get recipeFeedClearSearch => 'Nù Ìwáàrí Dànù';

  @override
  String get recipeFeedSmartToolsTitle => 'Àwọn Irinṣẹ́ Ìlànà Oúnjẹ Tó Gbọ́n';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'Mú àwọn ìlànà oúnjẹ wọlé bí app wẹ́ẹ̀bù ti ń ṣe é: ṣàwárí káàdì tàbí sọ ọ̀nà ìjápọ̀ fídíò di àkọ̀wé.';

  @override
  String get recipeFeedFeatureScanTitle => 'Ṣàwárí Ìlànà Oúnjẹ';

  @override
  String get recipeFeedFeatureScanDescription =>
      'Lo àwòrán káàdì àfọwọ́kọ tàbí ojú-ìwé ìwé oúnjẹ.';

  @override
  String get recipeFeedFeatureLinkTitle => 'Fipamọ́ Láti Ọ̀nà Ìjápọ̀';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'Sọ ọ̀nà ìjápọ̀ TikTok, Instagram, tàbí YouTube di àkọ̀wé.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'Ilé-iṣẹ́ Àjọyọ̀';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'àkókò $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return 'ọjọ́ $days kù';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ìlànà oúnjẹ $count',
      one: 'ìlànà oúnjẹ 1',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'Jọ̀wọ́ wọlé láti dé ìṣàtúntò profáìlì';

  @override
  String get profileSettingsLoadFailed =>
      'Kò lè gbé dátà olùmúlò wọlé. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get profileSettingsPhotoSourceTitle => 'Yan Orísun Àwòrán';

  @override
  String get profileSettingsCamera => 'Kámẹ́rà';

  @override
  String get profileSettingsGallery => 'Gálárì';

  @override
  String get profileSettingsCancel => 'Fagilé';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'Àṣẹ kámẹ́rà pọn dandan láti ya àwòrán';

  @override
  String get profileSettingsPickImageFailed =>
      'Kò lè yan àwòrán. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get profileSettingsUpdateSuccess => 'A ti ṣàtúnṣe profáìlì ní àṣeyọrí';

  @override
  String get profileSettingsUpdateFailed => 'Kò lè ṣàtúnṣe profáìlì';

  @override
  String get profileSettingsTitle => 'Ìṣàtúntò Profáìlì';

  @override
  String get profileSettingsSubtitle => 'Ṣàtúnṣe bí o ṣe fara hàn sí ìdílé';

  @override
  String get profileSettingsProfilePicture => 'Àwòrán Profáìlì';

  @override
  String get profileSettingsUploadPhotoHint =>
      'Gbé àwòrán wọlé láti ṣe àkànṣe profáìlì rẹ';

  @override
  String get profileSettingsDisplayName => 'Orúkọ Àfihàn';

  @override
  String get profileSettingsFullName => 'Orúkọ Kíkún';

  @override
  String get profileSettingsNicknameLabel => 'Ìnagijẹ (yíyàn)';

  @override
  String get profileSettingsNicknameHint => 'Tẹ ìnagijẹ kan...';

  @override
  String get profileSettingsNicknameHelper =>
      'Ìnagijẹ rẹ ni a óò fihàn dípò orúkọ kíkún rẹ lórí àwọn ìlànà oúnjẹ àti àríwí.';

  @override
  String get profileSettingsAccountInformation => 'Àlàyé Àkàǹtì';

  @override
  String get profileSettingsEmail => 'Ímeèlì';

  @override
  String get profileSettingsMemberSince => 'Ọmọ Ẹgbẹ́ Láti';

  @override
  String get profileSettingsSaveButton => 'Fipamọ́ Àwọn Àyípadà';

  @override
  String get cookbookLoadError =>
      'Kò lè gbé àwọn ìlànà oúnjẹ wọlé. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get cookbookSelectAtLeastOne => 'Jọ̀wọ́ yan ìlànà oúnjẹ kan ó kéré jù';

  @override
  String get cookbookGeneratingPdf => 'Ń ṣẹ̀dá PDF...';

  @override
  String get cookbookGeneratePdfError => 'Kò lè ṣẹ̀dá PDF';

  @override
  String get cookbookPdfGeneratedTitle => 'A ti Ṣẹ̀dá PDF ní Àṣeyọrí!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    return 'Ìwé oúnjẹ rẹ pẹ̀lú ìlànà oúnjẹ $recipeCount ti ṣetán. Kí ni o fẹ́ ṣe?';
  }

  @override
  String get cookbookSaveToDevice => 'Fipamọ́ sí Ẹrọ';

  @override
  String get cookbookShare => 'Pín';

  @override
  String get cookbookPreviewPrint => 'Àkọ́wòye/Ìtẹ̀wé';

  @override
  String get cookbookCancel => 'Fagilé';

  @override
  String get cookbookSavingPdf => 'Ń fipamọ́ PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      'A ti fipamọ́ PDF ní àṣeyọrí sí fódà Downloads!';

  @override
  String get cookbookPdfSharedSuccess => 'A ti pín PDF ní àṣeyọrí!';

  @override
  String get cookbookSavePdfError => 'Kò lè fipamọ́ PDF';

  @override
  String get cookbookSharePdfError => 'Kò lè pín PDF';

  @override
  String get cookbookPreviewPdfError => 'Kò lè ṣe àkọ́wòye PDF';

  @override
  String get cookbookTitle => 'Ìwé Oúnjẹ Ìdílé';

  @override
  String get cookbookSubtitle =>
      'Yan àwọn ìlànà oúnjẹ láti ṣẹ̀dá ìwé oúnjẹ PDF tí a lè tẹ̀';

  @override
  String get cookbookClear => 'Nù Ún Dànù';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    return 'A yan ìlànà oúnjẹ $selectedCount';
  }

  @override
  String get cookbookReadyToCreate => 'Ó ṣetán láti ṣẹ̀dá ìwé oúnjẹ rẹ';

  @override
  String get cookbookExportButton => 'Kó Ìwé Oúnjẹ PDF Jáde';

  @override
  String get cookbookNoRecipesTitle => 'Kò sí ìlànà oúnjẹ síbẹ̀';

  @override
  String get cookbookNoRecipesSubtitle =>
      'Fi àwọn ìlànà oúnjẹ kún ún láti ṣẹ̀dá ìwé oúnjẹ rẹ';

  @override
  String get createFamilyAppBarTitle => 'Dá Ìdílé';

  @override
  String get createFamilyHeading => 'Dá Ìdílé Kan';

  @override
  String get createFamilySubtitle =>
      'Bẹ̀rẹ̀ pípín ìlànà oúnjẹ pẹ̀lú àwọn ọmọ ìdílé rẹ';

  @override
  String get createFamilyNameLabel => 'ORÚKỌ ÌDÍLÉ';

  @override
  String get createFamilyNameHint => 'f.a., Ìdílé Adéwálé';

  @override
  String get createFamilyNameRequired => 'Jọ̀wọ́ tẹ orúkọ ìdílé kan';

  @override
  String get createFamilyNameTooShort =>
      'Orúkọ ìdílé gbọ́dọ̀ jẹ́ àmì méjì ó kéré jù';

  @override
  String get createFamilyNameTooLong =>
      'Orúkọ ìdílé gbọ́dọ̀ jẹ́ àmì 50 tàbí kéré sí i';

  @override
  String get createFamilyDescriptionLabel => 'ÀPÈJÚWE (YÍYÀN)';

  @override
  String get createFamilyDescriptionHint => 'Sọ fún wa nípa ìdílé rẹ...';

  @override
  String get createFamilyDescriptionTooLong =>
      'Àpèjúwe gbọ́dọ̀ jẹ́ àmì 500 tàbí kéré sí i';

  @override
  String get createFamilySubmitButton => 'Dá Ìdílé';

  @override
  String get createFamilyKeeperInfo =>
      'Ìwọ yóò di olùtọ́jú ìdílé, ìwọ sì lè pe àwọn mìíràn';

  @override
  String get createFamilyErrorGeneric => 'Kò lè dá ìdílé';

  @override
  String get createFamilyErrorAlreadyMember => 'O ti jẹ́ ọmọ ìdílé kan tẹ́lẹ̀.';

  @override
  String get createFamilySuccessTitle => 'A ti Dá Ìdílé!';

  @override
  String get createFamilyInviteCodeLabel => 'Kóòdù Ìpè';

  @override
  String get createFamilyInviteCodeCopied => 'A ti ṣàdàkọ kóòdù ìpè!';

  @override
  String get createFamilyShareCodeHint =>
      'Pín kóòdù yìí pẹ̀lú àwọn ọmọ ìdílé láti pè wọ́n';

  @override
  String get createFamilyShareInviteButton => 'Pín Ìpè';

  @override
  String get createFamilyDoneButton => 'Ó Tán';

  @override
  String get loginSubtitle => 'Pín ogún ìdáná rẹ';

  @override
  String get loginEmailLabel => 'ÍMEÈLÌ';

  @override
  String get loginEmailHint => 'Tẹ ímeèlì rẹ';

  @override
  String get loginEmailRequired => 'Jọ̀wọ́ tẹ ímeèlì rẹ';

  @override
  String get loginEmailInvalid => 'Jọ̀wọ́ tẹ ímeèlì tó tọ́';

  @override
  String get loginPasswordLabel => 'Ọ̀RỌ̀ ÌGBÀWỌLÉ';

  @override
  String get loginPasswordHint => 'Tẹ ọ̀rọ̀ ìgbàwọlé rẹ';

  @override
  String get loginPasswordRequired => 'Jọ̀wọ́ tẹ ọ̀rọ̀ ìgbàwọlé rẹ';

  @override
  String get loginPasswordTooShort =>
      'Ọ̀rọ̀ ìgbàwọlé gbọ́dọ̀ jẹ́ àmì mẹ́fà ó kéré jù';

  @override
  String get loginSignInButton => 'Wọlé';

  @override
  String get loginOrDivider => 'tàbí';

  @override
  String get loginContinueWithGoogle => 'Tẹ̀síwájú pẹ̀lú Google';

  @override
  String get loginContinueWithApple => 'Tẹ̀síwájú pẹ̀lú Apple';

  @override
  String get loginContinueWithFacebook => 'Tẹ̀síwájú pẹ̀lú Facebook';

  @override
  String get loginNewToFamily => 'Tuntun sí ìdílé? ';

  @override
  String get loginCreateAccount => 'Dá àkàǹtì';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'Àṣẹ máíkíròfóònù pọn dandan láti ṣàkọsílẹ̀ ìlànà oúnjẹ';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'Kò lè bẹ̀rẹ̀ ìṣàkọsílẹ̀: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'Kò lè dá ìṣàkọsílẹ̀ dúró: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'A kò rí fáìlì ìṣàkọsílẹ̀';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'A ti kọ ìlànà oúnjẹ sílẹ̀! Kírẹ́dítì $credits ló kù.';
  }

  @override
  String get voiceRecipeTitle => 'Ìlànà Oúnjẹ Ohùn';

  @override
  String get voiceRecipeIntro =>
      'Sọ ìlànà oúnjẹ rẹ sókè — a óò kọ ọ́ sílẹ̀ kí a sì sọ ọ́ di àkọ̀wé tí a ṣètò.';

  @override
  String get voiceRecipeUsesCredits => 'Ó lo kírẹ́dítì AI 2';

  @override
  String get voiceRecipeTapToStop => 'Tẹ bọ́tìnì láti dúró';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'Ìṣàkọsílẹ̀: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'Ó ṣetán láti kọ sílẹ̀';

  @override
  String get voiceRecipeTapToStart => 'Tẹ láti bẹ̀rẹ̀ ìṣàkọsílẹ̀';

  @override
  String get voiceRecipeSpeakNaturally =>
      'Sọ ìlànà oúnjẹ rẹ lọ́nà ẹ̀dá — fi àwọn èròjà, ìwọ̀n, àti àwọn ìgbésẹ̀ kún un.';

  @override
  String get voiceRecipeTipsTitle => 'Àwọn ìmọ̀ràn fún àbájáde tó dára jù';

  @override
  String get voiceRecipeTipsBody =>
      '• Bẹ̀rẹ̀ pẹ̀lú orúkọ ìlànà oúnjẹ\n• Tò èròjà kọ̀ọ̀kan pẹ̀lú ìwọ̀n\n• Ṣàpèjúwe àwọn ìgbésẹ̀ ní ìtẹ̀léǹtẹ̀lé\n• Mẹ́nu àkókò ìsè àti ìpín àbọ̀';

  @override
  String get voiceRecipeTranscribing => 'Ń kọ sílẹ̀ pẹ̀lú AI...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'Kọ Sílẹ̀ Di Àkọ̀wé';

  @override
  String get voiceRecipeRecordAgain => 'Tún Ṣàkọsílẹ̀';

  @override
  String get registerSubtitle => 'Pín ogún ìdáná rẹ';

  @override
  String get registerNameLabel => 'ORÚKỌ';

  @override
  String get registerNameHint => 'Tẹ orúkọ rẹ';

  @override
  String get registerNameRequired => 'Jọ̀wọ́ tẹ orúkọ rẹ';

  @override
  String get registerEmailLabel => 'ÍMEÈLÌ';

  @override
  String get registerEmailHint => 'Tẹ ímeèlì rẹ';

  @override
  String get registerEmailRequired => 'Jọ̀wọ́ tẹ ímeèlì rẹ';

  @override
  String get registerEmailInvalid => 'Jọ̀wọ́ tẹ ímeèlì tó tọ́';

  @override
  String get registerNicknameLabel => 'ÌNAGIJẸ (YÍYÀN)';

  @override
  String get registerNicknameHint => 'Tẹ ìnagijẹ rẹ (yíyàn)';

  @override
  String get registerNicknameTooLong =>
      'Ìnagijẹ gbọ́dọ̀ jẹ́ àmì 30 tàbí kéré sí i';

  @override
  String get registerPasswordLabel => 'Ọ̀RỌ̀ ÌGBÀWỌLÉ';

  @override
  String get registerPasswordHint => 'Tẹ ọ̀rọ̀ ìgbàwọlé rẹ';

  @override
  String get registerPasswordRequired => 'Jọ̀wọ́ tẹ ọ̀rọ̀ ìgbàwọlé rẹ';

  @override
  String get registerPasswordTooShort =>
      'Ọ̀rọ̀ ìgbàwọlé gbọ́dọ̀ jẹ́ àmì mẹ́fà ó kéré jù';

  @override
  String get registerCreateAccountButton => 'Dá Àkàǹtì';

  @override
  String get registerAlreadyHaveAccount => 'O ti ní àkàǹtì tẹ́lẹ̀? ';

  @override
  String get registerSignInLink => 'Wọlé';

  @override
  String get registerRegistrationFailed => 'Ìforúkọsílẹ̀ kùnà';

  @override
  String get scanRecipeCameraPermission =>
      'Àṣẹ kámẹ́rà pọn dandan láti ṣàwárí ìlànà oúnjẹ';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'A ti ṣàwárí ìlànà oúnjẹ! Kírẹ́dítì $credits ló kù.';
  }

  @override
  String get scanRecipeTitle => 'Ṣàwárí Ìlànà Oúnjẹ';

  @override
  String get scanRecipeIntro =>
      'Sọ káàdì àfọwọ́kọ tàbí ojú-ìwé ìwé oúnjẹ di àkọ̀wé ìlànà oúnjẹ tí a lè ṣàtúnṣe.';

  @override
  String get scanRecipeCreditCost => 'Ó lo kírẹ́dítì AI 1';

  @override
  String get scanRecipeEmptyTitle => 'Fi àwòrán ìlànà oúnjẹ kún ún láti ṣàwárí';

  @override
  String get scanRecipeEmptyHint =>
      'Àbájáde tó dára jù máa ń wá láti inú àwòrán tó ṣe kedere, tó ní ìmọ́lẹ̀ pẹ̀lú gbogbo ìlànà oúnjẹ tó hàn.';

  @override
  String get scanRecipeChoosePhoto => 'Yan Àwòrán';

  @override
  String get scanRecipeTakePhoto => 'Ya Àwòrán';

  @override
  String get scanRecipeScanning => 'Ń ṣàwárí pẹ̀lú AI...';

  @override
  String get scanRecipeScanButton => 'Ṣàwárí Di Àkọ̀wé';

  @override
  String get notificationsLoadError =>
      'Kò lè gbé àwọn ìfìtọ́nilẹ́tí wọlé. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get notificationsAllMarkedRead =>
      'A ti samì sí gbogbo ìfìtọ́nilẹ́tí gẹ́gẹ́ bí kíkà';

  @override
  String get notificationsMarkAllError =>
      'Kò lè samì sí gbogbo rẹ̀ gẹ́gẹ́ bí kíkà. Jọ̀wọ́ tún gbìyànjú.';

  @override
  String get notificationsTitle => 'Àwọn Ìfìtọ́nilẹ́tí';

  @override
  String get notificationsMarkAllButton => 'Samì sí gbogbo rẹ̀ gẹ́gẹ́ bí kíkà';

  @override
  String get notificationsEmptyTitle => 'Kò sí ìfìtọ́nilẹ́tí';

  @override
  String get notificationsEmptySubtitle => 'O ti mọ̀ nípa gbogbo rẹ̀!';

  @override
  String get joinFamilyAppBarTitle => 'Darapọ̀ Mọ́ Ìdílé';

  @override
  String get joinFamilyHeading => 'Darapọ̀ Mọ́ Ìdílé Kan';

  @override
  String get joinFamilySubtitle =>
      'Tẹ kóòdù ìpè onílẹ́tà-mẹ́jọ láti ọ̀dọ̀ olùtọ́jú ìdílé rẹ';

  @override
  String get joinFamilyInviteCodeLabel => 'KÓÒDÙ ÌPÈ';

  @override
  String get joinFamilyButton => 'Darapọ̀ Mọ́ Ìdílé';

  @override
  String get joinFamilyInfoText => 'Béèrè kóòdù ìpè lọ́wọ́ olùtọ́jú ìdílé rẹ';

  @override
  String get joinFamilyEmptyCodeError => 'Jọ̀wọ́ tẹ kóòdù ìpè';

  @override
  String get joinFamilyCodeLengthError => 'Kóòdù ìpè gbọ́dọ̀ jẹ́ àmì mẹ́jọ';

  @override
  String get joinFamilyGenericError => 'Kò lè darapọ̀ mọ́ ìdílé';

  @override
  String get joinFamilyInvalidCodeError =>
      'Kóòdù ìpè kò tọ́. Jọ̀wọ́ ṣàyẹ̀wò kí o sì tún gbìyànjú.';

  @override
  String get joinFamilyAlreadyMemberError => 'O ti jẹ́ ọmọ ìdílé kan tẹ́lẹ̀.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'O ti darapọ̀ mọ́ $familyName ní àṣeyọrí!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'Lẹ̀ fídíò ìdáná tàbí ọ̀nà ìjápọ̀ ìlànà oúnjẹ kún ún ní àkọ́kọ́';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'Jọ̀wọ́ tẹ URL tó tọ́ tó bẹ̀rẹ̀ pẹ̀lú http:// tàbí https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'A ti mú ìlànà oúnjẹ wọlé! Kírẹ́dítì $creditsRemaining ló kù.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'Fipamọ́ Láti Ọ̀nà Ìjápọ̀';

  @override
  String get saveFromLinkIntro =>
      'Lẹ̀ ọ̀nà ìjápọ̀ TikTok, Instagram, YouTube, tàbí ìlànà oúnjẹ kún ún kí o sì sọ ọ́ di àkọ̀wé Legacy Table tí a lè pín.';

  @override
  String get saveFromLinkCreditCost => 'Ó lo kírẹ́dítì AI 1';

  @override
  String get saveFromLinkDraftInfo =>
      'Ìlànà oúnjẹ tí a mú wọlé yóò ṣí gẹ́gẹ́ bí àkọ̀wé ní àkọ́kọ́, kí o lè ṣàtúnṣe àwọn èròjà, ṣàtúnṣe àwọn ìtọ́sọ́nà, kí o sì fi ìtàn tìrẹ kún un kí o tó pín in.';

  @override
  String get saveFromLinkImportingLabel => 'Ń mú wọlé pẹ̀lú AI...';

  @override
  String get saveFromLinkCreateDraftButton => 'Dá Àkọ̀wé Láti Ọ̀nà Ìjápọ̀';

  @override
  String get onboardingNextButton => 'Tó Kàn';

  @override
  String get onboardingGetStartedButton => 'Bẹ̀rẹ̀';

  @override
  String get homeUpgradeFab => 'Gbéga';

  @override
  String get homeShareRecipeFab => 'Pín Ìlànà Oúnjẹ Kan';

  @override
  String get homeNavHome => 'Ilé';

  @override
  String get homeNavCookbook => 'Ìwé Oúnjẹ';

  @override
  String get homeNavMyRecipes => 'Àwọn Ìlànà Oúnjẹ Mi';

  @override
  String get homeNavFamily => 'Ìdílé';

  @override
  String get homeNavSettings => 'Ìṣàtúntò';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Ètò Premium ti ń ṣiṣẹ́';

  @override
  String get homeSubscriptionUnlock => 'Ṣí àwọn ẹ̀yà ìdílé premium';

  @override
  String get profileTitle => 'Profáìlì Mi';

  @override
  String get profileNoRecipesTitle => 'Kò sí ìlànà oúnjẹ síbẹ̀';

  @override
  String get profileNoRecipesSubtitle => 'Pín ìlànà oúnjẹ ìdílé àkọ́kọ́ rẹ!';

  @override
  String profileLoadRecipesError(String error) {
    return 'Kò lè gbé àwọn ìlànà oúnjẹ wọlé: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'Kò sí ìlànà oúnjẹ tí a samì fún $holidayName síbẹ̀';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'Samì sí oúnjẹ ìdílé tí a fẹ́ràn fún ọdún yìí láti app wẹ́ẹ̀bù tàbí àwọn àfikún àlàyé alágbèéká tó ń bọ̀.';

  @override
  String get shareInviteTitle => 'Pín Ìpè';

  @override
  String get shareInviteLinkTab => 'Ọ̀nà Ìjápọ̀';

  @override
  String get shareInviteCodeTab => 'Kóòdù';

  @override
  String get shareInviteLinkHint =>
      'Ó ń ṣí app náà tàbí fihàn àwọn àṣàyàn ìgbàsílẹ̀';

  @override
  String get shareInviteCodeHint => 'Olùgbà yóò tẹ kóòdù yìí nínú app náà';

  @override
  String get shareInviteCopiedSnackbar => 'A ti ṣàdàkọ!';

  @override
  String get shareInviteCopyButton => 'Ṣàdàkọ';

  @override
  String get shareInviteShareButton => 'Pín';

  @override
  String get familySettingsInviteCodeCopied => 'A ti ṣàdàkọ kóòdù ìpè!';

  @override
  String get familySettingsFamilyHeading => 'Ìdílé';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'Darapọ̀ mọ́ tàbí dá ìdílé kan láti bẹ̀rẹ̀ pípín ìlànà oúnjẹ';

  @override
  String get familySettingsNoFamilyYet => 'Kò sí ìdílé síbẹ̀';

  @override
  String get familySettingsStartSharingRecipes =>
      'Bẹ̀rẹ̀ pípín ìlànà oúnjẹ pẹ̀lú àwọn ọmọ ìdílé rẹ';

  @override
  String get familySettingsJoinFamilyButton => 'Darapọ̀ Mọ́ Ìdílé';

  @override
  String get familySettingsCreateFamilyButton => 'Dá Ìdílé';

  @override
  String get familySettingsTitle => 'Ìṣàtúntò ìdílé';

  @override
  String get familySettingsManageSubtitle =>
      'Ṣàkóso ìdílé rẹ àti kóòdù ìpè rẹ.';

  @override
  String get familySettingsInviteCodeLabel => 'Kóòdù ìpè';

  @override
  String get familySettingsCopyButton => 'Ṣàdàkọ';

  @override
  String get familySettingsShareCodeHelper =>
      'Pín kóòdù yìí kí àwọn mìíràn lè darapọ̀ mọ́ ìdílé rẹ.';

  @override
  String get familySettingsMembersLabel => 'Àwọn Ọmọ Ẹgbẹ́';

  @override
  String get familySettingsNoMembersYet => 'Kò sí ọmọ ẹgbẹ́ síbẹ̀';

  @override
  String get familySettingsKeeperBadge => 'Olùtọ́jú';

  @override
  String recipeCardCookingTime(int minutes) {
    return 'ìṣẹ́jú $minutes';
  }

  @override
  String recipeCardServings(int count) {
    return 'ìpín àbọ̀ $count';
  }

  @override
  String get styledSnackbarDismiss => 'Kọ̀ Ọ́ Sílẹ̀';

  @override
  String get celebrationTitle => 'Ilé-iṣẹ́ Àjọyọ̀';

  @override
  String get celebrationNextUp => ' — Tó kàn: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ọjọ́',
      one: 'ọjọ́',
    );
    return '$emoji $name ní $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ọjọ́',
      one: 'ọjọ́',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'ìlànà oúnjẹ',
      one: 'ìlànà oúnjẹ',
    );
    return '$days $_temp0 kù  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return 'ìṣẹ́jú $minutes';
  }

  @override
  String cookbookCardServings(int count) {
    return 'ìpín àbọ̀ $count';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'láti ọwọ́ $name';
  }

  @override
  String get familyPromptTitle => 'Darapọ̀ Mọ́ tàbí Dá Ìdílé Kan';

  @override
  String get familyPromptSubtitle =>
      'Bẹ̀rẹ̀ pípín ìlànà oúnjẹ pẹ̀lú àwọn ọmọ ìdílé rẹ';

  @override
  String get familyPromptJoinButton => 'Darapọ̀ Mọ́ Ìdílé';

  @override
  String get familyPromptCreateButton => 'Dá Ìdílé';
}
