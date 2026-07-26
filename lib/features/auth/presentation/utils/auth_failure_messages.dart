import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validation/auth_validators.dart';

String messageForFailure(Failure failure, AppLocalizations l10n) {
  return localizeAuthMessage(failure.message, l10n);
}

String? localizeValidationError(String? code, AppLocalizations l10n) {
  if (code == null) return null;
  return localizeAuthMessage(code, l10n);
}

String localizeAuthMessage(String codeOrMessage, AppLocalizations l10n) {
  switch (codeOrMessage) {
    case AuthValidationCodes.emailInvalid:
      return l10n.authValidationEmailInvalid;
    case AuthValidationCodes.passwordWeak:
      return l10n.authValidationPasswordWeak;
    case AuthValidationCodes.passwordRequired:
      return l10n.authValidationPasswordRequired;
    case AuthValidationCodes.passwordMismatch:
      return l10n.authValidationPasswordMismatch;
    case AuthValidationCodes.otpInvalid:
      return l10n.authValidationOtpInvalid;
    case FailureCodes.network:
      return l10n.authErrorNetwork;
    case FailureCodes.server:
      return l10n.authErrorServer;
    case FailureCodes.invalidCredentials:
      return l10n.authErrorInvalidCredentials;
    case FailureCodes.invalidOtp:
      return l10n.authErrorInvalidOtp;
    case FailureCodes.otpExpired:
      return l10n.authErrorOtpExpired;
    case FailureCodes.userExists:
      return l10n.authErrorUserExists;
    case FailureCodes.accountLocked:
      return l10n.authErrorAccountLocked;
    case FailureCodes.rateLimited:
      return l10n.authErrorRateLimited;
    case FailureCodes.social:
      return l10n.authErrorSocial;
    case FailureCodes.invalidResetToken:
      return l10n.authErrorInvalidResetToken;
    case FailureCodes.resetTokenExpired:
      return l10n.authErrorResetTokenExpired;
    case FailureCodes.sessionExpired:
      return l10n.authErrorSessionExpired;
    case FailureCodes.invalidInput:
      return l10n.authErrorInvalidInput;
    default:
      return codeOrMessage;
  }
}
