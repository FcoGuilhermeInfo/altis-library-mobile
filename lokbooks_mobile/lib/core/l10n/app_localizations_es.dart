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

  @override
  String get forgotPasswordTitle => 'Recuperar Contraseña';

  @override
  String get forgotPasswordDescription =>
      'Introduce tu correo y CPF registrados para continuar.';

  @override
  String get forgotPasswordSubmit => 'Continuar';

  @override
  String get forgotPasswordInvalidCredentials =>
      'No pudimos verificar los datos proporcionados.';

  @override
  String get forgotPasswordInvalidData =>
      'Comprueba el correo y CPF introducidos.';

  @override
  String get passwordResetTooManyRequests =>
      'Demasiados intentos. Espera e inténtalo de nuevo.';

  @override
  String get resetPasswordTitle => 'Cambiar Contraseña';

  @override
  String get resetPasswordDescription =>
      'Introduce y confirma tu nueva contraseña.';

  @override
  String get resetPasswordNewPassword => 'Nueva Contraseña';

  @override
  String get resetPasswordSubmit => 'Cambiar';

  @override
  String get resetPasswordInvalidToken =>
      'La sesión de recuperación ha caducado o el token no es válido. Solicita uno nuevo.';

  @override
  String get resetPasswordInvalidData =>
      'Comprueba los datos de la nueva contraseña.';

  @override
  String get resetPasswordSuccess =>
      '¡Contraseña restablecida correctamente! Inicia sesión.';

  @override
  String get menuOpen => 'Abrir menú';

  @override
  String get menuDashboard => 'Panel principal';

  @override
  String get menuLoans => 'Préstamos';

  @override
  String get menuUsers => 'Usuarios';

  @override
  String get menuPublishers => 'Editoriales';

  @override
  String get menuBooks => 'Libros';

  @override
  String get menuProfile => 'Perfil';

  @override
  String get menuChangeLanguage => 'Cambiar idioma';

  @override
  String get menuLogout => 'Cerrar sesión';

  @override
  String get dashboardPlaceholder => 'Panel provisional';

  @override
  String get moduleUnderDevelopment => 'En desarrollo';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleUser => 'Usuario de la biblioteca';

  @override
  String get actionClose => 'Cerrar';

  @override
  String get logoutError => 'No se pudo cerrar la sesión. Inténtalo de nuevo.';

  @override
  String get languageDialogTitle => 'Idiomas';

  @override
  String get languageDialogSave => 'GUARDAR';

  @override
  String get usersSearchHint => 'Buscar usuarios por nombre';

  @override
  String get usersName => 'Nombre';

  @override
  String get usersCpf => 'CPF';

  @override
  String get usersStatus => 'Estado';

  @override
  String get usersActive => 'Activo';

  @override
  String get usersInactive => 'Inactivo';

  @override
  String get usersActions => 'Acciones del usuario';

  @override
  String get usersPrevious => 'Anterior';

  @override
  String get usersNext => 'Siguiente';

  @override
  String usersShowing(int start, int end, int total) {
    return 'Mostrando de $start a $end de $total usuarios';
  }

  @override
  String get usersEmpty => 'No se encontraron usuarios.';

  @override
  String get usersRetry => 'Intentar de nuevo';

  @override
  String get usersLoadError => 'No se pudieron cargar los usuarios.';

  @override
  String get usersUnauthorized =>
      'Tu sesión ha caducado. Inicia sesión de nuevo.';

  @override
  String get usersForbidden => 'No tienes permiso para acceder a esta función.';

  @override
  String get usersActivate => 'Activar usuario';

  @override
  String get usersInactivate => 'Desactivar usuario';

  @override
  String get usersConfirmActivate => '¿Quieres activar este usuario?';

  @override
  String get usersConfirmInactivate => '¿Quieres desactivar este usuario?';

  @override
  String get usersCancel => 'Cancelar';

  @override
  String get usersConfirm => 'Confirmar';

  @override
  String get usersStatusUpdated => 'Estado actualizado correctamente.';

  @override
  String get usersDetailsTitle => 'Ver detalles';

  @override
  String get usersViewDetails => 'Ver detalles';

  @override
  String get usersCreatedAt => 'Fecha de creación';

  @override
  String get usersUpdatedAt => 'Última actualización';

  @override
  String get publishersSearch => 'Buscar editoriales por nombre';

  @override
  String get publishersNew => 'Registrar nueva editorial';

  @override
  String get publishersCreateTitle => 'Registrar Editorial';

  @override
  String get publishersEditTitle => 'Editar Editorial';

  @override
  String get publishersSite => 'Sitio web';

  @override
  String get publishersCreate => 'Registrar';

  @override
  String get publishersEdit => 'Editar';

  @override
  String get publishersDelete => 'Eliminar Editorial';

  @override
  String get publishersDeleteConfirmation =>
      '¿Seguro que quieres eliminar esta editorial?';

  @override
  String get publishersDeleteConflict =>
      'No se puede eliminar una editorial con libros relacionados.';

  @override
  String get publishersInvalidData => 'Comprueba los datos de la editorial.';

  @override
  String get publishersInvalidPhone =>
      'Introduce un teléfono válido con código de área.';

  @override
  String get publishersInvalidSite => 'Introduce una dirección web válida.';

  @override
  String get publishersConflict =>
      'No se pudo completar la operación debido a un conflicto.';

  @override
  String get publishersNotFound => 'Editorial no encontrada.';

  @override
  String get publishersError =>
      'No se pudo completar la operación con la editorial.';

  @override
  String get publishersEmpty => 'No se encontraron editoriales.';

  @override
  String get publishersSuccess => 'Operación completada correctamente.';

  @override
  String publishersShowing(int start, int end, int total) {
    return 'Mostrando de $start a $end de $total editoriales';
  }

  @override
  String get booksSearch => 'Buscar libros por título';

  @override
  String get booksNew => 'Registrar nuevo libro';

  @override
  String get booksCreateTitle => 'Registrar Libro';

  @override
  String get booksEditTitle => 'Editar Libro';

  @override
  String get booksTitle => 'Título';

  @override
  String get booksAuthor => 'Autor';

  @override
  String get booksYear => 'Año';

  @override
  String get booksPublisher => 'Editorial';

  @override
  String get booksTotalQuantity => 'Cantidad total';

  @override
  String get booksTotalShort => 'Total';

  @override
  String get booksAvailableShort => 'Disponible';

  @override
  String get booksBorrowedShort => 'Prestada';

  @override
  String get booksCreate => 'Registrar';

  @override
  String get booksEdit => 'Editar';

  @override
  String get booksDelete => 'Eliminar Libro';

  @override
  String get booksDeleteConfirmation =>
      '¿Seguro que quieres eliminar este libro?';

  @override
  String get booksDeleteConflict =>
      'No se puede eliminar un libro que tenga préstamos relacionados.';

  @override
  String get booksInvalidData => 'Comprueba los datos del libro.';

  @override
  String get booksInvalidYear => 'Introduce un año entre 1 y 32767.';

  @override
  String get booksInvalidQuantity =>
      'La cantidad total debe ser mayor que cero.';

  @override
  String get booksQuantityBelowBorrowed =>
      'La cantidad total no puede ser inferior a la cantidad prestada.';

  @override
  String get booksPublisherLoadError =>
      'No se pudieron cargar las editoriales.';

  @override
  String get booksConflict =>
      'Este libro puede estar registrado o existe un conflicto con los datos proporcionados.';

  @override
  String get booksNotFound => 'Libro no encontrado.';

  @override
  String get booksError => 'No se pudo completar la operación con el libro.';

  @override
  String get booksEmpty => 'No se encontraron libros.';

  @override
  String get booksSuccess => 'Operación completada correctamente.';

  @override
  String booksShowing(int start, int end, int total) {
    return 'Mostrando de $start a $end de $total libros';
  }

  @override
  String get loansSearch => 'Buscar préstamos por usuario';

  @override
  String get loansNew => 'Registrar nuevo préstamo';

  @override
  String get loansCreateTitle => 'Realizar Préstamo';

  @override
  String get loansCreate => 'Realizar Préstamo';

  @override
  String get loansDetailsTitle => 'Detalles del Préstamo';

  @override
  String get loansViewDetails => 'Ver detalles';

  @override
  String get loansMember => 'Usuario';

  @override
  String get loansBook => 'Libro';

  @override
  String get loansBorrowedAt => 'Fecha del Préstamo';

  @override
  String get loansDueDate => 'Devolución Prevista';

  @override
  String get loansReturnedAt => 'Fecha de Devolución';

  @override
  String get loansSelectDate => 'Selecciona una fecha';

  @override
  String get loansBorrowed => 'Prestado';

  @override
  String get loansOverdue => 'Atrasado';

  @override
  String get loansReturned => 'Finalizado';

  @override
  String get loansUnknown => 'Desconocido';

  @override
  String get loansReturn => 'Confirmar Devolución';

  @override
  String get loansReturnConfirmation =>
      '¿Quieres confirmar la devolución de este libro?';

  @override
  String get loansRecentTitle => 'Últimos Préstamos Realizados';

  @override
  String get loansFullHistory => 'Ver historial completo';

  @override
  String get loansHistoryTitle => 'Historial de Préstamos';

  @override
  String get loansEmptyHistory => 'No hay préstamos finalizados.';

  @override
  String get loansEmpty => 'No se encontraron préstamos activos.';

  @override
  String get loansOptionsLoadError =>
      'No se pudieron cargar usuarios y libros.';

  @override
  String get loansInvalidDueDate => 'La devolución prevista debe ser futura.';

  @override
  String get loansNotFound => 'Préstamo no encontrado.';

  @override
  String get loansOperationError => 'No se pudo completar la operación.';

  @override
  String get loansCreatedSuccess => 'Préstamo registrado correctamente.';

  @override
  String get loansReturnedSuccess => 'Devolución confirmada correctamente.';

  @override
  String loansShowing(int start, int end, int total) {
    return 'Mostrando de $start a $end de $total préstamos';
  }

  @override
  String get profileEdit => 'Editar perfil';

  @override
  String get profileSaveChanges => 'Guardar cambios';

  @override
  String get profileLoadError => 'No se pudo cargar el perfil.';

  @override
  String get profileSaveSuccess => '¡Cambios guardados correctamente!';

  @override
  String get profilePasswordSuccess => '¡Contraseña cambiada correctamente!';

  @override
  String get profileCurrentPassword => 'Contraseña actual';

  @override
  String get profileNewPassword => 'Nueva contraseña';

  @override
  String get profileConfirmPassword => 'Confirmar contraseña';

  @override
  String get profileCurrentPasswordRequired =>
      'Introduce tu contraseña actual.';

  @override
  String get profileNewPasswordRequired => 'Introduce una nueva contraseña.';

  @override
  String get profileConfirmPasswordRequired => 'Confirma tu nueva contraseña.';

  @override
  String get profilePasswordLength =>
      'La nueva contraseña debe tener entre 8 y 15 caracteres.';

  @override
  String get profilePasswordMustDiffer =>
      'La nueva contraseña debe ser diferente de la actual.';

  @override
  String get profilePasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get profileShowPassword => 'Mostrar contraseña';

  @override
  String get profileHidePassword => 'Ocultar contraseña';

  @override
  String get profilePhoneInvalid =>
      'El teléfono debe contener 10 u 11 dígitos.';

  @override
  String get profileUnauthorized => 'Tu autenticación no fue autorizada.';

  @override
  String get profileForbidden => 'No tienes permiso para realizar este cambio.';

  @override
  String get profileInvalidData => 'Comprueba los datos introducidos.';

  @override
  String get profileConnectionError => 'No se pudo conectar con el servidor.';

  @override
  String get profileSaveError => 'No se pudieron guardar los cambios.';

  @override
  String get profilePasswordError =>
      'No se pudo cambiar la contraseña. Comprueba tu contraseña actual y los datos introducidos.';

  @override
  String get profilePartialSuccess =>
      'Los datos personales se guardaron, pero la contraseña no se cambió.';

  @override
  String get profileUnexpectedError =>
      'Ocurrió un error al guardar los cambios.';
}
