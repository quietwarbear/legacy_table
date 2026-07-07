// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get settingsLanguage => 'بولی';

  @override
  String get selectLanguage => 'بولی چنو';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'سیٹنگز';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'اکاؤنٹ مٹاون والا صفحہ کھل نئیں سکیا';

  @override
  String get settingsFailedToLoadMembers => 'ٹبر دے جی لوڈ نئیں ہو سکے';

  @override
  String get settingsInviteCodeCopied => 'انوائیٹ کوڈ کاپی ہو گیا!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Legacy Table اُتے میرے ٹبر \"$name\" وچ شامل ہووو!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'انوائیٹ کوڈ: $code';
  }

  @override
  String get settingsLeaveFamily => 'ٹبر چھڈو';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'کی تُسیں واقعی \"$name\" چھڈنا چاہندے او؟ دوبارہ شامل ہون لئی تہانوں انوائیٹ کوڈ دی لوڑ پوے گی۔';
  }

  @override
  String get settingsCancel => 'منسوخ';

  @override
  String get settingsLeave => 'چھڈو';

  @override
  String get settingsLeftFamilySuccess => 'ٹبر کامیابی نال چھڈ دتا';

  @override
  String get settingsFailedToLeaveFamily => 'ٹبر چھڈن وچ ناکامی';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'جان توں پہلاں تہانوں رکھوالے دی ذمے داری کسے ہور نوں دینی پوے گی';

  @override
  String get settingsTransferKeeperRole => 'رکھوالے دی ذمے داری منتقل کرو';

  @override
  String get settingsTransferKeeperPrompt =>
      'رکھوالے ہون دے ناطے، جان توں پہلاں تہانوں اپنی ذمے داری کسے ہور جی نوں دینی پوے گی۔ نواں رکھوالا بنان لئی کوئی جی چنو:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'رکھوالے دی ذمے داری $name نوں منتقل ہو گئی';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'ٹبر چھڈنا اے؟';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'تُسیں رکھوالے دی ذمے داری کامیابی نال منتقل کر دتی اے۔ کی ہُن تُسیں ٹبر چھڈنا چاہندے او؟';

  @override
  String get settingsStay => 'رہوو';

  @override
  String get settingsFailedToTransferKeeper =>
      'رکھوالے دی ذمے داری منتقل نئیں ہو سکی';

  @override
  String get settingsRemoveMember => 'ممبر کڈھو';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'کی تُسیں واقعی \"$name\" نوں \"$family\" وچوں کڈھنا چاہندے او؟ دوبارہ شامل ہون لئی اوہناں نوں انوائیٹ کوڈ دی لوڑ پوے گی۔';
  }

  @override
  String get settingsRemove => 'کڈھو';

  @override
  String settingsMemberRemoved(String name) {
    return '$name نوں ٹبر وچوں کڈھ دتا گیا اے';
  }

  @override
  String get settingsFailedToRemoveMember => 'ممبر کڈھن وچ ناکامی';

  @override
  String get settingsManageSubscription => 'سبسکرپشن دا انتظام';

  @override
  String get settingsUpgradeToPremium => 'Premium اُتے اپ گریڈ کرو';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection چالو اے';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper چالو اے';

  @override
  String get settingsUnlockPremiumFeatures =>
      'ٹبر والے پلان، ایکسپورٹ تے Premium فیچر کھولو';

  @override
  String get settingsKeeperBadge => 'رکھوالا';

  @override
  String get settingsMemberBadge => 'ممبر';

  @override
  String get settingsInviteCodeLabel => 'انوائیٹ کوڈ';

  @override
  String get settingsShareInviteCodeButton => 'انوائیٹ کوڈ شیئر کرو';

  @override
  String get settingsFamilyMembers => 'ٹبر دے جی';

  @override
  String get settingsNoMembersFound => 'کوئی ممبر نئیں لبھیا';

  @override
  String get settingsRemoveMemberTooltip => 'ممبر کڈھو';

  @override
  String get settingsTheme => 'تھیم';

  @override
  String get settingsDarkMode => 'ڈارک موڈ';

  @override
  String get settingsLightMode => 'لائٹ موڈ';

  @override
  String get settingsEditProfile => 'پروفائل ایڈٹ کرو';

  @override
  String get settingsDeleteAccount => 'اکاؤنٹ مٹاؤ';

  @override
  String get settingsNotifications => 'نوٹیفکیشنز';

  @override
  String get settingsTermsOfUse => 'ورتوں دیاں شرطاں';

  @override
  String get settingsPrivacyPolicy => 'پرائیویسی پالیسی';

  @override
  String get settingsAbout => 'ایپ بارے';

  @override
  String get settingsAboutVersion => 'Legacy Table ٹبر دیاں ریسپیاں v2.0.0';

  @override
  String get settingsLegalese => '© 2026 Ubuntu Market LLC. سارے حق محفوظ نیں۔';

  @override
  String get settingsLogout => 'لاگ آؤٹ';

  @override
  String get settingsLogoutConfirm => 'کی تُسیں واقعی لاگ آؤٹ کرنا چاہندے او؟';

  @override
  String get recipeDetailLoadRecipeError =>
      'ریسپی لوڈ نئیں ہو سکی۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get recipeDetailLoadCommentsError =>
      'کمنٹس لوڈ نئیں ہو سکے۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get recipeDetailLoginToComment =>
      'کمنٹ کرن لئی مہربانی کر کے لاگ اِن کرو';

  @override
  String get recipeDetailCommentPosted => 'کمنٹ پوسٹ ہو گیا!';

  @override
  String get recipeDetailPostCommentError => 'کمنٹ پوسٹ نئیں ہو سکیا';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'کمنٹ پوسٹ نئیں ہو سکیا: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'کمنٹ مٹاؤ';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'کی تُسیں واقعی ایہ کمنٹ مٹانا چاہندے او؟';

  @override
  String get recipeDetailCancel => 'منسوخ';

  @override
  String get recipeDetailDelete => 'مٹاؤ';

  @override
  String get recipeDetailCommentDeleted => 'کمنٹ مٹا دتا گیا';

  @override
  String get recipeDetailDeleteCommentError => 'کمنٹ مٹاون وچ ناکامی';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'کمنٹ مٹاون وچ ناکامی: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'ریسپی اپڈیٹ ہو گئی!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'ریسپی مٹاؤ';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'کی تُسیں واقعی \"$title\" مٹانا چاہندے او؟ ایہ کم فیر واپس نئیں ہو سکدا۔';
  }

  @override
  String get recipeDetailRecipeDeleted => 'ریسپی مٹا دتی گئی';

  @override
  String get recipeDetailDeleteRecipeError => 'ریسپی مٹاون وچ ناکامی';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'ریسپی مٹاون وچ ناکامی: $error';
  }

  @override
  String get recipeDetailNotFound => 'ریسپی نئیں لبھی';

  @override
  String get recipeDetailSharedByLabel => 'شیئر کرن والے';

  @override
  String get recipeDetailUnknownAuthor => 'نامعلوم';

  @override
  String get recipeDetailEdit => 'ایڈٹ کرو';

  @override
  String get recipeDetailStatTime => 'وقت';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get recipeDetailStatServes => 'بندے';

  @override
  String get recipeDetailStatCategory => 'کیٹیگری';

  @override
  String get recipeDetailIngredients => 'اجزاء';

  @override
  String get recipeDetailInstructions => 'ترکیب';

  @override
  String get recipeDetailStoryTitle => 'ایس ریسپی پچھے دی کہانی';

  @override
  String recipeDetailStorySharedBy(String author) {
    return '$author ولوں شیئر کیتی گئی';
  }

  @override
  String get recipeDetailFamilyComments => 'ٹبر دے کمنٹس';

  @override
  String get recipeDetailRefreshComments => 'کمنٹس تازہ کرو';

  @override
  String get recipeDetailCommentHint => 'ایس ریسپی بارے اپنے خیال دسو...';

  @override
  String get recipeDetailClear => 'صاف کرو';

  @override
  String get recipeDetailPosting => 'پوسٹ ہو رہیا اے...';

  @override
  String get recipeDetailPost => 'پوسٹ کرو';

  @override
  String get recipeDetailNoComments => 'ہالے کوئی کمنٹ نئیں';

  @override
  String get recipeDetailBeFirstToComment =>
      'سب توں پہلاں اپنے خیال دسن والے تُسیں بنو!';

  @override
  String get recipeDetailNoImage => 'کوئی تصویر موجود نئیں';

  @override
  String get recipeDetailDeleteCommentTooltip => 'کمنٹ مٹاؤ';

  @override
  String get addRecipePhotoPermissionTitle => 'فوٹو لائبریری دی اجازت';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'تصویراں چنن لئی فوٹو لائبریری دی اجازت ضروری اے۔\n\nچالو کرن لئی:\n1. \"سیٹنگز کھولو\" اُتے ٹیپ کرو\n2. \"Permissions\" وچ جاؤ\n3. \"Photos and videos\" چالو کرو';

  @override
  String get addRecipeStoragePermissionTitle => 'سٹوریج دی اجازت';

  @override
  String get addRecipeStoragePermissionMessage =>
      'تصویراں چنن لئی سٹوریج دی اجازت ضروری اے۔\n\nچالو کرن لئی:\n1. \"سیٹنگز کھولو\" اُتے ٹیپ کرو\n2. \"Permissions\" وچ جاؤ\n3. \"Storage\" یا \"Files and media\" چالو کرو';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'تصویراں چنن لئی فوٹو لائبریری دی اجازت ضروری اے۔\n\nچالو کرن لئی:\n1. \"سیٹنگز کھولو\" اُتے ٹیپ کرو\n2. \"Legacy Table\" لبھو\n3. \"Photos\" اُتے ٹیپ کرو\n4. \"All Photos\" یا \"Selected Photos\" چنو';

  @override
  String get addRecipeCameraPermissionTitle => 'کیمرے دی اجازت';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'کیمرے دی اجازت پکی طرحاں بند کر دتی گئی اے۔ مہربانی کر کے ایپ دیاں سیٹنگز وچوں چالو کرو۔';

  @override
  String get addRecipeCameraPermissionRequired =>
      'فوٹو کھچن لئی کیمرے دی اجازت ضروری اے';

  @override
  String get addRecipeCancel => 'منسوخ';

  @override
  String get addRecipeSettingsHintAndroid =>
      'ایپ سیٹنگز وچ \"Photos and videos\" یا \"Media\" والی اجازت لبھو';

  @override
  String get addRecipeSettingsHintIos =>
      'ایپ سیٹنگز وچ \"Photos\" والی اجازت لبھو';

  @override
  String get addRecipeOpenSettings => 'سیٹنگز کھولو';

  @override
  String get addRecipeImageSelectError =>
      'تصویراں چنیاں نئیں جا سکیاں۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get addRecipeTakePhotoError =>
      'فوٹو کھچی نئیں جا سکی۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get addRecipeSelectCategoryWarning => 'مہربانی کر کے کوئی کیٹیگری چنو';

  @override
  String get addRecipeAddIngredientWarning =>
      'مہربانی کر کے گھٹ توں گھٹ اک چیز شامل کرو';

  @override
  String get addRecipeUpdatingRecipe => 'ریسپی اپڈیٹ ہو رہی اے...';

  @override
  String get addRecipeSharingRecipe => 'ریسپی شیئر ہو رہی اے...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'تصویر \"$fileName\" بہت وڈی اے۔ ودھ توں ودھ سائز 5MB اے۔';
  }

  @override
  String get addRecipeProcessImagesError =>
      'تصویراں پروسیس نئیں ہو سکیاں۔ مہربانی کر کے ہور تصویراں چن کے ویکھو۔';

  @override
  String get addRecipeUpdateSuccess => 'ریسپی اپڈیٹ ہو گئی!';

  @override
  String get addRecipeShareSuccess => 'ریسپی شیئر ہو گئی!';

  @override
  String get addRecipeEditTitle => 'ریسپی ایڈٹ کرو';

  @override
  String get addRecipeShareTitle => 'ریسپی شیئر کرو';

  @override
  String get addRecipeEditSubtitle => 'اپنی ریسپی دیاں تفصیلاں اپڈیٹ کرو';

  @override
  String get addRecipeShareSubtitle => 'ٹبر دی کلیکشن وچ نواں پکوان شامل کرو';

  @override
  String get addRecipePhotosLabel => 'فوٹوز';

  @override
  String get addRecipeTitleLabel => 'ریسپی دا ناں *';

  @override
  String get addRecipeTitlePlaceholder => 'مثلاً، دادی دے خاص جولوف چول';

  @override
  String get addRecipeTitleRequired => 'ریسپی دا ناں ضروری اے';

  @override
  String get addRecipeCategoryLabel => 'کیٹیگری *';

  @override
  String get addRecipeCategoryPlaceholder => 'کیٹیگری چنو';

  @override
  String get addRecipeCategoryRequired => 'کیٹیگری ضروری اے';

  @override
  String get addRecipeDifficultyLabel => 'مشکل دا درجہ';

  @override
  String get addRecipeDifficultyPlaceholder => 'مشکل دا درجہ چنو';

  @override
  String get addRecipeCookingTimeLabel => 'پکاون دا وقت\n(منٹ)';

  @override
  String get addRecipeServingsLabel => '\nبندے';

  @override
  String get addRecipeIngredientsLabel => 'اجزاء *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'چیز $number';
  }

  @override
  String get addRecipeIngredientRequired => 'چیز لکھنی ضروری اے';

  @override
  String get addRecipeAddIngredient => 'ہور چیز شامل کرو';

  @override
  String get addRecipeInstructionsLabel => 'ترکیب *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'پکاون دی ترکیب قدم بہ قدم لکھو...';

  @override
  String get addRecipeInstructionsRequired => 'ترکیب لکھنی ضروری اے';

  @override
  String get addRecipeStoryLabel => 'ایس ریسپی پچھے دی کہانی (اختیاری)';

  @override
  String get addRecipeStoryDescription =>
      'ایس ریسپی دی کہانی سناؤ... ایہ کتھوں آئی؟ کنھے اگے ٹوری؟ تہاڈے ٹبر لئی ایہدے نال کیہڑیاں یاداں جُڑیاں نیں؟';

  @override
  String get addRecipeStoryPlaceholder =>
      'ایس پکوان نال جُڑی تریخ، ریتاں یا خاص یاداں بارے ساہنوں دسو۔';

  @override
  String get addRecipeUpdateButton => 'ریسپی اپڈیٹ کرو';

  @override
  String get addRecipeShareButton => 'ریسپی شیئر کرو';

  @override
  String get addRecipeErrorTitle => 'کجھ غلط ہو گیا';

  @override
  String get addRecipeErrorMessage =>
      'مہربانی کر کے فیر کوشش کرو یا ایپ دوبارہ چلاؤ۔';

  @override
  String get addRecipeGoBack => 'پچھے جاؤ';

  @override
  String get addRecipeUploadFromGallery => 'گیلری توں اپلوڈ کرو';

  @override
  String get addRecipeTakePhoto => 'فوٹو کھچو';

  @override
  String get subscriptionNotNow => 'ہالے نئیں';

  @override
  String get subscriptionRestoring => 'بحال ہو رہیا اے…';

  @override
  String get subscriptionRestore => 'بحال کرو';

  @override
  String get subscriptionHeaderTitle => 'اپنے ٹبر دی وراثت\nسانبھ کے رکھو';

  @override
  String get subscriptionHeaderSubtitle =>
      'Premium فیچر کھولو تاں جو تہاڈے ٹبر دیاں\nریسپیاں نسلاں تیک جیوندیاں رہن۔';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'شروعات لئی بالکل ٹھیک';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'ٹبر دا پورا تجربہ';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'ٹبر دیاں ریسپیاں لئی بے حساب سٹوریج';

  @override
  String get subscriptionFeatureFamilySharing => 'ٹبر نال شیئرنگ (10 جیاں تیک)';

  @override
  String get subscriptionFeaturePhotoUploads => 'ہر ریسپی لئی فوٹو اپلوڈ';

  @override
  String get subscriptionFeatureExportPrint =>
      'ریسپی کتاباں ایکسپورٹ تے پرنٹ کرو';

  @override
  String get subscriptionFeatureCategoriesTags => 'ریسپی کیٹیگریاں تے ٹیگ';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Heritage Keeper دا سب کجھ';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'ٹبر دے بے حساب جی';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'ریسپیاں دی ودھیا ترتیب';

  @override
  String get subscriptionFeaturePrioritySupport => 'پہل دے نال کسٹمر سپورٹ';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'نویں فیچراں تیک سب توں پہلاں رسائی';

  @override
  String get subscriptionFeatureCustomThemes =>
      'ٹبر دی کُک بُک لئی اپنی پسند دے تھیم';

  @override
  String get subscriptionAutoRenewNotice =>
      'سبسکرپشن منسوخ ہون تیک آپے رینیو ہوندی رہندی اے۔ اپنی ڈیوائس دیاں سیٹنگز وچوں جدوں مرضی منسوخ کرو۔';

  @override
  String get subscriptionTermsOfUse => 'ورتوں دیاں شرطاں';

  @override
  String get subscriptionPrivacyPolicy => 'پرائیویسی پالیسی';

  @override
  String get subscriptionMostPopular => 'سب توں مقبول';

  @override
  String get subscriptionPerYear => '/سال';

  @override
  String get subscriptionPerMonth => '/مہینہ';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/مہینہ';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return '$tierName لوو — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'سبسکرپشن پلان لوڈ نئیں ہو سکے۔ مہربانی کر کے اپنا انٹرنیٹ کنکشن ویکھ کے فیر کوشش کرو۔';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'ہالے کوئی سبسکرپشن پلان دستیاب نئیں۔ مہربانی کر کے RevenueCat تے App Store Connect دی کنفیگریشن ویکھو۔';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'ایس پلان لئی سالانہ قیمت ہالے دستیاب نئیں۔';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'ایس پلان لئی مہینے وار قیمت ہالے دستیاب نئیں۔';

  @override
  String get subscriptionWelcomePremium =>
      'Legacy Table Premium وچ جی آیاں نوں!';

  @override
  String get subscriptionRestoreSuccess => 'خریداریاں بحال ہو گئیاں!';

  @override
  String get subscriptionRestoreNoneFound => 'کوئی پرانی خریداری نئیں لبھی۔';

  @override
  String get recipeFeedNotificationsTooltip => 'نوٹیفکیشنز';

  @override
  String get recipeFeedSubheading => 'ٹبر دیاں ریسپیاں';

  @override
  String get recipeFeedTagline =>
      'اپنے ٹبر دے پکواناں دیاں ریتاں پیار نال سانبھو تے ونڈو';

  @override
  String get recipeFeedShareRecipe => 'ریسپی شیئر کرو';

  @override
  String get recipeFeedFamilyCookbook => 'ٹبر دی کُک بُک';

  @override
  String get recipeFeedScanRecipe => 'ریسپی سکین کرو';

  @override
  String get recipeFeedVoiceRecipe => 'بول کے ریسپی دسو';

  @override
  String get recipeFeedComingSoon => 'چھیتی آ رہیا اے';

  @override
  String get recipeFeedSaveFromLink => 'لنک توں سانبھو';

  @override
  String recipeFeedLoadError(String error) {
    return 'ریسپیاں لوڈ نئیں ہو سکیاں: $error';
  }

  @override
  String get recipeFeedSearchHint => 'ریسپیاں، اجزاء یا کیٹیگریاں لبھو...';

  @override
  String get recipeFeedCategoryAll => 'ساریاں';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'کوئی ریسپی نئیں لبھی';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'ہالے کوئی ریسپی نئیں';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'اپنی تلاش بدل کے ویکھو یا ساریاں ریسپیاں ویکھو';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'اپنے ٹبر دی پہلی ریسپی شیئر کرو تے اپنی کلیکشن بناؤنی شروع کرو!';

  @override
  String get recipeFeedClearSearch => 'تلاش صاف کرو';

  @override
  String get recipeFeedSmartToolsTitle => 'سمارٹ ریسپی ٹولز';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'ریسپیاں اوسے طرحاں لیاؤ جیویں ویب ایپ وچ: کوئی کارڈ سکین کرو یا ویڈیو لنک نوں ڈرافٹ بناؤ۔';

  @override
  String get recipeFeedFeatureScanTitle => 'ریسپی سکین کرو';

  @override
  String get recipeFeedFeatureScanDescription =>
      'ہتھ دے لکھے کارڈ یا کُک بُک دے صفحے دی فوٹو ورتو۔';

  @override
  String get recipeFeedFeatureLinkTitle => 'لنک توں سانبھو';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'TikTok، Instagram یا YouTube دا لنک ڈرافٹ وچ بدلو۔';

  @override
  String get recipeFeedCelebrationHeadquarters => 'تہواراں دا ٹھکانہ';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return '$season دا موسم • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return '$days دن باقی';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ریسپیاں',
      one: '1 ریسپی',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'پروفائل سیٹنگز تیک پہنچن لئی مہربانی کر کے لاگ اِن کرو';

  @override
  String get profileSettingsLoadFailed =>
      'یوزر دا ڈیٹا لوڈ نئیں ہو سکیا۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get profileSettingsPhotoSourceTitle => 'فوٹو کتھوں لینی اے؟';

  @override
  String get profileSettingsCamera => 'کیمرہ';

  @override
  String get profileSettingsGallery => 'گیلری';

  @override
  String get profileSettingsCancel => 'منسوخ';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'فوٹو کھچن لئی کیمرے دی اجازت ضروری اے';

  @override
  String get profileSettingsPickImageFailed =>
      'تصویر چنی نئیں جا سکی۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get profileSettingsUpdateSuccess => 'پروفائل اپڈیٹ ہو گئی';

  @override
  String get profileSettingsUpdateFailed => 'پروفائل اپڈیٹ نئیں ہو سکی';

  @override
  String get profileSettingsTitle => 'پروفائل سیٹنگز';

  @override
  String get profileSettingsSubtitle =>
      'ایہ طے کرو کہ ٹبر نوں تُسیں کیویں نظر آؤ';

  @override
  String get profileSettingsProfilePicture => 'پروفائل تصویر';

  @override
  String get profileSettingsUploadPhotoHint =>
      'اپنی پروفائل نوں نکھارن لئی اک فوٹو اپلوڈ کرو';

  @override
  String get profileSettingsDisplayName => 'ڈسپلے ناں';

  @override
  String get profileSettingsFullName => 'پورا ناں';

  @override
  String get profileSettingsNicknameLabel => 'نِک نیم (اختیاری)';

  @override
  String get profileSettingsNicknameHint => 'نِک نیم لکھو...';

  @override
  String get profileSettingsNicknameHelper =>
      'ریسپیاں تے کمنٹس اُتے تہاڈے پورے ناں دی تھاں تہاڈا نِک نیم وکھایا جاوے گا۔';

  @override
  String get profileSettingsAccountInformation => 'اکاؤنٹ دی جانکاری';

  @override
  String get profileSettingsEmail => 'ای میل';

  @override
  String get profileSettingsMemberSince => 'ممبر کدوں توں';

  @override
  String get profileSettingsSaveButton => 'تبدیلیاں سانبھو';

  @override
  String get cookbookLoadError =>
      'ریسپیاں لوڈ نئیں ہو سکیاں۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get cookbookSelectAtLeastOne =>
      'مہربانی کر کے گھٹ توں گھٹ اک ریسپی چنو';

  @override
  String get cookbookGeneratingPdf => 'PDF بن رہی اے...';

  @override
  String get cookbookGeneratePdfError => 'PDF بناون وچ ناکامی';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF بن گئی!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 'ریسپیاں',
      one: 'ریسپی',
    );
    return 'تہاڈی کُک بُک $recipeCount $_temp0 نال تیار اے۔ ہُن تُسیں کی کرنا چاہو گے؟';
  }

  @override
  String get cookbookSaveToDevice => 'ڈیوائس وچ سانبھو';

  @override
  String get cookbookShare => 'شیئر کرو';

  @override
  String get cookbookPreviewPrint => 'پری ویو/پرنٹ';

  @override
  String get cookbookCancel => 'منسوخ';

  @override
  String get cookbookSavingPdf => 'PDF سانبھی جا رہی اے...';

  @override
  String get cookbookPdfSavedSuccess => 'PDF ڈاؤن لوڈز فولڈر وچ سانبھ لئی گئی!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF شیئر ہو گئی!';

  @override
  String get cookbookSavePdfError => 'PDF سانبھن وچ ناکامی';

  @override
  String get cookbookSharePdfError => 'PDF شیئر کرن وچ ناکامی';

  @override
  String get cookbookPreviewPdfError => 'PDF دا پری ویو نئیں ہو سکیا';

  @override
  String get cookbookTitle => 'ٹبر دی کُک بُک';

  @override
  String get cookbookSubtitle =>
      'پرنٹ ہون والی PDF کُک بُک بناون لئی ریسپیاں چنو';

  @override
  String get cookbookClear => 'صاف کرو';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 'ریسپیاں چنیاں گئیاں',
      one: 'ریسپی چنی گئی',
    );
    return '$selectedCount $_temp0';
  }

  @override
  String get cookbookReadyToCreate => 'تہاڈی کُک بُک بنن لئی تیار اے';

  @override
  String get cookbookExportButton => 'PDF کُک بُک ایکسپورٹ کرو';

  @override
  String get cookbookNoRecipesTitle => 'ہالے کوئی ریسپی نئیں';

  @override
  String get cookbookNoRecipesSubtitle =>
      'اپنی کُک بُک بناون لئی ریسپیاں شامل کرو';

  @override
  String get createFamilyAppBarTitle => 'ٹبر بناؤ';

  @override
  String get createFamilyHeading => 'نواں ٹبر بناؤ';

  @override
  String get createFamilySubtitle =>
      'اپنے ٹبر دے جیاں نال ریسپیاں ونڈنا شروع کرو';

  @override
  String get createFamilyNameLabel => 'ٹبر دا ناں';

  @override
  String get createFamilyNameHint => 'مثلاً، بٹ فیملی';

  @override
  String get createFamilyNameRequired => 'مہربانی کر کے ٹبر دا ناں لکھو';

  @override
  String get createFamilyNameTooShort =>
      'ٹبر دا ناں گھٹ توں گھٹ 2 حرفاں دا ہووے';

  @override
  String get createFamilyNameTooLong =>
      'ٹبر دا ناں ودھ توں ودھ 50 حرفاں دا ہووے';

  @override
  String get createFamilyDescriptionLabel => 'تفصیل (اختیاری)';

  @override
  String get createFamilyDescriptionHint => 'اپنے ٹبر بارے ساہنوں دسو...';

  @override
  String get createFamilyDescriptionTooLong =>
      'تفصیل ودھ توں ودھ 500 حرفاں دی ہووے';

  @override
  String get createFamilySubmitButton => 'ٹبر بناؤ';

  @override
  String get createFamilyKeeperInfo =>
      'تُسیں ٹبر دے رکھوالے بنو گے تے دوجیاں نوں انوائیٹ کر سکو گے';

  @override
  String get createFamilyErrorGeneric => 'ٹبر بناون وچ ناکامی';

  @override
  String get createFamilyErrorAlreadyMember =>
      'تُسیں پہلاں ای کسے ٹبر دا حصہ او۔';

  @override
  String get createFamilySuccessTitle => 'ٹبر بن گیا!';

  @override
  String get createFamilyInviteCodeLabel => 'انوائیٹ کوڈ';

  @override
  String get createFamilyInviteCodeCopied => 'انوائیٹ کوڈ کاپی ہو گیا!';

  @override
  String get createFamilyShareCodeHint =>
      'ٹبر دے جیاں نوں سدن لئی ایہ کوڈ اوہناں نال شیئر کرو';

  @override
  String get createFamilyShareInviteButton => 'انوائیٹ شیئر کرو';

  @override
  String get createFamilyDoneButton => 'ہو گیا';

  @override
  String get loginSubtitle => 'اپنے پکوانی ورثے دی سانجھ پاؤ';

  @override
  String get loginEmailLabel => 'ای میل';

  @override
  String get loginEmailHint => 'اپنی ای میل لکھو';

  @override
  String get loginEmailRequired => 'مہربانی کر کے اپنی ای میل لکھو';

  @override
  String get loginEmailInvalid => 'مہربانی کر کے صحیح ای میل لکھو';

  @override
  String get loginPasswordLabel => 'پاس ورڈ';

  @override
  String get loginPasswordHint => 'اپنا پاس ورڈ لکھو';

  @override
  String get loginPasswordRequired => 'مہربانی کر کے اپنا پاس ورڈ لکھو';

  @override
  String get loginPasswordTooShort => 'پاس ورڈ گھٹ توں گھٹ 6 حرفاں دا ہووے';

  @override
  String get loginSignInButton => 'سائن اِن کرو';

  @override
  String get loginOrDivider => 'یا';

  @override
  String get loginContinueWithGoogle => 'Google نال جاری رکھو';

  @override
  String get loginContinueWithApple => 'Apple نال جاری رکھو';

  @override
  String get loginContinueWithFacebook => 'Facebook نال جاری رکھو';

  @override
  String get loginNewToFamily => 'ٹبر وچ نویں آئے او؟ ';

  @override
  String get loginCreateAccount => 'اکاؤنٹ بناؤ';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'ریسپی ریکارڈ کرن لئی مائیکروفون دی اجازت ضروری اے';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'ریکارڈنگ شروع نئیں ہو سکی: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'ریکارڈنگ بند نئیں ہو سکی: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'ریکارڈنگ دی فائل نئیں لبھی';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'ریسپی لکھی گئی! $credits کریڈٹ باقی نیں۔';
  }

  @override
  String get voiceRecipeTitle => 'وائس ریسپی';

  @override
  String get voiceRecipeIntro =>
      'اپنی ریسپی بول کے ساہنوں دسو — اسیں اوہنوں لکھ کے اک ترتیب والے ڈرافٹ وچ بدل دیاں گے۔';

  @override
  String get voiceRecipeUsesCredits => '2 AI کریڈٹ لگدے نیں';

  @override
  String get voiceRecipeTapToStop => 'روکن لئی بٹن دباؤ';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'ریکارڈنگ: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'لکھن لئی تیار';

  @override
  String get voiceRecipeTapToStart => 'ریکارڈنگ شروع کرن لئی ٹیپ کرو';

  @override
  String get voiceRecipeSpeakNaturally =>
      'اپنی ریسپی آرام نال بولو — اجزاء، مقدار تے سارے قدم دسو۔';

  @override
  String get voiceRecipeTipsTitle => 'چنگے نتیجیاں لئی گُر';

  @override
  String get voiceRecipeTipsBody =>
      '• ریسپی دے ناں توں شروع کرو\n• ہر چیز مقدار سمیت دسو\n• قدم ترتیب نال دسو\n• پکاون دا وقت تے بندے وی دسو';

  @override
  String get voiceRecipeTranscribing => 'AI نال لکھیا جا رہیا اے...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'لکھ کے ڈرافٹ بناؤ';

  @override
  String get voiceRecipeRecordAgain => 'فیر ریکارڈ کرو';

  @override
  String get registerSubtitle => 'اپنے پکوانی ورثے دی سانجھ پاؤ';

  @override
  String get registerNameLabel => 'ناں';

  @override
  String get registerNameHint => 'اپنا ناں لکھو';

  @override
  String get registerNameRequired => 'مہربانی کر کے اپنا ناں لکھو';

  @override
  String get registerEmailLabel => 'ای میل';

  @override
  String get registerEmailHint => 'اپنی ای میل لکھو';

  @override
  String get registerEmailRequired => 'مہربانی کر کے اپنی ای میل لکھو';

  @override
  String get registerEmailInvalid => 'مہربانی کر کے صحیح ای میل لکھو';

  @override
  String get registerNicknameLabel => 'نِک نیم (اختیاری)';

  @override
  String get registerNicknameHint => 'اپنا نِک نیم لکھو (اختیاری)';

  @override
  String get registerNicknameTooLong => 'نِک نیم ودھ توں ودھ 30 حرفاں دا ہووے';

  @override
  String get registerPasswordLabel => 'پاس ورڈ';

  @override
  String get registerPasswordHint => 'اپنا پاس ورڈ لکھو';

  @override
  String get registerPasswordRequired => 'مہربانی کر کے اپنا پاس ورڈ لکھو';

  @override
  String get registerPasswordTooShort => 'پاس ورڈ گھٹ توں گھٹ 6 حرفاں دا ہووے';

  @override
  String get registerCreateAccountButton => 'اکاؤنٹ بناؤ';

  @override
  String get registerAlreadyHaveAccount => 'پہلاں توں اکاؤنٹ اے؟ ';

  @override
  String get registerSignInLink => 'سائن اِن کرو';

  @override
  String get registerRegistrationFailed => 'رجسٹریشن نئیں ہو سکی';

  @override
  String get scanRecipeCameraPermission =>
      'ریسپی سکین کرن لئی کیمرے دی اجازت ضروری اے';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'ریسپی سکین ہو گئی! $credits کریڈٹ باقی نیں۔';
  }

  @override
  String get scanRecipeTitle => 'ریسپی سکین کرو';

  @override
  String get scanRecipeIntro =>
      'ہتھ دے لکھے کارڈ یا کُک بُک دے صفحے نوں ایڈٹ ہون والے ریسپی ڈرافٹ وچ بدلو۔';

  @override
  String get scanRecipeCreditCost => '1 AI کریڈٹ لگدا اے';

  @override
  String get scanRecipeEmptyTitle => 'سکین کرن لئی ریسپی دی فوٹو شامل کرو';

  @override
  String get scanRecipeEmptyHint =>
      'سب توں چنگے نتیجے صاف تے چانن والی فوٹو توں آؤندے نیں جیہدے وچ پوری ریسپی نظر آوے۔';

  @override
  String get scanRecipeChoosePhoto => 'فوٹو چنو';

  @override
  String get scanRecipeTakePhoto => 'فوٹو کھچو';

  @override
  String get scanRecipeScanning => 'AI نال سکین ہو رہیا اے...';

  @override
  String get scanRecipeScanButton => 'سکین کر کے ڈرافٹ بناؤ';

  @override
  String get notificationsLoadError =>
      'نوٹیفکیشنز لوڈ نئیں ہو سکیاں۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get notificationsAllMarkedRead =>
      'ساریاں نوٹیفکیشنز پڑھیاں ہوئیاں کر دتیاں گئیاں';

  @override
  String get notificationsMarkAllError =>
      'ساریاں پڑھیاں ہوئیاں نئیں کیتیاں جا سکیاں۔ مہربانی کر کے فیر کوشش کرو۔';

  @override
  String get notificationsTitle => 'نوٹیفکیشنز';

  @override
  String get notificationsMarkAllButton => 'ساریاں پڑھیاں ہوئیاں کرو';

  @override
  String get notificationsEmptyTitle => 'کوئی نوٹیفکیشن نئیں';

  @override
  String get notificationsEmptySubtitle => 'تُسیں سب کجھ ویکھ چکے او!';

  @override
  String get joinFamilyAppBarTitle => 'ٹبر وچ شامل ہووو';

  @override
  String get joinFamilyHeading => 'کسے ٹبر وچ شامل ہووو';

  @override
  String get joinFamilySubtitle =>
      'اپنے ٹبر دے رکھوالے ولوں ملیا 8 حرفاں دا انوائیٹ کوڈ لکھو';

  @override
  String get joinFamilyInviteCodeLabel => 'انوائیٹ کوڈ';

  @override
  String get joinFamilyButton => 'ٹبر وچ شامل ہووو';

  @override
  String get joinFamilyInfoText => 'اپنے ٹبر دے رکھوالے کولوں انوائیٹ کوڈ منگو';

  @override
  String get joinFamilyEmptyCodeError => 'مہربانی کر کے انوائیٹ کوڈ لکھو';

  @override
  String get joinFamilyCodeLengthError =>
      'انوائیٹ کوڈ 8 حرفاں دا ہونا چاہیدا اے';

  @override
  String get joinFamilyGenericError => 'ٹبر وچ شامل ہون وچ ناکامی';

  @override
  String get joinFamilyInvalidCodeError =>
      'انوائیٹ کوڈ غلط اے۔ مہربانی کر کے ویکھ کے فیر کوشش کرو۔';

  @override
  String get joinFamilyAlreadyMemberError =>
      'تُسیں پہلاں ای کسے ٹبر دا حصہ او۔';

  @override
  String joinFamilySuccess(String familyName) {
    return '$familyName وچ شامل ہو گئے!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'پہلاں کسے کھانا پکاون والی ویڈیو یا ریسپی دا لنک پیسٹ کرو';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'مہربانی کر کے صحیح URL لکھو جیہڑا http:// یا https:// توں شروع ہووے';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'ریسپی امپورٹ ہو گئی! $creditsRemaining کریڈٹ باقی نیں۔';
  }

  @override
  String get saveFromLinkAppBarTitle => 'لنک توں سانبھو';

  @override
  String get saveFromLinkIntro =>
      'TikTok، Instagram، YouTube یا کسے ریسپی دا لنک پیسٹ کرو تے اوہنوں شیئر ہون والے Legacy Table ڈرافٹ وچ بدلو۔';

  @override
  String get saveFromLinkCreditCost => '1 AI کریڈٹ لگدا اے';

  @override
  String get saveFromLinkDraftInfo =>
      'امپورٹ ہوئی ریسپی پہلاں ڈرافٹ دے طور تے کھلدی اے، تاں جو شیئر کرن توں پہلاں تُسیں اجزاء ٹھیک کر سکو، ترکیب سنوار سکو تے اپنی کہانی پا سکو۔';

  @override
  String get saveFromLinkImportingLabel => 'AI نال امپورٹ ہو رہیا اے...';

  @override
  String get saveFromLinkCreateDraftButton => 'لنک توں ڈرافٹ بناؤ';

  @override
  String get onboardingNextButton => 'اگے';

  @override
  String get onboardingGetStartedButton => 'شروع کرو';

  @override
  String get homeUpgradeFab => 'اپ گریڈ';

  @override
  String get homeShareRecipeFab => 'ریسپی شیئر کرو';

  @override
  String get homeNavHome => 'ہوم';

  @override
  String get homeNavCookbook => 'کُک بُک';

  @override
  String get homeNavMyRecipes => 'میریاں ریسپیاں';

  @override
  String get homeNavFamily => 'ٹبر';

  @override
  String get homeNavSettings => 'سیٹنگز';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Premium پلان چالو اے';

  @override
  String get homeSubscriptionUnlock => 'ٹبر دے Premium فیچر کھولو';

  @override
  String get profileTitle => 'میری پروفائل';

  @override
  String get profileNoRecipesTitle => 'ہالے کوئی ریسپی نئیں';

  @override
  String get profileNoRecipesSubtitle => 'اپنے ٹبر دی پہلی ریسپی شیئر کرو!';

  @override
  String profileLoadRecipesError(String error) {
    return 'ریسپیاں لوڈ نئیں ہو سکیاں: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return '$holidayName لئی ہالے کوئی ریسپی ٹیگ نئیں ہوئی';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'ویب ایپ توں یا آن والیاں موبائل اپڈیٹس راہیں ایس تہوار لئی ٹبر دی کوئی پسندیدہ ریسپی ٹیگ کرو۔';

  @override
  String get shareInviteTitle => 'انوائیٹ شیئر کرو';

  @override
  String get shareInviteLinkTab => 'لنک';

  @override
  String get shareInviteCodeTab => 'کوڈ';

  @override
  String get shareInviteLinkHint =>
      'ایپ کھولدا اے یا ڈاؤن لوڈ دے طریقے وکھاؤندا اے';

  @override
  String get shareInviteCodeHint => 'لین والا ایہ کوڈ ایپ وچ لکھدا اے';

  @override
  String get shareInviteCopiedSnackbar => 'کاپی ہو گیا!';

  @override
  String get shareInviteCopyButton => 'کاپی کرو';

  @override
  String get shareInviteShareButton => 'شیئر کرو';

  @override
  String get familySettingsInviteCodeCopied => 'انوائیٹ کوڈ کاپی ہو گیا!';

  @override
  String get familySettingsFamilyHeading => 'ٹبر';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'ریسپیاں ونڈنا شروع کرن لئی کسے ٹبر وچ شامل ہووو یا نواں بناؤ';

  @override
  String get familySettingsNoFamilyYet => 'ہالے کوئی ٹبر نئیں';

  @override
  String get familySettingsStartSharingRecipes =>
      'اپنے ٹبر دے جیاں نال ریسپیاں ونڈنا شروع کرو';

  @override
  String get familySettingsJoinFamilyButton => 'ٹبر وچ شامل ہووو';

  @override
  String get familySettingsCreateFamilyButton => 'ٹبر بناؤ';

  @override
  String get familySettingsTitle => 'ٹبر دیاں سیٹنگز';

  @override
  String get familySettingsManageSubtitle =>
      'اپنے ٹبر تے انوائیٹ کوڈ دا انتظام کرو۔';

  @override
  String get familySettingsInviteCodeLabel => 'انوائیٹ کوڈ';

  @override
  String get familySettingsCopyButton => 'کاپی کرو';

  @override
  String get familySettingsShareCodeHelper =>
      'ایہ کوڈ شیئر کرو تاں جو دوجے وی تہاڈے ٹبر وچ شامل ہو سکن۔';

  @override
  String get familySettingsMembersLabel => 'ممبر';

  @override
  String get familySettingsNoMembersYet => 'ہالے کوئی ممبر نئیں';

  @override
  String get familySettingsKeeperBadge => 'رکھوالا';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String recipeCardServings(int count) {
    return '$count بندے';
  }

  @override
  String get styledSnackbarDismiss => 'بند کرو';

  @override
  String get celebrationTitle => 'تہواراں دا ٹھکانہ';

  @override
  String get celebrationNextUp => ' — اگلا: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'دناں',
      one: 'دن',
    );
    return '$emoji $name $days $_temp0 وچ';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'دن',
      one: 'دن',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'ریسپیاں',
      one: 'ریسپی',
    );
    return '$days $_temp0 باقی  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count بندے';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return '$name ولوں';
  }

  @override
  String get familyPromptTitle => 'ٹبر وچ شامل ہووو یا نواں بناؤ';

  @override
  String get familyPromptSubtitle =>
      'اپنے ٹبر دے جیاں نال ریسپیاں ونڈنا شروع کرو';

  @override
  String get familyPromptJoinButton => 'ٹبر وچ شامل ہووو';

  @override
  String get familyPromptCreateButton => 'ٹبر بناؤ';

  @override
  String get familyPromptSampleButton =>
      'Just exploring? Try a sample cookbook';

  @override
  String get familyPromptSampleSuccess =>
      'Welcome! We\'ve added a few sample recipes to get you started.';

  @override
  String get familyPromptSampleFailed =>
      'Couldn\'t create the sample cookbook. Please try again.';

  @override
  String get shareRecipeTitle => 'Share this recipe';

  @override
  String get shareRecipeAsCard => 'Share as card';

  @override
  String get shareRecipeAsText => 'Share as text';
}
