import '../../domain/entities/social_provider.dart';

/// Abstracts native Google/Facebook SDKs.
///
/// Until platform credentials are configured, [FakeSocialAuthService] returns
/// deterministic tokens for UI development.
abstract class SocialAuthService {
  Future<String?> signIn(SocialProvider provider);
}

class FakeSocialAuthService implements SocialAuthService {
  @override
  Future<String?> signIn(SocialProvider provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return 'fake_${provider.apiValue}_token';
  }
}
