// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsCouldNotOpenDeleteAccount => 'تعذّر فتح صفحة حذف الحساب';

  @override
  String get settingsFailedToLoadMembers => 'فشل تحميل أفراد العائلة';

  @override
  String get settingsInviteCodeCopied => 'تم نسخ رمز الدعوة!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'انضمّ إلى عائلتي \"$name\" على Legacy Table!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'رمز الدعوة: $code';
  }

  @override
  String get settingsLeaveFamily => 'مغادرة العائلة';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'هل أنت متأكد من رغبتك في مغادرة \"$name\"؟ ستحتاج إلى رمز دعوة لإعادة الانضمام.';
  }

  @override
  String get settingsCancel => 'إلغاء';

  @override
  String get settingsLeave => 'مغادرة';

  @override
  String get settingsLeftFamilySuccess => 'تمت مغادرة العائلة بنجاح';

  @override
  String get settingsFailedToLeaveFamily => 'فشلت مغادرة العائلة';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'يجب أن تنقل دور القيّم قبل المغادرة';

  @override
  String get settingsTransferKeeperRole => 'نقل دور القيّم';

  @override
  String get settingsTransferKeeperPrompt =>
      'بصفتك القيّم، يجب أن تنقل دورك إلى عضو آخر قبل المغادرة. اختر عضوًا ليصبح القيّم الجديد:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'تم نقل دور القيّم إلى $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'مغادرة العائلة؟';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'لقد نقلت دور القيّم بنجاح. هل ترغب في مغادرة العائلة الآن؟';

  @override
  String get settingsStay => 'البقاء';

  @override
  String get settingsFailedToTransferKeeper => 'فشل نقل دور القيّم';

  @override
  String get settingsRemoveMember => 'إزالة عضو';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'هل أنت متأكد من رغبتك في إزالة \"$name\" من \"$family\"؟ سيحتاجون إلى رمز دعوة لإعادة الانضمام.';
  }

  @override
  String get settingsRemove => 'إزالة';

  @override
  String settingsMemberRemoved(String name) {
    return 'تمت إزالة $name من العائلة';
  }

  @override
  String get settingsFailedToRemoveMember => 'فشلت إزالة العضو';

  @override
  String get settingsManageSubscription => 'إدارة الاشتراك';

  @override
  String get settingsUpgradeToPremium => 'الترقية إلى Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection مُفعّل';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper مُفعّل';

  @override
  String get settingsUnlockPremiumFeatures =>
      'افتح خطط العائلة والتصدير والميزات المميزة';

  @override
  String get settingsKeeperBadge => 'القيّم';

  @override
  String get settingsMemberBadge => 'عضو';

  @override
  String get settingsInviteCodeLabel => 'رمز الدعوة';

  @override
  String get settingsShareInviteCodeButton => 'مشاركة رمز الدعوة';

  @override
  String get settingsFamilyMembers => 'أفراد العائلة';

  @override
  String get settingsNoMembersFound => 'لم يتم العثور على أعضاء';

  @override
  String get settingsRemoveMemberTooltip => 'إزالة عضو';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsLightMode => 'الوضع الفاتح';

  @override
  String get settingsEditProfile => 'تعديل الملف الشخصي';

  @override
  String get settingsDeleteAccount => 'حذف الحساب';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsTermsOfUse => 'شروط الاستخدام';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. جميع الحقوق محفوظة.';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get settingsLogoutConfirm => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get recipeDetailLoadRecipeError =>
      'فشل تحميل الوصفة. يرجى المحاولة مرة أخرى.';

  @override
  String get recipeDetailLoadCommentsError =>
      'فشل تحميل التعليقات. يرجى المحاولة مرة أخرى.';

  @override
  String get recipeDetailLoginToComment => 'يرجى تسجيل الدخول لنشر تعليق';

  @override
  String get recipeDetailCommentPosted => 'تم نشر التعليق بنجاح!';

  @override
  String get recipeDetailPostCommentError => 'فشل نشر التعليق';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'فشل نشر التعليق: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'حذف التعليق';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'هل أنت متأكد من رغبتك في حذف هذا التعليق؟';

  @override
  String get recipeDetailCancel => 'إلغاء';

  @override
  String get recipeDetailDelete => 'حذف';

  @override
  String get recipeDetailCommentDeleted => 'تم حذف التعليق بنجاح';

  @override
  String get recipeDetailDeleteCommentError => 'فشل حذف التعليق';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'فشل حذف التعليق: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'تم تحديث الوصفة بنجاح!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'حذف الوصفة';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'هل أنت متأكد من رغبتك في حذف \"$title\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'تم حذف الوصفة بنجاح';

  @override
  String get recipeDetailDeleteRecipeError => 'فشل حذف الوصفة';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'فشل حذف الوصفة: $error';
  }

  @override
  String get recipeDetailNotFound => 'لم يتم العثور على الوصفة';

  @override
  String get recipeDetailSharedByLabel => 'شاركها';

  @override
  String get recipeDetailUnknownAuthor => 'غير معروف';

  @override
  String get recipeDetailEdit => 'تعديل';

  @override
  String get recipeDetailStatTime => 'الوقت';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get recipeDetailStatServes => 'يكفي لـ';

  @override
  String get recipeDetailStatCategory => 'الفئة';

  @override
  String get recipeDetailIngredients => 'المكوّنات';

  @override
  String get recipeDetailInstructions => 'طريقة التحضير';

  @override
  String get recipeDetailStoryTitle => 'القصة وراء هذه الوصفة';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'شاركها $author';
  }

  @override
  String get recipeDetailFamilyComments => 'تعليقات العائلة';

  @override
  String get recipeDetailRefreshComments => 'تحديث التعليقات';

  @override
  String get recipeDetailCommentHint => 'شارك أفكارك حول هذه الوصفة...';

  @override
  String get recipeDetailClear => 'مسح';

  @override
  String get recipeDetailPosting => 'جارٍ النشر...';

  @override
  String get recipeDetailPost => 'نشر';

  @override
  String get recipeDetailNoComments => 'لا توجد تعليقات بعد';

  @override
  String get recipeDetailBeFirstToComment => 'كن أول من يشارك أفكاره!';

  @override
  String get recipeDetailNoImage => 'لا توجد صورة متاحة';

  @override
  String get recipeDetailDeleteCommentTooltip => 'حذف التعليق';

  @override
  String get addRecipePhotoPermissionTitle => 'إذن مكتبة الصور';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'إذن مكتبة الصور مطلوب لاختيار الصور.\n\nللتفعيل:\n1. اضغط على \"فتح الإعدادات\"\n2. انتقل إلى \"الأذونات\"\n3. فعّل \"الصور ومقاطع الفيديو\"';

  @override
  String get addRecipeStoragePermissionTitle => 'إذن التخزين';

  @override
  String get addRecipeStoragePermissionMessage =>
      'إذن التخزين مطلوب لاختيار الصور.\n\nللتفعيل:\n1. اضغط على \"فتح الإعدادات\"\n2. انتقل إلى \"الأذونات\"\n3. فعّل \"التخزين\" أو \"الملفات والوسائط\"';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'إذن مكتبة الصور مطلوب لاختيار الصور.\n\nللتفعيل:\n1. اضغط على \"فتح الإعدادات\"\n2. ابحث عن \"Legacy Table\"\n3. اضغط على \"الصور\"\n4. اختر \"كل الصور\" أو \"الصور المحددة\"';

  @override
  String get addRecipeCameraPermissionTitle => 'إذن الكاميرا';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'تم رفض إذن الكاميرا نهائيًا. يرجى تفعيله من إعدادات التطبيق.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'إذن الكاميرا مطلوب لالتقاط الصور';

  @override
  String get addRecipeCancel => 'إلغاء';

  @override
  String get addRecipeSettingsHintAndroid =>
      'ابحث عن إذن \"الصور ومقاطع الفيديو\" أو \"الوسائط\" في إعدادات التطبيق';

  @override
  String get addRecipeSettingsHintIos =>
      'ابحث عن إذن \"الصور\" في إعدادات التطبيق';

  @override
  String get addRecipeOpenSettings => 'فتح الإعدادات';

  @override
  String get addRecipeImageSelectError =>
      'تعذّر اختيار الصور. يرجى المحاولة مرة أخرى.';

  @override
  String get addRecipeTakePhotoError =>
      'تعذّر التقاط الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get addRecipeSelectCategoryWarning => 'يرجى اختيار فئة';

  @override
  String get addRecipeAddIngredientWarning => 'يرجى إضافة مكوّن واحد على الأقل';

  @override
  String get addRecipeUpdatingRecipe => 'جارٍ تحديث الوصفة...';

  @override
  String get addRecipeSharingRecipe => 'جارٍ مشاركة الوصفة...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'الصورة \"$fileName\" كبيرة جدًا. الحد الأقصى للحجم هو 5 ميجابايت.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'فشلت معالجة الصور. يرجى محاولة اختيار صور مختلفة.';

  @override
  String get addRecipeUpdateSuccess => 'تم تحديث الوصفة بنجاح!';

  @override
  String get addRecipeShareSuccess => 'تمت مشاركة الوصفة بنجاح!';

  @override
  String get addRecipeEditTitle => 'تعديل الوصفة';

  @override
  String get addRecipeShareTitle => 'مشاركة وصفة';

  @override
  String get addRecipeEditSubtitle => 'حدّث تفاصيل وصفتك';

  @override
  String get addRecipeShareSubtitle => 'أضف طبقًا جديدًا إلى مجموعة العائلة';

  @override
  String get addRecipePhotosLabel => 'الصور';

  @override
  String get addRecipeTitleLabel => 'عنوان الوصفة *';

  @override
  String get addRecipeTitlePlaceholder => 'مثال: أرز الجولوف الخاص بجدتي';

  @override
  String get addRecipeTitleRequired => 'عنوان الوصفة مطلوب';

  @override
  String get addRecipeCategoryLabel => 'الفئة *';

  @override
  String get addRecipeCategoryPlaceholder => 'اختر الفئة';

  @override
  String get addRecipeCategoryRequired => 'الفئة مطلوبة';

  @override
  String get addRecipeDifficultyLabel => 'مستوى الصعوبة';

  @override
  String get addRecipeDifficultyPlaceholder => 'اختر مستوى الصعوبة';

  @override
  String get addRecipeCookingTimeLabel => 'وقت الطهي\n(بالدقائق)';

  @override
  String get addRecipeServingsLabel => '\nعدد الحصص';

  @override
  String get addRecipeIngredientsLabel => 'المكوّنات *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'المكوّن $number';
  }

  @override
  String get addRecipeIngredientRequired => 'المكوّن مطلوب';

  @override
  String get addRecipeAddIngredient => 'إضافة مكوّن';

  @override
  String get addRecipeInstructionsLabel => 'طريقة التحضير *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'اكتب خطوات الطهي خطوة بخطوة...';

  @override
  String get addRecipeInstructionsRequired => 'طريقة التحضير مطلوبة';

  @override
  String get addRecipeStoryLabel => 'القصة وراء هذه الوصفة (اختياري)';

  @override
  String get addRecipeStoryDescription =>
      'شارك قصة هذه الوصفة... من أين أتت؟ من ورّثها؟ ما الذكريات التي تحملها لعائلتك؟';

  @override
  String get addRecipeStoryPlaceholder =>
      'حدّثنا عن تاريخ هذا الطبق أو التقاليد أو الذكريات الخاصة المرتبطة به.';

  @override
  String get addRecipeUpdateButton => 'تحديث الوصفة';

  @override
  String get addRecipeShareButton => 'مشاركة الوصفة';

  @override
  String get addRecipeErrorTitle => 'حدث خطأ ما';

  @override
  String get addRecipeErrorMessage =>
      'يرجى المحاولة مرة أخرى أو إعادة تشغيل التطبيق.';

  @override
  String get addRecipeGoBack => 'العودة';

  @override
  String get addRecipeUploadFromGallery => 'التحميل من المعرض';

  @override
  String get addRecipeTakePhoto => 'التقاط صورة';

  @override
  String get subscriptionNotNow => 'ليس الآن';

  @override
  String get subscriptionRestoring => 'جارٍ الاستعادة…';

  @override
  String get subscriptionRestore => 'استعادة';

  @override
  String get subscriptionHeaderTitle => 'احفظ\nإرث عائلتك';

  @override
  String get subscriptionHeaderSubtitle =>
      'افتح الميزات المميزة لإبقاء وصفات\nعائلتك حيّة للأجيال القادمة.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'مثالي للبدء';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'تجربة العائلة المتكاملة';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'تخزين غير محدود لوصفات العائلة';

  @override
  String get subscriptionFeatureFamilySharing => 'مشاركة عائلية (حتى 10 أعضاء)';

  @override
  String get subscriptionFeaturePhotoUploads => 'رفع صور لكل وصفة';

  @override
  String get subscriptionFeatureExportPrint => 'تصدير وطباعة كتب الوصفات';

  @override
  String get subscriptionFeatureCategoriesTags => 'فئات وعلامات الوصفات';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'كل ما في Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'أعضاء عائلة غير محدودين';

  @override
  String get subscriptionFeatureAdvancedOrganization => 'تنظيم متقدم للوصفات';

  @override
  String get subscriptionFeaturePrioritySupport => 'دعم عملاء ذو أولوية';

  @override
  String get subscriptionFeatureEarlyAccess => 'وصول مبكر إلى الميزات الجديدة';

  @override
  String get subscriptionFeatureCustomThemes => 'سمات مخصصة لكتاب طبخ العائلة';

  @override
  String get subscriptionAutoRenewNotice =>
      'تتجدد الاشتراكات تلقائيًا حتى يتم إلغاؤها. ألغِ في أي وقت من إعدادات جهازك.';

  @override
  String get subscriptionTermsOfUse => 'شروط الاستخدام';

  @override
  String get subscriptionPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get subscriptionMostPopular => 'الأكثر شيوعًا';

  @override
  String get subscriptionPerYear => '/سنويًا';

  @override
  String get subscriptionPerMonth => '/شهريًا';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/شهر';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'احصل على $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'تعذّر تحميل خطط الاشتراك. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'لا توجد خطط اشتراك متاحة حاليًا. يرجى التحقق من إعدادات RevenueCat وApp Store Connect.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'التسعير السنوي غير متاح لهذه الخطة بعد.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'التسعير الشهري غير متاح لهذه الخطة بعد.';

  @override
  String get subscriptionWelcomePremium => 'مرحبًا بك في Legacy Table Premium!';

  @override
  String get subscriptionRestoreSuccess => 'تمت استعادة المشتريات بنجاح!';

  @override
  String get subscriptionRestoreNoneFound => 'لم يتم العثور على مشتريات سابقة.';

  @override
  String get recipeFeedNotificationsTooltip => 'الإشعارات';

  @override
  String get recipeFeedSubheading => 'وصفات العائلة';

  @override
  String get recipeFeedTagline => 'احفظ وشارك تقاليد عائلتنا في الطهي بكل حب';

  @override
  String get recipeFeedShareRecipe => 'مشاركة وصفة';

  @override
  String get recipeFeedFamilyCookbook => 'كتاب طبخ العائلة';

  @override
  String get recipeFeedScanRecipe => 'مسح وصفة';

  @override
  String get recipeFeedVoiceRecipe => 'وصفة صوتية';

  @override
  String get recipeFeedComingSoon => 'قريبًا';

  @override
  String get recipeFeedSaveFromLink => 'حفظ من رابط';

  @override
  String recipeFeedLoadError(String error) {
    return 'فشل تحميل الوصفات: $error';
  }

  @override
  String get recipeFeedSearchHint => 'ابحث عن وصفات أو مكوّنات أو فئات...';

  @override
  String get recipeFeedCategoryAll => 'الكل';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'لم يتم العثور على وصفات';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'لا توجد وصفات بعد';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'جرّب تعديل بحثك أو تصفّح جميع الوصفات';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'شارك أول وصفة عائلية لك وابدأ في بناء مجموعتك!';

  @override
  String get recipeFeedClearSearch => 'مسح البحث';

  @override
  String get recipeFeedSmartToolsTitle => 'أدوات الوصفات الذكية';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'أضف الوصفات بالطريقة نفسها التي يتيحها تطبيق الويب: امسح بطاقة أو حوّل رابط فيديو إلى مسودة.';

  @override
  String get recipeFeedFeatureScanTitle => 'مسح وصفة';

  @override
  String get recipeFeedFeatureScanDescription =>
      'استخدم صورة لبطاقة مكتوبة بخط اليد أو صفحة من كتاب طبخ.';

  @override
  String get recipeFeedFeatureLinkTitle => 'حفظ من رابط';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'حوّل رابط TikTok أو Instagram أو YouTube إلى مسودة.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'مركز الاحتفالات';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'موسم $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return 'بعد $days يومًا';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وصفات',
      one: 'وصفة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'يرجى تسجيل الدخول للوصول إلى إعدادات الملف الشخصي';

  @override
  String get profileSettingsLoadFailed =>
      'فشل تحميل بيانات المستخدم. يرجى المحاولة مرة أخرى.';

  @override
  String get profileSettingsPhotoSourceTitle => 'اختر مصدر الصورة';

  @override
  String get profileSettingsCamera => 'الكاميرا';

  @override
  String get profileSettingsGallery => 'المعرض';

  @override
  String get profileSettingsCancel => 'إلغاء';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'إذن الكاميرا مطلوب لالتقاط صورة';

  @override
  String get profileSettingsPickImageFailed =>
      'فشل اختيار الصورة. يرجى المحاولة مرة أخرى.';

  @override
  String get profileSettingsUpdateSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get profileSettingsUpdateFailed => 'فشل تحديث الملف الشخصي';

  @override
  String get profileSettingsTitle => 'إعدادات الملف الشخصي';

  @override
  String get profileSettingsSubtitle => 'خصّص كيف تظهر للعائلة';

  @override
  String get profileSettingsProfilePicture => 'صورة الملف الشخصي';

  @override
  String get profileSettingsUploadPhotoHint => 'ارفع صورة لتخصيص ملفك الشخصي';

  @override
  String get profileSettingsDisplayName => 'الاسم المعروض';

  @override
  String get profileSettingsFullName => 'الاسم الكامل';

  @override
  String get profileSettingsNicknameLabel => 'اللقب (اختياري)';

  @override
  String get profileSettingsNicknameHint => 'أدخل لقبًا...';

  @override
  String get profileSettingsNicknameHelper =>
      'سيظهر لقبك بدلًا من اسمك الكامل في الوصفات والتعليقات.';

  @override
  String get profileSettingsAccountInformation => 'معلومات الحساب';

  @override
  String get profileSettingsEmail => 'البريد الإلكتروني';

  @override
  String get profileSettingsMemberSince => 'عضو منذ';

  @override
  String get profileSettingsSaveButton => 'حفظ التغييرات';

  @override
  String get cookbookLoadError => 'فشل تحميل الوصفات. يرجى المحاولة مرة أخرى.';

  @override
  String get cookbookSelectAtLeastOne => 'يرجى اختيار وصفة واحدة على الأقل';

  @override
  String get cookbookGeneratingPdf => 'جارٍ إنشاء ملف PDF...';

  @override
  String get cookbookGeneratePdfError => 'فشل إنشاء ملف PDF';

  @override
  String get cookbookPdfGeneratedTitle => 'تم إنشاء ملف PDF بنجاح!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    return 'كتاب الطبخ الخاص بك المكوّن من $recipeCount وصفة جاهز. ماذا تريد أن تفعل؟';
  }

  @override
  String get cookbookSaveToDevice => 'الحفظ على الجهاز';

  @override
  String get cookbookShare => 'مشاركة';

  @override
  String get cookbookPreviewPrint => 'معاينة/طباعة';

  @override
  String get cookbookCancel => 'إلغاء';

  @override
  String get cookbookSavingPdf => 'جارٍ حفظ ملف PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      'تم حفظ ملف PDF بنجاح في مجلد التنزيلات!';

  @override
  String get cookbookPdfSharedSuccess => 'تمت مشاركة ملف PDF بنجاح!';

  @override
  String get cookbookSavePdfError => 'فشل حفظ ملف PDF';

  @override
  String get cookbookSharePdfError => 'فشل مشاركة ملف PDF';

  @override
  String get cookbookPreviewPdfError => 'فشل معاينة ملف PDF';

  @override
  String get cookbookTitle => 'كتاب طبخ العائلة';

  @override
  String get cookbookSubtitle =>
      'اختر الوصفات لإنشاء كتاب طبخ PDF قابل للطباعة';

  @override
  String get cookbookClear => 'مسح';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 'وصفات محددة',
      one: 'وصفة محددة',
    );
    return '$selectedCount $_temp0';
  }

  @override
  String get cookbookReadyToCreate => 'جاهز لإنشاء كتاب طبخك';

  @override
  String get cookbookExportButton => 'تصدير كتاب طبخ PDF';

  @override
  String get cookbookNoRecipesTitle => 'لا توجد وصفات بعد';

  @override
  String get cookbookNoRecipesSubtitle => 'أضف وصفات لإنشاء كتاب طبخك';

  @override
  String get createFamilyAppBarTitle => 'إنشاء عائلة';

  @override
  String get createFamilyHeading => 'أنشئ عائلة';

  @override
  String get createFamilySubtitle => 'ابدأ بمشاركة الوصفات مع أفراد عائلتك';

  @override
  String get createFamilyNameLabel => 'اسم العائلة';

  @override
  String get createFamilyNameHint => 'مثال: عائلة سميث';

  @override
  String get createFamilyNameRequired => 'يرجى إدخال اسم العائلة';

  @override
  String get createFamilyNameTooShort =>
      'يجب أن يتكوّن اسم العائلة من حرفين على الأقل';

  @override
  String get createFamilyNameTooLong => 'يجب ألا يتجاوز اسم العائلة 50 حرفًا';

  @override
  String get createFamilyDescriptionLabel => 'الوصف (اختياري)';

  @override
  String get createFamilyDescriptionHint => 'حدّثنا عن عائلتك...';

  @override
  String get createFamilyDescriptionTooLong => 'يجب ألا يتجاوز الوصف 500 حرف';

  @override
  String get createFamilySubmitButton => 'إنشاء عائلة';

  @override
  String get createFamilyKeeperInfo => 'ستصبح قيّم العائلة ويمكنك دعوة الآخرين';

  @override
  String get createFamilyErrorGeneric => 'فشل إنشاء العائلة';

  @override
  String get createFamilyErrorAlreadyMember => 'أنت بالفعل جزء من عائلة.';

  @override
  String get createFamilySuccessTitle => 'تم إنشاء العائلة!';

  @override
  String get createFamilyInviteCodeLabel => 'رمز الدعوة';

  @override
  String get createFamilyInviteCodeCopied => 'تم نسخ رمز الدعوة!';

  @override
  String get createFamilyShareCodeHint =>
      'شارك هذا الرمز مع أفراد العائلة لدعوتهم';

  @override
  String get createFamilyShareInviteButton => 'مشاركة الدعوة';

  @override
  String get createFamilyDoneButton => 'تم';

  @override
  String get loginSubtitle => 'شارك إرثك في الطهي';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get loginEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get loginEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => 'أدخل كلمة المرور';

  @override
  String get loginPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get loginPasswordTooShort =>
      'يجب أن تتكوّن كلمة المرور من 6 أحرف على الأقل';

  @override
  String get loginSignInButton => 'تسجيل الدخول';

  @override
  String get loginOrDivider => 'أو';

  @override
  String get loginContinueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get loginContinueWithApple => 'المتابعة باستخدام Apple';

  @override
  String get loginContinueWithFacebook => 'المتابعة باستخدام Facebook';

  @override
  String get loginNewToFamily => 'جديد في العائلة؟ ';

  @override
  String get loginCreateAccount => 'إنشاء حساب';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'إذن الميكروفون مطلوب لتسجيل وصفة';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'فشل بدء التسجيل: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'فشل إيقاف التسجيل: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'لم يتم العثور على ملف التسجيل';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'تم تفريغ الوصفة! $credits رصيد متبقٍ.';
  }

  @override
  String get voiceRecipeTitle => 'وصفة صوتية';

  @override
  String get voiceRecipeIntro =>
      'أخبرنا بوصفتك بصوت عالٍ — سنفرّغها ونحوّلها إلى مسودة منظّمة.';

  @override
  String get voiceRecipeUsesCredits => 'يستخدم رصيدَي ذكاء اصطناعي';

  @override
  String get voiceRecipeTapToStop => 'اضغط على الزر للإيقاف';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'جارٍ التسجيل: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'جاهز للتفريغ';

  @override
  String get voiceRecipeTapToStart => 'اضغط لبدء التسجيل';

  @override
  String get voiceRecipeSpeakNaturally =>
      'انطق وصفتك بشكل طبيعي — اذكر المكوّنات والكميات والخطوات.';

  @override
  String get voiceRecipeTipsTitle => 'نصائح لأفضل النتائج';

  @override
  String get voiceRecipeTipsBody =>
      '• ابدأ باسم الوصفة\n• اذكر كل مكوّن مع كمياته\n• صِف الخطوات بالترتيب\n• اذكر وقت الطهي وعدد الحصص';

  @override
  String get voiceRecipeTranscribing => 'جارٍ التفريغ بالذكاء الاصطناعي...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'تفريغ إلى مسودة';

  @override
  String get voiceRecipeRecordAgain => 'تسجيل مرة أخرى';

  @override
  String get registerSubtitle => 'شارك إرثك في الطهي';

  @override
  String get registerNameLabel => 'الاسم';

  @override
  String get registerNameHint => 'أدخل اسمك';

  @override
  String get registerNameRequired => 'يرجى إدخال اسمك';

  @override
  String get registerEmailLabel => 'البريد الإلكتروني';

  @override
  String get registerEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get registerEmailRequired => 'يرجى إدخال بريدك الإلكتروني';

  @override
  String get registerEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get registerNicknameLabel => 'اللقب (اختياري)';

  @override
  String get registerNicknameHint => 'أدخل لقبك (اختياري)';

  @override
  String get registerNicknameTooLong => 'يجب ألا يتجاوز اللقب 30 حرفًا';

  @override
  String get registerPasswordLabel => 'كلمة المرور';

  @override
  String get registerPasswordHint => 'أدخل كلمة المرور';

  @override
  String get registerPasswordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get registerPasswordTooShort =>
      'يجب أن تتكوّن كلمة المرور من 6 أحرف على الأقل';

  @override
  String get registerCreateAccountButton => 'إنشاء حساب';

  @override
  String get registerAlreadyHaveAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get registerSignInLink => 'تسجيل الدخول';

  @override
  String get registerRegistrationFailed => 'فشل التسجيل';

  @override
  String get scanRecipeCameraPermission => 'إذن الكاميرا مطلوب لمسح وصفة';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'تم مسح الوصفة! $credits رصيد متبقٍ.';
  }

  @override
  String get scanRecipeTitle => 'مسح وصفة';

  @override
  String get scanRecipeIntro =>
      'حوّل بطاقة مكتوبة بخط اليد أو صفحة من كتاب طبخ إلى مسودة وصفة قابلة للتعديل.';

  @override
  String get scanRecipeCreditCost => 'يستخدم رصيد ذكاء اصطناعي واحد';

  @override
  String get scanRecipeEmptyTitle => 'أضف صورة وصفة لمسحها';

  @override
  String get scanRecipeEmptyHint =>
      'تأتي أفضل النتائج من صورة واضحة وجيدة الإضاءة تظهر فيها الوصفة كاملة.';

  @override
  String get scanRecipeChoosePhoto => 'اختيار صورة';

  @override
  String get scanRecipeTakePhoto => 'التقاط صورة';

  @override
  String get scanRecipeScanning => 'جارٍ المسح بالذكاء الاصطناعي...';

  @override
  String get scanRecipeScanButton => 'مسح إلى مسودة';

  @override
  String get notificationsLoadError =>
      'فشل تحميل الإشعارات. يرجى المحاولة مرة أخرى.';

  @override
  String get notificationsAllMarkedRead => 'تم تعليم جميع الإشعارات كمقروءة';

  @override
  String get notificationsMarkAllError =>
      'فشل تعليم الكل كمقروء. يرجى المحاولة مرة أخرى.';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsMarkAllButton => 'تعليم الكل كمقروء';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptySubtitle => 'أنت على اطّلاع بكل شيء!';

  @override
  String get joinFamilyAppBarTitle => 'الانضمام إلى عائلة';

  @override
  String get joinFamilyHeading => 'انضمّ إلى عائلة';

  @override
  String get joinFamilySubtitle =>
      'أدخل رمز الدعوة المكوّن من 8 أحرف من قيّم عائلتك';

  @override
  String get joinFamilyInviteCodeLabel => 'رمز الدعوة';

  @override
  String get joinFamilyButton => 'الانضمام إلى العائلة';

  @override
  String get joinFamilyInfoText => 'اطلب رمز الدعوة من قيّم عائلتك';

  @override
  String get joinFamilyEmptyCodeError => 'يرجى إدخال رمز دعوة';

  @override
  String get joinFamilyCodeLengthError => 'يجب أن يتكوّن رمز الدعوة من 8 أحرف';

  @override
  String get joinFamilyGenericError => 'فشل الانضمام إلى العائلة';

  @override
  String get joinFamilyInvalidCodeError =>
      'رمز دعوة غير صالح. يرجى التحقق والمحاولة مرة أخرى.';

  @override
  String get joinFamilyAlreadyMemberError => 'أنت بالفعل جزء من عائلة.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'تم الانضمام إلى $familyName بنجاح!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning => 'الصق رابط فيديو طهي أو وصفة أولًا';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'يرجى إدخال رابط صالح يبدأ بـ http:// أو https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'تم استيراد الوصفة! $creditsRemaining رصيد متبقٍ.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'حفظ من رابط';

  @override
  String get saveFromLinkIntro =>
      'الصق رابط TikTok أو Instagram أو YouTube أو وصفة وحوّله إلى مسودة Legacy Table قابلة للمشاركة.';

  @override
  String get saveFromLinkCreditCost => 'يستخدم رصيد ذكاء اصطناعي واحد';

  @override
  String get saveFromLinkDraftInfo =>
      'تُفتح الوصفة المستوردة كمسودة أولًا، حتى تتمكن من تنقيح المكوّنات وتعديل طريقة التحضير وإضافة قصتك الخاصة قبل مشاركتها.';

  @override
  String get saveFromLinkImportingLabel =>
      'جارٍ الاستيراد بالذكاء الاصطناعي...';

  @override
  String get saveFromLinkCreateDraftButton => 'إنشاء مسودة من الرابط';

  @override
  String get onboardingNextButton => 'التالي';

  @override
  String get onboardingGetStartedButton => 'ابدأ الآن';

  @override
  String get homeUpgradeFab => 'ترقية';

  @override
  String get homeShareRecipeFab => 'مشاركة وصفة';

  @override
  String get homeNavHome => 'الرئيسية';

  @override
  String get homeNavCookbook => 'كتاب الطبخ';

  @override
  String get homeNavMyRecipes => 'وصفاتي';

  @override
  String get homeNavFamily => 'العائلة';

  @override
  String get homeNavSettings => 'الإعدادات';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'خطة Premium مُفعّلة';

  @override
  String get homeSubscriptionUnlock => 'افتح ميزات العائلة المميزة';

  @override
  String get profileTitle => 'ملفي الشخصي';

  @override
  String get profileNoRecipesTitle => 'لا توجد وصفات بعد';

  @override
  String get profileNoRecipesSubtitle => 'شارك أول وصفة عائلية لك!';

  @override
  String profileLoadRecipesError(String error) {
    return 'فشل تحميل الوصفات: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'لا توجد وصفات موسومة لـ $holidayName بعد';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'ضع علامة على وصفة مفضّلة لدى العائلة لهذه المناسبة من تطبيق الويب أو من تحسينات التفاصيل القادمة على الهاتف.';

  @override
  String get shareInviteTitle => 'مشاركة الدعوة';

  @override
  String get shareInviteLinkTab => 'رابط';

  @override
  String get shareInviteCodeTab => 'رمز';

  @override
  String get shareInviteLinkHint => 'يفتح التطبيق أو يعرض خيارات التنزيل';

  @override
  String get shareInviteCodeHint => 'يُدخل المستلم هذا الرمز في التطبيق';

  @override
  String get shareInviteCopiedSnackbar => 'تم النسخ!';

  @override
  String get shareInviteCopyButton => 'نسخ';

  @override
  String get shareInviteShareButton => 'مشاركة';

  @override
  String get familySettingsInviteCodeCopied => 'تم نسخ رمز الدعوة!';

  @override
  String get familySettingsFamilyHeading => 'العائلة';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'انضمّ إلى عائلة أو أنشئها لتبدأ بمشاركة الوصفات';

  @override
  String get familySettingsNoFamilyYet => 'لا توجد عائلة بعد';

  @override
  String get familySettingsStartSharingRecipes =>
      'ابدأ بمشاركة الوصفات مع أفراد عائلتك';

  @override
  String get familySettingsJoinFamilyButton => 'الانضمام إلى عائلة';

  @override
  String get familySettingsCreateFamilyButton => 'إنشاء عائلة';

  @override
  String get familySettingsTitle => 'إعدادات العائلة';

  @override
  String get familySettingsManageSubtitle => 'أدِر عائلتك ورمز الدعوة.';

  @override
  String get familySettingsInviteCodeLabel => 'رمز الدعوة';

  @override
  String get familySettingsCopyButton => 'نسخ';

  @override
  String get familySettingsShareCodeHelper =>
      'شارك هذا الرمز ليتمكّن الآخرون من الانضمام إلى عائلتك.';

  @override
  String get familySettingsMembersLabel => 'الأعضاء';

  @override
  String get familySettingsNoMembersYet => 'لا يوجد أعضاء بعد';

  @override
  String get familySettingsKeeperBadge => 'القيّم';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String recipeCardServings(int count) {
    return '$count حصص';
  }

  @override
  String get styledSnackbarDismiss => 'تجاهل';

  @override
  String get celebrationTitle => 'مركز الاحتفالات';

  @override
  String get celebrationNextUp => ' — التالي: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'أيام',
      one: 'يوم',
    );
    return '$emoji $name بعد $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'أيام',
      one: 'يوم',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'وصفات',
      one: 'وصفة',
    );
    return 'بعد $days $_temp0  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count حصص';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'بقلم $name';
  }

  @override
  String get familyPromptTitle => 'انضمّ إلى عائلة أو أنشئها';

  @override
  String get familyPromptSubtitle => 'ابدأ بمشاركة الوصفات مع أفراد عائلتك';

  @override
  String get familyPromptJoinButton => 'الانضمام إلى عائلة';

  @override
  String get familyPromptCreateButton => 'إنشاء عائلة';

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

  @override
  String get recipeDetailVoiceNote => 'Voice note';
}
