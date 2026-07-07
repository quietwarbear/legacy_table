// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get selectLanguage => 'انتخاب زبان';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'باز کردن صفحه حذف حساب ممکن نشد';

  @override
  String get settingsFailedToLoadMembers => 'بارگذاری اعضای خانواده ناموفق بود';

  @override
  String get settingsInviteCodeCopied => 'کد دعوت کپی شد!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'به خانواده من «$name» در Legacy Table بپیوند!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'کد دعوت: $code';
  }

  @override
  String get settingsLeaveFamily => 'ترک خانواده';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'آیا مطمئنید که می‌خواهید «$name» را ترک کنید؟ برای پیوستن دوباره به کد دعوت نیاز خواهید داشت.';
  }

  @override
  String get settingsCancel => 'انصراف';

  @override
  String get settingsLeave => 'ترک کردن';

  @override
  String get settingsLeftFamilySuccess => 'با موفقیت از خانواده خارج شدید';

  @override
  String get settingsFailedToLeaveFamily => 'ترک خانواده ناموفق بود';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'پیش از خروج باید نقش نگهبان را واگذار کنید';

  @override
  String get settingsTransferKeeperRole => 'واگذاری نقش نگهبان';

  @override
  String get settingsTransferKeeperPrompt =>
      'به‌عنوان نگهبان، پیش از خروج باید نقش خود را به عضو دیگری واگذار کنید. عضوی را برای تبدیل‌شدن به نگهبان جدید انتخاب کنید:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'نقش نگهبان به $name واگذار شد';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'خانواده را ترک می‌کنید؟';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'نقش نگهبان را با موفقیت واگذار کردید. آیا می‌خواهید اکنون خانواده را ترک کنید؟';

  @override
  String get settingsStay => 'ماندن';

  @override
  String get settingsFailedToTransferKeeper => 'واگذاری نقش نگهبان ناموفق بود';

  @override
  String get settingsRemoveMember => 'حذف عضو';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'آیا مطمئنید که می‌خواهید «$name» را از «$family» حذف کنید؟ آن‌ها برای پیوستن دوباره به کد دعوت نیاز خواهند داشت.';
  }

  @override
  String get settingsRemove => 'حذف';

  @override
  String settingsMemberRemoved(String name) {
    return '$name از خانواده حذف شد';
  }

  @override
  String get settingsFailedToRemoveMember => 'حذف عضو ناموفق بود';

  @override
  String get settingsManageSubscription => 'مدیریت اشتراک';

  @override
  String get settingsUpgradeToPremium => 'ارتقا به Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection فعال است';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper فعال است';

  @override
  String get settingsUnlockPremiumFeatures =>
      'باز کردن طرح‌های خانوادگی، خروجی‌ها و امکانات ویژه';

  @override
  String get settingsKeeperBadge => 'نگهبان';

  @override
  String get settingsMemberBadge => 'عضو';

  @override
  String get settingsInviteCodeLabel => 'کد دعوت';

  @override
  String get settingsShareInviteCodeButton => 'اشتراک‌گذاری کد دعوت';

  @override
  String get settingsFamilyMembers => 'اعضای خانواده';

  @override
  String get settingsNoMembersFound => 'هیچ عضوی یافت نشد';

  @override
  String get settingsRemoveMemberTooltip => 'حذف عضو';

  @override
  String get settingsTheme => 'پوسته';

  @override
  String get settingsDarkMode => 'حالت تیره';

  @override
  String get settingsLightMode => 'حالت روشن';

  @override
  String get settingsEditProfile => 'ویرایش نمایه';

  @override
  String get settingsDeleteAccount => 'حذف حساب';

  @override
  String get settingsNotifications => 'اعلان‌ها';

  @override
  String get settingsTermsOfUse => 'شرایط استفاده';

  @override
  String get settingsPrivacyPolicy => 'سیاست حریم خصوصی';

  @override
  String get settingsAbout => 'درباره';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. تمامی حقوق محفوظ است.';

  @override
  String get settingsLogout => 'خروج';

  @override
  String get settingsLogoutConfirm => 'آیا مطمئنید که می‌خواهید خارج شوید؟';

  @override
  String get recipeDetailLoadRecipeError =>
      'بارگذاری دستور پخت ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get recipeDetailLoadCommentsError =>
      'بارگذاری نظرات ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get recipeDetailLoginToComment => 'لطفاً برای ثبت نظر وارد شوید';

  @override
  String get recipeDetailCommentPosted => 'نظر با موفقیت ثبت شد!';

  @override
  String get recipeDetailPostCommentError => 'ثبت نظر ناموفق بود';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'ثبت نظر ناموفق بود: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'حذف نظر';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'آیا مطمئنید که می‌خواهید این نظر را حذف کنید؟';

  @override
  String get recipeDetailCancel => 'انصراف';

  @override
  String get recipeDetailDelete => 'حذف';

  @override
  String get recipeDetailCommentDeleted => 'نظر با موفقیت حذف شد';

  @override
  String get recipeDetailDeleteCommentError => 'حذف نظر ناموفق بود';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'حذف نظر ناموفق بود: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'دستور پخت با موفقیت به‌روزرسانی شد!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'حذف دستور پخت';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'آیا مطمئنید که می‌خواهید «$title» را حذف کنید؟ این اقدام قابل بازگشت نیست.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'دستور پخت با موفقیت حذف شد';

  @override
  String get recipeDetailDeleteRecipeError => 'حذف دستور پخت ناموفق بود';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'حذف دستور پخت ناموفق بود: $error';
  }

  @override
  String get recipeDetailNotFound => 'دستور پخت یافت نشد';

  @override
  String get recipeDetailSharedByLabel => 'به اشتراک گذاشته‌شده توسط';

  @override
  String get recipeDetailUnknownAuthor => 'نامشخص';

  @override
  String get recipeDetailEdit => 'ویرایش';

  @override
  String get recipeDetailStatTime => 'زمان';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String get recipeDetailStatServes => 'تعداد نفرات';

  @override
  String get recipeDetailStatCategory => 'دسته‌بندی';

  @override
  String get recipeDetailIngredients => 'مواد لازم';

  @override
  String get recipeDetailInstructions => 'دستور تهیه';

  @override
  String get recipeDetailStoryTitle => 'داستان پشت این دستور پخت';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'به اشتراک گذاشته‌شده توسط $author';
  }

  @override
  String get recipeDetailFamilyComments => 'نظرات خانواده';

  @override
  String get recipeDetailRefreshComments => 'تازه‌سازی نظرات';

  @override
  String get recipeDetailCommentHint =>
      'نظرتان را درباره این دستور پخت بنویسید...';

  @override
  String get recipeDetailClear => 'پاک کردن';

  @override
  String get recipeDetailPosting => 'در حال ثبت...';

  @override
  String get recipeDetailPost => 'ثبت';

  @override
  String get recipeDetailNoComments => 'هنوز نظری ثبت نشده';

  @override
  String get recipeDetailBeFirstToComment =>
      'اولین نفری باشید که نظرش را به اشتراک می‌گذارد!';

  @override
  String get recipeDetailNoImage => 'تصویری موجود نیست';

  @override
  String get recipeDetailDeleteCommentTooltip => 'حذف نظر';

  @override
  String get addRecipePhotoPermissionTitle => 'مجوز دسترسی به گالری عکس';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'برای انتخاب تصاویر، مجوز دسترسی به گالری عکس لازم است.\n\nبرای فعال‌سازی:\n1. روی «باز کردن تنظیمات» بزنید\n2. به «مجوزها» بروید\n3. «عکس‌ها و ویدیوها» را فعال کنید';

  @override
  String get addRecipeStoragePermissionTitle => 'مجوز حافظه';

  @override
  String get addRecipeStoragePermissionMessage =>
      'برای انتخاب تصاویر، مجوز دسترسی به حافظه لازم است.\n\nبرای فعال‌سازی:\n1. روی «باز کردن تنظیمات» بزنید\n2. به «مجوزها» بروید\n3. «حافظه» یا «فایل‌ها و رسانه» را فعال کنید';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'برای انتخاب تصاویر، مجوز دسترسی به گالری عکس لازم است.\n\nبرای فعال‌سازی:\n1. روی «باز کردن تنظیمات» بزنید\n2. «Legacy Table» را پیدا کنید\n3. روی «عکس‌ها» بزنید\n4. «همه عکس‌ها» یا «عکس‌های انتخاب‌شده» را انتخاب کنید';

  @override
  String get addRecipeCameraPermissionTitle => 'مجوز دوربین';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'مجوز دوربین به‌طور دائمی رد شده است. لطفاً آن را از تنظیمات برنامه فعال کنید.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'برای گرفتن عکس، مجوز دوربین لازم است';

  @override
  String get addRecipeCancel => 'انصراف';

  @override
  String get addRecipeSettingsHintAndroid =>
      'در تنظیمات برنامه به دنبال مجوز «عکس‌ها و ویدیوها» یا «رسانه» بگردید';

  @override
  String get addRecipeSettingsHintIos =>
      'در تنظیمات برنامه به دنبال مجوز «عکس‌ها» بگردید';

  @override
  String get addRecipeOpenSettings => 'باز کردن تنظیمات';

  @override
  String get addRecipeImageSelectError =>
      'انتخاب تصاویر ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get addRecipeTakePhotoError =>
      'گرفتن عکس ممکن نشد. لطفاً دوباره تلاش کنید.';

  @override
  String get addRecipeSelectCategoryWarning => 'لطفاً یک دسته‌بندی انتخاب کنید';

  @override
  String get addRecipeAddIngredientWarning => 'لطفاً حداقل یک ماده اضافه کنید';

  @override
  String get addRecipeUpdatingRecipe => 'در حال به‌روزرسانی دستور پخت...';

  @override
  String get addRecipeSharingRecipe => 'در حال اشتراک‌گذاری دستور پخت...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'تصویر «$fileName» بیش از حد بزرگ است. حداکثر اندازه ۵ مگابایت است.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'پردازش تصاویر ناموفق بود. لطفاً تصاویر دیگری انتخاب کنید.';

  @override
  String get addRecipeUpdateSuccess => 'دستور پخت با موفقیت به‌روزرسانی شد!';

  @override
  String get addRecipeShareSuccess =>
      'دستور پخت با موفقیت به اشتراک گذاشته شد!';

  @override
  String get addRecipeEditTitle => 'ویرایش دستور پخت';

  @override
  String get addRecipeShareTitle => 'اشتراک‌گذاری یک دستور پخت';

  @override
  String get addRecipeEditSubtitle =>
      'جزئیات دستور پخت خود را به‌روزرسانی کنید';

  @override
  String get addRecipeShareSubtitle =>
      'یک غذای جدید به مجموعه خانواده اضافه کنید';

  @override
  String get addRecipePhotosLabel => 'عکس‌ها';

  @override
  String get addRecipeTitleLabel => 'عنوان دستور پخت *';

  @override
  String get addRecipeTitlePlaceholder => 'مثلاً، جلوف رایس مخصوص مادربزرگ';

  @override
  String get addRecipeTitleRequired => 'عنوان دستور پخت الزامی است';

  @override
  String get addRecipeCategoryLabel => 'دسته‌بندی *';

  @override
  String get addRecipeCategoryPlaceholder => 'انتخاب دسته‌بندی';

  @override
  String get addRecipeCategoryRequired => 'دسته‌بندی الزامی است';

  @override
  String get addRecipeDifficultyLabel => 'سطح دشواری';

  @override
  String get addRecipeDifficultyPlaceholder => 'انتخاب سطح دشواری';

  @override
  String get addRecipeCookingTimeLabel => 'زمان پخت\n(دقیقه)';

  @override
  String get addRecipeServingsLabel => '\nتعداد نفرات';

  @override
  String get addRecipeIngredientsLabel => 'مواد لازم *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'ماده $number';
  }

  @override
  String get addRecipeIngredientRequired => 'این ماده الزامی است';

  @override
  String get addRecipeAddIngredient => 'افزودن ماده';

  @override
  String get addRecipeInstructionsLabel => 'دستور تهیه *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'مراحل پخت را گام‌به‌گام بنویسید...';

  @override
  String get addRecipeInstructionsRequired => 'دستور تهیه الزامی است';

  @override
  String get addRecipeStoryLabel => 'داستان پشت این دستور پخت (اختیاری)';

  @override
  String get addRecipeStoryDescription =>
      'داستان این دستور پخت را به اشتراک بگذارید... از کجا آمده؟ چه کسی آن را به ارث گذاشته؟ چه خاطراتی برای خانواده‌تان دارد؟';

  @override
  String get addRecipeStoryPlaceholder =>
      'درباره تاریخچه، سنت‌ها یا خاطرات ویژه مرتبط با این غذا برایمان بگویید.';

  @override
  String get addRecipeUpdateButton => 'به‌روزرسانی دستور پخت';

  @override
  String get addRecipeShareButton => 'اشتراک‌گذاری دستور پخت';

  @override
  String get addRecipeErrorTitle => 'مشکلی پیش آمد';

  @override
  String get addRecipeErrorMessage =>
      'لطفاً دوباره تلاش کنید یا برنامه را مجدداً اجرا کنید.';

  @override
  String get addRecipeGoBack => 'بازگشت';

  @override
  String get addRecipeUploadFromGallery => 'بارگذاری از گالری';

  @override
  String get addRecipeTakePhoto => 'گرفتن عکس';

  @override
  String get subscriptionNotNow => 'اکنون نه';

  @override
  String get subscriptionRestoring => 'در حال بازیابی…';

  @override
  String get subscriptionRestore => 'بازیابی';

  @override
  String get subscriptionHeaderTitle => 'میراث خانوادگی‌تان\nرا حفظ کنید';

  @override
  String get subscriptionHeaderSubtitle =>
      'امکانات ویژه را باز کنید تا دستورهای پخت خانواده‌تان\nبرای نسل‌ها زنده بماند.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'مناسب برای شروع';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'تجربه کامل خانوادگی';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'ذخیره‌سازی نامحدود دستورهای پخت خانوادگی';

  @override
  String get subscriptionFeatureFamilySharing =>
      'اشتراک‌گذاری خانوادگی (تا ۱۰ عضو)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'بارگذاری عکس برای هر دستور پخت';

  @override
  String get subscriptionFeatureExportPrint => 'خروجی و چاپ کتاب‌های آشپزی';

  @override
  String get subscriptionFeatureCategoriesTags =>
      'دسته‌بندی‌ها و برچسب‌های دستور پخت';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'همه امکانات Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'اعضای خانوادگی نامحدود';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'سازماندهی پیشرفته دستورهای پخت';

  @override
  String get subscriptionFeaturePrioritySupport => 'پشتیبانی اولویت‌دار مشتری';

  @override
  String get subscriptionFeatureEarlyAccess =>
      'دسترسی زودهنگام به امکانات جدید';

  @override
  String get subscriptionFeatureCustomThemes =>
      'پوسته‌های سفارشی کتاب آشپزی خانوادگی';

  @override
  String get subscriptionAutoRenewNotice =>
      'اشتراک‌ها تا زمان لغو به‌صورت خودکار تمدید می‌شوند. هر زمان از تنظیمات دستگاه خود می‌توانید لغو کنید.';

  @override
  String get subscriptionTermsOfUse => 'شرایط استفاده';

  @override
  String get subscriptionPrivacyPolicy => 'سیاست حریم خصوصی';

  @override
  String get subscriptionMostPopular => 'محبوب‌ترین';

  @override
  String get subscriptionPerYear => '/سال';

  @override
  String get subscriptionPerMonth => '/ماه';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/ماه';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'دریافت $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'بارگذاری طرح‌های اشتراک ممکن نشد. لطفاً اتصال اینترنت خود را بررسی کرده و دوباره تلاش کنید.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'در حال حاضر هیچ طرح اشتراکی در دسترس نیست. لطفاً پیکربندی RevenueCat و App Store Connect را بررسی کنید.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'قیمت‌گذاری سالانه هنوز برای این طرح در دسترس نیست.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'قیمت‌گذاری ماهانه هنوز برای این طرح در دسترس نیست.';

  @override
  String get subscriptionWelcomePremium => 'به Legacy Table Premium خوش آمدید!';

  @override
  String get subscriptionRestoreSuccess => 'خریدها با موفقیت بازیابی شدند!';

  @override
  String get subscriptionRestoreNoneFound => 'هیچ خرید قبلی یافت نشد.';

  @override
  String get recipeFeedNotificationsTooltip => 'اعلان‌ها';

  @override
  String get recipeFeedSubheading => 'دستورهای پخت خانوادگی';

  @override
  String get recipeFeedTagline =>
      'سنت‌های آشپزی خانواده‌مان را با عشق حفظ کنیم و به اشتراک بگذاریم';

  @override
  String get recipeFeedShareRecipe => 'اشتراک‌گذاری یک دستور پخت';

  @override
  String get recipeFeedFamilyCookbook => 'کتاب آشپزی خانوادگی';

  @override
  String get recipeFeedScanRecipe => 'اسکن یک دستور پخت';

  @override
  String get recipeFeedVoiceRecipe => 'دستور پخت صوتی';

  @override
  String get recipeFeedComingSoon => 'به‌زودی';

  @override
  String get recipeFeedSaveFromLink => 'ذخیره از پیوند';

  @override
  String recipeFeedLoadError(String error) {
    return 'بارگذاری دستورهای پخت ناموفق بود: $error';
  }

  @override
  String get recipeFeedSearchHint =>
      'جستجوی دستورهای پخت، مواد یا دسته‌بندی‌ها...';

  @override
  String get recipeFeedCategoryAll => 'همه';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'هیچ دستور پختی یافت نشد';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'هنوز دستور پختی نیست';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'جستجوی خود را تغییر دهید یا همه دستورهای پخت را مرور کنید';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'اولین دستور پخت خانوادگی خود را به اشتراک بگذارید و ساختن مجموعه‌تان را آغاز کنید!';

  @override
  String get recipeFeedClearSearch => 'پاک کردن جستجو';

  @override
  String get recipeFeedSmartToolsTitle => 'ابزارهای هوشمند دستور پخت';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'دستورهای پخت را همانند نسخه وب وارد کنید: یک کارت را اسکن کنید یا پیوند یک ویدیو را به پیش‌نویس تبدیل کنید.';

  @override
  String get recipeFeedFeatureScanTitle => 'اسکن دستور پخت';

  @override
  String get recipeFeedFeatureScanDescription =>
      'از عکس یک کارت دست‌نویس یا صفحه کتاب آشپزی استفاده کنید.';

  @override
  String get recipeFeedFeatureLinkTitle => 'ذخیره از پیوند';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'یک پیوند تیک‌تاک، اینستاگرام یا یوتیوب را به پیش‌نویس تبدیل کنید.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'ستاد جشن‌ها';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return 'فصل $season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return '$days روز مانده';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دستور پخت',
      one: '۱ دستور پخت',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'لطفاً برای دسترسی به تنظیمات نمایه وارد شوید';

  @override
  String get profileSettingsLoadFailed =>
      'بارگذاری اطلاعات کاربر ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get profileSettingsPhotoSourceTitle => 'انتخاب منبع عکس';

  @override
  String get profileSettingsCamera => 'دوربین';

  @override
  String get profileSettingsGallery => 'گالری';

  @override
  String get profileSettingsCancel => 'انصراف';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'برای گرفتن عکس، مجوز دوربین لازم است';

  @override
  String get profileSettingsPickImageFailed =>
      'انتخاب تصویر ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get profileSettingsUpdateSuccess => 'نمایه با موفقیت به‌روزرسانی شد';

  @override
  String get profileSettingsUpdateFailed => 'به‌روزرسانی نمایه ناموفق بود';

  @override
  String get profileSettingsTitle => 'تنظیمات نمایه';

  @override
  String get profileSettingsSubtitle =>
      'نحوه نمایش خود را برای خانواده سفارشی کنید';

  @override
  String get profileSettingsProfilePicture => 'عکس نمایه';

  @override
  String get profileSettingsUploadPhotoHint =>
      'برای شخصی‌سازی نمایه خود عکسی بارگذاری کنید';

  @override
  String get profileSettingsDisplayName => 'نام نمایشی';

  @override
  String get profileSettingsFullName => 'نام کامل';

  @override
  String get profileSettingsNicknameLabel => 'لقب (اختیاری)';

  @override
  String get profileSettingsNicknameHint => 'یک لقب وارد کنید...';

  @override
  String get profileSettingsNicknameHelper =>
      'لقب شما به‌جای نام کامل‌تان روی دستورهای پخت و نظرات نمایش داده می‌شود.';

  @override
  String get profileSettingsAccountInformation => 'اطلاعات حساب';

  @override
  String get profileSettingsEmail => 'ایمیل';

  @override
  String get profileSettingsMemberSince => 'عضو از';

  @override
  String get profileSettingsSaveButton => 'ذخیره تغییرات';

  @override
  String get cookbookLoadError =>
      'بارگذاری دستورهای پخت ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get cookbookSelectAtLeastOne => 'لطفاً حداقل یک دستور پخت انتخاب کنید';

  @override
  String get cookbookGeneratingPdf => 'در حال ساخت PDF...';

  @override
  String get cookbookGeneratePdfError => 'ساخت PDF ناموفق بود';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF با موفقیت ساخته شد!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    return 'کتاب آشپزی شما با $recipeCount دستور پخت آماده است. می‌خواهید چه کاری انجام دهید؟';
  }

  @override
  String get cookbookSaveToDevice => 'ذخیره در دستگاه';

  @override
  String get cookbookShare => 'اشتراک‌گذاری';

  @override
  String get cookbookPreviewPrint => 'پیش‌نمایش/چاپ';

  @override
  String get cookbookCancel => 'انصراف';

  @override
  String get cookbookSavingPdf => 'در حال ذخیره PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF با موفقیت در پوشه دانلودها ذخیره شد!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF با موفقیت به اشتراک گذاشته شد!';

  @override
  String get cookbookSavePdfError => 'ذخیره PDF ناموفق بود';

  @override
  String get cookbookSharePdfError => 'اشتراک‌گذاری PDF ناموفق بود';

  @override
  String get cookbookPreviewPdfError => 'پیش‌نمایش PDF ناموفق بود';

  @override
  String get cookbookTitle => 'کتاب آشپزی خانوادگی';

  @override
  String get cookbookSubtitle =>
      'دستورهای پخت را برای ساخت یک کتاب آشپزی PDF قابل چاپ انتخاب کنید';

  @override
  String get cookbookClear => 'پاک کردن';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    return '$selectedCount دستور پخت انتخاب شد';
  }

  @override
  String get cookbookReadyToCreate => 'آماده ساخت کتاب آشپزی شما';

  @override
  String get cookbookExportButton => 'خروجی کتاب آشپزی PDF';

  @override
  String get cookbookNoRecipesTitle => 'هنوز دستور پختی نیست';

  @override
  String get cookbookNoRecipesSubtitle =>
      'برای ساخت کتاب آشپزی خود دستور پخت اضافه کنید';

  @override
  String get createFamilyAppBarTitle => 'ساخت خانواده';

  @override
  String get createFamilyHeading => 'یک خانواده بسازید';

  @override
  String get createFamilySubtitle =>
      'اشتراک‌گذاری دستورهای پخت با اعضای خانواده‌تان را آغاز کنید';

  @override
  String get createFamilyNameLabel => 'نام خانواده';

  @override
  String get createFamilyNameHint => 'مثلاً، خانواده اسمیت';

  @override
  String get createFamilyNameRequired => 'لطفاً نام خانواده را وارد کنید';

  @override
  String get createFamilyNameTooShort => 'نام خانواده باید حداقل ۲ نویسه باشد';

  @override
  String get createFamilyNameTooLong =>
      'نام خانواده باید ۵۰ نویسه یا کمتر باشد';

  @override
  String get createFamilyDescriptionLabel => 'توضیحات (اختیاری)';

  @override
  String get createFamilyDescriptionHint =>
      'درباره خانواده‌تان برایمان بگویید...';

  @override
  String get createFamilyDescriptionTooLong =>
      'توضیحات باید ۵۰۰ نویسه یا کمتر باشد';

  @override
  String get createFamilySubmitButton => 'ساخت خانواده';

  @override
  String get createFamilyKeeperInfo =>
      'شما نگهبان خانواده خواهید شد و می‌توانید دیگران را دعوت کنید';

  @override
  String get createFamilyErrorGeneric => 'ساخت خانواده ناموفق بود';

  @override
  String get createFamilyErrorAlreadyMember =>
      'شما هم‌اکنون عضو یک خانواده هستید.';

  @override
  String get createFamilySuccessTitle => 'خانواده ساخته شد!';

  @override
  String get createFamilyInviteCodeLabel => 'کد دعوت';

  @override
  String get createFamilyInviteCodeCopied => 'کد دعوت کپی شد!';

  @override
  String get createFamilyShareCodeHint =>
      'این کد را با اعضای خانواده به اشتراک بگذارید تا آن‌ها را دعوت کنید';

  @override
  String get createFamilyShareInviteButton => 'اشتراک‌گذاری دعوت';

  @override
  String get createFamilyDoneButton => 'انجام شد';

  @override
  String get loginSubtitle => 'میراث آشپزی خود را به اشتراک بگذارید';

  @override
  String get loginEmailLabel => 'ایمیل';

  @override
  String get loginEmailHint => 'ایمیل خود را وارد کنید';

  @override
  String get loginEmailRequired => 'لطفاً ایمیل خود را وارد کنید';

  @override
  String get loginEmailInvalid => 'لطفاً یک ایمیل معتبر وارد کنید';

  @override
  String get loginPasswordLabel => 'رمز عبور';

  @override
  String get loginPasswordHint => 'رمز عبور خود را وارد کنید';

  @override
  String get loginPasswordRequired => 'لطفاً رمز عبور خود را وارد کنید';

  @override
  String get loginPasswordTooShort => 'رمز عبور باید حداقل ۶ نویسه باشد';

  @override
  String get loginSignInButton => 'ورود';

  @override
  String get loginOrDivider => 'یا';

  @override
  String get loginContinueWithGoogle => 'ادامه با Google';

  @override
  String get loginContinueWithApple => 'ادامه با Apple';

  @override
  String get loginContinueWithFacebook => 'ادامه با Facebook';

  @override
  String get loginNewToFamily => 'تازه به خانواده پیوسته‌اید؟ ';

  @override
  String get loginCreateAccount => 'ساخت حساب';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'برای ضبط دستور پخت، مجوز میکروفون لازم است';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'شروع ضبط ناموفق بود: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'توقف ضبط ناموفق بود: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'فایل ضبط‌شده یافت نشد';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'دستور پخت رونویسی شد! $credits اعتبار باقی مانده است.';
  }

  @override
  String get voiceRecipeTitle => 'دستور پخت صوتی';

  @override
  String get voiceRecipeIntro =>
      'دستور پخت خود را با صدای بلند بگویید — آن را رونویسی می‌کنیم و به یک پیش‌نویس ساختارمند تبدیل می‌کنیم.';

  @override
  String get voiceRecipeUsesCredits => '۲ اعتبار هوش مصنوعی مصرف می‌کند';

  @override
  String get voiceRecipeTapToStop => 'برای توقف روی دکمه بزنید';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'ضبط: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'آماده رونویسی';

  @override
  String get voiceRecipeTapToStart => 'برای شروع ضبط بزنید';

  @override
  String get voiceRecipeSpeakNaturally =>
      'دستور پخت خود را طبیعی بیان کنید — مواد، مقادیر و مراحل را ذکر کنید.';

  @override
  String get voiceRecipeTipsTitle => 'نکاتی برای بهترین نتیجه';

  @override
  String get voiceRecipeTipsBody =>
      '• با نام دستور پخت شروع کنید\n• هر ماده را همراه با مقدارش فهرست کنید\n• مراحل را به‌ترتیب توضیح دهید\n• زمان پخت و تعداد نفرات را ذکر کنید';

  @override
  String get voiceRecipeTranscribing => 'در حال رونویسی با هوش مصنوعی...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'رونویسی به پیش‌نویس';

  @override
  String get voiceRecipeRecordAgain => 'ضبط دوباره';

  @override
  String get registerSubtitle => 'میراث آشپزی خود را به اشتراک بگذارید';

  @override
  String get registerNameLabel => 'نام';

  @override
  String get registerNameHint => 'نام خود را وارد کنید';

  @override
  String get registerNameRequired => 'لطفاً نام خود را وارد کنید';

  @override
  String get registerEmailLabel => 'ایمیل';

  @override
  String get registerEmailHint => 'ایمیل خود را وارد کنید';

  @override
  String get registerEmailRequired => 'لطفاً ایمیل خود را وارد کنید';

  @override
  String get registerEmailInvalid => 'لطفاً یک ایمیل معتبر وارد کنید';

  @override
  String get registerNicknameLabel => 'لقب (اختیاری)';

  @override
  String get registerNicknameHint => 'لقب خود را وارد کنید (اختیاری)';

  @override
  String get registerNicknameTooLong => 'لقب باید ۳۰ نویسه یا کمتر باشد';

  @override
  String get registerPasswordLabel => 'رمز عبور';

  @override
  String get registerPasswordHint => 'رمز عبور خود را وارد کنید';

  @override
  String get registerPasswordRequired => 'لطفاً رمز عبور خود را وارد کنید';

  @override
  String get registerPasswordTooShort => 'رمز عبور باید حداقل ۶ نویسه باشد';

  @override
  String get registerCreateAccountButton => 'ساخت حساب';

  @override
  String get registerAlreadyHaveAccount => 'از قبل حساب دارید؟ ';

  @override
  String get registerSignInLink => 'ورود';

  @override
  String get registerRegistrationFailed => 'ثبت‌نام ناموفق بود';

  @override
  String get scanRecipeCameraPermission =>
      'برای اسکن دستور پخت، مجوز دوربین لازم است';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'دستور پخت اسکن شد! $credits اعتبار باقی مانده است.';
  }

  @override
  String get scanRecipeTitle => 'اسکن دستور پخت';

  @override
  String get scanRecipeIntro =>
      'یک کارت دست‌نویس یا صفحه کتاب آشپزی را به یک پیش‌نویس دستور پخت قابل ویرایش تبدیل کنید.';

  @override
  String get scanRecipeCreditCost => '۱ اعتبار هوش مصنوعی مصرف می‌کند';

  @override
  String get scanRecipeEmptyTitle => 'برای اسکن، عکس یک دستور پخت اضافه کنید';

  @override
  String get scanRecipeEmptyHint =>
      'بهترین نتیجه از یک عکس واضح و با نور کافی که کل دستور پخت در آن دیده شود به دست می‌آید.';

  @override
  String get scanRecipeChoosePhoto => 'انتخاب عکس';

  @override
  String get scanRecipeTakePhoto => 'گرفتن عکس';

  @override
  String get scanRecipeScanning => 'در حال اسکن با هوش مصنوعی...';

  @override
  String get scanRecipeScanButton => 'اسکن به پیش‌نویس';

  @override
  String get notificationsLoadError =>
      'بارگذاری اعلان‌ها ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get notificationsAllMarkedRead =>
      'همه اعلان‌ها به‌عنوان خوانده‌شده علامت‌گذاری شدند';

  @override
  String get notificationsMarkAllError =>
      'علامت‌گذاری همه به‌عنوان خوانده‌شده ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get notificationsTitle => 'اعلان‌ها';

  @override
  String get notificationsMarkAllButton =>
      'علامت‌گذاری همه به‌عنوان خوانده‌شده';

  @override
  String get notificationsEmptyTitle => 'اعلانی نیست';

  @override
  String get notificationsEmptySubtitle => 'همه چیز را دیده‌اید!';

  @override
  String get joinFamilyAppBarTitle => 'پیوستن به خانواده';

  @override
  String get joinFamilyHeading => 'به یک خانواده بپیوندید';

  @override
  String get joinFamilySubtitle =>
      'کد دعوت ۸ نویسه‌ای را که از نگهبان خانواده‌تان گرفته‌اید وارد کنید';

  @override
  String get joinFamilyInviteCodeLabel => 'کد دعوت';

  @override
  String get joinFamilyButton => 'پیوستن به خانواده';

  @override
  String get joinFamilyInfoText => 'کد دعوت را از نگهبان خانواده‌تان بخواهید';

  @override
  String get joinFamilyEmptyCodeError => 'لطفاً یک کد دعوت وارد کنید';

  @override
  String get joinFamilyCodeLengthError => 'کد دعوت باید ۸ نویسه باشد';

  @override
  String get joinFamilyGenericError => 'پیوستن به خانواده ناموفق بود';

  @override
  String get joinFamilyInvalidCodeError =>
      'کد دعوت نامعتبر است. لطفاً بررسی کرده و دوباره تلاش کنید.';

  @override
  String get joinFamilyAlreadyMemberError =>
      'شما هم‌اکنون عضو یک خانواده هستید.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'با موفقیت به $familyName پیوستید!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'ابتدا پیوند یک ویدیوی آشپزی یا دستور پخت را بچسبانید';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'لطفاً یک نشانی معتبر که با http:// یا https:// شروع شود وارد کنید';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'دستور پخت وارد شد! $creditsRemaining اعتبار باقی مانده است.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'ذخیره از پیوند';

  @override
  String get saveFromLinkIntro =>
      'پیوند یک تیک‌تاک، اینستاگرام، یوتیوب یا دستور پخت را بچسبانید و آن را به یک پیش‌نویس قابل‌اشتراک Legacy Table تبدیل کنید.';

  @override
  String get saveFromLinkCreditCost => '۱ اعتبار هوش مصنوعی مصرف می‌کند';

  @override
  String get saveFromLinkDraftInfo =>
      'دستور پخت وارد‌شده ابتدا به‌صورت پیش‌نویس باز می‌شود تا پیش از اشتراک‌گذاری بتوانید مواد را مرتب کنید، دستور تهیه را تنظیم کنید و داستان خودتان را اضافه کنید.';

  @override
  String get saveFromLinkImportingLabel => 'در حال وارد کردن با هوش مصنوعی...';

  @override
  String get saveFromLinkCreateDraftButton => 'ساخت پیش‌نویس از پیوند';

  @override
  String get onboardingNextButton => 'بعدی';

  @override
  String get onboardingGetStartedButton => 'شروع کنید';

  @override
  String get homeUpgradeFab => 'ارتقا';

  @override
  String get homeShareRecipeFab => 'اشتراک‌گذاری یک دستور پخت';

  @override
  String get homeNavHome => 'خانه';

  @override
  String get homeNavCookbook => 'کتاب آشپزی';

  @override
  String get homeNavMyRecipes => 'دستورهای پخت من';

  @override
  String get homeNavFamily => 'خانواده';

  @override
  String get homeNavSettings => 'تنظیمات';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'طرح Premium فعال است';

  @override
  String get homeSubscriptionUnlock => 'باز کردن امکانات ویژه خانوادگی';

  @override
  String get profileTitle => 'نمایه من';

  @override
  String get profileNoRecipesTitle => 'هنوز دستور پختی نیست';

  @override
  String get profileNoRecipesSubtitle =>
      'اولین دستور پخت خانوادگی خود را به اشتراک بگذارید!';

  @override
  String profileLoadRecipesError(String error) {
    return 'بارگذاری دستورهای پخت ناموفق بود: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'هنوز دستور پختی برای $holidayName برچسب‌گذاری نشده';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'یک غذای مورد علاقه خانواده را برای این مناسبت از نسخه وب یا قابلیت‌های آینده صفحه جزئیات موبایل برچسب‌گذاری کنید.';

  @override
  String get shareInviteTitle => 'اشتراک‌گذاری دعوت';

  @override
  String get shareInviteLinkTab => 'پیوند';

  @override
  String get shareInviteCodeTab => 'کد';

  @override
  String get shareInviteLinkHint =>
      'برنامه را باز می‌کند یا گزینه‌های دانلود را نشان می‌دهد';

  @override
  String get shareInviteCodeHint => 'گیرنده این کد را در برنامه وارد می‌کند';

  @override
  String get shareInviteCopiedSnackbar => 'کپی شد!';

  @override
  String get shareInviteCopyButton => 'کپی';

  @override
  String get shareInviteShareButton => 'اشتراک‌گذاری';

  @override
  String get familySettingsInviteCodeCopied => 'کد دعوت کپی شد!';

  @override
  String get familySettingsFamilyHeading => 'خانواده';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'برای آغاز اشتراک‌گذاری دستورهای پخت به یک خانواده بپیوندید یا یکی بسازید';

  @override
  String get familySettingsNoFamilyYet => 'هنوز خانواده‌ای نیست';

  @override
  String get familySettingsStartSharingRecipes =>
      'اشتراک‌گذاری دستورهای پخت با اعضای خانواده‌تان را آغاز کنید';

  @override
  String get familySettingsJoinFamilyButton => 'پیوستن به خانواده';

  @override
  String get familySettingsCreateFamilyButton => 'ساخت خانواده';

  @override
  String get familySettingsTitle => 'تنظیمات خانواده';

  @override
  String get familySettingsManageSubtitle =>
      'خانواده و کد دعوت خود را مدیریت کنید.';

  @override
  String get familySettingsInviteCodeLabel => 'کد دعوت';

  @override
  String get familySettingsCopyButton => 'کپی';

  @override
  String get familySettingsShareCodeHelper =>
      'این کد را به اشتراک بگذارید تا دیگران بتوانند به خانواده‌تان بپیوندند.';

  @override
  String get familySettingsMembersLabel => 'اعضا';

  @override
  String get familySettingsNoMembersYet => 'هنوز عضوی نیست';

  @override
  String get familySettingsKeeperBadge => 'نگهبان';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String recipeCardServings(int count) {
    return '$count نفر';
  }

  @override
  String get styledSnackbarDismiss => 'بستن';

  @override
  String get celebrationTitle => 'ستاد جشن‌ها';

  @override
  String get celebrationNextUp => ' — بعدی: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'روز',
      one: 'روز',
    );
    return '$emoji $name تا $days $_temp0 دیگر';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'روز',
      one: 'روز',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'دستور پخت',
      one: 'دستور پخت',
    );
    return '$days $_temp0 مانده  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count نفر';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'از $name';
  }

  @override
  String get familyPromptTitle => 'به یک خانواده بپیوندید یا یکی بسازید';

  @override
  String get familyPromptSubtitle =>
      'اشتراک‌گذاری دستورهای پخت با اعضای خانواده‌تان را آغاز کنید';

  @override
  String get familyPromptJoinButton => 'پیوستن به خانواده';

  @override
  String get familyPromptCreateButton => 'ساخت خانواده';

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
