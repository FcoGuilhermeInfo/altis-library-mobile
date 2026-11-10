// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Senha';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginForgotPassword => 'Esqueceu sua senha?';

  @override
  String get loginNoAccount => 'Não tem uma conta?';

  @override
  String get loginRegister => 'Cadastre-se';
}
