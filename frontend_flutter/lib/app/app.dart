import 'package:flutter/material.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/state/auth_provider.dart';
import '../core/state/locale_provider.dart';
import 'app_router.dart';
import 'app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final appRouter = AppRouter(authProvider);

    if (authProvider.status == AuthStatus.unknown) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp.router(
      title: 'Vocab App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      locale: localeProvider.locale, 
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}