import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_kitchen/core/di/injection.dart';
import 'package:green_kitchen/core/storage/key_value_store.dart';
import 'package:green_kitchen/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:green_kitchen/main.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    await GetIt.I.reset();
    await configureDependencies(keyValueStore: MemoryKeyValueStore());
  });

  testWidgets('Welcome screen is shown when unauthenticated', (tester) async {
    final authBloc = getIt<AuthBloc>()..add(const AuthStarted());
    await tester.pumpWidget(GreenKitchenApp(authBloc: authBloc));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text("Let's Get Started!"), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.textContaining('Apple'), findsNothing);
  });
}
