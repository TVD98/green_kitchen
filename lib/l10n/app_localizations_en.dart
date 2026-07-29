// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Green Kitchen';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSampleHint => 'This text follows your language setting.';

  @override
  String get openLanguageSettings => 'Language';

  @override
  String get authWelcomeTitle => 'Let\'s Get Started!';

  @override
  String get authWelcomeSubtitle => 'Let\'s dive in into your account';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authPrivacyPolicy => 'Privacy Policy';

  @override
  String get authTermsOfService => 'Terms of Service';

  @override
  String get authPrivacyTermsSeparator => '  ·  ';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithFacebook => 'Continue with Facebook';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authGoogle => 'Google';

  @override
  String get authFacebook => 'Facebook';

  @override
  String get authLoginTitle => 'Welcome Back!';

  @override
  String get authLoginSubtitle =>
      'Sign in to continue your journey of healthier cooking.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get authSignupTitle => 'Join Green Kitchen Today!';

  @override
  String get authSignupSubtitle =>
      'Create your account to start cooking healthier meals.';

  @override
  String get authAgreeTerms => 'I agree to Terms & Conditions';

  @override
  String get authHaveAccountPrompt => 'Already have an account? ';

  @override
  String get authForgotTitle => 'Forgot Password?';

  @override
  String get authForgotSubtitle =>
      'Enter the email you used to sign up. We will send you a one-time code to reset your password.';

  @override
  String get authRegisteredEmail => 'Registered email address';

  @override
  String get authSendOtp => 'Send OTP Code';

  @override
  String get authOtpTitle => 'Enter OTP Code';

  @override
  String get authOtpSubtitle =>
      'Enter the OTP code from your email to verify your identity.';

  @override
  String authOtpResendInSeconds(int seconds) {
    return 'You can resend the code in $seconds seconds';
  }

  @override
  String get authOtpResendNow => 'You can resend the code now';

  @override
  String get authResendCode => 'Resend code';

  @override
  String get authRequestNewCode => 'Request a new code';

  @override
  String get authResetTitle => 'Secure Your Account';

  @override
  String get authResetSubtitle =>
      'Your new password must be at least 8 characters long. Avoid using the same one as before.';

  @override
  String get authCreateNewPassword => 'Create new password';

  @override
  String get authConfirmNewPassword => 'Confirm new password';

  @override
  String get authRequestNewResetCode => 'Request a new reset code';

  @override
  String get authSaveNewPassword => 'Save New Password';

  @override
  String get authPasswordUpdatedTitle => 'You\'re all set!';

  @override
  String get authPasswordUpdatedSubtitle => 'Your password has been updated.';

  @override
  String get authLogOut => 'Log out';

  @override
  String get authHomeWelcome => 'Welcome!';

  @override
  String authHomeWelcomeNamed(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get authValidationEmailInvalid =>
      'Invalid email. Please check and try again.';

  @override
  String get authValidationPasswordWeak =>
      'Password must be 8–32 characters and include upper, lower, number, and special character.';

  @override
  String get authValidationPasswordRequired => 'Please enter your password.';

  @override
  String get authValidationPasswordMismatch => 'Passwords do not match.';

  @override
  String get authValidationOtpInvalid => 'OTP must be 4 digits.';

  @override
  String get authErrorNetwork => 'No network connection. Please try again.';

  @override
  String get authErrorServer =>
      'Something went wrong. Please try again in a few minutes.';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authErrorInvalidOtp => 'Incorrect OTP. Please try again.';

  @override
  String get authErrorOtpExpired =>
      'OTP has expired. Please request a new code.';

  @override
  String get authErrorUserExists => 'This email is already registered.';

  @override
  String get authErrorAccountLocked =>
      'Your account is temporarily locked due to too many failed attempts.';

  @override
  String get authErrorRateLimited =>
      'Too many attempts. Please try again in 1 minute.';

  @override
  String get authErrorSocial => 'Social sign-in failed. Please try again.';

  @override
  String get authErrorInvalidResetToken =>
      'This password reset link is no longer valid.';

  @override
  String get authErrorResetTokenExpired =>
      'Your password reset session has expired. Please try again.';

  @override
  String get authErrorSessionExpired =>
      'Your session has expired. Please sign in again.';

  @override
  String get authErrorInvalidInput =>
      'Invalid input. Please check and try again.';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabRecipes => 'Recipes';

  @override
  String get tabSuggestions => 'For you';

  @override
  String get tabProfile => 'Profile';

  @override
  String get discoverTitle => 'What do you want to cook today?';

  @override
  String get discoverSubtitle =>
      'Describe what you want or pick a quick start below.';

  @override
  String get discoverPromptHint => 'e.g. quick vegetarian dinner…';

  @override
  String get discoverVoiceSuggestion => 'Speak instead of typing';

  @override
  String get discoverUsePreferencesTitle => 'Use food preferences';

  @override
  String get discoverUsePreferencesSubtitle =>
      'Suggestions based on your taste and diet';

  @override
  String get discoverExcludeAllergiesTitle => 'Exclude allergies';

  @override
  String get discoverExcludeAllergiesSubtitle =>
      'Avoid ingredients you\'re allergic to';

  @override
  String get discoverQuickStartLabel => 'Quick start';

  @override
  String get discoverQuickStartFridge => 'Fridge ingredients';

  @override
  String get discoverQuickStartCravings => 'Cravings';

  @override
  String get discoverQuickStartFastHealthy => 'Fast & healthy';

  @override
  String get discoverQuickStartVegetarian => 'Vegetarian only';

  @override
  String get discoverFindRecipes => 'Find recipes';

  @override
  String get discoverAiDisclaimer =>
      'AI-generated suggestions. Check ingredients and allergies before cooking.';

  @override
  String get discoverVoicePermissionDenied =>
      'Microphone permission is required for voice input.';

  @override
  String get discoverFridgeSheetTitle => 'Pick ingredients';

  @override
  String get discoverFridgeSheetSubtitle =>
      'Select up to 7 ingredients you have';

  @override
  String get discoverFridgeSearchHint => 'Search ingredients…';

  @override
  String get discoverFridgeSearchEmpty => 'Type an ingredient name to search';

  @override
  String discoverFridgeAddIngredients(int count, int max) {
    return 'Add ingredients ($count/$max)';
  }

  @override
  String get discoverFridgeClearSelection => 'Clear selection';

  @override
  String discoverPromptFridgeWithIngredients(String ingredients) {
    return 'I have: $ingredients. Suggest dishes to cook.';
  }

  @override
  String get discoverPromptFridgeEmpty =>
      'I have ingredients in my fridge. Suggest dishes to cook.';

  @override
  String discoverPromptCravingsWithInput(String craving) {
    return 'I\'m craving: $craving. What can I cook?';
  }

  @override
  String get discoverPromptCravingsTemplate =>
      'I\'m craving: ... What can I cook?';

  @override
  String get discoverPromptFastHealthy => 'Suggest quick and healthy dishes';

  @override
  String get discoverPromptVegetarian => 'Suggest vegetarian dishes';

  @override
  String get discoverIngredientCategoryVegetable => 'Vegetables';

  @override
  String get discoverIngredientCategoryProtein => 'Protein';

  @override
  String get discoverIngredientCategoryDairy => 'Dairy';

  @override
  String get discoverIngredientCategoryGrain => 'Grains';

  @override
  String get discoverIngredientCategoryOther => 'Other';

  @override
  String get discoverRecentSearches => 'Recent searches';

  @override
  String get discoverNoRecent => 'No recent searches yet.';

  @override
  String get discoveryResultsTitle => 'Search results';

  @override
  String get discoveryEmpty => 'No matching recipes found.';

  @override
  String get discoveryRetry => 'Try again';

  @override
  String get pantryResultsTitle => 'Suggested dishes';

  @override
  String get pantryRetry => 'Try again';

  @override
  String get pantryEmpty => 'No recipes found for these ingredients.';

  @override
  String get pantryError => 'Could not load suggestions. Please try again.';

  @override
  String get filterTitle => 'Search filters';

  @override
  String get filterMaxTime => 'Max cook time (minutes)';

  @override
  String get filterDifficulty => 'Difficulty';

  @override
  String get filterApply => 'Apply';

  @override
  String get filterAny => 'Any';

  @override
  String get filterEasy => 'Easy';

  @override
  String get filterMedium => 'Medium';

  @override
  String get filterHard => 'Hard';

  @override
  String get librarySegmentAll => 'All';

  @override
  String get librarySegmentViewed => 'Viewed';

  @override
  String get librarySegmentSaved => 'Saved';

  @override
  String get librarySegmentFromPantry => 'From pantry';

  @override
  String get libraryEmptyAll =>
      'No recipes yet. Explore or save dishes to see them here.';

  @override
  String get libraryEmptyViewed => 'You haven\'t viewed any recipes yet.';

  @override
  String get libraryEmptySaved => 'No saved recipes yet.';

  @override
  String get libraryEmptyFromPantry => 'No pantry searches yet.';

  @override
  String get suggestionsFeatured => 'Featured today';

  @override
  String get suggestionsPopular => 'Popular';

  @override
  String get suggestionsQuick => 'Quick meals';

  @override
  String get suggestionsEasy => 'Easy recipes';

  @override
  String suggestionsMockViews(String count) {
    return '$count views';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileLogout => 'Log out';

  @override
  String get recipeDetailIngredients => 'Ingredients';

  @override
  String get recipeDetailSteps => 'Steps';

  @override
  String get recipeDetailNutrition => 'Nutrition';

  @override
  String get recipeDetailSave => 'Save';

  @override
  String get recipeDetailUnsave => 'Saved';

  @override
  String get recipeDetailNotFound => 'Recipe not found.';

  @override
  String recipeDetailMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String recipeDetailServings(int count) {
    return '$count servings';
  }

  @override
  String get recipeDifficultyEasy => 'Easy';

  @override
  String get recipeDifficultyMedium => 'Medium';

  @override
  String get recipeDifficultyHard => 'Hard';

  @override
  String get discoveryErrorNotFound => 'Recipe not found.';

  @override
  String get discoveryErrorServer => 'Something went wrong. Please try again.';

  @override
  String get discoveryErrorRateLimited =>
      'Too many requests. Please wait and try again.';
}
