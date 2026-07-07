// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get settingsLanguage => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'खाता हटाने वाला पेज नहीं खुल सका';

  @override
  String get settingsFailedToLoadMembers =>
      'परिवार के सदस्यों को लोड करने में विफल';

  @override
  String get settingsInviteCodeCopied => 'आमंत्रण कोड कॉपी हो गया!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Legacy Table पर मेरे परिवार \"$name\" में शामिल हों!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'आमंत्रण कोड: $code';
  }

  @override
  String get settingsLeaveFamily => 'परिवार छोड़ें';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'क्या आप वाकई \"$name\" छोड़ना चाहते हैं? दोबारा शामिल होने के लिए आपको आमंत्रण कोड की आवश्यकता होगी।';
  }

  @override
  String get settingsCancel => 'रद्द करें';

  @override
  String get settingsLeave => 'छोड़ें';

  @override
  String get settingsLeftFamilySuccess => 'परिवार सफलतापूर्वक छोड़ दिया';

  @override
  String get settingsFailedToLeaveFamily => 'परिवार छोड़ने में विफल';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'छोड़ने से पहले आपको कीपर की भूमिका स्थानांतरित करनी होगी';

  @override
  String get settingsTransferKeeperRole => 'कीपर की भूमिका स्थानांतरित करें';

  @override
  String get settingsTransferKeeperPrompt =>
      'कीपर के रूप में, छोड़ने से पहले आपको अपनी भूमिका किसी अन्य सदस्य को स्थानांतरित करनी होगी। नए कीपर बनने के लिए एक सदस्य चुनें:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'कीपर की भूमिका $name को स्थानांतरित कर दी गई';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'परिवार छोड़ें?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'आपने सफलतापूर्वक कीपर की भूमिका स्थानांतरित कर दी है। क्या आप अभी परिवार छोड़ना चाहेंगे?';

  @override
  String get settingsStay => 'बने रहें';

  @override
  String get settingsFailedToTransferKeeper =>
      'कीपर की भूमिका स्थानांतरित करने में विफल';

  @override
  String get settingsRemoveMember => 'सदस्य हटाएं';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'क्या आप वाकई \"$name\" को \"$family\" से हटाना चाहते हैं? दोबारा शामिल होने के लिए उन्हें आमंत्रण कोड की आवश्यकता होगी।';
  }

  @override
  String get settingsRemove => 'हटाएं';

  @override
  String settingsMemberRemoved(String name) {
    return '$name को परिवार से हटा दिया गया है';
  }

  @override
  String get settingsFailedToRemoveMember => 'सदस्य हटाने में विफल';

  @override
  String get settingsManageSubscription => 'सदस्यता प्रबंधित करें';

  @override
  String get settingsUpgradeToPremium => 'Premium में अपग्रेड करें';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection सक्रिय है';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper सक्रिय है';

  @override
  String get settingsUnlockPremiumFeatures =>
      'फैमिली प्लान, एक्सपोर्ट और प्रीमियम सुविधाएं अनलॉक करें';

  @override
  String get settingsKeeperBadge => 'कीपर';

  @override
  String get settingsMemberBadge => 'सदस्य';

  @override
  String get settingsInviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get settingsShareInviteCodeButton => 'आमंत्रण कोड साझा करें';

  @override
  String get settingsFamilyMembers => 'परिवार के सदस्य';

  @override
  String get settingsNoMembersFound => 'कोई सदस्य नहीं मिला';

  @override
  String get settingsRemoveMemberTooltip => 'सदस्य हटाएं';

  @override
  String get settingsTheme => 'थीम';

  @override
  String get settingsDarkMode => 'डार्क मोड';

  @override
  String get settingsLightMode => 'लाइट मोड';

  @override
  String get settingsEditProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get settingsDeleteAccount => 'खाता हटाएं';

  @override
  String get settingsNotifications => 'सूचनाएं';

  @override
  String get settingsTermsOfUse => 'उपयोग की शर्तें';

  @override
  String get settingsPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get settingsAbout => 'परिचय';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. सर्वाधिकार सुरक्षित।';

  @override
  String get settingsLogout => 'लॉग आउट';

  @override
  String get settingsLogoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get recipeDetailLoadRecipeError =>
      'रेसिपी लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get recipeDetailLoadCommentsError =>
      'टिप्पणियां लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get recipeDetailLoginToComment =>
      'टिप्पणी पोस्ट करने के लिए कृपया लॉग इन करें';

  @override
  String get recipeDetailCommentPosted => 'टिप्पणी सफलतापूर्वक पोस्ट हो गई!';

  @override
  String get recipeDetailPostCommentError => 'टिप्पणी पोस्ट करने में विफल';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'टिप्पणी पोस्ट करने में विफल: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'टिप्पणी हटाएं';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'क्या आप वाकई इस टिप्पणी को हटाना चाहते हैं?';

  @override
  String get recipeDetailCancel => 'रद्द करें';

  @override
  String get recipeDetailDelete => 'हटाएं';

  @override
  String get recipeDetailCommentDeleted => 'टिप्पणी सफलतापूर्वक हटा दी गई';

  @override
  String get recipeDetailDeleteCommentError => 'टिप्पणी हटाने में विफल';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'टिप्पणी हटाने में विफल: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'रेसिपी सफलतापूर्वक अपडेट हो गई!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'रेसिपी हटाएं';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'क्या आप वाकई \"$title\" को हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';
  }

  @override
  String get recipeDetailRecipeDeleted => 'रेसिपी सफलतापूर्वक हटा दी गई';

  @override
  String get recipeDetailDeleteRecipeError => 'रेसिपी हटाने में विफल';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'रेसिपी हटाने में विफल: $error';
  }

  @override
  String get recipeDetailNotFound => 'रेसिपी नहीं मिली';

  @override
  String get recipeDetailSharedByLabel => 'द्वारा साझा किया गया';

  @override
  String get recipeDetailUnknownAuthor => 'अज्ञात';

  @override
  String get recipeDetailEdit => 'संपादित करें';

  @override
  String get recipeDetailStatTime => 'समय';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String get recipeDetailStatServes => 'परोसता है';

  @override
  String get recipeDetailStatCategory => 'श्रेणी';

  @override
  String get recipeDetailIngredients => 'सामग्री';

  @override
  String get recipeDetailInstructions => 'निर्देश';

  @override
  String get recipeDetailStoryTitle => 'इस रेसिपी के पीछे की कहानी';

  @override
  String recipeDetailStorySharedBy(String author) {
    return '$author द्वारा साझा किया गया';
  }

  @override
  String get recipeDetailFamilyComments => 'परिवार की टिप्पणियां';

  @override
  String get recipeDetailRefreshComments => 'टिप्पणियां रिफ्रेश करें';

  @override
  String get recipeDetailCommentHint =>
      'इस रेसिपी के बारे में अपने विचार साझा करें...';

  @override
  String get recipeDetailClear => 'साफ़ करें';

  @override
  String get recipeDetailPosting => 'पोस्ट हो रहा है...';

  @override
  String get recipeDetailPost => 'पोस्ट करें';

  @override
  String get recipeDetailNoComments => 'अभी तक कोई टिप्पणी नहीं';

  @override
  String get recipeDetailBeFirstToComment =>
      'अपने विचार साझा करने वाले पहले व्यक्ति बनें!';

  @override
  String get recipeDetailNoImage => 'कोई छवि उपलब्ध नहीं';

  @override
  String get recipeDetailDeleteCommentTooltip => 'टिप्पणी हटाएं';

  @override
  String get addRecipePhotoPermissionTitle => 'फोटो लाइब्रेरी अनुमति';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'छवियां चुनने के लिए फोटो लाइब्रेरी की अनुमति आवश्यक है।\n\nसक्षम करने के लिए:\n1. \"सेटिंग्स खोलें\" पर टैप करें\n2. \"अनुमतियां\" पर जाएं\n3. \"फोटो और वीडियो\" सक्षम करें';

  @override
  String get addRecipeStoragePermissionTitle => 'स्टोरेज अनुमति';

  @override
  String get addRecipeStoragePermissionMessage =>
      'छवियां चुनने के लिए स्टोरेज की अनुमति आवश्यक है।\n\nसक्षम करने के लिए:\n1. \"सेटिंग्स खोलें\" पर टैप करें\n2. \"अनुमतियां\" पर जाएं\n3. \"स्टोरेज\" या \"फ़ाइलें और मीडिया\" सक्षम करें';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'छवियां चुनने के लिए फोटो लाइब्रेरी की अनुमति आवश्यक है।\n\nसक्षम करने के लिए:\n1. \"सेटिंग्स खोलें\" पर टैप करें\n2. \"Legacy Table\" खोजें\n3. \"फोटो\" पर टैप करें\n4. \"सभी फोटो\" या \"चयनित फोटो\" चुनें';

  @override
  String get addRecipeCameraPermissionTitle => 'कैमरा अनुमति';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'कैमरा अनुमति स्थायी रूप से अस्वीकृत है। कृपया इसे ऐप सेटिंग्स से सक्षम करें।';

  @override
  String get addRecipeCameraPermissionRequired =>
      'फोटो लेने के लिए कैमरा अनुमति आवश्यक है';

  @override
  String get addRecipeCancel => 'रद्द करें';

  @override
  String get addRecipeSettingsHintAndroid =>
      'ऐप सेटिंग्स में \"फोटो और वीडियो\" या \"मीडिया\" अनुमति देखें';

  @override
  String get addRecipeSettingsHintIos =>
      'ऐप सेटिंग्स में \"फोटो\" अनुमति देखें';

  @override
  String get addRecipeOpenSettings => 'सेटिंग्स खोलें';

  @override
  String get addRecipeImageSelectError =>
      'छवियां नहीं चुनी जा सकीं। कृपया पुनः प्रयास करें।';

  @override
  String get addRecipeTakePhotoError =>
      'फोटो नहीं ली जा सकी। कृपया पुनः प्रयास करें।';

  @override
  String get addRecipeSelectCategoryWarning => 'कृपया एक श्रेणी चुनें';

  @override
  String get addRecipeAddIngredientWarning =>
      'कृपया कम से कम एक सामग्री जोड़ें';

  @override
  String get addRecipeUpdatingRecipe => 'रेसिपी अपडेट हो रही है...';

  @override
  String get addRecipeSharingRecipe => 'रेसिपी साझा हो रही है...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'छवि \"$fileName\" बहुत बड़ी है। अधिकतम आकार 5MB है।';
  }

  @override
  String get addRecipeProcessImagesError =>
      'छवियों को प्रोसेस करने में विफल। कृपया अलग छवियां चुनने का प्रयास करें।';

  @override
  String get addRecipeUpdateSuccess => 'रेसिपी सफलतापूर्वक अपडेट हो गई!';

  @override
  String get addRecipeShareSuccess => 'रेसिपी सफलतापूर्वक साझा हो गई!';

  @override
  String get addRecipeEditTitle => 'रेसिपी संपादित करें';

  @override
  String get addRecipeShareTitle => 'एक रेसिपी साझा करें';

  @override
  String get addRecipeEditSubtitle => 'अपनी रेसिपी का विवरण अपडेट करें';

  @override
  String get addRecipeShareSubtitle =>
      'परिवार के संग्रह में एक नया व्यंजन जोड़ें';

  @override
  String get addRecipePhotosLabel => 'फोटो';

  @override
  String get addRecipeTitleLabel => 'रेसिपी का शीर्षक *';

  @override
  String get addRecipeTitlePlaceholder => 'उदा., दादी की खास जोलोफ राइस';

  @override
  String get addRecipeTitleRequired => 'रेसिपी का शीर्षक आवश्यक है';

  @override
  String get addRecipeCategoryLabel => 'श्रेणी *';

  @override
  String get addRecipeCategoryPlaceholder => 'श्रेणी चुनें';

  @override
  String get addRecipeCategoryRequired => 'श्रेणी आवश्यक है';

  @override
  String get addRecipeDifficultyLabel => 'कठिनाई';

  @override
  String get addRecipeDifficultyPlaceholder => 'कठिनाई चुनें';

  @override
  String get addRecipeCookingTimeLabel => 'पकाने का समय\n(मिनट)';

  @override
  String get addRecipeServingsLabel => '\nपरोसने की मात्रा';

  @override
  String get addRecipeIngredientsLabel => 'सामग्री *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'सामग्री $number';
  }

  @override
  String get addRecipeIngredientRequired => 'सामग्री आवश्यक है';

  @override
  String get addRecipeAddIngredient => 'सामग्री जोड़ें';

  @override
  String get addRecipeInstructionsLabel => 'निर्देश *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'चरण-दर-चरण पकाने के निर्देश लिखें...';

  @override
  String get addRecipeInstructionsRequired => 'निर्देश आवश्यक हैं';

  @override
  String get addRecipeStoryLabel => 'इस रेसिपी के पीछे की कहानी (वैकल्पिक)';

  @override
  String get addRecipeStoryDescription =>
      'इस रेसिपी की कहानी साझा करें... यह कहां से आई? इसे किसने आगे बढ़ाया? इससे आपके परिवार की कौन सी यादें जुड़ी हैं?';

  @override
  String get addRecipeStoryPlaceholder =>
      'इस व्यंजन से जुड़े इतिहास, परंपराओं या खास यादों के बारे में हमें बताएं।';

  @override
  String get addRecipeUpdateButton => 'रेसिपी अपडेट करें';

  @override
  String get addRecipeShareButton => 'रेसिपी साझा करें';

  @override
  String get addRecipeErrorTitle => 'कुछ गलत हो गया';

  @override
  String get addRecipeErrorMessage =>
      'कृपया पुनः प्रयास करें या ऐप को पुनः आरंभ करें।';

  @override
  String get addRecipeGoBack => 'वापस जाएं';

  @override
  String get addRecipeUploadFromGallery => 'गैलरी से अपलोड करें';

  @override
  String get addRecipeTakePhoto => 'फोटो लें';

  @override
  String get subscriptionNotNow => 'अभी नहीं';

  @override
  String get subscriptionRestoring => 'पुनर्स्थापित हो रहा है…';

  @override
  String get subscriptionRestore => 'पुनर्स्थापित करें';

  @override
  String get subscriptionHeaderTitle => 'अपनी पारिवारिक\nविरासत को सहेजें';

  @override
  String get subscriptionHeaderSubtitle =>
      'अपने परिवार की रेसिपीज़ को पीढ़ियों तक जीवित\nरखने के लिए प्रीमियम सुविधाएं अनलॉक करें।';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline =>
      'शुरुआत करने के लिए बिल्कुल सही';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'संपूर्ण पारिवारिक अनुभव';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'असीमित पारिवारिक रेसिपी स्टोरेज';

  @override
  String get subscriptionFeatureFamilySharing =>
      'परिवार के साथ साझाकरण (10 सदस्यों तक)';

  @override
  String get subscriptionFeaturePhotoUploads => 'हर रेसिपी के लिए फोटो अपलोड';

  @override
  String get subscriptionFeatureExportPrint =>
      'रेसिपी बुक एक्सपोर्ट और प्रिंट करें';

  @override
  String get subscriptionFeatureCategoriesTags => 'रेसिपी श्रेणियां और टैग';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Heritage Keeper में सब कुछ';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'असीमित परिवार के सदस्य';

  @override
  String get subscriptionFeatureAdvancedOrganization => 'उन्नत रेसिपी व्यवस्था';

  @override
  String get subscriptionFeaturePrioritySupport => 'प्राथमिकता ग्राहक सहायता';

  @override
  String get subscriptionFeatureEarlyAccess => 'नई सुविधाओं तक जल्दी पहुंच';

  @override
  String get subscriptionFeatureCustomThemes => 'कस्टम पारिवारिक कुकबुक थीम';

  @override
  String get subscriptionAutoRenewNotice =>
      'रद्द किए जाने तक सदस्यताएं स्वतः नवीनीकृत होती हैं। अपने डिवाइस की सेटिंग्स में कभी भी रद्द करें।';

  @override
  String get subscriptionTermsOfUse => 'उपयोग की शर्तें';

  @override
  String get subscriptionPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get subscriptionMostPopular => 'सर्वाधिक लोकप्रिय';

  @override
  String get subscriptionPerYear => '/वर्ष';

  @override
  String get subscriptionPerMonth => '/माह';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/माह';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return '$tierName पाएं — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'सदस्यता योजनाएं लोड नहीं की जा सकीं। कृपया अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'अभी कोई सदस्यता योजना उपलब्ध नहीं है। कृपया RevenueCat और App Store Connect कॉन्फ़िगरेशन जांचें।';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'इस योजना के लिए वार्षिक मूल्य अभी उपलब्ध नहीं है।';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'इस योजना के लिए मासिक मूल्य अभी उपलब्ध नहीं है।';

  @override
  String get subscriptionWelcomePremium =>
      'Legacy Table Premium में आपका स्वागत है!';

  @override
  String get subscriptionRestoreSuccess =>
      'खरीदारी सफलतापूर्वक पुनर्स्थापित हो गई!';

  @override
  String get subscriptionRestoreNoneFound => 'कोई पिछली खरीदारी नहीं मिली।';

  @override
  String get recipeFeedNotificationsTooltip => 'सूचनाएं';

  @override
  String get recipeFeedSubheading => 'पारिवारिक रेसिपीज़';

  @override
  String get recipeFeedTagline =>
      'हमारे परिवार की पाक परंपराओं को प्यार से सहेजें और साझा करें';

  @override
  String get recipeFeedShareRecipe => 'एक रेसिपी साझा करें';

  @override
  String get recipeFeedFamilyCookbook => 'पारिवारिक कुकबुक';

  @override
  String get recipeFeedScanRecipe => 'रेसिपी स्कैन करें';

  @override
  String get recipeFeedVoiceRecipe => 'रेसिपी बोलें';

  @override
  String get recipeFeedComingSoon => 'जल्द आ रहा है';

  @override
  String get recipeFeedSaveFromLink => 'लिंक से सहेजें';

  @override
  String recipeFeedLoadError(String error) {
    return 'रेसिपीज़ लोड करने में विफल: $error';
  }

  @override
  String get recipeFeedSearchHint => 'रेसिपी, सामग्री या श्रेणियां खोजें...';

  @override
  String get recipeFeedCategoryAll => 'सभी';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'कोई रेसिपी नहीं मिली';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'अभी तक कोई रेसिपी नहीं';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'अपनी खोज समायोजित करने या सभी रेसिपीज़ ब्राउज़ करने का प्रयास करें';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'अपनी पहली पारिवारिक रेसिपी साझा करें और अपना संग्रह बनाना शुरू करें!';

  @override
  String get recipeFeedClearSearch => 'खोज साफ़ करें';

  @override
  String get recipeFeedSmartToolsTitle => 'स्मार्ट रेसिपी टूल';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'वेब ऐप की तरह ही रेसिपीज़ लाएं: एक कार्ड स्कैन करें या किसी वीडियो लिंक को ड्राफ्ट में बदलें।';

  @override
  String get recipeFeedFeatureScanTitle => 'रेसिपी स्कैन करें';

  @override
  String get recipeFeedFeatureScanDescription =>
      'हस्तलिखित कार्ड या कुकबुक पेज की एक फोटो का उपयोग करें।';

  @override
  String get recipeFeedFeatureLinkTitle => 'लिंक से सहेजें';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'किसी TikTok, Instagram या YouTube लिंक को ड्राफ्ट में बदलें।';

  @override
  String get recipeFeedCelebrationHeadquarters => 'उत्सव मुख्यालय';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return '$season सीज़न • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return '$days दिन बाकी';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count रेसिपीज़',
      one: '1 रेसिपी',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'प्रोफ़ाइल सेटिंग्स तक पहुंचने के लिए कृपया लॉग इन करें';

  @override
  String get profileSettingsLoadFailed =>
      'उपयोगकर्ता डेटा लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get profileSettingsPhotoSourceTitle => 'फोटो स्रोत चुनें';

  @override
  String get profileSettingsCamera => 'कैमरा';

  @override
  String get profileSettingsGallery => 'गैलरी';

  @override
  String get profileSettingsCancel => 'रद्द करें';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'फोटो लेने के लिए कैमरा अनुमति आवश्यक है';

  @override
  String get profileSettingsPickImageFailed =>
      'छवि चुनने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get profileSettingsUpdateSuccess =>
      'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई';

  @override
  String get profileSettingsUpdateFailed => 'प्रोफ़ाइल अपडेट करने में विफल';

  @override
  String get profileSettingsTitle => 'प्रोफ़ाइल सेटिंग्स';

  @override
  String get profileSettingsSubtitle =>
      'परिवार के सामने आप कैसे दिखते हैं, इसे अनुकूलित करें';

  @override
  String get profileSettingsProfilePicture => 'प्रोफ़ाइल चित्र';

  @override
  String get profileSettingsUploadPhotoHint =>
      'अपनी प्रोफ़ाइल को निजी बनाने के लिए एक फोटो अपलोड करें';

  @override
  String get profileSettingsDisplayName => 'प्रदर्शित नाम';

  @override
  String get profileSettingsFullName => 'पूरा नाम';

  @override
  String get profileSettingsNicknameLabel => 'उपनाम (वैकल्पिक)';

  @override
  String get profileSettingsNicknameHint => 'एक उपनाम दर्ज करें...';

  @override
  String get profileSettingsNicknameHelper =>
      'रेसिपीज़ और टिप्पणियों पर आपके पूरे नाम के बजाय आपका उपनाम दिखाया जाएगा।';

  @override
  String get profileSettingsAccountInformation => 'खाता जानकारी';

  @override
  String get profileSettingsEmail => 'ईमेल';

  @override
  String get profileSettingsMemberSince => 'सदस्य कब से';

  @override
  String get profileSettingsSaveButton => 'परिवर्तन सहेजें';

  @override
  String get cookbookLoadError =>
      'रेसिपीज़ लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get cookbookSelectAtLeastOne => 'कृपया कम से कम एक रेसिपी चुनें';

  @override
  String get cookbookGeneratingPdf => 'PDF तैयार हो रही है...';

  @override
  String get cookbookGeneratePdfError => 'PDF तैयार करने में विफल';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF सफलतापूर्वक तैयार हो गई!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 'ज़',
      one: '',
    );
    return '$recipeCount रेसिपी$_temp0 वाली आपकी कुकबुक तैयार है। आप क्या करना चाहेंगे?';
  }

  @override
  String get cookbookSaveToDevice => 'डिवाइस में सहेजें';

  @override
  String get cookbookShare => 'साझा करें';

  @override
  String get cookbookPreviewPrint => 'पूर्वावलोकन/प्रिंट करें';

  @override
  String get cookbookCancel => 'रद्द करें';

  @override
  String get cookbookSavingPdf => 'PDF सहेजी जा रही है...';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF सफलतापूर्वक डाउनलोड फ़ोल्डर में सहेजी गई!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF सफलतापूर्वक साझा हो गई!';

  @override
  String get cookbookSavePdfError => 'PDF सहेजने में विफल';

  @override
  String get cookbookSharePdfError => 'PDF साझा करने में विफल';

  @override
  String get cookbookPreviewPdfError => 'PDF का पूर्वावलोकन करने में विफल';

  @override
  String get cookbookTitle => 'पारिवारिक कुकबुक';

  @override
  String get cookbookSubtitle =>
      'प्रिंट करने योग्य PDF कुकबुक बनाने के लिए रेसिपीज़ चुनें';

  @override
  String get cookbookClear => 'साफ़ करें';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 'ज़',
      one: '',
    );
    return '$selectedCount रेसिपी$_temp0 चयनित';
  }

  @override
  String get cookbookReadyToCreate => 'आपकी कुकबुक बनाने के लिए तैयार';

  @override
  String get cookbookExportButton => 'PDF कुकबुक एक्सपोर्ट करें';

  @override
  String get cookbookNoRecipesTitle => 'अभी तक कोई रेसिपी नहीं';

  @override
  String get cookbookNoRecipesSubtitle =>
      'अपनी कुकबुक बनाने के लिए रेसिपीज़ जोड़ें';

  @override
  String get createFamilyAppBarTitle => 'परिवार बनाएं';

  @override
  String get createFamilyHeading => 'एक परिवार बनाएं';

  @override
  String get createFamilySubtitle =>
      'अपने परिवार के सदस्यों के साथ रेसिपीज़ साझा करना शुरू करें';

  @override
  String get createFamilyNameLabel => 'परिवार का नाम';

  @override
  String get createFamilyNameHint => 'उदा., शर्मा परिवार';

  @override
  String get createFamilyNameRequired => 'कृपया परिवार का नाम दर्ज करें';

  @override
  String get createFamilyNameTooShort =>
      'परिवार का नाम कम से कम 2 अक्षरों का होना चाहिए';

  @override
  String get createFamilyNameTooLong =>
      'परिवार का नाम 50 अक्षरों या उससे कम का होना चाहिए';

  @override
  String get createFamilyDescriptionLabel => 'विवरण (वैकल्पिक)';

  @override
  String get createFamilyDescriptionHint =>
      'अपने परिवार के बारे में हमें बताएं...';

  @override
  String get createFamilyDescriptionTooLong =>
      'विवरण 500 अक्षरों या उससे कम का होना चाहिए';

  @override
  String get createFamilySubmitButton => 'परिवार बनाएं';

  @override
  String get createFamilyKeeperInfo =>
      'आप परिवार के कीपर बनेंगे और दूसरों को आमंत्रित कर सकेंगे';

  @override
  String get createFamilyErrorGeneric => 'परिवार बनाने में विफल';

  @override
  String get createFamilyErrorAlreadyMember =>
      'आप पहले से ही एक परिवार का हिस्सा हैं।';

  @override
  String get createFamilySuccessTitle => 'परिवार बन गया!';

  @override
  String get createFamilyInviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get createFamilyInviteCodeCopied => 'आमंत्रण कोड कॉपी हो गया!';

  @override
  String get createFamilyShareCodeHint =>
      'परिवार के सदस्यों को आमंत्रित करने के लिए यह कोड उनके साथ साझा करें';

  @override
  String get createFamilyShareInviteButton => 'आमंत्रण साझा करें';

  @override
  String get createFamilyDoneButton => 'हो गया';

  @override
  String get loginSubtitle => 'अपनी पाक विरासत साझा करें';

  @override
  String get loginEmailLabel => 'ईमेल';

  @override
  String get loginEmailHint => 'अपना ईमेल दर्ज करें';

  @override
  String get loginEmailRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get loginEmailInvalid => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get loginPasswordRequired => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get loginPasswordTooShort =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get loginSignInButton => 'साइन इन करें';

  @override
  String get loginOrDivider => 'या';

  @override
  String get loginContinueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get loginContinueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get loginContinueWithFacebook => 'Facebook के साथ जारी रखें';

  @override
  String get loginNewToFamily => 'परिवार में नए हैं? ';

  @override
  String get loginCreateAccount => 'खाता बनाएं';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'रेसिपी रिकॉर्ड करने के लिए माइक्रोफ़ोन अनुमति आवश्यक है';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'रिकॉर्डिंग शुरू करने में विफल: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'रिकॉर्डिंग रोकने में विफल: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'रिकॉर्डिंग फ़ाइल नहीं मिली';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'रेसिपी ट्रांसक्राइब हो गई! $credits क्रेडिट शेष।';
  }

  @override
  String get voiceRecipeTitle => 'वॉइस रेसिपी';

  @override
  String get voiceRecipeIntro =>
      'अपनी रेसिपी हमें ज़ोर से बताएं — हम इसे ट्रांसक्राइब करेंगे और एक संरचित ड्राफ्ट में बदल देंगे।';

  @override
  String get voiceRecipeUsesCredits => '2 AI क्रेडिट का उपयोग करता है';

  @override
  String get voiceRecipeTapToStop => 'रोकने के लिए बटन पर टैप करें';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'रिकॉर्डिंग: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'ट्रांसक्राइब करने के लिए तैयार';

  @override
  String get voiceRecipeTapToStart => 'रिकॉर्डिंग शुरू करने के लिए टैप करें';

  @override
  String get voiceRecipeSpeakNaturally =>
      'अपनी रेसिपी स्वाभाविक रूप से बोलें — सामग्री, मात्रा और चरण शामिल करें।';

  @override
  String get voiceRecipeTipsTitle => 'बेहतरीन परिणामों के लिए सुझाव';

  @override
  String get voiceRecipeTipsBody =>
      '• रेसिपी के नाम से शुरू करें\n• प्रत्येक सामग्री को मात्रा सहित बताएं\n• चरणों को क्रम में बताएं\n• पकाने का समय और परोसने की मात्रा बताएं';

  @override
  String get voiceRecipeTranscribing => 'AI से ट्रांसक्राइब हो रहा है...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'ड्राफ्ट में ट्रांसक्राइब करें';

  @override
  String get voiceRecipeRecordAgain => 'फिर से रिकॉर्ड करें';

  @override
  String get registerSubtitle => 'अपनी पाक विरासत साझा करें';

  @override
  String get registerNameLabel => 'नाम';

  @override
  String get registerNameHint => 'अपना नाम दर्ज करें';

  @override
  String get registerNameRequired => 'कृपया अपना नाम दर्ज करें';

  @override
  String get registerEmailLabel => 'ईमेल';

  @override
  String get registerEmailHint => 'अपना ईमेल दर्ज करें';

  @override
  String get registerEmailRequired => 'कृपया अपना ईमेल दर्ज करें';

  @override
  String get registerEmailInvalid => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String get registerNicknameLabel => 'उपनाम (वैकल्पिक)';

  @override
  String get registerNicknameHint => 'अपना उपनाम दर्ज करें (वैकल्पिक)';

  @override
  String get registerNicknameTooLong =>
      'उपनाम 30 अक्षरों या उससे कम का होना चाहिए';

  @override
  String get registerPasswordLabel => 'पासवर्ड';

  @override
  String get registerPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get registerPasswordRequired => 'कृपया अपना पासवर्ड दर्ज करें';

  @override
  String get registerPasswordTooShort =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get registerCreateAccountButton => 'खाता बनाएं';

  @override
  String get registerAlreadyHaveAccount => 'पहले से ही एक खाता है? ';

  @override
  String get registerSignInLink => 'साइन इन करें';

  @override
  String get registerRegistrationFailed => 'पंजीकरण विफल रहा';

  @override
  String get scanRecipeCameraPermission =>
      'रेसिपी स्कैन करने के लिए कैमरा अनुमति आवश्यक है';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'रेसिपी स्कैन हो गई! $credits क्रेडिट शेष।';
  }

  @override
  String get scanRecipeTitle => 'रेसिपी स्कैन करें';

  @override
  String get scanRecipeIntro =>
      'किसी हस्तलिखित कार्ड या कुकबुक पेज को एक संपादन योग्य रेसिपी ड्राफ्ट में बदलें।';

  @override
  String get scanRecipeCreditCost => '1 AI क्रेडिट का उपयोग करता है';

  @override
  String get scanRecipeEmptyTitle => 'स्कैन करने के लिए एक रेसिपी फोटो जोड़ें';

  @override
  String get scanRecipeEmptyHint =>
      'बेहतरीन परिणाम एक स्पष्ट, अच्छी रोशनी वाली फोटो से मिलते हैं जिसमें पूरी रेसिपी दिखाई दे।';

  @override
  String get scanRecipeChoosePhoto => 'फोटो चुनें';

  @override
  String get scanRecipeTakePhoto => 'फोटो लें';

  @override
  String get scanRecipeScanning => 'AI से स्कैन हो रहा है...';

  @override
  String get scanRecipeScanButton => 'ड्राफ्ट में स्कैन करें';

  @override
  String get notificationsLoadError =>
      'सूचनाएं लोड करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get notificationsAllMarkedRead =>
      'सभी सूचनाएं पढ़ी गई के रूप में चिह्नित';

  @override
  String get notificationsMarkAllError =>
      'सभी को पढ़ा गया चिह्नित करने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get notificationsTitle => 'सूचनाएं';

  @override
  String get notificationsMarkAllButton => 'सभी को पढ़ा गया चिह्नित करें';

  @override
  String get notificationsEmptyTitle => 'कोई सूचना नहीं';

  @override
  String get notificationsEmptySubtitle => 'आप पूरी तरह अपडेट हैं!';

  @override
  String get joinFamilyAppBarTitle => 'परिवार में शामिल हों';

  @override
  String get joinFamilyHeading => 'एक परिवार में शामिल हों';

  @override
  String get joinFamilySubtitle =>
      'अपने परिवार के कीपर से मिला 8-अक्षरों का आमंत्रण कोड दर्ज करें';

  @override
  String get joinFamilyInviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get joinFamilyButton => 'परिवार में शामिल हों';

  @override
  String get joinFamilyInfoText =>
      'आमंत्रण कोड के लिए अपने परिवार के कीपर से पूछें';

  @override
  String get joinFamilyEmptyCodeError => 'कृपया एक आमंत्रण कोड दर्ज करें';

  @override
  String get joinFamilyCodeLengthError => 'आमंत्रण कोड 8 अक्षरों का होना चाहिए';

  @override
  String get joinFamilyGenericError => 'परिवार में शामिल होने में विफल';

  @override
  String get joinFamilyInvalidCodeError =>
      'अमान्य आमंत्रण कोड। कृपया जांचें और पुनः प्रयास करें।';

  @override
  String get joinFamilyAlreadyMemberError =>
      'आप पहले से ही एक परिवार का हिस्सा हैं।';

  @override
  String joinFamilySuccess(String familyName) {
    return '$familyName में सफलतापूर्वक शामिल हो गए!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'पहले एक कुकिंग वीडियो या रेसिपी लिंक पेस्ट करें';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'कृपया http:// या https:// से शुरू होने वाला एक वैध URL दर्ज करें';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'रेसिपी इम्पोर्ट हो गई! $creditsRemaining क्रेडिट शेष।';
  }

  @override
  String get saveFromLinkAppBarTitle => 'लिंक से सहेजें';

  @override
  String get saveFromLinkIntro =>
      'किसी TikTok, Instagram, YouTube या रेसिपी लिंक को पेस्ट करें और उसे एक साझा करने योग्य Legacy Table ड्राफ्ट में बदलें।';

  @override
  String get saveFromLinkCreditCost => '1 AI क्रेडिट का उपयोग करता है';

  @override
  String get saveFromLinkDraftInfo =>
      'इम्पोर्ट की गई रेसिपी पहले एक ड्राफ्ट के रूप में खुलती है, ताकि आप इसे साझा करने से पहले सामग्री को व्यवस्थित कर सकें, निर्देशों को समायोजित कर सकें और अपनी खुद की कहानी जोड़ सकें।';

  @override
  String get saveFromLinkImportingLabel => 'AI से इम्पोर्ट हो रहा है...';

  @override
  String get saveFromLinkCreateDraftButton => 'लिंक से ड्राफ्ट बनाएं';

  @override
  String get onboardingNextButton => 'अगला';

  @override
  String get onboardingGetStartedButton => 'शुरू करें';

  @override
  String get homeUpgradeFab => 'अपग्रेड करें';

  @override
  String get homeShareRecipeFab => 'एक रेसिपी साझा करें';

  @override
  String get homeNavHome => 'होम';

  @override
  String get homeNavCookbook => 'कुकबुक';

  @override
  String get homeNavMyRecipes => 'मेरी रेसिपीज़';

  @override
  String get homeNavFamily => 'परिवार';

  @override
  String get homeNavSettings => 'सेटिंग्स';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Premium प्लान सक्रिय';

  @override
  String get homeSubscriptionUnlock => 'प्रीमियम पारिवारिक सुविधाएं अनलॉक करें';

  @override
  String get profileTitle => 'मेरी प्रोफ़ाइल';

  @override
  String get profileNoRecipesTitle => 'अभी तक कोई रेसिपी नहीं';

  @override
  String get profileNoRecipesSubtitle =>
      'अपनी पहली पारिवारिक रेसिपी साझा करें!';

  @override
  String profileLoadRecipesError(String error) {
    return 'रेसिपीज़ लोड करने में विफल: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return '$holidayName के लिए अभी तक कोई रेसिपी टैग नहीं की गई';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'वेब ऐप या आगामी मोबाइल विवरण सुधारों से इस त्योहार के लिए परिवार की किसी पसंदीदा रेसिपी को टैग करें।';

  @override
  String get shareInviteTitle => 'आमंत्रण साझा करें';

  @override
  String get shareInviteLinkTab => 'लिंक';

  @override
  String get shareInviteCodeTab => 'कोड';

  @override
  String get shareInviteLinkHint => 'ऐप खोलता है या डाउनलोड विकल्प दिखाता है';

  @override
  String get shareInviteCodeHint => 'प्राप्तकर्ता ऐप में यह कोड दर्ज करता है';

  @override
  String get shareInviteCopiedSnackbar => 'कॉपी हो गया!';

  @override
  String get shareInviteCopyButton => 'कॉपी करें';

  @override
  String get shareInviteShareButton => 'साझा करें';

  @override
  String get familySettingsInviteCodeCopied => 'आमंत्रण कोड कॉपी हो गया!';

  @override
  String get familySettingsFamilyHeading => 'परिवार';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'रेसिपीज़ साझा करना शुरू करने के लिए किसी परिवार में शामिल हों या बनाएं';

  @override
  String get familySettingsNoFamilyYet => 'अभी तक कोई परिवार नहीं';

  @override
  String get familySettingsStartSharingRecipes =>
      'अपने परिवार के सदस्यों के साथ रेसिपीज़ साझा करना शुरू करें';

  @override
  String get familySettingsJoinFamilyButton => 'परिवार में शामिल हों';

  @override
  String get familySettingsCreateFamilyButton => 'परिवार बनाएं';

  @override
  String get familySettingsTitle => 'परिवार सेटिंग्स';

  @override
  String get familySettingsManageSubtitle =>
      'अपने परिवार और आमंत्रण कोड को प्रबंधित करें।';

  @override
  String get familySettingsInviteCodeLabel => 'आमंत्रण कोड';

  @override
  String get familySettingsCopyButton => 'कॉपी करें';

  @override
  String get familySettingsShareCodeHelper =>
      'यह कोड साझा करें ताकि दूसरे आपके परिवार में शामिल हो सकें।';

  @override
  String get familySettingsMembersLabel => 'सदस्य';

  @override
  String get familySettingsNoMembersYet => 'अभी तक कोई सदस्य नहीं';

  @override
  String get familySettingsKeeperBadge => 'कीपर';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String recipeCardServings(int count) {
    return '$count सर्विंग';
  }

  @override
  String get styledSnackbarDismiss => 'खारिज करें';

  @override
  String get celebrationTitle => 'उत्सव मुख्यालय';

  @override
  String get celebrationNextUp => ' — अगला: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'दिन',
      one: 'दिन',
    );
    return '$emoji $name $days $_temp0 में';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'दिन',
      one: 'दिन',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'रेसिपीज़',
      one: 'रेसिपी',
    );
    return '$days $_temp0 बाकी  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes मिनट';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count सर्विंग';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return '$name द्वारा';
  }

  @override
  String get familyPromptTitle => 'किसी परिवार में शामिल हों या बनाएं';

  @override
  String get familyPromptSubtitle =>
      'अपने परिवार के सदस्यों के साथ रेसिपीज़ साझा करना शुरू करें';

  @override
  String get familyPromptJoinButton => 'परिवार में शामिल हों';

  @override
  String get familyPromptCreateButton => 'परिवार बनाएं';

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
