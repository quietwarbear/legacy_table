// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'اکاؤنٹ حذف کرنے کا صفحہ نہیں کھل سکا';

  @override
  String get settingsFailedToLoadMembers =>
      'خاندان کے ارکان لوڈ کرنے میں ناکامی ہوئی';

  @override
  String get settingsInviteCodeCopied => 'دعوتی کوڈ نقل ہو گیا!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Legacy Table پر میرے خاندان \"$name\" میں شامل ہوں!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'دعوتی کوڈ: $code';
  }

  @override
  String get settingsLeaveFamily => 'خاندان چھوڑیں';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'کیا آپ واقعی \"$name\" چھوڑنا چاہتے ہیں؟ دوبارہ شامل ہونے کے لیے آپ کو دعوتی کوڈ کی ضرورت ہوگی۔';
  }

  @override
  String get settingsCancel => 'منسوخ کریں';

  @override
  String get settingsLeave => 'چھوڑیں';

  @override
  String get settingsLeftFamilySuccess => 'خاندان کامیابی سے چھوڑ دیا گیا';

  @override
  String get settingsFailedToLeaveFamily => 'خاندان چھوڑنے میں ناکامی ہوئی';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'چھوڑنے سے پہلے آپ کو نگہبان کا کردار منتقل کرنا ہوگا';

  @override
  String get settingsTransferKeeperRole => 'نگہبان کا کردار منتقل کریں';

  @override
  String get settingsTransferKeeperPrompt =>
      'بطور نگہبان، چھوڑنے سے پہلے آپ کو اپنا کردار کسی اور رکن کو منتقل کرنا ہوگا۔ نیا نگہبان بننے کے لیے ایک رکن منتخب کریں:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'نگہبان کا کردار $name کو منتقل کر دیا گیا';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'خاندان چھوڑیں؟';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'آپ نے نگہبان کا کردار کامیابی سے منتقل کر دیا ہے۔ کیا آپ اب خاندان چھوڑنا چاہیں گے؟';

  @override
  String get settingsStay => 'رہیں';

  @override
  String get settingsFailedToTransferKeeper =>
      'نگہبان کا کردار منتقل کرنے میں ناکامی ہوئی';

  @override
  String get settingsRemoveMember => 'رکن ہٹائیں';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'کیا آپ واقعی \"$name\" کو \"$family\" سے ہٹانا چاہتے ہیں؟ دوبارہ شامل ہونے کے لیے انہیں دعوتی کوڈ کی ضرورت ہوگی۔';
  }

  @override
  String get settingsRemove => 'ہٹائیں';

  @override
  String settingsMemberRemoved(String name) {
    return '$name کو خاندان سے ہٹا دیا گیا ہے';
  }

  @override
  String get settingsFailedToRemoveMember => 'رکن ہٹانے میں ناکامی ہوئی';

  @override
  String get settingsManageSubscription => 'سبسکرپشن کا انتظام کریں';

  @override
  String get settingsUpgradeToPremium => 'Premium پر اپ گریڈ کریں';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection فعال ہے';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper فعال ہے';

  @override
  String get settingsUnlockPremiumFeatures =>
      'خاندانی پلانز، برآمدات، اور Premium خصوصیات کو کھولیں';

  @override
  String get settingsKeeperBadge => 'نگہبان';

  @override
  String get settingsMemberBadge => 'رکن';

  @override
  String get settingsInviteCodeLabel => 'دعوتی کوڈ';

  @override
  String get settingsShareInviteCodeButton => 'دعوتی کوڈ شیئر کریں';

  @override
  String get settingsFamilyMembers => 'خاندان کے ارکان';

  @override
  String get settingsNoMembersFound => 'کوئی رکن نہیں ملا';

  @override
  String get settingsRemoveMemberTooltip => 'رکن ہٹائیں';

  @override
  String get settingsTheme => 'تھیم';

  @override
  String get settingsDarkMode => 'ڈارک موڈ';

  @override
  String get settingsLightMode => 'لائٹ موڈ';

  @override
  String get settingsEditProfile => 'پروفائل میں ترمیم کریں';

  @override
  String get settingsDeleteAccount => 'اکاؤنٹ حذف کریں';

  @override
  String get settingsNotifications => 'اطلاعات';

  @override
  String get settingsTermsOfUse => 'شرائطِ استعمال';

  @override
  String get settingsPrivacyPolicy => 'رازداری کی پالیسی';

  @override
  String get settingsAbout => 'تعارف';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. جملہ حقوق محفوظ ہیں۔';

  @override
  String get settingsLogout => 'لاگ آؤٹ';

  @override
  String get settingsLogoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get recipeDetailLoadRecipeError =>
      'ترکیب لوڈ کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get recipeDetailLoadCommentsError =>
      'تبصرے لوڈ کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get recipeDetailLoginToComment =>
      'تبصرہ کرنے کے لیے براہِ کرم لاگ ان کریں';

  @override
  String get recipeDetailCommentPosted => 'تبصرہ کامیابی سے شائع ہو گیا!';

  @override
  String get recipeDetailPostCommentError => 'تبصرہ شائع کرنے میں ناکامی ہوئی';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'تبصرہ شائع کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'تبصرہ حذف کریں';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'کیا آپ واقعی یہ تبصرہ حذف کرنا چاہتے ہیں؟';

  @override
  String get recipeDetailCancel => 'منسوخ کریں';

  @override
  String get recipeDetailDelete => 'حذف کریں';

  @override
  String get recipeDetailCommentDeleted => 'تبصرہ کامیابی سے حذف ہو گیا';

  @override
  String get recipeDetailDeleteCommentError => 'تبصرہ حذف کرنے میں ناکامی ہوئی';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'تبصرہ حذف کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'ترکیب کامیابی سے اپ ڈیٹ ہو گئی!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'ترکیب حذف کریں';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'کیا آپ واقعی \"$title\" حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکتا۔';
  }

  @override
  String get recipeDetailRecipeDeleted => 'ترکیب کامیابی سے حذف ہو گئی';

  @override
  String get recipeDetailDeleteRecipeError => 'ترکیب حذف کرنے میں ناکامی ہوئی';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'ترکیب حذف کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String get recipeDetailNotFound => 'ترکیب نہیں ملی';

  @override
  String get recipeDetailSharedByLabel => 'شیئر کنندہ';

  @override
  String get recipeDetailUnknownAuthor => 'نامعلوم';

  @override
  String get recipeDetailEdit => 'ترمیم کریں';

  @override
  String get recipeDetailStatTime => 'وقت';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String get recipeDetailStatServes => 'افراد';

  @override
  String get recipeDetailStatCategory => 'زمرہ';

  @override
  String get recipeDetailIngredients => 'اجزاء';

  @override
  String get recipeDetailInstructions => 'ہدایات';

  @override
  String get recipeDetailStoryTitle => 'اس ترکیب کے پیچھے کی کہانی';

  @override
  String recipeDetailStorySharedBy(String author) {
    return '$author نے شیئر کیا';
  }

  @override
  String get recipeDetailFamilyComments => 'خاندانی تبصرے';

  @override
  String get recipeDetailRefreshComments => 'تبصرے تازہ کریں';

  @override
  String get recipeDetailCommentHint =>
      'اس ترکیب کے بارے میں اپنے خیالات شیئر کریں...';

  @override
  String get recipeDetailClear => 'صاف کریں';

  @override
  String get recipeDetailPosting => 'شائع ہو رہا ہے...';

  @override
  String get recipeDetailPost => 'شائع کریں';

  @override
  String get recipeDetailNoComments => 'ابھی تک کوئی تبصرہ نہیں';

  @override
  String get recipeDetailBeFirstToComment =>
      'اپنے خیالات شیئر کرنے والے پہلے فرد بنیں!';

  @override
  String get recipeDetailNoImage => 'کوئی تصویر دستیاب نہیں';

  @override
  String get recipeDetailDeleteCommentTooltip => 'تبصرہ حذف کریں';

  @override
  String get addRecipePhotoPermissionTitle => 'فوٹو لائبریری کی اجازت';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'تصاویر منتخب کرنے کے لیے فوٹو لائبریری کی اجازت درکار ہے۔\n\nفعال کرنے کے لیے:\n1. \"ترتیبات کھولیں\" پر ٹیپ کریں\n2. \"اجازتیں\" پر جائیں\n3. \"تصاویر اور ویڈیوز\" فعال کریں';

  @override
  String get addRecipeStoragePermissionTitle => 'اسٹوریج کی اجازت';

  @override
  String get addRecipeStoragePermissionMessage =>
      'تصاویر منتخب کرنے کے لیے اسٹوریج کی اجازت درکار ہے۔\n\nفعال کرنے کے لیے:\n1. \"ترتیبات کھولیں\" پر ٹیپ کریں\n2. \"اجازتیں\" پر جائیں\n3. \"اسٹوریج\" یا \"فائلیں اور میڈیا\" فعال کریں';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'تصاویر منتخب کرنے کے لیے فوٹو لائبریری کی اجازت درکار ہے۔\n\nفعال کرنے کے لیے:\n1. \"ترتیبات کھولیں\" پر ٹیپ کریں\n2. \"Legacy Table\" تلاش کریں\n3. \"تصاویر\" پر ٹیپ کریں\n4. \"تمام تصاویر\" یا \"منتخب تصاویر\" منتخب کریں';

  @override
  String get addRecipeCameraPermissionTitle => 'کیمرے کی اجازت';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'کیمرے کی اجازت مستقل طور پر مسترد کر دی گئی ہے۔ براہِ کرم اسے ایپ کی ترتیبات سے فعال کریں۔';

  @override
  String get addRecipeCameraPermissionRequired =>
      'تصاویر لینے کے لیے کیمرے کی اجازت درکار ہے';

  @override
  String get addRecipeCancel => 'منسوخ کریں';

  @override
  String get addRecipeSettingsHintAndroid =>
      'ایپ کی ترتیبات میں \"تصاویر اور ویڈیوز\" یا \"میڈیا\" کی اجازت تلاش کریں';

  @override
  String get addRecipeSettingsHintIos =>
      'ایپ کی ترتیبات میں \"تصاویر\" کی اجازت تلاش کریں';

  @override
  String get addRecipeOpenSettings => 'ترتیبات کھولیں';

  @override
  String get addRecipeImageSelectError =>
      'تصاویر منتخب نہیں ہو سکیں۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get addRecipeTakePhotoError =>
      'تصویر نہیں لی جا سکی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get addRecipeSelectCategoryWarning => 'براہِ کرم ایک زمرہ منتخب کریں';

  @override
  String get addRecipeAddIngredientWarning =>
      'براہِ کرم کم از کم ایک جزو شامل کریں';

  @override
  String get addRecipeUpdatingRecipe => 'ترکیب اپ ڈیٹ ہو رہی ہے...';

  @override
  String get addRecipeSharingRecipe => 'ترکیب شیئر ہو رہی ہے...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'تصویر \"$fileName\" بہت بڑی ہے۔ زیادہ سے زیادہ سائز 5MB ہے۔';
  }

  @override
  String get addRecipeProcessImagesError =>
      'تصاویر پروسیس کرنے میں ناکامی ہوئی۔ براہِ کرم مختلف تصاویر منتخب کرنے کی کوشش کریں۔';

  @override
  String get addRecipeUpdateSuccess => 'ترکیب کامیابی سے اپ ڈیٹ ہو گئی!';

  @override
  String get addRecipeShareSuccess => 'ترکیب کامیابی سے شیئر ہو گئی!';

  @override
  String get addRecipeEditTitle => 'ترکیب میں ترمیم کریں';

  @override
  String get addRecipeShareTitle => 'ایک ترکیب شیئر کریں';

  @override
  String get addRecipeEditSubtitle => 'اپنی ترکیب کی تفصیلات اپ ڈیٹ کریں';

  @override
  String get addRecipeShareSubtitle =>
      'خاندانی مجموعے میں ایک نیا پکوان شامل کریں';

  @override
  String get addRecipePhotosLabel => 'تصاویر';

  @override
  String get addRecipeTitleLabel => 'ترکیب کا عنوان *';

  @override
  String get addRecipeTitlePlaceholder => 'مثلاً، دادی کے خاص جولوف چاول';

  @override
  String get addRecipeTitleRequired => 'ترکیب کا عنوان درکار ہے';

  @override
  String get addRecipeCategoryLabel => 'زمرہ *';

  @override
  String get addRecipeCategoryPlaceholder => 'زمرہ منتخب کریں';

  @override
  String get addRecipeCategoryRequired => 'زمرہ درکار ہے';

  @override
  String get addRecipeDifficultyLabel => 'دشواری';

  @override
  String get addRecipeDifficultyPlaceholder => 'دشواری منتخب کریں';

  @override
  String get addRecipeCookingTimeLabel => 'پکانے کا وقت\n(منٹ)';

  @override
  String get addRecipeServingsLabel => '\nافراد';

  @override
  String get addRecipeIngredientsLabel => 'اجزاء *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'جزو $number';
  }

  @override
  String get addRecipeIngredientRequired => 'جزو درکار ہے';

  @override
  String get addRecipeAddIngredient => 'جزو شامل کریں';

  @override
  String get addRecipeInstructionsLabel => 'ہدایات *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'مرحلہ وار پکانے کی ہدایات لکھیں...';

  @override
  String get addRecipeInstructionsRequired => 'ہدایات درکار ہیں';

  @override
  String get addRecipeStoryLabel => 'اس ترکیب کے پیچھے کی کہانی (اختیاری)';

  @override
  String get addRecipeStoryDescription =>
      'اس ترکیب کی کہانی شیئر کریں... یہ کہاں سے آئی؟ اسے کس نے آگے بڑھایا؟ یہ آپ کے خاندان کے لیے کون سی یادیں رکھتی ہے؟';

  @override
  String get addRecipeStoryPlaceholder =>
      'ہمیں اس پکوان سے جڑی تاریخ، روایات، یا خاص یادوں کے بارے میں بتائیں۔';

  @override
  String get addRecipeUpdateButton => 'ترکیب اپ ڈیٹ کریں';

  @override
  String get addRecipeShareButton => 'ترکیب شیئر کریں';

  @override
  String get addRecipeErrorTitle => 'کچھ غلط ہو گیا';

  @override
  String get addRecipeErrorMessage =>
      'براہِ کرم دوبارہ کوشش کریں یا ایپ کو دوبارہ شروع کریں۔';

  @override
  String get addRecipeGoBack => 'واپس جائیں';

  @override
  String get addRecipeUploadFromGallery => 'گیلری سے اپ لوڈ کریں';

  @override
  String get addRecipeTakePhoto => 'تصویر لیں';

  @override
  String get subscriptionNotNow => 'ابھی نہیں';

  @override
  String get subscriptionRestoring => 'بحال ہو رہا ہے…';

  @override
  String get subscriptionRestore => 'بحال کریں';

  @override
  String get subscriptionHeaderTitle => 'اپنی خاندانی\nوراثت محفوظ کریں';

  @override
  String get subscriptionHeaderSubtitle =>
      'اپنے خاندان کی ترکیبیں نسلوں تک زندہ رکھنے کے لیے\nPremium خصوصیات کھولیں۔';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'شروعات کے لیے بہترین';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'مکمل خاندانی تجربہ';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'لامحدود خاندانی ترکیبوں کا اسٹوریج';

  @override
  String get subscriptionFeatureFamilySharing => 'خاندانی اشتراک (10 ارکان تک)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'ہر ترکیب کے لیے تصویری اپ لوڈز';

  @override
  String get subscriptionFeatureExportPrint =>
      'ترکیبوں کی کتابیں برآمد اور پرنٹ کریں';

  @override
  String get subscriptionFeatureCategoriesTags => 'ترکیبوں کے زمرے اور ٹیگز';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Heritage Keeper میں شامل ہر چیز';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'لامحدود خاندانی ارکان';

  @override
  String get subscriptionFeatureAdvancedOrganization => 'ترکیبوں کی جدید ترتیب';

  @override
  String get subscriptionFeaturePrioritySupport => 'ترجیحی کسٹمر سپورٹ';

  @override
  String get subscriptionFeatureEarlyAccess => 'نئی خصوصیات تک ابتدائی رسائی';

  @override
  String get subscriptionFeatureCustomThemes =>
      'خاندانی ترکیبوں کی کتاب کے حسبِ ضرورت تھیمز';

  @override
  String get subscriptionAutoRenewNotice =>
      'سبسکرپشنز منسوخی تک خودکار طور پر تجدید ہوتی ہیں۔ آپ اپنے آلے کی ترتیبات میں کسی بھی وقت منسوخ کر سکتے ہیں۔';

  @override
  String get subscriptionTermsOfUse => 'شرائطِ استعمال';

  @override
  String get subscriptionPrivacyPolicy => 'رازداری کی پالیسی';

  @override
  String get subscriptionMostPopular => 'سب سے مقبول';

  @override
  String get subscriptionPerYear => '/سال';

  @override
  String get subscriptionPerMonth => '/ماہ';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/ماہ';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return '$tierName حاصل کریں — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'سبسکرپشن پلانز لوڈ کرنے میں ناکامی۔ براہِ کرم اپنا انٹرنیٹ کنکشن چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'اس وقت کوئی سبسکرپشن پلان دستیاب نہیں ہے۔ براہِ کرم RevenueCat اور App Store Connect کی ترتیب چیک کریں۔';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'اس پلان کے لیے سالانہ قیمت ابھی دستیاب نہیں ہے۔';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'اس پلان کے لیے ماہانہ قیمت ابھی دستیاب نہیں ہے۔';

  @override
  String get subscriptionWelcomePremium =>
      'Legacy Table Premium میں خوش آمدید!';

  @override
  String get subscriptionRestoreSuccess => 'خریداریاں کامیابی سے بحال ہو گئیں!';

  @override
  String get subscriptionRestoreNoneFound => 'کوئی سابقہ خریداری نہیں ملی۔';

  @override
  String get recipeFeedNotificationsTooltip => 'اطلاعات';

  @override
  String get recipeFeedSubheading => 'خاندانی ترکیبیں';

  @override
  String get recipeFeedTagline =>
      'محبت کے ساتھ اپنے خاندان کی پکوان روایات کو محفوظ کریں اور شیئر کریں';

  @override
  String get recipeFeedShareRecipe => 'ایک ترکیب شیئر کریں';

  @override
  String get recipeFeedFamilyCookbook => 'خاندانی ترکیبوں کی کتاب';

  @override
  String get recipeFeedScanRecipe => 'ایک ترکیب اسکین کریں';

  @override
  String get recipeFeedVoiceRecipe => 'آواز سے ترکیب بنائیں';

  @override
  String get recipeFeedComingSoon => 'جلد آ رہا ہے';

  @override
  String get recipeFeedSaveFromLink => 'لنک سے محفوظ کریں';

  @override
  String recipeFeedLoadError(String error) {
    return 'ترکیبیں لوڈ کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String get recipeFeedSearchHint => 'ترکیبیں، اجزاء، یا زمرے تلاش کریں...';

  @override
  String get recipeFeedCategoryAll => 'تمام';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'کوئی ترکیب نہیں ملی';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'ابھی تک کوئی ترکیب نہیں';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'اپنی تلاش کو ایڈجسٹ کرنے یا تمام ترکیبیں دیکھنے کی کوشش کریں';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'اپنی پہلی خاندانی ترکیب شیئر کریں اور اپنا مجموعہ بنانا شروع کریں!';

  @override
  String get recipeFeedClearSearch => 'تلاش صاف کریں';

  @override
  String get recipeFeedSmartToolsTitle => 'اسمارٹ ترکیب کے اوزار';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'ترکیبیں اسی طرح شامل کریں جیسے ویب ایپ کرتی ہے: کارڈ اسکین کریں یا ویڈیو لنک کو مسودے میں تبدیل کریں۔';

  @override
  String get recipeFeedFeatureScanTitle => 'ترکیب اسکین کریں';

  @override
  String get recipeFeedFeatureScanDescription =>
      'ہاتھ سے لکھے کارڈ یا ترکیبوں کی کتاب کے صفحے کی تصویر استعمال کریں۔';

  @override
  String get recipeFeedFeatureLinkTitle => 'لنک سے محفوظ کریں';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'TikTok، Instagram، یا YouTube لنک کو مسودے میں تبدیل کریں۔';

  @override
  String get recipeFeedCelebrationHeadquarters => 'تقریبات کا مرکز';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return '$season موسم • $theme';
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
      other: '$count ترکیبیں',
      one: '1 ترکیب',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'پروفائل کی ترتیبات تک رسائی کے لیے براہِ کرم لاگ ان کریں';

  @override
  String get profileSettingsLoadFailed =>
      'صارف کا ڈیٹا لوڈ کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get profileSettingsPhotoSourceTitle => 'تصویر کا ذریعہ منتخب کریں';

  @override
  String get profileSettingsCamera => 'کیمرہ';

  @override
  String get profileSettingsGallery => 'گیلری';

  @override
  String get profileSettingsCancel => 'منسوخ کریں';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'تصویر لینے کے لیے کیمرے کی اجازت درکار ہے';

  @override
  String get profileSettingsPickImageFailed =>
      'تصویر منتخب کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get profileSettingsUpdateSuccess => 'پروفائل کامیابی سے اپ ڈیٹ ہو گیا';

  @override
  String get profileSettingsUpdateFailed =>
      'پروفائل اپ ڈیٹ کرنے میں ناکامی ہوئی';

  @override
  String get profileSettingsTitle => 'پروفائل کی ترتیبات';

  @override
  String get profileSettingsSubtitle =>
      'اپنی مرضی کے مطابق طے کریں کہ آپ خاندان کو کیسے دکھائی دیں';

  @override
  String get profileSettingsProfilePicture => 'پروفائل تصویر';

  @override
  String get profileSettingsUploadPhotoHint =>
      'اپنی پروفائل کو ذاتی بنانے کے لیے ایک تصویر اپ لوڈ کریں';

  @override
  String get profileSettingsDisplayName => 'ظاہر ہونے والا نام';

  @override
  String get profileSettingsFullName => 'پورا نام';

  @override
  String get profileSettingsNicknameLabel => 'عرفی نام (اختیاری)';

  @override
  String get profileSettingsNicknameHint => 'ایک عرفی نام درج کریں...';

  @override
  String get profileSettingsNicknameHelper =>
      'ترکیبوں اور تبصروں پر آپ کے پورے نام کے بجائے آپ کا عرفی نام دکھایا جائے گا۔';

  @override
  String get profileSettingsAccountInformation => 'اکاؤنٹ کی معلومات';

  @override
  String get profileSettingsEmail => 'ای میل';

  @override
  String get profileSettingsMemberSince => 'رکن بننے کی تاریخ';

  @override
  String get profileSettingsSaveButton => 'تبدیلیاں محفوظ کریں';

  @override
  String get cookbookLoadError =>
      'ترکیبیں لوڈ کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get cookbookSelectAtLeastOne =>
      'براہِ کرم کم از کم ایک ترکیب منتخب کریں';

  @override
  String get cookbookGeneratingPdf => 'PDF تیار ہو رہی ہے...';

  @override
  String get cookbookGeneratePdfError => 'PDF تیار کرنے میں ناکامی ہوئی';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF کامیابی سے تیار ہو گئی!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 'وں',
      one: '',
    );
    return '$recipeCount ترکیب$_temp0 پر مشتمل آپ کی ترکیبوں کی کتاب تیار ہے۔ آپ کیا کرنا چاہیں گے؟';
  }

  @override
  String get cookbookSaveToDevice => 'آلے میں محفوظ کریں';

  @override
  String get cookbookShare => 'شیئر کریں';

  @override
  String get cookbookPreviewPrint => 'پیش منظر/پرنٹ';

  @override
  String get cookbookCancel => 'منسوخ کریں';

  @override
  String get cookbookSavingPdf => 'PDF محفوظ ہو رہی ہے...';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF کامیابی سے Downloads فولڈر میں محفوظ ہو گئی!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF کامیابی سے شیئر ہو گئی!';

  @override
  String get cookbookSavePdfError => 'PDF محفوظ کرنے میں ناکامی ہوئی';

  @override
  String get cookbookSharePdfError => 'PDF شیئر کرنے میں ناکامی ہوئی';

  @override
  String get cookbookPreviewPdfError =>
      'PDF کا پیش منظر دیکھنے میں ناکامی ہوئی';

  @override
  String get cookbookTitle => 'خاندانی ترکیبوں کی کتاب';

  @override
  String get cookbookSubtitle =>
      'پرنٹ کے قابل PDF ترکیبوں کی کتاب بنانے کے لیے ترکیبیں منتخب کریں';

  @override
  String get cookbookClear => 'صاف کریں';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 'یں',
      one: '',
    );
    return '$selectedCount ترکیب$_temp0 منتخب';
  }

  @override
  String get cookbookReadyToCreate => 'آپ کی ترکیبوں کی کتاب بنانے کے لیے تیار';

  @override
  String get cookbookExportButton => 'PDF ترکیبوں کی کتاب برآمد کریں';

  @override
  String get cookbookNoRecipesTitle => 'ابھی تک کوئی ترکیب نہیں';

  @override
  String get cookbookNoRecipesSubtitle =>
      'اپنی ترکیبوں کی کتاب بنانے کے لیے ترکیبیں شامل کریں';

  @override
  String get createFamilyAppBarTitle => 'خاندان بنائیں';

  @override
  String get createFamilyHeading => 'ایک خاندان بنائیں';

  @override
  String get createFamilySubtitle =>
      'اپنے خاندان کے ارکان کے ساتھ ترکیبیں شیئر کرنا شروع کریں';

  @override
  String get createFamilyNameLabel => 'خاندان کا نام';

  @override
  String get createFamilyNameHint => 'مثلاً، اسمتھ فیملی';

  @override
  String get createFamilyNameRequired => 'براہِ کرم خاندان کا نام درج کریں';

  @override
  String get createFamilyNameTooShort =>
      'خاندان کا نام کم از کم 2 حروف کا ہونا چاہیے';

  @override
  String get createFamilyNameTooLong =>
      'خاندان کا نام 50 حروف یا اس سے کم ہونا چاہیے';

  @override
  String get createFamilyDescriptionLabel => 'تفصیل (اختیاری)';

  @override
  String get createFamilyDescriptionHint =>
      'ہمیں اپنے خاندان کے بارے میں بتائیں...';

  @override
  String get createFamilyDescriptionTooLong =>
      'تفصیل 500 حروف یا اس سے کم ہونی چاہیے';

  @override
  String get createFamilySubmitButton => 'خاندان بنائیں';

  @override
  String get createFamilyKeeperInfo =>
      'آپ خاندان کے نگہبان بن جائیں گے اور دوسروں کو مدعو کر سکیں گے';

  @override
  String get createFamilyErrorGeneric => 'خاندان بنانے میں ناکامی ہوئی';

  @override
  String get createFamilyErrorAlreadyMember =>
      'آپ پہلے ہی کسی خاندان کا حصہ ہیں۔';

  @override
  String get createFamilySuccessTitle => 'خاندان بن گیا!';

  @override
  String get createFamilyInviteCodeLabel => 'دعوتی کوڈ';

  @override
  String get createFamilyInviteCodeCopied => 'دعوتی کوڈ نقل ہو گیا!';

  @override
  String get createFamilyShareCodeHint =>
      'خاندان کے ارکان کو مدعو کرنے کے لیے یہ کوڈ ان کے ساتھ شیئر کریں';

  @override
  String get createFamilyShareInviteButton => 'دعوت شیئر کریں';

  @override
  String get createFamilyDoneButton => 'ہو گیا';

  @override
  String get loginSubtitle => 'اپنی پکوان وراثت شیئر کریں';

  @override
  String get loginEmailLabel => 'ای میل';

  @override
  String get loginEmailHint => 'اپنا ای میل درج کریں';

  @override
  String get loginEmailRequired => 'براہِ کرم اپنا ای میل درج کریں';

  @override
  String get loginEmailInvalid => 'براہِ کرم ایک درست ای میل درج کریں';

  @override
  String get loginPasswordLabel => 'پاس ورڈ';

  @override
  String get loginPasswordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get loginPasswordRequired => 'براہِ کرم اپنا پاس ورڈ درج کریں';

  @override
  String get loginPasswordTooShort => 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get loginSignInButton => 'سائن اِن کریں';

  @override
  String get loginOrDivider => 'یا';

  @override
  String get loginContinueWithGoogle => 'Google کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithApple => 'Apple کے ساتھ جاری رکھیں';

  @override
  String get loginContinueWithFacebook => 'Facebook کے ساتھ جاری رکھیں';

  @override
  String get loginNewToFamily => 'خاندان میں نئے ہیں؟ ';

  @override
  String get loginCreateAccount => 'اکاؤنٹ بنائیں';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'ترکیب ریکارڈ کرنے کے لیے مائیکروفون کی اجازت درکار ہے';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'ریکارڈنگ شروع کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'ریکارڈنگ روکنے میں ناکامی ہوئی: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'ریکارڈنگ فائل نہیں ملی';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'ترکیب نقل ہو گئی! $credits کریڈٹس باقی ہیں۔';
  }

  @override
  String get voiceRecipeTitle => 'آواز سے ترکیب';

  @override
  String get voiceRecipeIntro =>
      'اپنی ترکیب بلند آواز میں بتائیں — ہم اسے نقل کریں گے اور ایک منظم مسودے میں تبدیل کریں گے۔';

  @override
  String get voiceRecipeUsesCredits => '2 AI کریڈٹس استعمال کرتا ہے';

  @override
  String get voiceRecipeTapToStop => 'روکنے کے لیے بٹن پر ٹیپ کریں';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'ریکارڈنگ: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'نقل کرنے کے لیے تیار';

  @override
  String get voiceRecipeTapToStart => 'ریکارڈنگ شروع کرنے کے لیے ٹیپ کریں';

  @override
  String get voiceRecipeSpeakNaturally =>
      'اپنی ترکیب قدرتی انداز میں بولیں — اجزاء، مقدار، اور مراحل شامل کریں۔';

  @override
  String get voiceRecipeTipsTitle => 'بہترین نتائج کے لیے تجاویز';

  @override
  String get voiceRecipeTipsBody =>
      '• ترکیب کے نام سے شروع کریں\n• ہر جزو کو مقدار کے ساتھ درج کریں\n• مراحل کو ترتیب سے بیان کریں\n• پکانے کا وقت اور افراد کی تعداد بتائیں';

  @override
  String get voiceRecipeTranscribing => 'AI کے ساتھ نقل ہو رہا ہے...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'مسودے میں نقل کریں';

  @override
  String get voiceRecipeRecordAgain => 'دوبارہ ریکارڈ کریں';

  @override
  String get registerSubtitle => 'اپنی پکوان وراثت شیئر کریں';

  @override
  String get registerNameLabel => 'نام';

  @override
  String get registerNameHint => 'اپنا نام درج کریں';

  @override
  String get registerNameRequired => 'براہِ کرم اپنا نام درج کریں';

  @override
  String get registerEmailLabel => 'ای میل';

  @override
  String get registerEmailHint => 'اپنا ای میل درج کریں';

  @override
  String get registerEmailRequired => 'براہِ کرم اپنا ای میل درج کریں';

  @override
  String get registerEmailInvalid => 'براہِ کرم ایک درست ای میل درج کریں';

  @override
  String get registerNicknameLabel => 'عرفی نام (اختیاری)';

  @override
  String get registerNicknameHint => 'اپنا عرفی نام درج کریں (اختیاری)';

  @override
  String get registerNicknameTooLong =>
      'عرفی نام 30 حروف یا اس سے کم ہونا چاہیے';

  @override
  String get registerPasswordLabel => 'پاس ورڈ';

  @override
  String get registerPasswordHint => 'اپنا پاس ورڈ درج کریں';

  @override
  String get registerPasswordRequired => 'براہِ کرم اپنا پاس ورڈ درج کریں';

  @override
  String get registerPasswordTooShort =>
      'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے';

  @override
  String get registerCreateAccountButton => 'اکاؤنٹ بنائیں';

  @override
  String get registerAlreadyHaveAccount => 'پہلے سے اکاؤنٹ ہے؟ ';

  @override
  String get registerSignInLink => 'سائن اِن کریں';

  @override
  String get registerRegistrationFailed => 'رجسٹریشن ناکام ہوئی';

  @override
  String get scanRecipeCameraPermission =>
      'ترکیب اسکین کرنے کے لیے کیمرے کی اجازت درکار ہے';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'ترکیب اسکین ہو گئی! $credits کریڈٹس باقی ہیں۔';
  }

  @override
  String get scanRecipeTitle => 'ترکیب اسکین کریں';

  @override
  String get scanRecipeIntro =>
      'ہاتھ سے لکھے کارڈ یا ترکیبوں کی کتاب کے صفحے کو قابلِ ترمیم ترکیب کے مسودے میں تبدیل کریں۔';

  @override
  String get scanRecipeCreditCost => '1 AI کریڈٹ استعمال کرتا ہے';

  @override
  String get scanRecipeEmptyTitle =>
      'اسکین کرنے کے لیے ترکیب کی تصویر شامل کریں';

  @override
  String get scanRecipeEmptyHint =>
      'بہترین نتائج ایک واضح، اچھی روشنی والی تصویر سے ملتے ہیں جس میں پوری ترکیب نظر آتی ہو۔';

  @override
  String get scanRecipeChoosePhoto => 'تصویر منتخب کریں';

  @override
  String get scanRecipeTakePhoto => 'تصویر لیں';

  @override
  String get scanRecipeScanning => 'AI کے ساتھ اسکین ہو رہا ہے...';

  @override
  String get scanRecipeScanButton => 'مسودے میں اسکین کریں';

  @override
  String get notificationsLoadError =>
      'اطلاعات لوڈ کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get notificationsAllMarkedRead =>
      'تمام اطلاعات کو پڑھا ہوا نشان زد کر دیا گیا';

  @override
  String get notificationsMarkAllError =>
      'سب کو پڑھا ہوا نشان زد کرنے میں ناکامی ہوئی۔ براہِ کرم دوبارہ کوشش کریں۔';

  @override
  String get notificationsTitle => 'اطلاعات';

  @override
  String get notificationsMarkAllButton => 'سب کو پڑھا ہوا نشان زد کریں';

  @override
  String get notificationsEmptyTitle => 'کوئی اطلاع نہیں';

  @override
  String get notificationsEmptySubtitle => 'آپ سب کچھ دیکھ چکے ہیں!';

  @override
  String get joinFamilyAppBarTitle => 'خاندان میں شامل ہوں';

  @override
  String get joinFamilyHeading => 'ایک خاندان میں شامل ہوں';

  @override
  String get joinFamilySubtitle =>
      'اپنے خاندان کے نگہبان سے ملنے والا 8 حروف کا دعوتی کوڈ درج کریں';

  @override
  String get joinFamilyInviteCodeLabel => 'دعوتی کوڈ';

  @override
  String get joinFamilyButton => 'خاندان میں شامل ہوں';

  @override
  String get joinFamilyInfoText =>
      'دعوتی کوڈ کے لیے اپنے خاندان کے نگہبان سے پوچھیں';

  @override
  String get joinFamilyEmptyCodeError => 'براہِ کرم ایک دعوتی کوڈ درج کریں';

  @override
  String get joinFamilyCodeLengthError => 'دعوتی کوڈ 8 حروف کا ہونا چاہیے';

  @override
  String get joinFamilyGenericError => 'خاندان میں شامل ہونے میں ناکامی ہوئی';

  @override
  String get joinFamilyInvalidCodeError =>
      'غلط دعوتی کوڈ۔ براہِ کرم چیک کریں اور دوبارہ کوشش کریں۔';

  @override
  String get joinFamilyAlreadyMemberError =>
      'آپ پہلے ہی کسی خاندان کا حصہ ہیں۔';

  @override
  String joinFamilySuccess(String familyName) {
    return 'کامیابی سے $familyName میں شامل ہو گئے!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'پہلے کوئی کوکنگ ویڈیو یا ترکیب کا لنک پیسٹ کریں';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'براہِ کرم http:// یا https:// سے شروع ہونے والا ایک درست URL درج کریں';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'ترکیب درآمد ہو گئی! $creditsRemaining کریڈٹس باقی ہیں۔';
  }

  @override
  String get saveFromLinkAppBarTitle => 'لنک سے محفوظ کریں';

  @override
  String get saveFromLinkIntro =>
      'TikTok، Instagram، YouTube، یا ترکیب کا لنک پیسٹ کریں اور اسے ایک قابلِ اشتراک Legacy Table مسودے میں تبدیل کریں۔';

  @override
  String get saveFromLinkCreditCost => '1 AI کریڈٹ استعمال کرتا ہے';

  @override
  String get saveFromLinkDraftInfo =>
      'درآمد شدہ ترکیب پہلے ایک مسودے کے طور پر کھلتی ہے، تاکہ شیئر کرنے سے پہلے آپ اجزاء کو درست کر سکیں، ہدایات کو ایڈجسٹ کر سکیں، اور اپنی کہانی شامل کر سکیں۔';

  @override
  String get saveFromLinkImportingLabel => 'AI کے ساتھ درآمد ہو رہا ہے...';

  @override
  String get saveFromLinkCreateDraftButton => 'لنک سے مسودہ بنائیں';

  @override
  String get onboardingNextButton => 'اگلا';

  @override
  String get onboardingGetStartedButton => 'شروع کریں';

  @override
  String get homeUpgradeFab => 'اپ گریڈ کریں';

  @override
  String get homeShareRecipeFab => 'ایک ترکیب شیئر کریں';

  @override
  String get homeNavHome => 'ہوم';

  @override
  String get homeNavCookbook => 'ترکیبوں کی کتاب';

  @override
  String get homeNavMyRecipes => 'میری ترکیبیں';

  @override
  String get homeNavFamily => 'خاندان';

  @override
  String get homeNavSettings => 'ترتیبات';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Premium پلان فعال ہے';

  @override
  String get homeSubscriptionUnlock => 'Premium خاندانی خصوصیات کھولیں';

  @override
  String get profileTitle => 'میرا پروفائل';

  @override
  String get profileNoRecipesTitle => 'ابھی تک کوئی ترکیب نہیں';

  @override
  String get profileNoRecipesSubtitle => 'اپنی پہلی خاندانی ترکیب شیئر کریں!';

  @override
  String profileLoadRecipesError(String error) {
    return 'ترکیبیں لوڈ کرنے میں ناکامی ہوئی: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'ابھی تک $holidayName کے لیے کوئی ترکیب ٹیگ نہیں کی گئی';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'ویب ایپ یا آنے والی موبائل تفصیلی بہتری سے اس تہوار کے لیے کسی خاندانی پسندیدہ ترکیب کو ٹیگ کریں۔';

  @override
  String get shareInviteTitle => 'دعوت شیئر کریں';

  @override
  String get shareInviteLinkTab => 'لنک';

  @override
  String get shareInviteCodeTab => 'کوڈ';

  @override
  String get shareInviteLinkHint =>
      'ایپ کھولتا ہے یا ڈاؤن لوڈ کے اختیارات دکھاتا ہے';

  @override
  String get shareInviteCodeHint => 'وصول کنندہ یہ کوڈ ایپ میں درج کرتا ہے';

  @override
  String get shareInviteCopiedSnackbar => 'نقل ہو گیا!';

  @override
  String get shareInviteCopyButton => 'نقل کریں';

  @override
  String get shareInviteShareButton => 'شیئر کریں';

  @override
  String get familySettingsInviteCodeCopied => 'دعوتی کوڈ نقل ہو گیا!';

  @override
  String get familySettingsFamilyHeading => 'خاندان';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'ترکیبیں شیئر کرنا شروع کرنے کے لیے کسی خاندان میں شامل ہوں یا بنائیں';

  @override
  String get familySettingsNoFamilyYet => 'ابھی تک کوئی خاندان نہیں';

  @override
  String get familySettingsStartSharingRecipes =>
      'اپنے خاندان کے ارکان کے ساتھ ترکیبیں شیئر کرنا شروع کریں';

  @override
  String get familySettingsJoinFamilyButton => 'خاندان میں شامل ہوں';

  @override
  String get familySettingsCreateFamilyButton => 'خاندان بنائیں';

  @override
  String get familySettingsTitle => 'خاندان کی ترتیبات';

  @override
  String get familySettingsManageSubtitle =>
      'اپنے خاندان اور دعوتی کوڈ کا انتظام کریں۔';

  @override
  String get familySettingsInviteCodeLabel => 'دعوتی کوڈ';

  @override
  String get familySettingsCopyButton => 'نقل کریں';

  @override
  String get familySettingsShareCodeHelper =>
      'یہ کوڈ شیئر کریں تاکہ دوسرے آپ کے خاندان میں شامل ہو سکیں۔';

  @override
  String get familySettingsMembersLabel => 'ارکان';

  @override
  String get familySettingsNoMembersYet => 'ابھی تک کوئی رکن نہیں';

  @override
  String get familySettingsKeeperBadge => 'نگہبان';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String recipeCardServings(int count) {
    return '$count افراد';
  }

  @override
  String get styledSnackbarDismiss => 'برخاست کریں';

  @override
  String get celebrationTitle => 'تقریبات کا مرکز';

  @override
  String get celebrationNextUp => ' — اگلا: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'دن',
      one: 'دن',
    );
    return '$emoji $name $days $_temp0 میں';
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
      other: 'ترکیبیں',
      one: 'ترکیب',
    );
    return '$days $_temp0 باقی  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes منٹ';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count افراد';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'بقلم $name';
  }

  @override
  String get familyPromptTitle => 'کسی خاندان میں شامل ہوں یا بنائیں';

  @override
  String get familyPromptSubtitle =>
      'اپنے خاندان کے ارکان کے ساتھ ترکیبیں شیئر کرنا شروع کریں';

  @override
  String get familyPromptJoinButton => 'خاندان میں شامل ہوں';

  @override
  String get familyPromptCreateButton => 'خاندان بنائیں';

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
