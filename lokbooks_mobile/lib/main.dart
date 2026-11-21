
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/l10n/app_localizations.dart';
import 'core/services/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/controllers/auth_controller.dart';

void main() {
  runApp(const LokBooksApp());
}

class LokBooksApp extends StatefulWidget {
  const LokBooksApp({super.key});

  @override
  State<LokBooksApp> createState() => _LokBooksAppState();
}

class _LokBooksAppState extends State<LokBooksApp> {
  final AuthController _authController = AuthController();

  late final GoRouter _router;

  Locale _locale = const Locale('pt');

  @override
  void initState() {
    super.initState();

    _router = createAppRouter(
      authController: _authController,
      getLocale: () => _locale,
      onLocaleChanged: _changeLocale,
    );

    _authController.restoreSession();
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void dispose() {
    _router.dispose();
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LokBooks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: _locale,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
