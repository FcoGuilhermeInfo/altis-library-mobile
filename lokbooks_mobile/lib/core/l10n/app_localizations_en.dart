// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginRegister => 'Sign up';

  @override
  String get loginEmailRequired => 'Enter your email';

  @override
  String get loginEmailInvalid => 'Enter a valid email address';

  @override
  String get loginPasswordRequired => 'Enter your password';

  @override
  String get loginInvalidCredentials => 'Invalid email or password.';

  @override
  String get loginConnectionError => 'Could not connect to the server.';

  @override
  String get loginServerError => 'Could not sign in. Please try again.';

  @override
  String get loginAdminSuccess => 'Signed in as administrator.';

  @override
  String get loginUserSuccess => 'Signed in as library member.';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerName => 'Full name';

  @override
  String get registerBirthDate => 'Date of birth';

  @override
  String get registerCpf => 'CPF';

  @override
  String get registerPhone => 'Phone number';

  @override
  String get registerAddress => 'Address';

  @override
  String get registerEmail => 'Email';

  @override
  String get registerPassword => 'Password';

  @override
  String get registerConfirmPassword => 'Confirm Password';

  @override
  String get registerSubmit => 'Sign in';

  @override
  String get registerBackToLogin => 'Already have an account?';

  @override
  String get registerRequired => 'This field is required';

  @override
  String get registerInvalidCpf => 'CPF must contain 11 digits';

  @override
  String get registerInvalidPhone =>
      'Enter an 11-digit mobile number with area code';

  @override
  String get registerInvalidDate => 'Enter a valid date of birth';

  @override
  String get registerInvalidEmail => 'Enter a valid Gmail address';

  @override
  String get registerInvalidPassword =>
      'Password must contain 8 to 15 characters';

  @override
  String get registerPasswordMismatch => 'Passwords do not match';

  @override
  String get registerSuccess => 'Registration successful! Please sign in.';

  @override
  String get registerInvalidData =>
      'Check the information provided and try again.';

  @override
  String get registerForbidden =>
      'Registration is not available without authorization.';

  @override
  String get registerConflict =>
      'An account with this information already exists.';

  @override
  String get registerServerError =>
      'Could not complete registration. Please try again.';
}
