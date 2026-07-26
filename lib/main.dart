import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/locale_preference/presentation/cubit/locale_preference_cubit.dart';
import 'features/locale_preference/presentation/locale_resolution.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final authBloc = getIt<AuthBloc>()..add(const AuthStarted());
  final localeCubit = getIt<LocalePreferenceCubit>();
  runApp(
    GreenKitchenApp(
      authBloc: authBloc,
      localePreferenceCubit: localeCubit,
    ),
  );
}

class GreenKitchenApp extends StatelessWidget {
  const GreenKitchenApp({
    super.key,
    required this.authBloc,
    required this.localePreferenceCubit,
  });

  final AuthBloc authBloc;
  final LocalePreferenceCubit localePreferenceCubit;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(authBloc);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: localePreferenceCubit),
      ],
      child: BlocBuilder<LocalePreferenceCubit, LocalePreferenceState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: localeState.materialLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeListResolutionCallback: resolveAppLocale,
            routerConfig: appRouter.router,
            builder: (context, child) {
              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state.status == AuthStatus.unknown) {
                    return const Scaffold(
                      body: Center(child: AppLoading()),
                    );
                  }
                  return child ?? const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}
