// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginEmail => 'Correo electrónico';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginNoAccount => '¿No tienes una cuenta?';

  @override
  String get loginRegister => 'Regístrate';

  @override
  String get loginEmailRequired => 'Introduce tu correo electrónico';

  @override
  String get loginEmailInvalid => 'Introduce un correo electrónico válido';

  @override
  String get loginPasswordRequired => 'Introduce tu contraseña';

  @override
  String get loginInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get loginConnectionError => 'No se pudo conectar con el servidor.';

  @override
  String get loginServerError =>
      'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get loginAdminSuccess => 'Sesión iniciada como administrador.';

  @override
  String get loginUserSuccess =>
      'Sesión iniciada como usuario de la biblioteca.';
}
