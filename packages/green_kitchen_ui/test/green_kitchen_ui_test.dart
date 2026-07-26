import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppColors', () {
    test('brand matches Focuso coral', () {
      expect(AppColors.primary, const Color(0xFFFF4749));
      expect(AppColors.brand, AppColors.primary);
      expect(AppColors.absoluteWhite, const Color(0xFFFFFFFF));
    });
  });

  group('AppTheme', () {
    test('light and dark use brand primary', () {
      expect(AppTheme.light.colorScheme.primary, AppColors.brand);
      expect(AppTheme.dark.colorScheme.primary, AppColors.brand);
    });

    test('dark theme uses dark background', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBackground);
    });
  });

  group('tokens', () {
    test('Focuso spacing and radius', () {
      expect(AppSpacing.gap10, 10);
      expect(AppSpacing.md, 16);
      expect(AppRadius.tab, 6);
      expect(AppRadius.md, 10);
      expect(AppRadius.lg, 16);
      expect(AppRadius.pill, 1000);
    });

    test('H4 typography size', () {
      expect(AppTypography.h4().fontSize, 24);
      expect(AppTypography.fontFamily, 'Urbanist');
    });
  });

  group('widgets', () {
    testWidgets('AppButton primary renders label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppButton(label: 'Sign up', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('AppTabs reports onChanged', (tester) async {
      var index = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppTabs(
                  tabs: const ['Active', 'Completed'],
                  selectedIndex: index,
                  onChanged: (i) => setState(() => index = i),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Completed'));
      await tester.pump();
      expect(index, 1);
    });

    testWidgets('AppLoading shows white progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoading()),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(indicator.color, AppColors.absoluteWhite);
    });

    testWidgets('AppPageIndicator renders markers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppPageIndicator(count: 3, index: 1),
          ),
        ),
      );

      expect(find.byType(AppPageIndicator), findsOneWidget);
    });

    testWidgets('AppSwitch toggles', (tester) async {
      var value = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return AppSwitch(
                  value: value,
                  onChanged: (v) => setState(() => value = v),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(value, isTrue);
    });
  });
}
