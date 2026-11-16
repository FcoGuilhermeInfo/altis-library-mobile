
import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_theme.dart';
import 'package:lokbooks_mobile/modules/auth/controllers/auth_controller.dart';
import 'package:lokbooks_mobile/modules/auth/presentation/pages/login_page.dart';

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

  @override
  void initState() {
    super.initState();
    _authController.restoreSession();
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
      locale: const Locale('pt'),
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

          return LoginPage(
            authController: _authController,
          );
        },
      ),
    );
  }
}
