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

  @override
  String get registerTitle => 'Registro';

  @override
  String get registerName => 'Nombre completo';

  @override
  String get registerBirthDate => 'Fecha de nacimiento';

  @override
  String get registerCpf => 'CPF';

  @override
  String get registerPhone => 'Teléfono';

  @override
  String get registerAddress => 'Dirección';

  @override
  String get registerEmail => 'Correo electrónico';

  @override
  String get registerPassword => 'Contraseña';

  @override
  String get registerConfirmPassword => 'Confirmar contraseña';

  @override
  String get registerSubmit => 'Entrar';

  @override
  String get registerBackToLogin => '¿Ya tienes una cuenta?';

  @override
  String get registerRequired => 'Este campo es obligatorio';

  @override
  String get registerInvalidCpf => 'El CPF debe contener 11 dígitos';

  @override
  String get registerInvalidPhone =>
      'Introduce un móvil de 11 dígitos con código de área';

  @override
  String get registerInvalidDate => 'Introduce una fecha de nacimiento válida';

  @override
  String get registerInvalidEmail => 'Introduce una dirección válida de Gmail';

  @override
  String get registerInvalidPassword =>
      'La contraseña debe tener entre 8 y 15 caracteres';

  @override
  String get registerPasswordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerSuccess => '¡Registro completado! Inicia sesión.';

  @override
  String get registerInvalidData => 'Comprueba los datos e inténtalo de nuevo.';

  @override
  String get registerForbidden =>
      'El registro no está disponible sin autorización.';

  @override
  String get registerConflict => 'Ya existe una cuenta con estos datos.';

  @override
  String get registerServerError =>
      'No se pudo completar el registro. Inténtalo de nuevo.';
}
