import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @loginForgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu sua senha?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In pt, this message translates to:
  /// **'Não tem uma conta?'**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In pt, this message translates to:
  /// **'Cadastre-se'**
  String get loginRegister;

  /// No description provided for @loginEmailRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Informe um e-mail válido'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe sua senha'**
  String get loginPasswordRequired;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'E-mail ou senha inválidos.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível conectar ao servidor.'**
  String get loginConnectionError;

  /// No description provided for @loginServerError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível realizar o login. Tente novamente.'**
  String get loginServerError;

  /// No description provided for @loginAdminSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Autenticado como administrador.'**
  String get loginAdminSuccess;

  /// No description provided for @loginUserSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Autenticado como locatário.'**
  String get loginUserSuccess;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro'**
  String get registerTitle;

  /// No description provided for @registerName.
  ///
  /// In pt, this message translates to:
  /// **'Nome Completo'**
  String get registerName;

  /// No description provided for @registerBirthDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de Nascimento'**
  String get registerBirthDate;

  /// No description provided for @registerCpf.
  ///
  /// In pt, this message translates to:
  /// **'CPF'**
  String get registerCpf;

  /// No description provided for @registerPhone.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get registerPhone;

  /// No description provided for @registerAddress.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get registerAddress;

  /// No description provided for @registerEmail.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get registerEmail;

  /// No description provided for @registerPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get registerPassword;

  /// No description provided for @registerConfirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Senha'**
  String get registerConfirmPassword;

  /// No description provided for @registerSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get registerSubmit;

  /// No description provided for @registerBackToLogin.
  ///
  /// In pt, this message translates to:
  /// **'Já tem uma conta?'**
  String get registerBackToLogin;

  /// No description provided for @registerRequired.
  ///
  /// In pt, this message translates to:
  /// **'Este campo é obrigatório'**
  String get registerRequired;

  /// No description provided for @registerInvalidCpf.
  ///
  /// In pt, this message translates to:
  /// **'O CPF deve conter 11 dígitos'**
  String get registerInvalidCpf;

  /// No description provided for @registerInvalidPhone.
  ///
  /// In pt, this message translates to:
  /// **'Informe um celular com DDD e 11 dígitos'**
  String get registerInvalidPhone;

  /// No description provided for @registerInvalidDate.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma data de nascimento válida'**
  String get registerInvalidDate;

  /// No description provided for @registerInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'Informe um e-mail válido do Gmail'**
  String get registerInvalidEmail;

  /// No description provided for @registerInvalidPassword.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter entre 8 e 15 caracteres'**
  String get registerInvalidPassword;

  /// No description provided for @registerPasswordMismatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem'**
  String get registerPasswordMismatch;

  /// No description provided for @registerSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro realizado com sucesso! Faça seu login.'**
  String get registerSuccess;

  /// No description provided for @registerInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Verifique os dados informados e tente novamente.'**
  String get registerInvalidData;

  /// No description provided for @registerForbidden.
  ///
  /// In pt, this message translates to:
  /// **'O cadastro não está disponível sem autorização.'**
  String get registerForbidden;

  /// No description provided for @registerConflict.
  ///
  /// In pt, this message translates to:
  /// **'Já existe um cadastro com esses dados.'**
  String get registerConflict;

  /// No description provided for @registerServerError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível realizar o cadastro. Tente novamente.'**
  String get registerServerError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
