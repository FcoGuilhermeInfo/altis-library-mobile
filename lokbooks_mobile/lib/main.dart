
import 'package:flutter/material.dart';

import 'core/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/pages/login_page.dart';

void main() {
  runApp(const LokBooksApp());
}

class LokBooksApp extends StatelessWidget {
  const LokBooksApp({super.key});

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
      home: const LoginPage(),
    );
  }
}
