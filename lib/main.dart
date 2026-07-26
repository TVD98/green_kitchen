import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_kitchen_ui/green_kitchen_ui.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final authBloc = getIt<AuthBloc>()..add(const AuthStarted());
  runApp(GreenKitchenApp(authBloc: authBloc));
}

class GreenKitchenApp extends StatelessWidget {
  const GreenKitchenApp({super.key, required this.authBloc});

  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(authBloc);

    return BlocProvider.value(
      value: authBloc,
      child: MaterialApp.router(
        title: 'Green Kitchen',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
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
      ),
    );
  }
}
