import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/password_updated_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/discover/presentation/models/discovery_search_args.dart';
import '../../features/discover/presentation/pages/discovery_results_page.dart';
import '../../features/discover/presentation/pages/discover_page.dart';
import '../../features/home_shell/presentation/pages/home_shell_page.dart';
import '../../features/locale_preference/presentation/pages/language_settings_page.dart';
import '../../features/pantry/presentation/models/pantry_search_args.dart';
import '../../features/pantry/presentation/pages/pantry_results_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/recipe_library/presentation/pages/recipe_library_page.dart';
import '../../features/recipes/presentation/pages/recipe_detail_page.dart';
import '../../features/suggestions/presentation/pages/suggestions_page.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthBloc authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: _AuthRouterRefresh(authBloc),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/welcome' ||
          loc == '/signup' ||
          loc == '/login' ||
          loc.startsWith('/forgot-password') ||
          loc.startsWith('/otp') ||
          loc.startsWith('/reset-password') ||
          loc == '/password-updated';

      if (status == AuthStatus.unknown) {
        return null;
      }

      if (status == AuthStatus.unauthenticated && !isAuthRoute) {
        return '/welcome';
      }

      if (status == AuthStatus.authenticated && isAuthRoute) {
        return '/home/discover';
      }

      if (status == AuthStatus.authenticated && loc == '/home') {
        return '/home/discover';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OtpPage(
            sessionId: extra['sessionId'] as String? ?? '',
            email: extra['email'] as String? ?? '',
            expireInSeconds: extra['expireInSeconds'] as int? ?? 180,
            resendAfterSeconds: extra['resendAfterSeconds'] as int? ?? 60,
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return ResetPasswordPage(
            resetToken: extra['resetToken'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/password-updated',
        builder: (context, state) => const PasswordUpdatedPage(),
      ),
      GoRoute(
        path: '/recipes/:id',
        builder: (context, state) => RecipeDetailPage(
          recipeId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/pantry/results',
        builder: (context, state) {
          final args = state.extra! as PantrySearchArgs;
          return PantryResultsPage(args: args);
        },
      ),
      GoRoute(
        path: '/discovery/results',
        builder: (context, state) {
          final args = state.extra! as DiscoverySearchArgs;
          return DiscoveryResultsPage(args: args);
        },
      ),
      GoRoute(
        path: '/settings/language',
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/discover',
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/library',
                builder: (context, state) => const RecipeLibraryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/suggestions',
                builder: (context, state) => const SuggestionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(this._authBloc) {
    _subscription = _authBloc.stream.listen((_) => notifyListeners());
  }

  final AuthBloc _authBloc;
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
