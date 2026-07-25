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
    test('primary matches Duolingo green', () {
      expect(AppColors.primary, const Color(0xFF58CC02));
    });
  });

  group('AppTheme', () {
    test('light theme uses brand primary', () {
      expect(AppTheme.light.colorScheme.primary, AppColors.primary);
    });

    test('dark theme uses dark background', () {
      expect(AppTheme.dark.scaffoldBackgroundColor, AppColors.darkBackground);
    });
  });

  group('tokens', () {
    test('spacing and radius scales', () {
      expect(AppSpacing.md, 16);
      expect(AppRadius.md, 12);
    });
  });

  group('widgets', () {
    testWidgets('AppButton primary renders label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: AppButton(label: 'Cook', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Cook'), findsOneWidget);
    });

    testWidgets('AppText caption renders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: AppText('hello', variant: AppTextVariant.caption),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('AppLoading shows progress indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLoading()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
