import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('vi'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Green Kitchen'**
  String get appTitle;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language settings section title
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// Follow device language option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// Vietnamese language option
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Sample string to verify localization wiring
  ///
  /// In en, this message translates to:
  /// **'This text follows your language setting.'**
  String get languageSampleHint;

  /// Action label to open language settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get openLanguageSettings;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started!'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s dive in into your account'**
  String get authWelcomeSubtitle;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUp;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get authPrivacyPolicy;

  /// No description provided for @authTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get authTermsOfService;

  /// No description provided for @authPrivacyTermsSeparator.
  ///
  /// In en, this message translates to:
  /// **'  ·  '**
  String get authPrivacyTermsSeparator;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get authContinueWithFacebook;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authGoogle;

  /// No description provided for @authFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get authFacebook;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get authLoginTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey of healthier cooking.'**
  String get authLoginSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authRememberMe;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccountPrompt;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Green Kitchen Today!'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start cooking healthier meals.'**
  String get authSignupSubtitle;

  /// No description provided for @authAgreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to Terms & Conditions'**
  String get authAgreeTerms;

  /// No description provided for @authHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccountPrompt;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotTitle;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the email you used to sign up. We will send you a one-time code to reset your password.'**
  String get authForgotSubtitle;

  /// No description provided for @authRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Registered email address'**
  String get authRegisteredEmail;

  /// No description provided for @authSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code'**
  String get authSendOtp;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Code'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP code from your email to verify your identity.'**
  String get authOtpSubtitle;

  /// No description provided for @authOtpResendInSeconds.
  ///
  /// In en, this message translates to:
  /// **'You can resend the code in {seconds} seconds'**
  String authOtpResendInSeconds(int seconds);

  /// No description provided for @authOtpResendNow.
  ///
  /// In en, this message translates to:
  /// **'You can resend the code now'**
  String get authOtpResendNow;

  /// No description provided for @authResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get authResendCode;

  /// No description provided for @authRequestNewCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new code'**
  String get authRequestNewCode;

  /// No description provided for @authResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get authResetTitle;

  /// No description provided for @authResetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be at least 8 characters long. Avoid using the same one as before.'**
  String get authResetSubtitle;

  /// No description provided for @authCreateNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get authCreateNewPassword;

  /// No description provided for @authConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get authConfirmNewPassword;

  /// No description provided for @authRequestNewResetCode.
  ///
  /// In en, this message translates to:
  /// **'Request a new reset code'**
  String get authRequestNewResetCode;

  /// No description provided for @authSaveNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Save New Password'**
  String get authSaveNewPassword;

  /// No description provided for @authPasswordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get authPasswordUpdatedTitle;

  /// No description provided for @authPasswordUpdatedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated.'**
  String get authPasswordUpdatedSubtitle;

  /// No description provided for @authLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authLogOut;

  /// No description provided for @authHomeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get authHomeWelcome;

  /// No description provided for @authHomeWelcomeNamed.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String authHomeWelcomeNamed(String name);

  /// No description provided for @authValidationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email. Please check and try again.'**
  String get authValidationEmailInvalid;

  /// No description provided for @authValidationPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8–32 characters and include upper, lower, number, and special character.'**
  String get authValidationPasswordWeak;

  /// No description provided for @authValidationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get authValidationPasswordRequired;

  /// No description provided for @authValidationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authValidationPasswordMismatch;

  /// No description provided for @authValidationOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 4 digits.'**
  String get authValidationOtpInvalid;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Please try again.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again in a few minutes.'**
  String get authErrorServer;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP. Please try again.'**
  String get authErrorInvalidOtp;

  /// No description provided for @authErrorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'OTP has expired. Please request a new code.'**
  String get authErrorOtpExpired;

  /// No description provided for @authErrorUserExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get authErrorUserExists;

  /// No description provided for @authErrorAccountLocked.
  ///
  /// In en, this message translates to:
  /// **'Your account is temporarily locked due to too many failed attempts.'**
  String get authErrorAccountLocked;

  /// No description provided for @authErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again in 1 minute.'**
  String get authErrorRateLimited;

  /// No description provided for @authErrorSocial.
  ///
  /// In en, this message translates to:
  /// **'Social sign-in failed. Please try again.'**
  String get authErrorSocial;

  /// No description provided for @authErrorInvalidResetToken.
  ///
  /// In en, this message translates to:
  /// **'This password reset link is no longer valid.'**
  String get authErrorInvalidResetToken;

  /// No description provided for @authErrorResetTokenExpired.
  ///
  /// In en, this message translates to:
  /// **'Your password reset session has expired. Please try again.'**
  String get authErrorResetTokenExpired;

  /// No description provided for @authErrorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get authErrorSessionExpired;

  /// No description provided for @authErrorInvalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input. Please check and try again.'**
  String get authErrorInvalidInput;

  /// No description provided for @tabDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get tabDiscover;

  /// No description provided for @tabRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get tabRecipes;

  /// No description provided for @tabSuggestions.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get tabSuggestions;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s in your kitchen?'**
  String get discoverTitle;

  /// No description provided for @discoverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients you have and we\'ll suggest dishes.'**
  String get discoverSubtitle;

  /// No description provided for @discoverIngredientHint.
  ///
  /// In en, this message translates to:
  /// **'Search ingredients…'**
  String get discoverIngredientHint;

  /// No description provided for @discoverSuggestDishes.
  ///
  /// In en, this message translates to:
  /// **'Suggest dishes'**
  String get discoverSuggestDishes;

  /// No description provided for @discoverFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get discoverFilters;

  /// No description provided for @discoverRecentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get discoverRecentSearches;

  /// No description provided for @discoverNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent searches yet.'**
  String get discoverNoRecent;

  /// No description provided for @discoverSelectedIngredients.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get discoverSelectedIngredients;

  /// No description provided for @pantryResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested dishes'**
  String get pantryResultsTitle;

  /// No description provided for @pantryRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get pantryRetry;

  /// No description provided for @pantryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recipes found for these ingredients.'**
  String get pantryEmpty;

  /// No description provided for @pantryError.
  ///
  /// In en, this message translates to:
  /// **'Could not load suggestions. Please try again.'**
  String get pantryError;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Search filters'**
  String get filterTitle;

  /// No description provided for @filterMaxTime.
  ///
  /// In en, this message translates to:
  /// **'Max cook time (minutes)'**
  String get filterMaxTime;

  /// No description provided for @filterDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get filterDifficulty;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filterApply;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @filterEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get filterEasy;

  /// No description provided for @filterMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get filterMedium;

  /// No description provided for @filterHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get filterHard;

  /// No description provided for @librarySegmentAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get librarySegmentAll;

  /// No description provided for @librarySegmentViewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get librarySegmentViewed;

  /// No description provided for @librarySegmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get librarySegmentSaved;

  /// No description provided for @librarySegmentFromPantry.
  ///
  /// In en, this message translates to:
  /// **'From pantry'**
  String get librarySegmentFromPantry;

  /// No description provided for @libraryEmptyAll.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet. Explore or save dishes to see them here.'**
  String get libraryEmptyAll;

  /// No description provided for @libraryEmptyViewed.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t viewed any recipes yet.'**
  String get libraryEmptyViewed;

  /// No description provided for @libraryEmptySaved.
  ///
  /// In en, this message translates to:
  /// **'No saved recipes yet.'**
  String get libraryEmptySaved;

  /// No description provided for @libraryEmptyFromPantry.
  ///
  /// In en, this message translates to:
  /// **'No pantry searches yet.'**
  String get libraryEmptyFromPantry;

  /// No description provided for @suggestionsFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured today'**
  String get suggestionsFeatured;

  /// No description provided for @suggestionsPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get suggestionsPopular;

  /// No description provided for @suggestionsQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick meals'**
  String get suggestionsQuick;

  /// No description provided for @suggestionsEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy recipes'**
  String get suggestionsEasy;

  /// No description provided for @suggestionsMockViews.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String suggestionsMockViews(String count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @recipeDetailIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get recipeDetailIngredients;

  /// No description provided for @recipeDetailSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get recipeDetailSteps;

  /// No description provided for @recipeDetailNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get recipeDetailNutrition;

  /// No description provided for @recipeDetailSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get recipeDetailSave;

  /// No description provided for @recipeDetailUnsave.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get recipeDetailUnsave;

  /// No description provided for @recipeDetailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found.'**
  String get recipeDetailNotFound;

  /// No description provided for @recipeDetailMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String recipeDetailMinutes(int minutes);

  /// No description provided for @recipeDetailServings.
  ///
  /// In en, this message translates to:
  /// **'{count} servings'**
  String recipeDetailServings(int count);

  /// No description provided for @recipeDifficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get recipeDifficultyEasy;

  /// No description provided for @recipeDifficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get recipeDifficultyMedium;

  /// No description provided for @recipeDifficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get recipeDifficultyHard;

  /// No description provided for @discoveryErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Recipe not found.'**
  String get discoveryErrorNotFound;

  /// No description provided for @discoveryErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get discoveryErrorServer;

  /// No description provided for @discoveryErrorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait and try again.'**
  String get discoveryErrorRateLimited;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
