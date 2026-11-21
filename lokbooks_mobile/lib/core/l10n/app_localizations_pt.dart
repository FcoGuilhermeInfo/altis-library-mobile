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

  @override
  String get booksSearch => 'Buscar Livro por Nome';

  @override
  String get booksNew => 'Cadastrar novo livro';

  @override
  String get booksCreateTitle => 'Cadastrar Livro';

  @override
  String get booksEditTitle => 'Editar Livro';

  @override
  String get booksTitle => 'Título';

  @override
  String get booksAuthor => 'Autor';

  @override
  String get booksYear => 'Ano';

  @override
  String get booksPublisher => 'Editora';

  @override
  String get booksTotalQuantity => 'Quantidade total';

  @override
  String get booksTotalShort => 'Total';

  @override
  String get booksAvailableShort => 'Disponível';

  @override
  String get booksBorrowedShort => 'Emprestada';

  @override
  String get booksCreate => 'Cadastrar';

  @override
  String get booksEdit => 'Editar';

  @override
  String get booksDelete => 'Excluir Livro';

  @override
  String get booksDeleteConfirmation =>
      'Tem certeza de que deseja excluir este livro?';

  @override
  String get booksDeleteConflict =>
      'Não é possível excluir um livro que possui empréstimos relacionados.';

  @override
  String get booksInvalidData => 'Verifique os dados informados do livro.';

  @override
  String get booksInvalidYear => 'Informe um ano entre 1 e 32767.';

  @override
  String get booksInvalidQuantity =>
      'A quantidade total deve ser maior que zero.';

  @override
  String get booksQuantityBelowBorrowed =>
      'A quantidade total não pode ser menor que a quantidade emprestada.';

  @override
  String get booksPublisherLoadError =>
      'Não foi possível carregar as editoras.';

  @override
  String get booksConflict =>
      'Este livro já pode estar cadastrado ou existe um conflito com os dados informados.';

  @override
  String get booksNotFound => 'Livro não encontrado.';

  @override
  String get booksError => 'Não foi possível concluir a operação com o livro.';

  @override
  String get booksEmpty => 'Nenhum livro encontrado.';

  @override
  String get booksSuccess => 'Operação realizada com sucesso.';

  @override
  String booksShowing(int start, int end, int total) {
    return 'Mostrando $start a $end de $total livros';
  }

  @override
  String get loansSearch => 'Buscar empréstimo por locatário';

  @override
  String get loansNew => 'Registrar novo empréstimo';

  @override
  String get loansCreateTitle => 'Realizar Empréstimo';

  @override
  String get loansCreate => 'Realizar Empréstimo';

  @override
  String get loansDetailsTitle => 'Detalhes do Empréstimo';

  @override
  String get loansViewDetails => 'Visualizar detalhes';

  @override
  String get loansMember => 'Locatário';

  @override
  String get loansBook => 'Livro';

  @override
  String get loansBorrowedAt => 'Data do Empréstimo';

  @override
  String get loansDueDate => 'Devolução Prevista';

  @override
  String get loansReturnedAt => 'Data da Devolução';

  @override
  String get loansSelectDate => 'Selecione uma data';

  @override
  String get loansBorrowed => 'Emprestado';

  @override
  String get loansOverdue => 'Atrasado';

  @override
  String get loansReturned => 'Finalizado';

  @override
  String get loansUnknown => 'Desconhecido';

  @override
  String get loansReturn => 'Confirmar Devolução';

  @override
  String get loansReturnConfirmation =>
      'Deseja confirmar a devolução deste livro?';

  @override
  String get loansRecentTitle => 'Últimos Empréstimos Realizados';

  @override
  String get loansFullHistory => 'Ver histórico completo';

  @override
  String get loansHistoryTitle => 'Histórico de Empréstimos';

  @override
  String get loansEmptyHistory => 'Nenhum empréstimo finalizado.';

  @override
  String get loansEmpty => 'Nenhum empréstimo ativo encontrado.';

  @override
  String get loansOptionsLoadError =>
      'Não foi possível carregar locatários e livros.';

  @override
  String get loansInvalidDueDate => 'A devolução prevista deve ser futura.';

  @override
  String get loansNotFound => 'Empréstimo não encontrado.';

  @override
  String get loansOperationError => 'Não foi possível concluir a operação.';

  @override
  String get loansCreatedSuccess => 'Empréstimo registrado com sucesso.';

  @override
  String get loansReturnedSuccess => 'Devolução confirmada com sucesso.';

  @override
  String loansShowing(int start, int end, int total) {
    return 'Mostrando $start a $end de $total empréstimos';
  }

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileSaveChanges => 'Salvar Alterações';

  @override
  String get profileLoadError => 'Não foi possível carregar o perfil.';

  @override
  String get profileSaveSuccess => 'Alterações salvas com sucesso!';

  @override
  String get profilePasswordSuccess => 'Senha alterada com sucesso!';

  @override
  String get profileCurrentPassword => 'Senha Atual';

  @override
  String get profileNewPassword => 'Nova Senha';

  @override
  String get profileConfirmPassword => 'Confirmar Senha';

  @override
  String get profileCurrentPasswordRequired => 'Informe sua senha atual.';

  @override
  String get profileNewPasswordRequired => 'Informe a nova senha.';

  @override
  String get profileConfirmPasswordRequired => 'Confirme sua nova senha.';

  @override
  String get profilePasswordLength =>
      'A nova senha deve ter entre 8 e 15 caracteres.';

  @override
  String get profilePasswordMustDiffer =>
      'A nova senha deve ser diferente da atual.';

  @override
  String get profilePasswordMismatch => 'As senhas não coincidem.';

  @override
  String get profileShowPassword => 'Mostrar senha';

  @override
  String get profileHidePassword => 'Ocultar senha';

  @override
  String get profilePhoneInvalid => 'O telefone deve conter 10 ou 11 números.';

  @override
  String get profileUnauthorized => 'Sua autenticação não foi autorizada.';

  @override
  String get profileForbidden =>
      'Você não tem permissão para realizar esta alteração.';

  @override
  String get profileInvalidData => 'Verifique os dados informados.';

  @override
  String get profileConnectionError => 'Não foi possível conectar ao servidor.';

  @override
  String get profileSaveError => 'Não foi possível salvar as alterações.';

  @override
  String get profilePasswordError =>
      'Não foi possível alterar a senha. Confira a senha atual e os dados informados.';

  @override
  String get profilePartialSuccess =>
      'Os dados pessoais foram salvos, mas a senha não foi alterada.';

  @override
  String get profileUnexpectedError =>
      'Ocorreu um erro ao salvar as alterações.';

  @override
  String get dashboardRegisteredBooks => 'Livros cadastrados';

  @override
  String get dashboardMonthlyLoans => 'Empréstimos do mês';

  @override
  String get dashboardLastLoan => 'Último empréstimo realizado';

  @override
  String get dashboardNoLoansRecorded => 'Nenhum empréstimo registrado';

  @override
  String get dashboardNoLoansYet => 'Ainda não existem empréstimos.';

  @override
  String get dashboardMostBorrowedBook => 'Livro mais emprestado do mês';

  @override
  String get dashboardNoBookFound => 'Nenhum livro encontrado';

  @override
  String get dashboardNoMonthlyLoans =>
      'Ainda não existem empréstimos neste mês.';

  @override
  String dashboardLoanCount(int count) {
    return '$count empréstimos';
  }

  @override
  String get dashboardTopThree => 'Top 3 livros mais emprestados do mês';

  @override
  String get dashboardLoanRanking => 'Ranking de empréstimos';

  @override
  String get dashboardNoMonthlyData => 'Não há dados para este mês.';

  @override
  String get dashboardBorrowedBooks => 'Livros emprestados';

  @override
  String get dashboardNextReturn => 'Próxima devolução';

  @override
  String get dashboardLastBorrowedBook => 'Último livro emprestado';

  @override
  String get dashboardNoBooks => 'Nenhum livro';

  @override
  String get dashboardMyLoans => 'Meus livros emprestados';

  @override
  String get dashboardNoLoansFound => 'Nenhum empréstimo encontrado';

  @override
  String get dashboardLoansAppearHere => 'Seus empréstimos aparecerão aqui.';

  @override
  String get dashboardLoadError => 'Não foi possível carregar o dashboard.';
}
