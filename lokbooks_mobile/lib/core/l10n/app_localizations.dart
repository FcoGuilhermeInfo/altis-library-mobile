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

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recuperar Senha'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu e-mail e CPF cadastrados para continuar.'**
  String get forgotPasswordDescription;

  /// No description provided for @forgotPasswordSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get forgotPasswordSubmit;

  /// No description provided for @forgotPasswordInvalidCredentials.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível confirmar os dados informados.'**
  String get forgotPasswordInvalidCredentials;

  /// No description provided for @forgotPasswordInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Verifique o e-mail e o CPF informados.'**
  String get forgotPasswordInvalidData;

  /// No description provided for @passwordResetTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Muitas tentativas. Aguarde e tente novamente.'**
  String get passwordResetTooManyRequests;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In pt, this message translates to:
  /// **'Alterar Senha'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In pt, this message translates to:
  /// **'Digite sua nova senha e confirme para finalizar.'**
  String get resetPasswordDescription;

  /// No description provided for @resetPasswordNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Nova Senha'**
  String get resetPasswordNewPassword;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Alterar'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordInvalidToken.
  ///
  /// In pt, this message translates to:
  /// **'O prazo de recuperação expirou ou o token é inválido. Solicite novamente.'**
  String get resetPasswordInvalidToken;

  /// No description provided for @resetPasswordInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Verifique os dados da nova senha.'**
  String get resetPasswordInvalidData;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Senha redefinida com sucesso! Faça seu login.'**
  String get resetPasswordSuccess;

  /// No description provided for @menuOpen.
  ///
  /// In pt, this message translates to:
  /// **'Abrir menu'**
  String get menuOpen;

  /// No description provided for @menuDashboard.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard'**
  String get menuDashboard;

  /// No description provided for @menuLoans.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimos'**
  String get menuLoans;

  /// No description provided for @menuUsers.
  ///
  /// In pt, this message translates to:
  /// **'Usuários'**
  String get menuUsers;

  /// No description provided for @menuPublishers.
  ///
  /// In pt, this message translates to:
  /// **'Editoras'**
  String get menuPublishers;

  /// No description provided for @menuBooks.
  ///
  /// In pt, this message translates to:
  /// **'Livros'**
  String get menuBooks;

  /// No description provided for @menuProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get menuProfile;

  /// No description provided for @menuChangeLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Trocar Idioma'**
  String get menuChangeLanguage;

  /// No description provided for @menuLogout.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar Sessão'**
  String get menuLogout;

  /// No description provided for @dashboardPlaceholder.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard Provisorio'**
  String get dashboardPlaceholder;

  /// No description provided for @moduleUnderDevelopment.
  ///
  /// In pt, this message translates to:
  /// **'Em desenvolvimento'**
  String get moduleUnderDevelopment;

  /// No description provided for @roleAdmin.
  ///
  /// In pt, this message translates to:
  /// **'Administrador'**
  String get roleAdmin;

  /// No description provided for @roleUser.
  ///
  /// In pt, this message translates to:
  /// **'Locatário'**
  String get roleUser;

  /// No description provided for @actionClose.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get actionClose;

  /// No description provided for @logoutError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível sair. Tente novamente.'**
  String get logoutError;

  /// No description provided for @languageDialogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Idiomas'**
  String get languageDialogTitle;

  /// No description provided for @languageDialogSave.
  ///
  /// In pt, this message translates to:
  /// **'SALVAR'**
  String get languageDialogSave;

  /// No description provided for @usersSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar usuário por nome'**
  String get usersSearchHint;

  /// No description provided for @usersName.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get usersName;

  /// No description provided for @usersCpf.
  ///
  /// In pt, this message translates to:
  /// **'CPF'**
  String get usersCpf;

  /// No description provided for @usersStatus.
  ///
  /// In pt, this message translates to:
  /// **'Status'**
  String get usersStatus;

  /// No description provided for @usersActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativo'**
  String get usersActive;

  /// No description provided for @usersInactive.
  ///
  /// In pt, this message translates to:
  /// **'Inativo'**
  String get usersInactive;

  /// No description provided for @usersActions.
  ///
  /// In pt, this message translates to:
  /// **'Ações do usuário'**
  String get usersActions;

  /// No description provided for @usersPrevious.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get usersPrevious;

  /// No description provided for @usersNext.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get usersNext;

  /// No description provided for @usersShowing.
  ///
  /// In pt, this message translates to:
  /// **'Mostrando {start} a {end} de {total} usuários'**
  String usersShowing(int start, int end, int total);

  /// No description provided for @usersEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum usuário encontrado.'**
  String get usersEmpty;

  /// No description provided for @usersRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get usersRetry;

  /// No description provided for @usersLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os usuários.'**
  String get usersLoadError;

  /// No description provided for @usersUnauthorized.
  ///
  /// In pt, this message translates to:
  /// **'Sua sessão expirou. Entre novamente.'**
  String get usersUnauthorized;

  /// No description provided for @usersForbidden.
  ///
  /// In pt, this message translates to:
  /// **'Você não tem permissão para acessar esta funcionalidade.'**
  String get usersForbidden;

  /// No description provided for @usersActivate.
  ///
  /// In pt, this message translates to:
  /// **'Ativar locatário'**
  String get usersActivate;

  /// No description provided for @usersInactivate.
  ///
  /// In pt, this message translates to:
  /// **'Inativar locatário'**
  String get usersInactivate;

  /// No description provided for @usersConfirmActivate.
  ///
  /// In pt, this message translates to:
  /// **'Deseja ativar este locatário?'**
  String get usersConfirmActivate;

  /// No description provided for @usersConfirmInactivate.
  ///
  /// In pt, this message translates to:
  /// **'Deseja inativar este locatário?'**
  String get usersConfirmInactivate;

  /// No description provided for @usersCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get usersCancel;

  /// No description provided for @usersConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get usersConfirm;

  /// No description provided for @usersStatusUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Status atualizado com sucesso.'**
  String get usersStatusUpdated;

  /// No description provided for @usersDetailsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar detalhes'**
  String get usersDetailsTitle;

  /// No description provided for @usersViewDetails.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar detalhes'**
  String get usersViewDetails;

  /// No description provided for @usersCreatedAt.
  ///
  /// In pt, this message translates to:
  /// **'Data de criação'**
  String get usersCreatedAt;

  /// No description provided for @usersUpdatedAt.
  ///
  /// In pt, this message translates to:
  /// **'Última atualização'**
  String get usersUpdatedAt;

  /// No description provided for @publishersSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar Editora por Nome'**
  String get publishersSearch;

  /// No description provided for @publishersNew.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar nova editora'**
  String get publishersNew;

  /// No description provided for @publishersCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar Editora'**
  String get publishersCreateTitle;

  /// No description provided for @publishersEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Editora'**
  String get publishersEditTitle;

  /// No description provided for @publishersSite.
  ///
  /// In pt, this message translates to:
  /// **'Site'**
  String get publishersSite;

  /// No description provided for @publishersCreate.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get publishersCreate;

  /// No description provided for @publishersEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get publishersEdit;

  /// No description provided for @publishersDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Editora'**
  String get publishersDelete;

  /// No description provided for @publishersDeleteConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza de que deseja excluir esta editora?'**
  String get publishersDeleteConfirmation;

  /// No description provided for @publishersDeleteConflict.
  ///
  /// In pt, this message translates to:
  /// **'Não é possível excluir uma editora que possui livros relacionados.'**
  String get publishersDeleteConflict;

  /// No description provided for @publishersInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Verifique os dados informados da editora.'**
  String get publishersInvalidData;

  /// No description provided for @publishersInvalidPhone.
  ///
  /// In pt, this message translates to:
  /// **'Informe um telefone com DDD válido.'**
  String get publishersInvalidPhone;

  /// No description provided for @publishersInvalidSite.
  ///
  /// In pt, this message translates to:
  /// **'Informe um endereço de site válido.'**
  String get publishersInvalidSite;

  /// No description provided for @publishersConflict.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir a operação devido a um conflito.'**
  String get publishersConflict;

  /// No description provided for @publishersNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Editora não encontrada.'**
  String get publishersNotFound;

  /// No description provided for @publishersError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir a operação com a editora.'**
  String get publishersError;

  /// No description provided for @publishersEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma editora encontrada.'**
  String get publishersEmpty;

  /// No description provided for @publishersSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Operação realizada com sucesso.'**
  String get publishersSuccess;

  /// No description provided for @publishersShowing.
  ///
  /// In pt, this message translates to:
  /// **'Mostrando {start} a {end} de {total} editoras'**
  String publishersShowing(int start, int end, int total);

  /// No description provided for @booksSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar Livro por Nome'**
  String get booksSearch;

  /// No description provided for @booksNew.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar novo livro'**
  String get booksNew;

  /// No description provided for @booksCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar Livro'**
  String get booksCreateTitle;

  /// No description provided for @booksEditTitle.
  ///
  /// In pt, this message translates to:
  /// **'Editar Livro'**
  String get booksEditTitle;

  /// No description provided for @booksTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get booksTitle;

  /// No description provided for @booksAuthor.
  ///
  /// In pt, this message translates to:
  /// **'Autor'**
  String get booksAuthor;

  /// No description provided for @booksYear.
  ///
  /// In pt, this message translates to:
  /// **'Ano'**
  String get booksYear;

  /// No description provided for @booksPublisher.
  ///
  /// In pt, this message translates to:
  /// **'Editora'**
  String get booksPublisher;

  /// No description provided for @booksTotalQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade total'**
  String get booksTotalQuantity;

  /// No description provided for @booksTotalShort.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get booksTotalShort;

  /// No description provided for @booksAvailableShort.
  ///
  /// In pt, this message translates to:
  /// **'Disponível'**
  String get booksAvailableShort;

  /// No description provided for @booksBorrowedShort.
  ///
  /// In pt, this message translates to:
  /// **'Emprestada'**
  String get booksBorrowedShort;

  /// No description provided for @booksCreate.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get booksCreate;

  /// No description provided for @booksEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get booksEdit;

  /// No description provided for @booksDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir Livro'**
  String get booksDelete;

  /// No description provided for @booksDeleteConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza de que deseja excluir este livro?'**
  String get booksDeleteConfirmation;

  /// No description provided for @booksDeleteConflict.
  ///
  /// In pt, this message translates to:
  /// **'Não é possível excluir um livro que possui empréstimos relacionados.'**
  String get booksDeleteConflict;

  /// No description provided for @booksInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Verifique os dados informados do livro.'**
  String get booksInvalidData;

  /// No description provided for @booksInvalidYear.
  ///
  /// In pt, this message translates to:
  /// **'Informe um ano entre 1 e 32767.'**
  String get booksInvalidYear;

  /// No description provided for @booksInvalidQuantity.
  ///
  /// In pt, this message translates to:
  /// **'A quantidade total deve ser maior que zero.'**
  String get booksInvalidQuantity;

  /// No description provided for @booksQuantityBelowBorrowed.
  ///
  /// In pt, this message translates to:
  /// **'A quantidade total não pode ser menor que a quantidade emprestada.'**
  String get booksQuantityBelowBorrowed;

  /// No description provided for @booksPublisherLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar as editoras.'**
  String get booksPublisherLoadError;

  /// No description provided for @booksConflict.
  ///
  /// In pt, this message translates to:
  /// **'Este livro já pode estar cadastrado ou existe um conflito com os dados informados.'**
  String get booksConflict;

  /// No description provided for @booksNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Livro não encontrado.'**
  String get booksNotFound;

  /// No description provided for @booksError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir a operação com o livro.'**
  String get booksError;

  /// No description provided for @booksEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum livro encontrado.'**
  String get booksEmpty;

  /// No description provided for @booksSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Operação realizada com sucesso.'**
  String get booksSuccess;

  /// No description provided for @booksShowing.
  ///
  /// In pt, this message translates to:
  /// **'Mostrando {start} a {end} de {total} livros'**
  String booksShowing(int start, int end, int total);

  /// No description provided for @loansSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar empréstimo por locatário'**
  String get loansSearch;

  /// No description provided for @loansNew.
  ///
  /// In pt, this message translates to:
  /// **'Registrar novo empréstimo'**
  String get loansNew;

  /// No description provided for @loansCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Realizar Empréstimo'**
  String get loansCreateTitle;

  /// No description provided for @loansCreate.
  ///
  /// In pt, this message translates to:
  /// **'Realizar Empréstimo'**
  String get loansCreate;

  /// No description provided for @loansDetailsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do Empréstimo'**
  String get loansDetailsTitle;

  /// No description provided for @loansViewDetails.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar detalhes'**
  String get loansViewDetails;

  /// No description provided for @loansMember.
  ///
  /// In pt, this message translates to:
  /// **'Locatário'**
  String get loansMember;

  /// No description provided for @loansBook.
  ///
  /// In pt, this message translates to:
  /// **'Livro'**
  String get loansBook;

  /// No description provided for @loansBorrowedAt.
  ///
  /// In pt, this message translates to:
  /// **'Data do Empréstimo'**
  String get loansBorrowedAt;

  /// No description provided for @loansDueDate.
  ///
  /// In pt, this message translates to:
  /// **'Devolução Prevista'**
  String get loansDueDate;

  /// No description provided for @loansReturnedAt.
  ///
  /// In pt, this message translates to:
  /// **'Data da Devolução'**
  String get loansReturnedAt;

  /// No description provided for @loansSelectDate.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma data'**
  String get loansSelectDate;

  /// No description provided for @loansBorrowed.
  ///
  /// In pt, this message translates to:
  /// **'Emprestado'**
  String get loansBorrowed;

  /// No description provided for @loansOverdue.
  ///
  /// In pt, this message translates to:
  /// **'Atrasado'**
  String get loansOverdue;

  /// No description provided for @loansReturned.
  ///
  /// In pt, this message translates to:
  /// **'Finalizado'**
  String get loansReturned;

  /// No description provided for @loansUnknown.
  ///
  /// In pt, this message translates to:
  /// **'Desconhecido'**
  String get loansUnknown;

  /// No description provided for @loansReturn.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar Devolução'**
  String get loansReturn;

  /// No description provided for @loansReturnConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Deseja confirmar a devolução deste livro?'**
  String get loansReturnConfirmation;

  /// No description provided for @loansRecentTitle.
  ///
  /// In pt, this message translates to:
  /// **'Últimos Empréstimos Realizados'**
  String get loansRecentTitle;

  /// No description provided for @loansFullHistory.
  ///
  /// In pt, this message translates to:
  /// **'Ver histórico completo'**
  String get loansFullHistory;

  /// No description provided for @loansHistoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de Empréstimos'**
  String get loansHistoryTitle;

  /// No description provided for @loansEmptyHistory.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum empréstimo finalizado.'**
  String get loansEmptyHistory;

  /// No description provided for @loansEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum empréstimo ativo encontrado.'**
  String get loansEmpty;

  /// No description provided for @loansOptionsLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar locatários e livros.'**
  String get loansOptionsLoadError;

  /// No description provided for @loansInvalidDueDate.
  ///
  /// In pt, this message translates to:
  /// **'A devolução prevista deve ser futura.'**
  String get loansInvalidDueDate;

  /// No description provided for @loansNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimo não encontrado.'**
  String get loansNotFound;

  /// No description provided for @loansOperationError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir a operação.'**
  String get loansOperationError;

  /// No description provided for @loansCreatedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Empréstimo registrado com sucesso.'**
  String get loansCreatedSuccess;

  /// No description provided for @loansReturnedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Devolução confirmada com sucesso.'**
  String get loansReturnedSuccess;

  /// No description provided for @loansShowing.
  ///
  /// In pt, this message translates to:
  /// **'Mostrando {start} a {end} de {total} empréstimos'**
  String loansShowing(int start, int end, int total);
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
