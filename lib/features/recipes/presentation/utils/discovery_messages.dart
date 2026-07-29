import '../../../../core/error/failures.dart';
import '../../../../l10n/app_localizations.dart';

String discoveryFailureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure.message) {
    FailureCodes.network => l10n.authErrorNetwork,
    DiscoveryFailureCodes.notFound => l10n.discoveryErrorNotFound,
    DiscoveryFailureCodes.rateLimited => l10n.discoveryErrorRateLimited,
    _ => l10n.discoveryErrorServer,
  };
}

String recipeDifficultyLabel(AppLocalizations l10n, String difficulty) {
  return switch (difficulty.toLowerCase()) {
    'easy' => l10n.recipeDifficultyEasy,
    'medium' => l10n.recipeDifficultyMedium,
    'hard' => l10n.recipeDifficultyHard,
    _ => difficulty,
  };
}
