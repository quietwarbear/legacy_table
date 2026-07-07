// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsLanguage => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsCouldNotOpenDeleteAccount =>
      'Could not open delete account page';

  @override
  String get settingsFailedToLoadMembers => 'Failed to load family members';

  @override
  String get settingsInviteCodeCopied => 'Invite code copied!';

  @override
  String settingsShareInviteJoin(String name) {
    return 'Join my family \"$name\" on Legacy Table!';
  }

  @override
  String settingsShareInviteCode(String code) {
    return 'Invite Code: $code';
  }

  @override
  String get settingsLeaveFamily => 'Leave Family';

  @override
  String settingsLeaveFamilyConfirm(String name) {
    return 'Are you sure you want to leave \"$name\"? You will need an invite code to rejoin.';
  }

  @override
  String get settingsCancel => 'Cancel';

  @override
  String get settingsLeave => 'Leave';

  @override
  String get settingsLeftFamilySuccess => 'Successfully left family';

  @override
  String get settingsFailedToLeaveFamily => 'Failed to leave family';

  @override
  String get settingsMustTransferBeforeLeaving =>
      'You must transfer the keeper role before leaving';

  @override
  String get settingsTransferKeeperRole => 'Transfer Keeper Role';

  @override
  String get settingsTransferKeeperPrompt =>
      'As the keeper, you must transfer your role to another member before leaving. Select a member to become the new keeper:';

  @override
  String settingsKeeperTransferredTo(String name) {
    return 'Keeper role transferred to $name';
  }

  @override
  String get settingsLeaveFamilyQuestion => 'Leave Family?';

  @override
  String get settingsTransferSuccessLeavePrompt =>
      'You have successfully transferred the keeper role. Would you like to leave the family now?';

  @override
  String get settingsStay => 'Stay';

  @override
  String get settingsFailedToTransferKeeper => 'Failed to transfer keeper role';

  @override
  String get settingsRemoveMember => 'Remove Member';

  @override
  String settingsRemoveMemberConfirm(String name, String family) {
    return 'Are you sure you want to remove \"$name\" from \"$family\"? They will need an invite code to rejoin.';
  }

  @override
  String get settingsRemove => 'Remove';

  @override
  String settingsMemberRemoved(String name) {
    return '$name has been removed from the family';
  }

  @override
  String get settingsFailedToRemoveMember => 'Failed to remove member';

  @override
  String get settingsManageSubscription => 'Manage Subscription';

  @override
  String get settingsUpgradeToPremium => 'Upgrade to Premium';

  @override
  String get settingsLegacyCollectionActive => 'Legacy Collection is active';

  @override
  String get settingsHeritageKeeperActive => 'Heritage Keeper is active';

  @override
  String get settingsUnlockPremiumFeatures =>
      'Unlock family plans, exports, and premium features';

  @override
  String get settingsKeeperBadge => 'Keeper';

  @override
  String get settingsMemberBadge => 'Member';

  @override
  String get settingsInviteCodeLabel => 'Invite Code';

  @override
  String get settingsShareInviteCodeButton => 'Share Invite Code';

  @override
  String get settingsFamilyMembers => 'Family Members';

  @override
  String get settingsNoMembersFound => 'No members found';

  @override
  String get settingsRemoveMemberTooltip => 'Remove member';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsLightMode => 'Light Mode';

  @override
  String get settingsEditProfile => 'Edit Profile';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsTermsOfUse => 'Terms of Use';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutVersion => 'Legacy Table Family Recipes v2.0.0';

  @override
  String get settingsLegalese =>
      '© 2026 Ubuntu Market LLC. All rights reserved.';

  @override
  String get settingsLogout => 'Logout';

  @override
  String get settingsLogoutConfirm => 'Are you sure you want to logout?';

  @override
  String get recipeDetailLoadRecipeError =>
      'Failed to load recipe. Please try again.';

  @override
  String get recipeDetailLoadCommentsError =>
      'Failed to load comments. Please try again.';

  @override
  String get recipeDetailLoginToComment => 'Please log in to post a comment';

  @override
  String get recipeDetailCommentPosted => 'Comment posted successfully!';

  @override
  String get recipeDetailPostCommentError => 'Failed to post comment';

  @override
  String recipeDetailPostCommentErrorDetail(String error) {
    return 'Failed to post comment: $error';
  }

  @override
  String get recipeDetailDeleteCommentTitle => 'Delete Comment';

  @override
  String get recipeDetailDeleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get recipeDetailCancel => 'Cancel';

  @override
  String get recipeDetailDelete => 'Delete';

  @override
  String get recipeDetailCommentDeleted => 'Comment deleted successfully';

  @override
  String get recipeDetailDeleteCommentError => 'Failed to delete comment';

  @override
  String recipeDetailDeleteCommentErrorDetail(String error) {
    return 'Failed to delete comment: $error';
  }

  @override
  String get recipeDetailRecipeUpdated => 'Recipe updated successfully!';

  @override
  String get recipeDetailDeleteRecipeTitle => 'Delete Recipe';

  @override
  String recipeDetailDeleteRecipeConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"? This action cannot be undone.';
  }

  @override
  String get recipeDetailRecipeDeleted => 'Recipe deleted successfully';

  @override
  String get recipeDetailDeleteRecipeError => 'Failed to delete recipe';

  @override
  String recipeDetailDeleteRecipeErrorDetail(String error) {
    return 'Failed to delete recipe: $error';
  }

  @override
  String get recipeDetailNotFound => 'Recipe not found';

  @override
  String get recipeDetailSharedByLabel => 'Shared by';

  @override
  String get recipeDetailUnknownAuthor => 'Unknown';

  @override
  String get recipeDetailEdit => 'Edit';

  @override
  String get recipeDetailStatTime => 'Time';

  @override
  String recipeDetailStatTimeValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get recipeDetailStatServes => 'Serves';

  @override
  String get recipeDetailStatCategory => 'Category';

  @override
  String get recipeDetailIngredients => 'Ingredients';

  @override
  String get recipeDetailInstructions => 'Instructions';

  @override
  String get recipeDetailStoryTitle => 'The Story Behind This Recipe';

  @override
  String recipeDetailStorySharedBy(String author) {
    return 'Shared by $author';
  }

  @override
  String get recipeDetailFamilyComments => 'Family Comments';

  @override
  String get recipeDetailRefreshComments => 'Refresh comments';

  @override
  String get recipeDetailCommentHint =>
      'Share your thoughts about this recipe...';

  @override
  String get recipeDetailClear => 'Clear';

  @override
  String get recipeDetailPosting => 'Posting...';

  @override
  String get recipeDetailPost => 'Post';

  @override
  String get recipeDetailNoComments => 'No comments yet';

  @override
  String get recipeDetailBeFirstToComment =>
      'Be the first to share your thoughts!';

  @override
  String get recipeDetailNoImage => 'No image available';

  @override
  String get recipeDetailDeleteCommentTooltip => 'Delete comment';

  @override
  String get addRecipePhotoPermissionTitle => 'Photo Library Permission';

  @override
  String get addRecipePhotoPermissionAndroidMessage =>
      'Photo library permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Go to \"Permissions\"\n3. Enable \"Photos and videos\"';

  @override
  String get addRecipeStoragePermissionTitle => 'Storage Permission';

  @override
  String get addRecipeStoragePermissionMessage =>
      'Storage permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Go to \"Permissions\"\n3. Enable \"Storage\" or \"Files and media\"';

  @override
  String get addRecipePhotoPermissionIosMessage =>
      'Photo library permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Find \"Legacy Table\"\n3. Tap \"Photos\"\n4. Select \"All Photos\" or \"Selected Photos\"';

  @override
  String get addRecipeCameraPermissionTitle => 'Camera Permission';

  @override
  String get addRecipeCameraPermissionDeniedMessage =>
      'Camera permission is permanently denied. Please enable it from app settings.';

  @override
  String get addRecipeCameraPermissionRequired =>
      'Camera permission is required to take photos';

  @override
  String get addRecipeCancel => 'Cancel';

  @override
  String get addRecipeSettingsHintAndroid =>
      'Look for \"Photos and videos\" or \"Media\" permission in App Settings';

  @override
  String get addRecipeSettingsHintIos =>
      'Look for \"Photos\" permission in App Settings';

  @override
  String get addRecipeOpenSettings => 'Open Settings';

  @override
  String get addRecipeImageSelectError =>
      'Couldn\'t select images. Please try again.';

  @override
  String get addRecipeTakePhotoError =>
      'Couldn\'t take photo. Please try again.';

  @override
  String get addRecipeSelectCategoryWarning => 'Please select a category';

  @override
  String get addRecipeAddIngredientWarning =>
      'Please add at least one ingredient';

  @override
  String get addRecipeUpdatingRecipe => 'Updating recipe...';

  @override
  String get addRecipeSharingRecipe => 'Sharing recipe...';

  @override
  String addRecipeImageTooLarge(String fileName) {
    return 'Image \"$fileName\" is too large. Maximum size is 5MB.';
  }

  @override
  String get addRecipeProcessImagesError =>
      'Failed to process images. Please try selecting different images.';

  @override
  String get addRecipeUpdateSuccess => 'Recipe updated successfully!';

  @override
  String get addRecipeShareSuccess => 'Recipe shared successfully!';

  @override
  String get addRecipeEditTitle => 'Edit Recipe';

  @override
  String get addRecipeShareTitle => 'Share a Recipe';

  @override
  String get addRecipeEditSubtitle => 'Update your recipe details';

  @override
  String get addRecipeShareSubtitle =>
      'Add a new dish to the family collection';

  @override
  String get addRecipePhotosLabel => 'PHOTOS';

  @override
  String get addRecipeTitleLabel => 'RECIPE TITLE *';

  @override
  String get addRecipeTitlePlaceholder =>
      'e.g., Grandma\'s Special Jollof Rice';

  @override
  String get addRecipeTitleRequired => 'Recipe title is required';

  @override
  String get addRecipeCategoryLabel => 'CATEGORY *';

  @override
  String get addRecipeCategoryPlaceholder => 'Select category';

  @override
  String get addRecipeCategoryRequired => 'Category is required';

  @override
  String get addRecipeDifficultyLabel => 'DIFFICULTY';

  @override
  String get addRecipeDifficultyPlaceholder => 'Select difficulty';

  @override
  String get addRecipeCookingTimeLabel => 'COOKING TIME\n(MINUTES)';

  @override
  String get addRecipeServingsLabel => '\nSERVINGS';

  @override
  String get addRecipeIngredientsLabel => 'INGREDIENTS *';

  @override
  String addRecipeIngredientPlaceholder(int number) {
    return 'Ingredient $number';
  }

  @override
  String get addRecipeIngredientRequired => 'Ingredient is required';

  @override
  String get addRecipeAddIngredient => 'Add ingredient';

  @override
  String get addRecipeInstructionsLabel => 'INSTRUCTIONS *';

  @override
  String get addRecipeInstructionsPlaceholder =>
      'Write the step-by-step cooking instructions...';

  @override
  String get addRecipeInstructionsRequired => 'Instructions are required';

  @override
  String get addRecipeStoryLabel => 'THE STORY BEHIND THIS RECIPE (optional)';

  @override
  String get addRecipeStoryDescription =>
      'Share the story of this recipe... Where did it come from? Who passed it down? What memories does it hold for your family?';

  @override
  String get addRecipeStoryPlaceholder =>
      'Tell us about the history, traditions, or special memories connected to this dish.';

  @override
  String get addRecipeUpdateButton => 'Update Recipe';

  @override
  String get addRecipeShareButton => 'Share Recipe';

  @override
  String get addRecipeErrorTitle => 'Something went wrong';

  @override
  String get addRecipeErrorMessage => 'Please try again or restart the app.';

  @override
  String get addRecipeGoBack => 'Go Back';

  @override
  String get addRecipeUploadFromGallery => 'Upload from gallery';

  @override
  String get addRecipeTakePhoto => 'Take Photo';

  @override
  String get subscriptionNotNow => 'Not now';

  @override
  String get subscriptionRestoring => 'Restoring…';

  @override
  String get subscriptionRestore => 'Restore';

  @override
  String get subscriptionHeaderTitle => 'Preserve Your\nFamily Legacy';

  @override
  String get subscriptionHeaderSubtitle =>
      'Unlock premium features to keep your family\'s\nrecipes alive for generations.';

  @override
  String get subscriptionTierHeritageName => 'Heritage Keeper';

  @override
  String get subscriptionTierHeritageTagline => 'Perfect for getting started';

  @override
  String get subscriptionTierLegacyName => 'Legacy Collection';

  @override
  String get subscriptionTierLegacyTagline => 'The complete family experience';

  @override
  String get subscriptionFeatureUnlimitedStorage =>
      'Unlimited family recipe storage';

  @override
  String get subscriptionFeatureFamilySharing =>
      'Family sharing (up to 10 members)';

  @override
  String get subscriptionFeaturePhotoUploads =>
      'Photo uploads for every recipe';

  @override
  String get subscriptionFeatureExportPrint => 'Export & print recipe books';

  @override
  String get subscriptionFeatureCategoriesTags => 'Recipe categories & tags';

  @override
  String get subscriptionFeatureEverythingHeritage =>
      'Everything in Heritage Keeper';

  @override
  String get subscriptionFeatureUnlimitedMembers => 'Unlimited family members';

  @override
  String get subscriptionFeatureAdvancedOrganization =>
      'Advanced recipe organization';

  @override
  String get subscriptionFeaturePrioritySupport => 'Priority customer support';

  @override
  String get subscriptionFeatureEarlyAccess => 'Early access to new features';

  @override
  String get subscriptionFeatureCustomThemes => 'Custom family cookbook themes';

  @override
  String get subscriptionAutoRenewNotice =>
      'Subscriptions auto-renew until cancelled. Cancel anytime in your device settings.';

  @override
  String get subscriptionTermsOfUse => 'Terms of Use';

  @override
  String get subscriptionPrivacyPolicy => 'Privacy Policy';

  @override
  String get subscriptionMostPopular => 'MOST POPULAR';

  @override
  String get subscriptionPerYear => '/year';

  @override
  String get subscriptionPerMonth => '/month';

  @override
  String subscriptionPerMonthEquivalent(String price) {
    return '$price/mo';
  }

  @override
  String subscriptionGetPlanCta(String tierName, String price) {
    return 'Get $tierName — $price';
  }

  @override
  String get subscriptionErrorLoadPlans =>
      'Unable to load subscription plans. Please check your internet connection and try again.';

  @override
  String get subscriptionErrorNoPlansAvailable =>
      'No subscription plans are available right now. Please check RevenueCat and App Store Connect configuration.';

  @override
  String get subscriptionErrorAnnualUnavailable =>
      'Annual pricing is not available for this plan yet.';

  @override
  String get subscriptionErrorMonthlyUnavailable =>
      'Monthly pricing is not available for this plan yet.';

  @override
  String get subscriptionWelcomePremium => 'Welcome to Legacy Table Premium!';

  @override
  String get subscriptionRestoreSuccess => 'Purchases restored successfully!';

  @override
  String get subscriptionRestoreNoneFound => 'No previous purchases found.';

  @override
  String get recipeFeedNotificationsTooltip => 'Notifications';

  @override
  String get recipeFeedSubheading => 'Family Recipes';

  @override
  String get recipeFeedTagline =>
      'Preserve and share our family\'s culinary traditions with love';

  @override
  String get recipeFeedShareRecipe => 'Share a Recipe';

  @override
  String get recipeFeedFamilyCookbook => 'Family Cookbook';

  @override
  String get recipeFeedScanRecipe => 'Scan a Recipe';

  @override
  String get recipeFeedVoiceRecipe => 'Voice a Recipe';

  @override
  String get recipeFeedComingSoon => 'Coming soon';

  @override
  String get recipeFeedSaveFromLink => 'Save from Link';

  @override
  String recipeFeedLoadError(String error) {
    return 'Failed to load recipes: $error';
  }

  @override
  String get recipeFeedSearchHint =>
      'Search recipes, ingredients, or categories...';

  @override
  String get recipeFeedCategoryAll => 'All';

  @override
  String get recipeFeedEmptyNoResultsTitle => 'No recipes found';

  @override
  String get recipeFeedEmptyNoRecipesTitle => 'No recipes yet';

  @override
  String get recipeFeedEmptyNoResultsBody =>
      'Try adjusting your search or browse all recipes';

  @override
  String get recipeFeedEmptyNoRecipesBody =>
      'Share your first family recipe and start building your collection!';

  @override
  String get recipeFeedClearSearch => 'Clear Search';

  @override
  String get recipeFeedSmartToolsTitle => 'Smart Recipe Tools';

  @override
  String get recipeFeedSmartToolsSubtitle =>
      'Bring recipes in the same way the web app does: scan a card or turn a video link into a draft.';

  @override
  String get recipeFeedFeatureScanTitle => 'Scan Recipe';

  @override
  String get recipeFeedFeatureScanDescription =>
      'Use a photo of a handwritten card or cookbook page.';

  @override
  String get recipeFeedFeatureLinkTitle => 'Save From Link';

  @override
  String get recipeFeedFeatureLinkDescription =>
      'Turn a TikTok, Instagram, or YouTube link into a draft.';

  @override
  String get recipeFeedCelebrationHeadquarters => 'Celebration Headquarters';

  @override
  String recipeFeedSeasonTheme(String season, String theme) {
    return '$season season • $theme';
  }

  @override
  String recipeFeedDaysAway(int days) {
    return '$days days away';
  }

  @override
  String recipeFeedRecipeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recipes',
      one: '1 recipe',
    );
    return '$_temp0';
  }

  @override
  String get profileSettingsLoginRequired =>
      'Please log in to access profile settings';

  @override
  String get profileSettingsLoadFailed =>
      'Failed to load user data. Please try again.';

  @override
  String get profileSettingsPhotoSourceTitle => 'Select Photo Source';

  @override
  String get profileSettingsCamera => 'Camera';

  @override
  String get profileSettingsGallery => 'Gallery';

  @override
  String get profileSettingsCancel => 'Cancel';

  @override
  String get profileSettingsCameraPermissionRequired =>
      'Camera permission is required to take a photo';

  @override
  String get profileSettingsPickImageFailed =>
      'Failed to pick image. Please try again.';

  @override
  String get profileSettingsUpdateSuccess => 'Profile updated successfully';

  @override
  String get profileSettingsUpdateFailed => 'Failed to update profile';

  @override
  String get profileSettingsTitle => 'Profile Settings';

  @override
  String get profileSettingsSubtitle =>
      'Customize how you appear to the family';

  @override
  String get profileSettingsProfilePicture => 'Profile Picture';

  @override
  String get profileSettingsUploadPhotoHint =>
      'Upload a photo to personalize your profile';

  @override
  String get profileSettingsDisplayName => 'Display Name';

  @override
  String get profileSettingsFullName => 'Full Name';

  @override
  String get profileSettingsNicknameLabel => 'Nickname (optional)';

  @override
  String get profileSettingsNicknameHint => 'Enter a nickname...';

  @override
  String get profileSettingsNicknameHelper =>
      'Your nickname will be shown instead of your full name on recipes and comments.';

  @override
  String get profileSettingsAccountInformation => 'Account Information';

  @override
  String get profileSettingsEmail => 'Email';

  @override
  String get profileSettingsMemberSince => 'Member Since';

  @override
  String get profileSettingsSaveButton => 'Save Changes';

  @override
  String get cookbookLoadError => 'Failed to load recipes. Please try again.';

  @override
  String get cookbookSelectAtLeastOne => 'Please select at least one recipe';

  @override
  String get cookbookGeneratingPdf => 'Generating PDF...';

  @override
  String get cookbookGeneratePdfError => 'Failed to generate PDF';

  @override
  String get cookbookPdfGeneratedTitle => 'PDF Generated Successfully!';

  @override
  String cookbookPdfReadyMessage(int recipeCount) {
    String _temp0 = intl.Intl.pluralLogic(
      recipeCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Your cookbook with $recipeCount recipe$_temp0 is ready. What would you like to do?';
  }

  @override
  String get cookbookSaveToDevice => 'Save to Device';

  @override
  String get cookbookShare => 'Share';

  @override
  String get cookbookPreviewPrint => 'Preview/Print';

  @override
  String get cookbookCancel => 'Cancel';

  @override
  String get cookbookSavingPdf => 'Saving PDF...';

  @override
  String get cookbookPdfSavedSuccess =>
      'PDF saved successfully to Downloads folder!';

  @override
  String get cookbookPdfSharedSuccess => 'PDF shared successfully!';

  @override
  String get cookbookSavePdfError => 'Failed to save PDF';

  @override
  String get cookbookSharePdfError => 'Failed to share PDF';

  @override
  String get cookbookPreviewPdfError => 'Failed to preview PDF';

  @override
  String get cookbookTitle => 'Family Cookbook';

  @override
  String get cookbookSubtitle =>
      'Select recipes to create a printable PDF cookbook';

  @override
  String get cookbookClear => 'Clear';

  @override
  String cookbookRecipesSelected(int selectedCount) {
    String _temp0 = intl.Intl.pluralLogic(
      selectedCount,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$selectedCount recipe$_temp0 selected';
  }

  @override
  String get cookbookReadyToCreate => 'Ready to create your cookbook';

  @override
  String get cookbookExportButton => 'Export PDF Cookbook';

  @override
  String get cookbookNoRecipesTitle => 'No recipes yet';

  @override
  String get cookbookNoRecipesSubtitle => 'Add recipes to create your cookbook';

  @override
  String get createFamilyAppBarTitle => 'Create Family';

  @override
  String get createFamilyHeading => 'Create a Family';

  @override
  String get createFamilySubtitle =>
      'Start sharing recipes with your family members';

  @override
  String get createFamilyNameLabel => 'FAMILY NAME';

  @override
  String get createFamilyNameHint => 'e.g., Smith Family';

  @override
  String get createFamilyNameRequired => 'Please enter a family name';

  @override
  String get createFamilyNameTooShort =>
      'Family name must be at least 2 characters';

  @override
  String get createFamilyNameTooLong =>
      'Family name must be 50 characters or less';

  @override
  String get createFamilyDescriptionLabel => 'DESCRIPTION (OPTIONAL)';

  @override
  String get createFamilyDescriptionHint => 'Tell us about your family...';

  @override
  String get createFamilyDescriptionTooLong =>
      'Description must be 500 characters or less';

  @override
  String get createFamilySubmitButton => 'Create Family';

  @override
  String get createFamilyKeeperInfo =>
      'You will become the family keeper and can invite others';

  @override
  String get createFamilyErrorGeneric => 'Failed to create family';

  @override
  String get createFamilyErrorAlreadyMember =>
      'You are already part of a family.';

  @override
  String get createFamilySuccessTitle => 'Family Created!';

  @override
  String get createFamilyInviteCodeLabel => 'Invite Code';

  @override
  String get createFamilyInviteCodeCopied => 'Invite code copied!';

  @override
  String get createFamilyShareCodeHint =>
      'Share this code with family members to invite them';

  @override
  String get createFamilyShareInviteButton => 'Share Invite';

  @override
  String get createFamilyDoneButton => 'Done';

  @override
  String get loginSubtitle => 'Share your culinary heritage';

  @override
  String get loginEmailLabel => 'EMAIL';

  @override
  String get loginEmailHint => 'Enter your email';

  @override
  String get loginEmailRequired => 'Please enter your email';

  @override
  String get loginEmailInvalid => 'Please enter a valid email';

  @override
  String get loginPasswordLabel => 'PASSWORD';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginPasswordRequired => 'Please enter your password';

  @override
  String get loginPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginSignInButton => 'Sign In';

  @override
  String get loginOrDivider => 'or';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginContinueWithApple => 'Continue with Apple';

  @override
  String get loginContinueWithFacebook => 'Continue with Facebook';

  @override
  String get loginNewToFamily => 'New to the family? ';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get voiceRecipeMicPermissionRequired =>
      'Microphone permission is required to record a recipe';

  @override
  String voiceRecipeFailedToStart(String error) {
    return 'Failed to start recording: $error';
  }

  @override
  String voiceRecipeFailedToStop(String error) {
    return 'Failed to stop recording: $error';
  }

  @override
  String get voiceRecipeFileNotFound => 'Recording file not found';

  @override
  String voiceRecipeTranscribedCredits(int credits) {
    return 'Recipe transcribed! $credits credits remaining.';
  }

  @override
  String get voiceRecipeTitle => 'Voice Recipe';

  @override
  String get voiceRecipeIntro =>
      'Tell us your recipe out loud — we\'ll transcribe it and turn it into a structured draft.';

  @override
  String get voiceRecipeUsesCredits => 'Uses 2 AI credits';

  @override
  String get voiceRecipeTapToStop => 'Tap the button to stop';

  @override
  String voiceRecipeRecordingDuration(String duration) {
    return 'Recording: $duration';
  }

  @override
  String get voiceRecipeReadyToTranscribe => 'Ready to transcribe';

  @override
  String get voiceRecipeTapToStart => 'Tap to start recording';

  @override
  String get voiceRecipeSpeakNaturally =>
      'Speak your recipe naturally — include ingredients, amounts, and steps.';

  @override
  String get voiceRecipeTipsTitle => 'Tips for best results';

  @override
  String get voiceRecipeTipsBody =>
      '• Start with the recipe name\n• List each ingredient with amounts\n• Describe the steps in order\n• Mention cooking time and servings';

  @override
  String get voiceRecipeTranscribing => 'Transcribing with AI...';

  @override
  String get voiceRecipeTranscribeIntoDraft => 'Transcribe Into Draft';

  @override
  String get voiceRecipeRecordAgain => 'Record Again';

  @override
  String get registerSubtitle => 'Share your culinary heritage';

  @override
  String get registerNameLabel => 'NAME';

  @override
  String get registerNameHint => 'Enter your name';

  @override
  String get registerNameRequired => 'Please enter your name';

  @override
  String get registerEmailLabel => 'EMAIL';

  @override
  String get registerEmailHint => 'Enter your email';

  @override
  String get registerEmailRequired => 'Please enter your email';

  @override
  String get registerEmailInvalid => 'Please enter a valid email';

  @override
  String get registerNicknameLabel => 'NICKNAME (OPTIONAL)';

  @override
  String get registerNicknameHint => 'Enter your nickname (optional)';

  @override
  String get registerNicknameTooLong =>
      'Nickname must be 30 characters or less';

  @override
  String get registerPasswordLabel => 'PASSWORD';

  @override
  String get registerPasswordHint => 'Enter your password';

  @override
  String get registerPasswordRequired => 'Please enter your password';

  @override
  String get registerPasswordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get registerCreateAccountButton => 'Create Account';

  @override
  String get registerAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get registerSignInLink => 'Sign in';

  @override
  String get registerRegistrationFailed => 'Registration failed';

  @override
  String get scanRecipeCameraPermission =>
      'Camera permission is required to scan a recipe';

  @override
  String scanRecipeScannedSuccess(int credits) {
    return 'Recipe scanned! $credits credits remaining.';
  }

  @override
  String get scanRecipeTitle => 'Scan Recipe';

  @override
  String get scanRecipeIntro =>
      'Turn a handwritten card or cookbook page into an editable recipe draft.';

  @override
  String get scanRecipeCreditCost => 'Uses 1 AI credit';

  @override
  String get scanRecipeEmptyTitle => 'Add a recipe photo to scan';

  @override
  String get scanRecipeEmptyHint =>
      'Best results come from a clear, well-lit photo with the full recipe visible.';

  @override
  String get scanRecipeChoosePhoto => 'Choose Photo';

  @override
  String get scanRecipeTakePhoto => 'Take Photo';

  @override
  String get scanRecipeScanning => 'Scanning with AI...';

  @override
  String get scanRecipeScanButton => 'Scan Into Draft';

  @override
  String get notificationsLoadError =>
      'Failed to load notifications. Please try again.';

  @override
  String get notificationsAllMarkedRead => 'All notifications marked as read';

  @override
  String get notificationsMarkAllError =>
      'Failed to mark all as read. Please try again.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllButton => 'Mark all as read';

  @override
  String get notificationsEmptyTitle => 'No notifications';

  @override
  String get notificationsEmptySubtitle => 'You\'re all caught up!';

  @override
  String get joinFamilyAppBarTitle => 'Join Family';

  @override
  String get joinFamilyHeading => 'Join a Family';

  @override
  String get joinFamilySubtitle =>
      'Enter the 8-character invite code from your family keeper';

  @override
  String get joinFamilyInviteCodeLabel => 'INVITE CODE';

  @override
  String get joinFamilyButton => 'Join Family';

  @override
  String get joinFamilyInfoText => 'Ask your family keeper for the invite code';

  @override
  String get joinFamilyEmptyCodeError => 'Please enter an invite code';

  @override
  String get joinFamilyCodeLengthError => 'Invite code must be 8 characters';

  @override
  String get joinFamilyGenericError => 'Failed to join family';

  @override
  String get joinFamilyInvalidCodeError =>
      'Invalid invite code. Please check and try again.';

  @override
  String get joinFamilyAlreadyMemberError =>
      'You are already part of a family.';

  @override
  String joinFamilySuccess(String familyName) {
    return 'Successfully joined $familyName!';
  }

  @override
  String get saveFromLinkEmptyUrlWarning =>
      'Paste a cooking video or recipe link first';

  @override
  String get saveFromLinkInvalidUrlWarning =>
      'Please enter a valid URL starting with http:// or https://';

  @override
  String saveFromLinkImportSuccess(int creditsRemaining) {
    return 'Recipe imported! $creditsRemaining credits remaining.';
  }

  @override
  String get saveFromLinkAppBarTitle => 'Save From Link';

  @override
  String get saveFromLinkIntro =>
      'Paste a TikTok, Instagram, YouTube, or recipe link and turn it into a shareable Legacy Table draft.';

  @override
  String get saveFromLinkCreditCost => 'Uses 1 AI credit';

  @override
  String get saveFromLinkDraftInfo =>
      'The imported recipe opens as a draft first, so you can clean up ingredients, adjust instructions, and add your own story before sharing it.';

  @override
  String get saveFromLinkImportingLabel => 'Importing with AI...';

  @override
  String get saveFromLinkCreateDraftButton => 'Create Draft From Link';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get onboardingGetStartedButton => 'Get Started';

  @override
  String get homeUpgradeFab => 'Upgrade';

  @override
  String get homeShareRecipeFab => 'Share a Recipe';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavCookbook => 'Cookbook';

  @override
  String get homeNavMyRecipes => 'My Recipes';

  @override
  String get homeNavFamily => 'Family';

  @override
  String get homeNavSettings => 'Settings';

  @override
  String get homeTierLegacyCollection => 'Legacy Collection';

  @override
  String get homeTierHeritageKeeper => 'Heritage Keeper';

  @override
  String get homeSubscriptionActive => 'Premium plan active';

  @override
  String get homeSubscriptionUnlock => 'Unlock premium family features';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileNoRecipesTitle => 'No recipes yet';

  @override
  String get profileNoRecipesSubtitle => 'Share your first family recipe!';

  @override
  String profileLoadRecipesError(String error) {
    return 'Failed to load recipes: $error';
  }

  @override
  String holidayRecipesEmptyTitle(String holidayName) {
    return 'No recipes tagged for $holidayName yet';
  }

  @override
  String get holidayRecipesEmptyBody =>
      'Tag a family favorite for this holiday from the web app or upcoming mobile detail enhancements.';

  @override
  String get shareInviteTitle => 'Share Invite';

  @override
  String get shareInviteLinkTab => 'Link';

  @override
  String get shareInviteCodeTab => 'Code';

  @override
  String get shareInviteLinkHint => 'Opens the app or shows download options';

  @override
  String get shareInviteCodeHint => 'Recipient enters this code in the app';

  @override
  String get shareInviteCopiedSnackbar => 'Copied!';

  @override
  String get shareInviteCopyButton => 'Copy';

  @override
  String get shareInviteShareButton => 'Share';

  @override
  String get familySettingsInviteCodeCopied => 'Invite code copied!';

  @override
  String get familySettingsFamilyHeading => 'Family';

  @override
  String get familySettingsJoinOrCreateSubtitle =>
      'Join or create a family to start sharing recipes';

  @override
  String get familySettingsNoFamilyYet => 'No family yet';

  @override
  String get familySettingsStartSharingRecipes =>
      'Start sharing recipes with your family members';

  @override
  String get familySettingsJoinFamilyButton => 'Join Family';

  @override
  String get familySettingsCreateFamilyButton => 'Create Family';

  @override
  String get familySettingsTitle => 'Family settings';

  @override
  String get familySettingsManageSubtitle =>
      'Manage your family and invite code.';

  @override
  String get familySettingsInviteCodeLabel => 'Invite code';

  @override
  String get familySettingsCopyButton => 'Copy';

  @override
  String get familySettingsShareCodeHelper =>
      'Share this code so others can join your family.';

  @override
  String get familySettingsMembersLabel => 'Members';

  @override
  String get familySettingsNoMembersYet => 'No members yet';

  @override
  String get familySettingsKeeperBadge => 'Keeper';

  @override
  String recipeCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeCardServings(int count) {
    return '$count servings';
  }

  @override
  String get styledSnackbarDismiss => 'Dismiss';

  @override
  String get celebrationTitle => 'Celebration Headquarters';

  @override
  String get celebrationNextUp => ' — Next up: ';

  @override
  String celebrationNextHoliday(String emoji, String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$emoji $name in $days $_temp0';
  }

  @override
  String celebrationHolidayCardSubtitle(int days, int recipes) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      recipes,
      locale: localeName,
      other: 'recipes',
      one: 'recipe',
    );
    return '$days $_temp0 away  •  $recipes $_temp1';
  }

  @override
  String cookbookCardCookingTime(int minutes) {
    return '$minutes min';
  }

  @override
  String cookbookCardServings(int count) {
    return '$count servings';
  }

  @override
  String cookbookCardByAuthor(String name) {
    return 'by $name';
  }

  @override
  String get familyPromptTitle => 'Join or Create a Family';

  @override
  String get familyPromptSubtitle =>
      'Start sharing recipes with your family members';

  @override
  String get familyPromptJoinButton => 'Join Family';

  @override
  String get familyPromptCreateButton => 'Create Family';

  @override
  String get familyPromptSampleButton =>
      'Just exploring? Try a sample cookbook';

  @override
  String get familyPromptSampleSuccess =>
      'Welcome! We\'ve added a few sample recipes to get you started.';

  @override
  String get familyPromptSampleFailed =>
      'Couldn\'t create the sample cookbook. Please try again.';
}
