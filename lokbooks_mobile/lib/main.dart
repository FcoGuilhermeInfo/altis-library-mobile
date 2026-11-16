
import 'package:flutter/material.dart';

import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_shell.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/auth/presentation/pages/login_page.dart';

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
  Locale _locale = const Locale('pt');

  @override
  void initState() {
    super.initState();
    _authController.restoreSession();
  }

  void _changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LokBooks',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: _locale,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ListenableBuilder(
        listenable: _authController,
        builder: (context, child) {
          if (_authController.isRestoring) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (_authController.isAuthenticated) {
            return MainShell(
              authController: _authController,
              locale: _locale,
              onLocaleChanged: _changeLocale,
            );
          }

          return LoginPage(
            authController: _authController,
          );
        },
      ),
    );
  }
}
