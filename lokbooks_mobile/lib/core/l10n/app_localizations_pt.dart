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

  @override
  String get registerTitle => 'Cadastro';

  @override
  String get registerName => 'Nome Completo';

  @override
  String get registerBirthDate => 'Data de Nascimento';

  @override
  String get registerCpf => 'CPF';

  @override
  String get registerPhone => 'Telefone';

  @override
  String get registerAddress => 'Endereço';

  @override
  String get registerEmail => 'E-mail';

  @override
  String get registerPassword => 'Senha';

  @override
  String get registerConfirmPassword => 'Confirmar Senha';

  @override
  String get registerSubmit => 'Entrar';

  @override
  String get registerBackToLogin => 'Já tem uma conta?';

  @override
  String get registerRequired => 'Este campo é obrigatório';

  @override
  String get registerInvalidCpf => 'O CPF deve conter 11 dígitos';

  @override
  String get registerInvalidPhone => 'Informe um celular com DDD e 11 dígitos';

  @override
  String get registerInvalidDate => 'Informe uma data de nascimento válida';

  @override
  String get registerInvalidEmail => 'Informe um e-mail válido do Gmail';

  @override
  String get registerInvalidPassword =>
      'A senha deve ter entre 8 e 15 caracteres';

  @override
  String get registerPasswordMismatch => 'As senhas não coincidem';

  @override
  String get registerSuccess =>
      'Cadastro realizado com sucesso! Faça seu login.';

  @override
  String get registerInvalidData =>
      'Verifique os dados informados e tente novamente.';

  @override
  String get registerForbidden =>
      'O cadastro não está disponível sem autorização.';

  @override
  String get registerConflict => 'Já existe um cadastro com esses dados.';

  @override
  String get registerServerError =>
      'Não foi possível realizar o cadastro. Tente novamente.';

  @override
  String get forgotPasswordTitle => 'Recuperar Senha';

  @override
  String get forgotPasswordDescription =>
      'Informe seu e-mail e CPF cadastrados para continuar.';

  @override
  String get forgotPasswordSubmit => 'Continuar';

  @override
  String get forgotPasswordInvalidCredentials =>
      'Não foi possível confirmar os dados informados.';

  @override
  String get forgotPasswordInvalidData =>
      'Verifique o e-mail e o CPF informados.';

  @override
  String get passwordResetTooManyRequests =>
      'Muitas tentativas. Aguarde e tente novamente.';

  @override
  String get resetPasswordTitle => 'Alterar Senha';

  @override
  String get resetPasswordDescription =>
      'Digite sua nova senha e confirme para finalizar.';

  @override
  String get resetPasswordNewPassword => 'Nova Senha';

  @override
  String get resetPasswordSubmit => 'Alterar';

  @override
  String get resetPasswordInvalidToken =>
      'O prazo de recuperação expirou ou o token é inválido. Solicite novamente.';

  @override
  String get resetPasswordInvalidData => 'Verifique os dados da nova senha.';

  @override
  String get resetPasswordSuccess =>
      'Senha redefinida com sucesso! Faça seu login.';

  @override
  String get menuOpen => 'Abrir menu';

  @override
  String get menuDashboard => 'Dashboard';

  @override
  String get menuLoans => 'Empréstimos';

  @override
  String get menuUsers => 'Usuários';

  @override
  String get menuPublishers => 'Editoras';

  @override
  String get menuBooks => 'Livros';

  @override
  String get menuProfile => 'Perfil';

  @override
  String get menuChangeLanguage => 'Trocar Idioma';

  @override
  String get menuLogout => 'Encerrar Sessão';

  @override
  String get dashboardPlaceholder => 'Dashboard Provisorio';

  @override
  String get moduleUnderDevelopment => 'Em desenvolvimento';

  @override
  String get roleAdmin => 'Administrador';

  @override
  String get roleUser => 'Locatário';

  @override
  String get actionClose => 'Fechar';

  @override
  String get logoutError => 'Não foi possível sair. Tente novamente.';

  @override
  String get languageDialogTitle => 'Idiomas';

  @override
  String get languageDialogSave => 'SALVAR';

  @override
  String get usersSearchHint => 'Buscar usuário por nome';

  @override
  String get usersName => 'Nome';

  @override
  String get usersCpf => 'CPF';

  @override
  String get usersStatus => 'Status';

  @override
  String get usersActive => 'Ativo';

  @override
  String get usersInactive => 'Inativo';

  @override
  String get usersActions => 'Ações do usuário';

  @override
  String get usersPrevious => 'Voltar';

  @override
  String get usersNext => 'Próximo';

  @override
  String usersShowing(int start, int end, int total) {
    return 'Mostrando $start a $end de $total usuários';
  }

  @override
  String get usersEmpty => 'Nenhum usuário encontrado.';

  @override
  String get usersRetry => 'Tentar novamente';

  @override
  String get usersLoadError => 'Não foi possível carregar os usuários.';

  @override
  String get usersUnauthorized => 'Sua sessão expirou. Entre novamente.';

  @override
  String get usersForbidden =>
      'Você não tem permissão para acessar esta funcionalidade.';

  @override
  String get usersActivate => 'Ativar locatário';

  @override
  String get usersInactivate => 'Inativar locatário';

  @override
  String get usersConfirmActivate => 'Deseja ativar este locatário?';

  @override
  String get usersConfirmInactivate => 'Deseja inativar este locatário?';

  @override
  String get usersCancel => 'Cancelar';

  @override
  String get usersConfirm => 'Confirmar';

  @override
  String get usersStatusUpdated => 'Status atualizado com sucesso.';

  @override
  String get usersDetailsTitle => 'Visualizar detalhes';

  @override
  String get usersViewDetails => 'Visualizar detalhes';

  @override
  String get usersCreatedAt => 'Data de criação';

  @override
  String get usersUpdatedAt => 'Última atualização';

  @override
  String get publishersSearch => 'Buscar Editora por Nome';

  @override
  String get publishersNew => 'Cadastrar nova editora';

  @override
  String get publishersCreateTitle => 'Cadastrar Editora';

  @override
  String get publishersEditTitle => 'Editar Editora';

  @override
  String get publishersSite => 'Site';

  @override
  String get publishersCreate => 'Cadastrar';

  @override
  String get publishersEdit => 'Editar';

  @override
  String get publishersDelete => 'Excluir Editora';

  @override
  String get publishersDeleteConfirmation =>
      'Tem certeza de que deseja excluir esta editora?';

  @override
  String get publishersDeleteConflict =>
      'Não é possível excluir uma editora que possui livros relacionados.';

  @override
  String get publishersInvalidData =>
      'Verifique os dados informados da editora.';

  @override
  String get publishersInvalidPhone => 'Informe um telefone com DDD válido.';

  @override
  String get publishersInvalidSite => 'Informe um endereço de site válido.';

  @override
  String get publishersConflict =>
      'Não foi possível concluir a operação devido a um conflito.';

  @override
  String get publishersNotFound => 'Editora não encontrada.';

  @override
  String get publishersError =>
      'Não foi possível concluir a operação com a editora.';

  @override
  String get publishersEmpty => 'Nenhuma editora encontrada.';

  @override
  String get publishersSuccess => 'Operação realizada com sucesso.';

  @override
  String publishersShowing(int start, int end, int total) {
    return 'Mostrando $start a $end de $total editoras';
  }
}
