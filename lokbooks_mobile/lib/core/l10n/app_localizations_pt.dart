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

  @override
  String get loginEmailRequired => 'Informe seu e-mail';

  @override
  String get loginEmailInvalid => 'Informe um e-mail válido';

  @override
  String get loginPasswordRequired => 'Informe sua senha';

  @override
  String get loginInvalidCredentials => 'E-mail ou senha inválidos.';

  @override
  String get loginConnectionError => 'Não foi possível conectar ao servidor.';

  @override
  String get loginServerError =>
      'Não foi possível realizar o login. Tente novamente.';

  @override
  String get loginAdminSuccess => 'Autenticado como administrador.';

  @override
  String get loginUserSuccess => 'Autenticado como locatário.';
}
