import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_kitchen/features/home_shell/presentation/pages/home_shell_page.dart';
import 'package:green_kitchen/l10n/app_localizations.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('home shell renders localized tab labels', (tester) async {
    final router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return HomeShellPage(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home/discover',
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Discover body')),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home/library',
                  builder: (context, state) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home/suggestions',
                  builder: (context, state) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home/profile',
                  builder: (context, state) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
      ],
      initialLocation: '/home/discover',
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('For you'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    expect(find.text('Discover body'), findsNothing);

    await tester.tap(find.text('Discover'));
    await tester.pumpAndSettle();
    expect(find.text('Discover body'), findsOneWidget);
  });
}
