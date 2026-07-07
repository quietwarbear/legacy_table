import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_yo.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('pa'),
    Locale('pt'),
    Locale('ur'),
    Locale('yo'),
  ];

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsCouldNotOpenDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Could not open delete account page'**
  String get settingsCouldNotOpenDeleteAccount;

  /// No description provided for @settingsFailedToLoadMembers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load family members'**
  String get settingsFailedToLoadMembers;

  /// No description provided for @settingsInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied!'**
  String get settingsInviteCodeCopied;

  /// No description provided for @settingsShareInviteJoin.
  ///
  /// In en, this message translates to:
  /// **'Join my family \"{name}\" on Legacy Table!'**
  String settingsShareInviteJoin(String name);

  /// No description provided for @settingsShareInviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code: {code}'**
  String settingsShareInviteCode(String code);

  /// No description provided for @settingsLeaveFamily.
  ///
  /// In en, this message translates to:
  /// **'Leave Family'**
  String get settingsLeaveFamily;

  /// No description provided for @settingsLeaveFamilyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave \"{name}\"? You will need an invite code to rejoin.'**
  String settingsLeaveFamilyConfirm(String name);

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get settingsLeave;

  /// No description provided for @settingsLeftFamilySuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully left family'**
  String get settingsLeftFamilySuccess;

  /// No description provided for @settingsFailedToLeaveFamily.
  ///
  /// In en, this message translates to:
  /// **'Failed to leave family'**
  String get settingsFailedToLeaveFamily;

  /// No description provided for @settingsMustTransferBeforeLeaving.
  ///
  /// In en, this message translates to:
  /// **'You must transfer the keeper role before leaving'**
  String get settingsMustTransferBeforeLeaving;

  /// No description provided for @settingsTransferKeeperRole.
  ///
  /// In en, this message translates to:
  /// **'Transfer Keeper Role'**
  String get settingsTransferKeeperRole;

  /// No description provided for @settingsTransferKeeperPrompt.
  ///
  /// In en, this message translates to:
  /// **'As the keeper, you must transfer your role to another member before leaving. Select a member to become the new keeper:'**
  String get settingsTransferKeeperPrompt;

  /// No description provided for @settingsKeeperTransferredTo.
  ///
  /// In en, this message translates to:
  /// **'Keeper role transferred to {name}'**
  String settingsKeeperTransferredTo(String name);

  /// No description provided for @settingsLeaveFamilyQuestion.
  ///
  /// In en, this message translates to:
  /// **'Leave Family?'**
  String get settingsLeaveFamilyQuestion;

  /// No description provided for @settingsTransferSuccessLeavePrompt.
  ///
  /// In en, this message translates to:
  /// **'You have successfully transferred the keeper role. Would you like to leave the family now?'**
  String get settingsTransferSuccessLeavePrompt;

  /// No description provided for @settingsStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get settingsStay;

  /// No description provided for @settingsFailedToTransferKeeper.
  ///
  /// In en, this message translates to:
  /// **'Failed to transfer keeper role'**
  String get settingsFailedToTransferKeeper;

  /// No description provided for @settingsRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get settingsRemoveMember;

  /// No description provided for @settingsRemoveMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{name}\" from \"{family}\"? They will need an invite code to rejoin.'**
  String settingsRemoveMemberConfirm(String name, String family);

  /// No description provided for @settingsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get settingsRemove;

  /// No description provided for @settingsMemberRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} has been removed from the family'**
  String settingsMemberRemoved(String name);

  /// No description provided for @settingsFailedToRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove member'**
  String get settingsFailedToRemoveMember;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get settingsManageSubscription;

  /// No description provided for @settingsUpgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get settingsUpgradeToPremium;

  /// No description provided for @settingsLegacyCollectionActive.
  ///
  /// In en, this message translates to:
  /// **'Legacy Collection is active'**
  String get settingsLegacyCollectionActive;

  /// No description provided for @settingsHeritageKeeperActive.
  ///
  /// In en, this message translates to:
  /// **'Heritage Keeper is active'**
  String get settingsHeritageKeeperActive;

  /// No description provided for @settingsUnlockPremiumFeatures.
  ///
  /// In en, this message translates to:
  /// **'Unlock family plans, exports, and premium features'**
  String get settingsUnlockPremiumFeatures;

  /// No description provided for @settingsKeeperBadge.
  ///
  /// In en, this message translates to:
  /// **'Keeper'**
  String get settingsKeeperBadge;

  /// No description provided for @settingsMemberBadge.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get settingsMemberBadge;

  /// No description provided for @settingsInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get settingsInviteCodeLabel;

  /// No description provided for @settingsShareInviteCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Share Invite Code'**
  String get settingsShareInviteCodeButton;

  /// No description provided for @settingsFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get settingsFamilyMembers;

  /// No description provided for @settingsNoMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get settingsNoMembersFound;

  /// No description provided for @settingsRemoveMemberTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get settingsRemoveMemberTooltip;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// No description provided for @settingsLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// No description provided for @settingsEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get settingsEditProfile;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Legacy Table Family Recipes v2.0.0'**
  String get settingsAboutVersion;

  /// No description provided for @settingsLegalese.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Ubuntu Market LLC. All rights reserved.'**
  String get settingsLegalese;

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get settingsLogoutConfirm;

  /// No description provided for @recipeDetailLoadRecipeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipe. Please try again.'**
  String get recipeDetailLoadRecipeError;

  /// No description provided for @recipeDetailLoadCommentsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments. Please try again.'**
  String get recipeDetailLoadCommentsError;

  /// No description provided for @recipeDetailLoginToComment.
  ///
  /// In en, this message translates to:
  /// **'Please log in to post a comment'**
  String get recipeDetailLoginToComment;

  /// No description provided for @recipeDetailCommentPosted.
  ///
  /// In en, this message translates to:
  /// **'Comment posted successfully!'**
  String get recipeDetailCommentPosted;

  /// No description provided for @recipeDetailPostCommentError.
  ///
  /// In en, this message translates to:
  /// **'Failed to post comment'**
  String get recipeDetailPostCommentError;

  /// No description provided for @recipeDetailPostCommentErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Failed to post comment: {error}'**
  String recipeDetailPostCommentErrorDetail(String error);

  /// No description provided for @recipeDetailDeleteCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Comment'**
  String get recipeDetailDeleteCommentTitle;

  /// No description provided for @recipeDetailDeleteCommentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get recipeDetailDeleteCommentConfirm;

  /// No description provided for @recipeDetailCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recipeDetailCancel;

  /// No description provided for @recipeDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recipeDetailDelete;

  /// No description provided for @recipeDetailCommentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully'**
  String get recipeDetailCommentDeleted;

  /// No description provided for @recipeDetailDeleteCommentError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete comment'**
  String get recipeDetailDeleteCommentError;

  /// No description provided for @recipeDetailDeleteCommentErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete comment: {error}'**
  String recipeDetailDeleteCommentErrorDetail(String error);

  /// No description provided for @recipeDetailRecipeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recipe updated successfully!'**
  String get recipeDetailRecipeUpdated;

  /// No description provided for @recipeDetailDeleteRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Recipe'**
  String get recipeDetailDeleteRecipeTitle;

  /// No description provided for @recipeDetailDeleteRecipeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? This action cannot be undone.'**
  String recipeDetailDeleteRecipeConfirm(String title);

  /// No description provided for @recipeDetailRecipeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Recipe deleted successfully'**
  String get recipeDetailRecipeDeleted;

  /// No description provided for @recipeDetailDeleteRecipeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete recipe'**
  String get recipeDetailDeleteRecipeError;

  /// No description provided for @recipeDetailDeleteRecipeErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete recipe: {error}'**
  String recipeDetailDeleteRecipeErrorDetail(String error);

  /// No description provided for @recipeDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found'**
  String get recipeDetailNotFound;

  /// No description provided for @recipeDetailSharedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared by'**
  String get recipeDetailSharedByLabel;

  /// No description provided for @recipeDetailUnknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get recipeDetailUnknownAuthor;

  /// No description provided for @recipeDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get recipeDetailEdit;

  /// No description provided for @recipeDetailStatTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get recipeDetailStatTime;

  /// No description provided for @recipeDetailStatTimeValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeDetailStatTimeValue(int minutes);

  /// No description provided for @recipeDetailStatServes.
  ///
  /// In en, this message translates to:
  /// **'Serves'**
  String get recipeDetailStatServes;

  /// No description provided for @recipeDetailStatCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get recipeDetailStatCategory;

  /// No description provided for @recipeDetailIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeDetailIngredients;

  /// No description provided for @recipeDetailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get recipeDetailInstructions;

  /// No description provided for @recipeDetailStoryTitle.
  ///
  /// In en, this message translates to:
  /// **'The Story Behind This Recipe'**
  String get recipeDetailStoryTitle;

  /// No description provided for @recipeDetailStorySharedBy.
  ///
  /// In en, this message translates to:
  /// **'Shared by {author}'**
  String recipeDetailStorySharedBy(String author);

  /// No description provided for @recipeDetailFamilyComments.
  ///
  /// In en, this message translates to:
  /// **'Family Comments'**
  String get recipeDetailFamilyComments;

  /// No description provided for @recipeDetailRefreshComments.
  ///
  /// In en, this message translates to:
  /// **'Refresh comments'**
  String get recipeDetailRefreshComments;

  /// No description provided for @recipeDetailCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts about this recipe...'**
  String get recipeDetailCommentHint;

  /// No description provided for @recipeDetailClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get recipeDetailClear;

  /// No description provided for @recipeDetailPosting.
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get recipeDetailPosting;

  /// No description provided for @recipeDetailPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get recipeDetailPost;

  /// No description provided for @recipeDetailNoComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get recipeDetailNoComments;

  /// No description provided for @recipeDetailBeFirstToComment.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share your thoughts!'**
  String get recipeDetailBeFirstToComment;

  /// No description provided for @recipeDetailNoImage.
  ///
  /// In en, this message translates to:
  /// **'No image available'**
  String get recipeDetailNoImage;

  /// No description provided for @recipeDetailDeleteCommentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get recipeDetailDeleteCommentTooltip;

  /// No description provided for @addRecipePhotoPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Library Permission'**
  String get addRecipePhotoPermissionTitle;

  /// No description provided for @addRecipePhotoPermissionAndroidMessage.
  ///
  /// In en, this message translates to:
  /// **'Photo library permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Go to \"Permissions\"\n3. Enable \"Photos and videos\"'**
  String get addRecipePhotoPermissionAndroidMessage;

  /// No description provided for @addRecipeStoragePermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Storage Permission'**
  String get addRecipeStoragePermissionTitle;

  /// No description provided for @addRecipeStoragePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Go to \"Permissions\"\n3. Enable \"Storage\" or \"Files and media\"'**
  String get addRecipeStoragePermissionMessage;

  /// No description provided for @addRecipePhotoPermissionIosMessage.
  ///
  /// In en, this message translates to:
  /// **'Photo library permission is required to select images.\n\nTo enable:\n1. Tap \"Open Settings\"\n2. Find \"Legacy Table\"\n3. Tap \"Photos\"\n4. Select \"All Photos\" or \"Selected Photos\"'**
  String get addRecipePhotoPermissionIosMessage;

  /// No description provided for @addRecipeCameraPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission'**
  String get addRecipeCameraPermissionTitle;

  /// No description provided for @addRecipeCameraPermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is permanently denied. Please enable it from app settings.'**
  String get addRecipeCameraPermissionDeniedMessage;

  /// No description provided for @addRecipeCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take photos'**
  String get addRecipeCameraPermissionRequired;

  /// No description provided for @addRecipeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addRecipeCancel;

  /// No description provided for @addRecipeSettingsHintAndroid.
  ///
  /// In en, this message translates to:
  /// **'Look for \"Photos and videos\" or \"Media\" permission in App Settings'**
  String get addRecipeSettingsHintAndroid;

  /// No description provided for @addRecipeSettingsHintIos.
  ///
  /// In en, this message translates to:
  /// **'Look for \"Photos\" permission in App Settings'**
  String get addRecipeSettingsHintIos;

  /// No description provided for @addRecipeOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get addRecipeOpenSettings;

  /// No description provided for @addRecipeImageSelectError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t select images. Please try again.'**
  String get addRecipeImageSelectError;

  /// No description provided for @addRecipeTakePhotoError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t take photo. Please try again.'**
  String get addRecipeTakePhotoError;

  /// No description provided for @addRecipeSelectCategoryWarning.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get addRecipeSelectCategoryWarning;

  /// No description provided for @addRecipeAddIngredientWarning.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one ingredient'**
  String get addRecipeAddIngredientWarning;

  /// No description provided for @addRecipeUpdatingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Updating recipe...'**
  String get addRecipeUpdatingRecipe;

  /// No description provided for @addRecipeSharingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Sharing recipe...'**
  String get addRecipeSharingRecipe;

  /// No description provided for @addRecipeImageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image \"{fileName}\" is too large. Maximum size is 5MB.'**
  String addRecipeImageTooLarge(String fileName);

  /// No description provided for @addRecipeProcessImagesError.
  ///
  /// In en, this message translates to:
  /// **'Failed to process images. Please try selecting different images.'**
  String get addRecipeProcessImagesError;

  /// No description provided for @addRecipeUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe updated successfully!'**
  String get addRecipeUpdateSuccess;

  /// No description provided for @addRecipeShareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe shared successfully!'**
  String get addRecipeShareSuccess;

  /// No description provided for @addRecipeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get addRecipeEditTitle;

  /// No description provided for @addRecipeShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share a Recipe'**
  String get addRecipeShareTitle;

  /// No description provided for @addRecipeEditSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your recipe details'**
  String get addRecipeEditSubtitle;

  /// No description provided for @addRecipeShareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new dish to the family collection'**
  String get addRecipeShareSubtitle;

  /// No description provided for @addRecipePhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'PHOTOS'**
  String get addRecipePhotosLabel;

  /// No description provided for @addRecipeTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'RECIPE TITLE *'**
  String get addRecipeTitleLabel;

  /// No description provided for @addRecipeTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Grandma\'s Special Jollof Rice'**
  String get addRecipeTitlePlaceholder;

  /// No description provided for @addRecipeTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Recipe title is required'**
  String get addRecipeTitleRequired;

  /// No description provided for @addRecipeCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY *'**
  String get addRecipeCategoryLabel;

  /// No description provided for @addRecipeCategoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get addRecipeCategoryPlaceholder;

  /// No description provided for @addRecipeCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get addRecipeCategoryRequired;

  /// No description provided for @addRecipeDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULTY'**
  String get addRecipeDifficultyLabel;

  /// No description provided for @addRecipeDifficultyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select difficulty'**
  String get addRecipeDifficultyPlaceholder;

  /// No description provided for @addRecipeCookingTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'COOKING TIME\n(MINUTES)'**
  String get addRecipeCookingTimeLabel;

  /// No description provided for @addRecipeServingsLabel.
  ///
  /// In en, this message translates to:
  /// **'\nSERVINGS'**
  String get addRecipeServingsLabel;

  /// No description provided for @addRecipeIngredientsLabel.
  ///
  /// In en, this message translates to:
  /// **'INGREDIENTS *'**
  String get addRecipeIngredientsLabel;

  /// No description provided for @addRecipeIngredientPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ingredient {number}'**
  String addRecipeIngredientPlaceholder(int number);

  /// No description provided for @addRecipeIngredientRequired.
  ///
  /// In en, this message translates to:
  /// **'Ingredient is required'**
  String get addRecipeIngredientRequired;

  /// No description provided for @addRecipeAddIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addRecipeAddIngredient;

  /// No description provided for @addRecipeInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'INSTRUCTIONS *'**
  String get addRecipeInstructionsLabel;

  /// No description provided for @addRecipeInstructionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write the step-by-step cooking instructions...'**
  String get addRecipeInstructionsPlaceholder;

  /// No description provided for @addRecipeInstructionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Instructions are required'**
  String get addRecipeInstructionsRequired;

  /// No description provided for @addRecipeStoryLabel.
  ///
  /// In en, this message translates to:
  /// **'THE STORY BEHIND THIS RECIPE (optional)'**
  String get addRecipeStoryLabel;

  /// No description provided for @addRecipeStoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Share the story of this recipe... Where did it come from? Who passed it down? What memories does it hold for your family?'**
  String get addRecipeStoryDescription;

  /// No description provided for @addRecipeStoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Tell us about the history, traditions, or special memories connected to this dish.'**
  String get addRecipeStoryPlaceholder;

  /// No description provided for @addRecipeUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Recipe'**
  String get addRecipeUpdateButton;

  /// No description provided for @addRecipeShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share Recipe'**
  String get addRecipeShareButton;

  /// No description provided for @addRecipeErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get addRecipeErrorTitle;

  /// No description provided for @addRecipeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Please try again or restart the app.'**
  String get addRecipeErrorMessage;

  /// No description provided for @addRecipeGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get addRecipeGoBack;

  /// No description provided for @addRecipeUploadFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Upload from gallery'**
  String get addRecipeUploadFromGallery;

  /// No description provided for @addRecipeTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get addRecipeTakePhoto;

  /// No description provided for @subscriptionNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get subscriptionNotNow;

  /// No description provided for @subscriptionRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring…'**
  String get subscriptionRestoring;

  /// No description provided for @subscriptionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get subscriptionRestore;

  /// No description provided for @subscriptionHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve Your\nFamily Legacy'**
  String get subscriptionHeaderTitle;

  /// No description provided for @subscriptionHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium features to keep your family\'s\nrecipes alive for generations.'**
  String get subscriptionHeaderSubtitle;

  /// No description provided for @subscriptionTierHeritageName.
  ///
  /// In en, this message translates to:
  /// **'Heritage Keeper'**
  String get subscriptionTierHeritageName;

  /// No description provided for @subscriptionTierHeritageTagline.
  ///
  /// In en, this message translates to:
  /// **'Perfect for getting started'**
  String get subscriptionTierHeritageTagline;

  /// No description provided for @subscriptionTierLegacyName.
  ///
  /// In en, this message translates to:
  /// **'Legacy Collection'**
  String get subscriptionTierLegacyName;

  /// No description provided for @subscriptionTierLegacyTagline.
  ///
  /// In en, this message translates to:
  /// **'The complete family experience'**
  String get subscriptionTierLegacyTagline;

  /// No description provided for @subscriptionFeatureUnlimitedStorage.
  ///
  /// In en, this message translates to:
  /// **'Unlimited family recipe storage'**
  String get subscriptionFeatureUnlimitedStorage;

  /// No description provided for @subscriptionFeatureFamilySharing.
  ///
  /// In en, this message translates to:
  /// **'Family sharing (up to 10 members)'**
  String get subscriptionFeatureFamilySharing;

  /// No description provided for @subscriptionFeaturePhotoUploads.
  ///
  /// In en, this message translates to:
  /// **'Photo uploads for every recipe'**
  String get subscriptionFeaturePhotoUploads;

  /// No description provided for @subscriptionFeatureExportPrint.
  ///
  /// In en, this message translates to:
  /// **'Export & print recipe books'**
  String get subscriptionFeatureExportPrint;

  /// No description provided for @subscriptionFeatureCategoriesTags.
  ///
  /// In en, this message translates to:
  /// **'Recipe categories & tags'**
  String get subscriptionFeatureCategoriesTags;

  /// No description provided for @subscriptionFeatureEverythingHeritage.
  ///
  /// In en, this message translates to:
  /// **'Everything in Heritage Keeper'**
  String get subscriptionFeatureEverythingHeritage;

  /// No description provided for @subscriptionFeatureUnlimitedMembers.
  ///
  /// In en, this message translates to:
  /// **'Unlimited family members'**
  String get subscriptionFeatureUnlimitedMembers;

  /// No description provided for @subscriptionFeatureAdvancedOrganization.
  ///
  /// In en, this message translates to:
  /// **'Advanced recipe organization'**
  String get subscriptionFeatureAdvancedOrganization;

  /// No description provided for @subscriptionFeaturePrioritySupport.
  ///
  /// In en, this message translates to:
  /// **'Priority customer support'**
  String get subscriptionFeaturePrioritySupport;

  /// No description provided for @subscriptionFeatureEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Early access to new features'**
  String get subscriptionFeatureEarlyAccess;

  /// No description provided for @subscriptionFeatureCustomThemes.
  ///
  /// In en, this message translates to:
  /// **'Custom family cookbook themes'**
  String get subscriptionFeatureCustomThemes;

  /// No description provided for @subscriptionAutoRenewNotice.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions auto-renew until cancelled. Cancel anytime in your device settings.'**
  String get subscriptionAutoRenewNotice;

  /// No description provided for @subscriptionTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get subscriptionTermsOfUse;

  /// No description provided for @subscriptionPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get subscriptionPrivacyPolicy;

  /// No description provided for @subscriptionMostPopular.
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get subscriptionMostPopular;

  /// No description provided for @subscriptionPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get subscriptionPerYear;

  /// No description provided for @subscriptionPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get subscriptionPerMonth;

  /// No description provided for @subscriptionPerMonthEquivalent.
  ///
  /// In en, this message translates to:
  /// **'{price}/mo'**
  String subscriptionPerMonthEquivalent(String price);

  /// No description provided for @subscriptionGetPlanCta.
  ///
  /// In en, this message translates to:
  /// **'Get {tierName} — {price}'**
  String subscriptionGetPlanCta(String tierName, String price);

  /// No description provided for @subscriptionErrorLoadPlans.
  ///
  /// In en, this message translates to:
  /// **'Unable to load subscription plans. Please check your internet connection and try again.'**
  String get subscriptionErrorLoadPlans;

  /// No description provided for @subscriptionErrorNoPlansAvailable.
  ///
  /// In en, this message translates to:
  /// **'No subscription plans are available right now. Please check RevenueCat and App Store Connect configuration.'**
  String get subscriptionErrorNoPlansAvailable;

  /// No description provided for @subscriptionErrorAnnualUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Annual pricing is not available for this plan yet.'**
  String get subscriptionErrorAnnualUnavailable;

  /// No description provided for @subscriptionErrorMonthlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Monthly pricing is not available for this plan yet.'**
  String get subscriptionErrorMonthlyUnavailable;

  /// No description provided for @subscriptionWelcomePremium.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Legacy Table Premium!'**
  String get subscriptionWelcomePremium;

  /// No description provided for @subscriptionRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully!'**
  String get subscriptionRestoreSuccess;

  /// No description provided for @subscriptionRestoreNoneFound.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found.'**
  String get subscriptionRestoreNoneFound;

  /// No description provided for @recipeFeedNotificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get recipeFeedNotificationsTooltip;

  /// No description provided for @recipeFeedSubheading.
  ///
  /// In en, this message translates to:
  /// **'Family Recipes'**
  String get recipeFeedSubheading;

  /// No description provided for @recipeFeedTagline.
  ///
  /// In en, this message translates to:
  /// **'Preserve and share our family\'s culinary traditions with love'**
  String get recipeFeedTagline;

  /// No description provided for @recipeFeedShareRecipe.
  ///
  /// In en, this message translates to:
  /// **'Share a Recipe'**
  String get recipeFeedShareRecipe;

  /// No description provided for @recipeFeedFamilyCookbook.
  ///
  /// In en, this message translates to:
  /// **'Family Cookbook'**
  String get recipeFeedFamilyCookbook;

  /// No description provided for @recipeFeedScanRecipe.
  ///
  /// In en, this message translates to:
  /// **'Scan a Recipe'**
  String get recipeFeedScanRecipe;

  /// No description provided for @recipeFeedVoiceRecipe.
  ///
  /// In en, this message translates to:
  /// **'Voice a Recipe'**
  String get recipeFeedVoiceRecipe;

  /// No description provided for @recipeFeedComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get recipeFeedComingSoon;

  /// No description provided for @recipeFeedSaveFromLink.
  ///
  /// In en, this message translates to:
  /// **'Save from Link'**
  String get recipeFeedSaveFromLink;

  /// No description provided for @recipeFeedLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipes: {error}'**
  String recipeFeedLoadError(String error);

  /// No description provided for @recipeFeedSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes, ingredients, or categories...'**
  String get recipeFeedSearchHint;

  /// No description provided for @recipeFeedCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get recipeFeedCategoryAll;

  /// No description provided for @recipeFeedEmptyNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get recipeFeedEmptyNoResultsTitle;

  /// No description provided for @recipeFeedEmptyNoRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get recipeFeedEmptyNoRecipesTitle;

  /// No description provided for @recipeFeedEmptyNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or browse all recipes'**
  String get recipeFeedEmptyNoResultsBody;

  /// No description provided for @recipeFeedEmptyNoRecipesBody.
  ///
  /// In en, this message translates to:
  /// **'Share your first family recipe and start building your collection!'**
  String get recipeFeedEmptyNoRecipesBody;

  /// No description provided for @recipeFeedClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get recipeFeedClearSearch;

  /// No description provided for @recipeFeedSmartToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Recipe Tools'**
  String get recipeFeedSmartToolsTitle;

  /// No description provided for @recipeFeedSmartToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring recipes in the same way the web app does: scan a card or turn a video link into a draft.'**
  String get recipeFeedSmartToolsSubtitle;

  /// No description provided for @recipeFeedFeatureScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Recipe'**
  String get recipeFeedFeatureScanTitle;

  /// No description provided for @recipeFeedFeatureScanDescription.
  ///
  /// In en, this message translates to:
  /// **'Use a photo of a handwritten card or cookbook page.'**
  String get recipeFeedFeatureScanDescription;

  /// No description provided for @recipeFeedFeatureLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Save From Link'**
  String get recipeFeedFeatureLinkTitle;

  /// No description provided for @recipeFeedFeatureLinkDescription.
  ///
  /// In en, this message translates to:
  /// **'Turn a TikTok, Instagram, or YouTube link into a draft.'**
  String get recipeFeedFeatureLinkDescription;

  /// No description provided for @recipeFeedCelebrationHeadquarters.
  ///
  /// In en, this message translates to:
  /// **'Celebration Headquarters'**
  String get recipeFeedCelebrationHeadquarters;

  /// No description provided for @recipeFeedSeasonTheme.
  ///
  /// In en, this message translates to:
  /// **'{season} season • {theme}'**
  String recipeFeedSeasonTheme(String season, String theme);

  /// No description provided for @recipeFeedDaysAway.
  ///
  /// In en, this message translates to:
  /// **'{days} days away'**
  String recipeFeedDaysAway(int days);

  /// No description provided for @recipeFeedRecipeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recipe} other{{count} recipes}}'**
  String recipeFeedRecipeCount(int count);

  /// No description provided for @profileSettingsLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access profile settings'**
  String get profileSettingsLoginRequired;

  /// No description provided for @profileSettingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user data. Please try again.'**
  String get profileSettingsLoadFailed;

  /// No description provided for @profileSettingsPhotoSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Photo Source'**
  String get profileSettingsPhotoSourceTitle;

  /// No description provided for @profileSettingsCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profileSettingsCamera;

  /// No description provided for @profileSettingsGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profileSettingsGallery;

  /// No description provided for @profileSettingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileSettingsCancel;

  /// No description provided for @profileSettingsCameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to take a photo'**
  String get profileSettingsCameraPermissionRequired;

  /// No description provided for @profileSettingsPickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image. Please try again.'**
  String get profileSettingsPickImageFailed;

  /// No description provided for @profileSettingsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSettingsUpdateSuccess;

  /// No description provided for @profileSettingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileSettingsUpdateFailed;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettingsTitle;

  /// No description provided for @profileSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize how you appear to the family'**
  String get profileSettingsSubtitle;

  /// No description provided for @profileSettingsProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profileSettingsProfilePicture;

  /// No description provided for @profileSettingsUploadPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo to personalize your profile'**
  String get profileSettingsUploadPhotoHint;

  /// No description provided for @profileSettingsDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileSettingsDisplayName;

  /// No description provided for @profileSettingsFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get profileSettingsFullName;

  /// No description provided for @profileSettingsNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname (optional)'**
  String get profileSettingsNicknameLabel;

  /// No description provided for @profileSettingsNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a nickname...'**
  String get profileSettingsNicknameHint;

  /// No description provided for @profileSettingsNicknameHelper.
  ///
  /// In en, this message translates to:
  /// **'Your nickname will be shown instead of your full name on recipes and comments.'**
  String get profileSettingsNicknameHelper;

  /// No description provided for @profileSettingsAccountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get profileSettingsAccountInformation;

  /// No description provided for @profileSettingsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileSettingsEmail;

  /// No description provided for @profileSettingsMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profileSettingsMemberSince;

  /// No description provided for @profileSettingsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSettingsSaveButton;

  /// No description provided for @cookbookLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipes. Please try again.'**
  String get cookbookLoadError;

  /// No description provided for @cookbookSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one recipe'**
  String get cookbookSelectAtLeastOne;

  /// No description provided for @cookbookGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get cookbookGeneratingPdf;

  /// No description provided for @cookbookGeneratePdfError.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get cookbookGeneratePdfError;

  /// No description provided for @cookbookPdfGeneratedTitle.
  ///
  /// In en, this message translates to:
  /// **'PDF Generated Successfully!'**
  String get cookbookPdfGeneratedTitle;

  /// No description provided for @cookbookPdfReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cookbook with {recipeCount} recipe{recipeCount, plural, =1{} other{s}} is ready. What would you like to do?'**
  String cookbookPdfReadyMessage(int recipeCount);

  /// No description provided for @cookbookSaveToDevice.
  ///
  /// In en, this message translates to:
  /// **'Save to Device'**
  String get cookbookSaveToDevice;

  /// No description provided for @cookbookShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get cookbookShare;

  /// No description provided for @cookbookPreviewPrint.
  ///
  /// In en, this message translates to:
  /// **'Preview/Print'**
  String get cookbookPreviewPrint;

  /// No description provided for @cookbookCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cookbookCancel;

  /// No description provided for @cookbookSavingPdf.
  ///
  /// In en, this message translates to:
  /// **'Saving PDF...'**
  String get cookbookSavingPdf;

  /// No description provided for @cookbookPdfSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF saved successfully to Downloads folder!'**
  String get cookbookPdfSavedSuccess;

  /// No description provided for @cookbookPdfSharedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF shared successfully!'**
  String get cookbookPdfSharedSuccess;

  /// No description provided for @cookbookSavePdfError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save PDF'**
  String get cookbookSavePdfError;

  /// No description provided for @cookbookSharePdfError.
  ///
  /// In en, this message translates to:
  /// **'Failed to share PDF'**
  String get cookbookSharePdfError;

  /// No description provided for @cookbookPreviewPdfError.
  ///
  /// In en, this message translates to:
  /// **'Failed to preview PDF'**
  String get cookbookPreviewPdfError;

  /// No description provided for @cookbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Cookbook'**
  String get cookbookTitle;

  /// No description provided for @cookbookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select recipes to create a printable PDF cookbook'**
  String get cookbookSubtitle;

  /// No description provided for @cookbookClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get cookbookClear;

  /// No description provided for @cookbookRecipesSelected.
  ///
  /// In en, this message translates to:
  /// **'{selectedCount} recipe{selectedCount, plural, =1{} other{s}} selected'**
  String cookbookRecipesSelected(int selectedCount);

  /// No description provided for @cookbookReadyToCreate.
  ///
  /// In en, this message translates to:
  /// **'Ready to create your cookbook'**
  String get cookbookReadyToCreate;

  /// No description provided for @cookbookExportButton.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Cookbook'**
  String get cookbookExportButton;

  /// No description provided for @cookbookNoRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get cookbookNoRecipesTitle;

  /// No description provided for @cookbookNoRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add recipes to create your cookbook'**
  String get cookbookNoRecipesSubtitle;

  /// No description provided for @createFamilyAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Family'**
  String get createFamilyAppBarTitle;

  /// No description provided for @createFamilyHeading.
  ///
  /// In en, this message translates to:
  /// **'Create a Family'**
  String get createFamilyHeading;

  /// No description provided for @createFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start sharing recipes with your family members'**
  String get createFamilySubtitle;

  /// No description provided for @createFamilyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'FAMILY NAME'**
  String get createFamilyNameLabel;

  /// No description provided for @createFamilyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Smith Family'**
  String get createFamilyNameHint;

  /// No description provided for @createFamilyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a family name'**
  String get createFamilyNameRequired;

  /// No description provided for @createFamilyNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Family name must be at least 2 characters'**
  String get createFamilyNameTooShort;

  /// No description provided for @createFamilyNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Family name must be 50 characters or less'**
  String get createFamilyNameTooLong;

  /// No description provided for @createFamilyDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION (OPTIONAL)'**
  String get createFamilyDescriptionLabel;

  /// No description provided for @createFamilyDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your family...'**
  String get createFamilyDescriptionHint;

  /// No description provided for @createFamilyDescriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description must be 500 characters or less'**
  String get createFamilyDescriptionTooLong;

  /// No description provided for @createFamilySubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Create Family'**
  String get createFamilySubmitButton;

  /// No description provided for @createFamilyKeeperInfo.
  ///
  /// In en, this message translates to:
  /// **'You will become the family keeper and can invite others'**
  String get createFamilyKeeperInfo;

  /// No description provided for @createFamilyErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Failed to create family'**
  String get createFamilyErrorGeneric;

  /// No description provided for @createFamilyErrorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already part of a family.'**
  String get createFamilyErrorAlreadyMember;

  /// No description provided for @createFamilySuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Created!'**
  String get createFamilySuccessTitle;

  /// No description provided for @createFamilyInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get createFamilyInviteCodeLabel;

  /// No description provided for @createFamilyInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied!'**
  String get createFamilyInviteCodeCopied;

  /// No description provided for @createFamilyShareCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Share this code with family members to invite them'**
  String get createFamilyShareCodeHint;

  /// No description provided for @createFamilyShareInviteButton.
  ///
  /// In en, this message translates to:
  /// **'Share Invite'**
  String get createFamilyShareInviteButton;

  /// No description provided for @createFamilyDoneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get createFamilyDoneButton;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your culinary heritage'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordTooShort;

  /// No description provided for @loginSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignInButton;

  /// No description provided for @loginOrDivider.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOrDivider;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get loginContinueWithApple;

  /// No description provided for @loginContinueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get loginContinueWithFacebook;

  /// No description provided for @loginNewToFamily.
  ///
  /// In en, this message translates to:
  /// **'New to the family? '**
  String get loginNewToFamily;

  /// No description provided for @loginCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// No description provided for @voiceRecipeMicPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required to record a recipe'**
  String get voiceRecipeMicPermissionRequired;

  /// No description provided for @voiceRecipeFailedToStart.
  ///
  /// In en, this message translates to:
  /// **'Failed to start recording: {error}'**
  String voiceRecipeFailedToStart(String error);

  /// No description provided for @voiceRecipeFailedToStop.
  ///
  /// In en, this message translates to:
  /// **'Failed to stop recording: {error}'**
  String voiceRecipeFailedToStop(String error);

  /// No description provided for @voiceRecipeFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recording file not found'**
  String get voiceRecipeFileNotFound;

  /// No description provided for @voiceRecipeTranscribedCredits.
  ///
  /// In en, this message translates to:
  /// **'Recipe transcribed! {credits} credits remaining.'**
  String voiceRecipeTranscribedCredits(int credits);

  /// No description provided for @voiceRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice Recipe'**
  String get voiceRecipeTitle;

  /// No description provided for @voiceRecipeIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell us your recipe out loud — we\'ll transcribe it and turn it into a structured draft.'**
  String get voiceRecipeIntro;

  /// No description provided for @voiceRecipeUsesCredits.
  ///
  /// In en, this message translates to:
  /// **'Uses 2 AI credits'**
  String get voiceRecipeUsesCredits;

  /// No description provided for @voiceRecipeTapToStop.
  ///
  /// In en, this message translates to:
  /// **'Tap the button to stop'**
  String get voiceRecipeTapToStop;

  /// No description provided for @voiceRecipeRecordingDuration.
  ///
  /// In en, this message translates to:
  /// **'Recording: {duration}'**
  String voiceRecipeRecordingDuration(String duration);

  /// No description provided for @voiceRecipeReadyToTranscribe.
  ///
  /// In en, this message translates to:
  /// **'Ready to transcribe'**
  String get voiceRecipeReadyToTranscribe;

  /// No description provided for @voiceRecipeTapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to start recording'**
  String get voiceRecipeTapToStart;

  /// No description provided for @voiceRecipeSpeakNaturally.
  ///
  /// In en, this message translates to:
  /// **'Speak your recipe naturally — include ingredients, amounts, and steps.'**
  String get voiceRecipeSpeakNaturally;

  /// No description provided for @voiceRecipeTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for best results'**
  String get voiceRecipeTipsTitle;

  /// No description provided for @voiceRecipeTipsBody.
  ///
  /// In en, this message translates to:
  /// **'• Start with the recipe name\n• List each ingredient with amounts\n• Describe the steps in order\n• Mention cooking time and servings'**
  String get voiceRecipeTipsBody;

  /// No description provided for @voiceRecipeTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Transcribing with AI...'**
  String get voiceRecipeTranscribing;

  /// No description provided for @voiceRecipeTranscribeIntoDraft.
  ///
  /// In en, this message translates to:
  /// **'Transcribe Into Draft'**
  String get voiceRecipeTranscribeIntoDraft;

  /// No description provided for @voiceRecipeRecordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record Again'**
  String get voiceRecipeRecordAgain;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your culinary heritage'**
  String get registerSubtitle;

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get registerNameHint;

  /// No description provided for @registerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get registerNameRequired;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get registerEmailHint;

  /// No description provided for @registerEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get registerEmailRequired;

  /// No description provided for @registerEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get registerEmailInvalid;

  /// No description provided for @registerNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'NICKNAME (OPTIONAL)'**
  String get registerNicknameLabel;

  /// No description provided for @registerNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname (optional)'**
  String get registerNicknameHint;

  /// No description provided for @registerNicknameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Nickname must be 30 characters or less'**
  String get registerNicknameTooLong;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get registerPasswordHint;

  /// No description provided for @registerPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get registerPasswordRequired;

  /// No description provided for @registerPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get registerPasswordTooShort;

  /// No description provided for @registerCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerCreateAccountButton;

  /// No description provided for @registerAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerAlreadyHaveAccount;

  /// No description provided for @registerSignInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get registerSignInLink;

  /// No description provided for @registerRegistrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerRegistrationFailed;

  /// No description provided for @scanRecipeCameraPermission.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan a recipe'**
  String get scanRecipeCameraPermission;

  /// No description provided for @scanRecipeScannedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe scanned! {credits} credits remaining.'**
  String scanRecipeScannedSuccess(int credits);

  /// No description provided for @scanRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Recipe'**
  String get scanRecipeTitle;

  /// No description provided for @scanRecipeIntro.
  ///
  /// In en, this message translates to:
  /// **'Turn a handwritten card or cookbook page into an editable recipe draft.'**
  String get scanRecipeIntro;

  /// No description provided for @scanRecipeCreditCost.
  ///
  /// In en, this message translates to:
  /// **'Uses 1 AI credit'**
  String get scanRecipeCreditCost;

  /// No description provided for @scanRecipeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a recipe photo to scan'**
  String get scanRecipeEmptyTitle;

  /// No description provided for @scanRecipeEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Best results come from a clear, well-lit photo with the full recipe visible.'**
  String get scanRecipeEmptyHint;

  /// No description provided for @scanRecipeChoosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get scanRecipeChoosePhoto;

  /// No description provided for @scanRecipeTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get scanRecipeTakePhoto;

  /// No description provided for @scanRecipeScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning with AI...'**
  String get scanRecipeScanning;

  /// No description provided for @scanRecipeScanButton.
  ///
  /// In en, this message translates to:
  /// **'Scan Into Draft'**
  String get scanRecipeScanButton;

  /// No description provided for @notificationsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications. Please try again.'**
  String get notificationsLoadError;

  /// No description provided for @notificationsAllMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notificationsAllMarkedRead;

  /// No description provided for @notificationsMarkAllError.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark all as read. Please try again.'**
  String get notificationsMarkAllError;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllButton.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllButton;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get notificationsEmptySubtitle;

  /// No description provided for @joinFamilyAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get joinFamilyAppBarTitle;

  /// No description provided for @joinFamilyHeading.
  ///
  /// In en, this message translates to:
  /// **'Join a Family'**
  String get joinFamilyHeading;

  /// No description provided for @joinFamilySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 8-character invite code from your family keeper'**
  String get joinFamilySubtitle;

  /// No description provided for @joinFamilyInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'INVITE CODE'**
  String get joinFamilyInviteCodeLabel;

  /// No description provided for @joinFamilyButton.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get joinFamilyButton;

  /// No description provided for @joinFamilyInfoText.
  ///
  /// In en, this message translates to:
  /// **'Ask your family keeper for the invite code'**
  String get joinFamilyInfoText;

  /// No description provided for @joinFamilyEmptyCodeError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an invite code'**
  String get joinFamilyEmptyCodeError;

  /// No description provided for @joinFamilyCodeLengthError.
  ///
  /// In en, this message translates to:
  /// **'Invite code must be 8 characters'**
  String get joinFamilyCodeLengthError;

  /// No description provided for @joinFamilyGenericError.
  ///
  /// In en, this message translates to:
  /// **'Failed to join family'**
  String get joinFamilyGenericError;

  /// No description provided for @joinFamilyInvalidCodeError.
  ///
  /// In en, this message translates to:
  /// **'Invalid invite code. Please check and try again.'**
  String get joinFamilyInvalidCodeError;

  /// No description provided for @joinFamilyAlreadyMemberError.
  ///
  /// In en, this message translates to:
  /// **'You are already part of a family.'**
  String get joinFamilyAlreadyMemberError;

  /// No description provided for @joinFamilySuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully joined {familyName}!'**
  String joinFamilySuccess(String familyName);

  /// No description provided for @saveFromLinkEmptyUrlWarning.
  ///
  /// In en, this message translates to:
  /// **'Paste a cooking video or recipe link first'**
  String get saveFromLinkEmptyUrlWarning;

  /// No description provided for @saveFromLinkInvalidUrlWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL starting with http:// or https://'**
  String get saveFromLinkInvalidUrlWarning;

  /// No description provided for @saveFromLinkImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Recipe imported! {creditsRemaining} credits remaining.'**
  String saveFromLinkImportSuccess(int creditsRemaining);

  /// No description provided for @saveFromLinkAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Save From Link'**
  String get saveFromLinkAppBarTitle;

  /// No description provided for @saveFromLinkIntro.
  ///
  /// In en, this message translates to:
  /// **'Paste a TikTok, Instagram, YouTube, or recipe link and turn it into a shareable Legacy Table draft.'**
  String get saveFromLinkIntro;

  /// No description provided for @saveFromLinkCreditCost.
  ///
  /// In en, this message translates to:
  /// **'Uses 1 AI credit'**
  String get saveFromLinkCreditCost;

  /// No description provided for @saveFromLinkDraftInfo.
  ///
  /// In en, this message translates to:
  /// **'The imported recipe opens as a draft first, so you can clean up ingredients, adjust instructions, and add your own story before sharing it.'**
  String get saveFromLinkDraftInfo;

  /// No description provided for @saveFromLinkImportingLabel.
  ///
  /// In en, this message translates to:
  /// **'Importing with AI...'**
  String get saveFromLinkImportingLabel;

  /// No description provided for @saveFromLinkCreateDraftButton.
  ///
  /// In en, this message translates to:
  /// **'Create Draft From Link'**
  String get saveFromLinkCreateDraftButton;

  /// No description provided for @onboardingNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNextButton;

  /// No description provided for @onboardingGetStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStartedButton;

  /// No description provided for @homeUpgradeFab.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get homeUpgradeFab;

  /// No description provided for @homeShareRecipeFab.
  ///
  /// In en, this message translates to:
  /// **'Share a Recipe'**
  String get homeShareRecipeFab;

  /// No description provided for @homeNavHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavHome;

  /// No description provided for @homeNavCookbook.
  ///
  /// In en, this message translates to:
  /// **'Cookbook'**
  String get homeNavCookbook;

  /// No description provided for @homeNavMyRecipes.
  ///
  /// In en, this message translates to:
  /// **'My Recipes'**
  String get homeNavMyRecipes;

  /// No description provided for @homeNavFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get homeNavFamily;

  /// No description provided for @homeNavSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeNavSettings;

  /// No description provided for @homeTierLegacyCollection.
  ///
  /// In en, this message translates to:
  /// **'Legacy Collection'**
  String get homeTierLegacyCollection;

  /// No description provided for @homeTierHeritageKeeper.
  ///
  /// In en, this message translates to:
  /// **'Heritage Keeper'**
  String get homeTierHeritageKeeper;

  /// No description provided for @homeSubscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Premium plan active'**
  String get homeSubscriptionActive;

  /// No description provided for @homeSubscriptionUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium family features'**
  String get homeSubscriptionUnlock;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @profileNoRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get profileNoRecipesTitle;

  /// No description provided for @profileNoRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your first family recipe!'**
  String get profileNoRecipesSubtitle;

  /// No description provided for @profileLoadRecipesError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipes: {error}'**
  String profileLoadRecipesError(String error);

  /// No description provided for @holidayRecipesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes tagged for {holidayName} yet'**
  String holidayRecipesEmptyTitle(String holidayName);

  /// No description provided for @holidayRecipesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tag a family favorite for this holiday from the web app or upcoming mobile detail enhancements.'**
  String get holidayRecipesEmptyBody;

  /// No description provided for @shareInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Share Invite'**
  String get shareInviteTitle;

  /// No description provided for @shareInviteLinkTab.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get shareInviteLinkTab;

  /// No description provided for @shareInviteCodeTab.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get shareInviteCodeTab;

  /// No description provided for @shareInviteLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Opens the app or shows download options'**
  String get shareInviteLinkHint;

  /// No description provided for @shareInviteCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Recipient enters this code in the app'**
  String get shareInviteCodeHint;

  /// No description provided for @shareInviteCopiedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get shareInviteCopiedSnackbar;

  /// No description provided for @shareInviteCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get shareInviteCopyButton;

  /// No description provided for @shareInviteShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareInviteShareButton;

  /// No description provided for @familySettingsInviteCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite code copied!'**
  String get familySettingsInviteCodeCopied;

  /// No description provided for @familySettingsFamilyHeading.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familySettingsFamilyHeading;

  /// No description provided for @familySettingsJoinOrCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join or create a family to start sharing recipes'**
  String get familySettingsJoinOrCreateSubtitle;

  /// No description provided for @familySettingsNoFamilyYet.
  ///
  /// In en, this message translates to:
  /// **'No family yet'**
  String get familySettingsNoFamilyYet;

  /// No description provided for @familySettingsStartSharingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Start sharing recipes with your family members'**
  String get familySettingsStartSharingRecipes;

  /// No description provided for @familySettingsJoinFamilyButton.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get familySettingsJoinFamilyButton;

  /// No description provided for @familySettingsCreateFamilyButton.
  ///
  /// In en, this message translates to:
  /// **'Create Family'**
  String get familySettingsCreateFamilyButton;

  /// No description provided for @familySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Family settings'**
  String get familySettingsTitle;

  /// No description provided for @familySettingsManageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your family and invite code.'**
  String get familySettingsManageSubtitle;

  /// No description provided for @familySettingsInviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get familySettingsInviteCodeLabel;

  /// No description provided for @familySettingsCopyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get familySettingsCopyButton;

  /// No description provided for @familySettingsShareCodeHelper.
  ///
  /// In en, this message translates to:
  /// **'Share this code so others can join your family.'**
  String get familySettingsShareCodeHelper;

  /// No description provided for @familySettingsMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get familySettingsMembersLabel;

  /// No description provided for @familySettingsNoMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get familySettingsNoMembersYet;

  /// No description provided for @familySettingsKeeperBadge.
  ///
  /// In en, this message translates to:
  /// **'Keeper'**
  String get familySettingsKeeperBadge;

  /// No description provided for @recipeCardCookingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeCardCookingTime(int minutes);

  /// No description provided for @recipeCardServings.
  ///
  /// In en, this message translates to:
  /// **'{count} servings'**
  String recipeCardServings(int count);

  /// No description provided for @styledSnackbarDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get styledSnackbarDismiss;

  /// No description provided for @celebrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Celebration Headquarters'**
  String get celebrationTitle;

  /// No description provided for @celebrationNextUp.
  ///
  /// In en, this message translates to:
  /// **' — Next up: '**
  String get celebrationNextUp;

  /// No description provided for @celebrationNextHoliday.
  ///
  /// In en, this message translates to:
  /// **'{emoji} {name} in {days} {days, plural, =1{day} other{days}}'**
  String celebrationNextHoliday(String emoji, String name, int days);

  /// No description provided for @celebrationHolidayCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{days} {days, plural, =1{day} other{days}} away  •  {recipes} {recipes, plural, =1{recipe} other{recipes}}'**
  String celebrationHolidayCardSubtitle(int days, int recipes);

  /// No description provided for @cookbookCardCookingTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String cookbookCardCookingTime(int minutes);

  /// No description provided for @cookbookCardServings.
  ///
  /// In en, this message translates to:
  /// **'{count} servings'**
  String cookbookCardServings(int count);

  /// No description provided for @cookbookCardByAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String cookbookCardByAuthor(String name);

  /// No description provided for @familyPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Join or Create a Family'**
  String get familyPromptTitle;

  /// No description provided for @familyPromptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start sharing recipes with your family members'**
  String get familyPromptSubtitle;

  /// No description provided for @familyPromptJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join Family'**
  String get familyPromptJoinButton;

  /// No description provided for @familyPromptCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Family'**
  String get familyPromptCreateButton;

  /// No description provided for @familyPromptSampleButton.
  ///
  /// In en, this message translates to:
  /// **'Just exploring? Try a sample cookbook'**
  String get familyPromptSampleButton;

  /// No description provided for @familyPromptSampleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome! We\'ve added a few sample recipes to get you started.'**
  String get familyPromptSampleSuccess;

  /// No description provided for @familyPromptSampleFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the sample cookbook. Please try again.'**
  String get familyPromptSampleFailed;

  /// No description provided for @shareRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Share this recipe'**
  String get shareRecipeTitle;

  /// No description provided for @shareRecipeAsCard.
  ///
  /// In en, this message translates to:
  /// **'Share as card'**
  String get shareRecipeAsCard;

  /// No description provided for @shareRecipeAsText.
  ///
  /// In en, this message translates to:
  /// **'Share as text'**
  String get shareRecipeAsText;

  /// No description provided for @recipeDetailVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get recipeDetailVoiceNote;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'pa',
    'pt',
    'ur',
    'yo',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'pa':
      return AppLocalizationsPa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ur':
      return AppLocalizationsUr();
    case 'yo':
      return AppLocalizationsYo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
