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
}
