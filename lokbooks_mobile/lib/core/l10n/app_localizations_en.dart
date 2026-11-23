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

  @override
  String get forgotPasswordTitle => 'Recover Password';

  @override
  String get forgotPasswordDescription =>
      'Enter your registered email address and CPF to continue.';

  @override
  String get forgotPasswordSubmit => 'Continue';

  @override
  String get forgotPasswordInvalidCredentials =>
      'We could not verify the information provided.';

  @override
  String get forgotPasswordInvalidData =>
      'Check the email address and CPF provided.';

  @override
  String get passwordResetTooManyRequests =>
      'Too many attempts. Wait and try again.';

  @override
  String get resetPasswordTitle => 'Change Password';

  @override
  String get resetPasswordDescription => 'Enter and confirm your new password.';

  @override
  String get resetPasswordNewPassword => 'New Password';

  @override
  String get resetPasswordSubmit => 'Change';

  @override
  String get resetPasswordInvalidToken =>
      'Your recovery session has expired or the token is invalid. Please request a new one.';

  @override
  String get resetPasswordInvalidData => 'Check your new password information.';

  @override
  String get resetPasswordSuccess =>
      'Password reset successfully! Please sign in.';

  @override
  String get menuOpen => 'Open menu';

  @override
  String get menuDashboard => 'Dashboard';

  @override
  String get menuLoans => 'Loans';

  @override
  String get menuUsers => 'Users';

  @override
  String get menuPublishers => 'Publishers';

  @override
  String get menuBooks => 'Books';

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuChangeLanguage => 'Change Language';

  @override
  String get menuLogout => 'Log Out';

  @override
  String get dashboardPlaceholder => 'Temporary Dashboard';

  @override
  String get moduleUnderDevelopment => 'Under development';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleUser => 'Library member';

  @override
  String get actionClose => 'Close';

  @override
  String get logoutError => 'Could not log out. Please try again.';

  @override
  String get languageDialogTitle => 'Languages';

  @override
  String get languageDialogSave => 'SAVE';

  @override
  String get usersSearchHint => 'Search users by name';

  @override
  String get usersName => 'Name';

  @override
  String get usersCpf => 'CPF';

  @override
  String get usersStatus => 'Status';

  @override
  String get usersActive => 'Active';

  @override
  String get usersInactive => 'Inactive';

  @override
  String get usersActions => 'User actions';

  @override
  String get usersPrevious => 'Previous';

  @override
  String get usersNext => 'Next';

  @override
  String usersShowing(int start, int end, int total) {
    return 'Showing $start to $end of $total users';
  }

  @override
  String get usersEmpty => 'No users found.';

  @override
  String get usersRetry => 'Try again';

  @override
  String get usersLoadError => 'Could not load users.';

  @override
  String get usersUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get usersForbidden =>
      'You do not have permission to access this feature.';

  @override
  String get usersActivate => 'Activate member';

  @override
  String get usersInactivate => 'Deactivate member';

  @override
  String get usersConfirmActivate => 'Do you want to activate this member?';

  @override
  String get usersConfirmInactivate => 'Do you want to deactivate this member?';

  @override
  String get usersCancel => 'Cancel';

  @override
  String get usersConfirm => 'Confirm';

  @override
  String get usersStatusUpdated => 'Status updated successfully.';

  @override
  String get usersDetailsTitle => 'View details';

  @override
  String get usersViewDetails => 'View details';

  @override
  String get usersCreatedAt => 'Created on';

  @override
  String get usersUpdatedAt => 'Last updated';

  @override
  String get publishersSearch => 'Search publishers by name';

  @override
  String get publishersNew => 'Register new publisher';

  @override
  String get publishersCreateTitle => 'Register Publisher';

  @override
  String get publishersEditTitle => 'Edit Publisher';

  @override
  String get publishersSite => 'Website';

  @override
  String get publishersCreate => 'Register';

  @override
  String get publishersEdit => 'Edit';

  @override
  String get publishersDelete => 'Delete Publisher';

  @override
  String get publishersDeleteConfirmation =>
      'Are you sure you want to delete this publisher?';

  @override
  String get publishersDeleteConflict =>
      'A publisher with related books cannot be deleted.';

  @override
  String get publishersInvalidData => 'Check the publisher information.';

  @override
  String get publishersInvalidPhone =>
      'Enter a valid phone number with area code.';

  @override
  String get publishersInvalidSite => 'Enter a valid website address.';

  @override
  String get publishersConflict =>
      'The operation could not be completed due to a conflict.';

  @override
  String get publishersNotFound => 'Publisher not found.';

  @override
  String get publishersError => 'Could not complete the publisher operation.';

  @override
  String get publishersEmpty => 'No publishers found.';

  @override
  String get publishersSuccess => 'Operation completed successfully.';

  @override
  String publishersShowing(int start, int end, int total) {
    return 'Showing $start to $end of $total publishers';
  }

  @override
  String get booksSearch => 'Search books by title';

  @override
  String get booksNew => 'Register new book';

  @override
  String get booksCreateTitle => 'Register Book';

  @override
  String get booksEditTitle => 'Edit Book';

  @override
  String get booksTitle => 'Title';

  @override
  String get booksAuthor => 'Author';

  @override
  String get booksYear => 'Year';

  @override
  String get booksPublisher => 'Publisher';

  @override
  String get booksTotalQuantity => 'Total quantity';

  @override
  String get booksTotalShort => 'Total';

  @override
  String get booksAvailableShort => 'Available';

  @override
  String get booksBorrowedShort => 'Borrowed';

  @override
  String get booksCreate => 'Register';

  @override
  String get booksEdit => 'Edit';

  @override
  String get booksDelete => 'Delete Book';

  @override
  String get booksDeleteConfirmation =>
      'Are you sure you want to delete this book?';

  @override
  String get booksDeleteConflict =>
      'A book with related loans cannot be deleted.';

  @override
  String get booksInvalidData => 'Check the book information.';

  @override
  String get booksInvalidYear => 'Enter a year between 1 and 32767.';

  @override
  String get booksInvalidQuantity =>
      'The total quantity must be greater than zero.';

  @override
  String get booksQuantityBelowBorrowed =>
      'The total quantity cannot be less than the borrowed quantity.';

  @override
  String get booksPublisherLoadError => 'Could not load publishers.';

  @override
  String get booksConflict =>
      'This book may already exist or there is a conflict with the provided information.';

  @override
  String get booksNotFound => 'Book not found.';

  @override
  String get booksError => 'Could not complete the book operation.';

  @override
  String get booksEmpty => 'No books found.';

  @override
  String get booksSuccess => 'Operation completed successfully.';

  @override
  String booksShowing(int start, int end, int total) {
    return 'Showing $start to $end of $total books';
  }

  @override
  String get loansSearch => 'Search loans by member';

  @override
  String get loansNew => 'Register new loan';

  @override
  String get loansCreateTitle => 'Create Loan';

  @override
  String get loansCreate => 'Create Loan';

  @override
  String get loansDetailsTitle => 'Loan Details';

  @override
  String get loansViewDetails => 'View details';

  @override
  String get loansMember => 'Library member';

  @override
  String get loansBook => 'Book';

  @override
  String get loansBorrowedAt => 'Loan Date';

  @override
  String get loansDueDate => 'Expected Return';

  @override
  String get loansReturnedAt => 'Return Date';

  @override
  String get loansSelectDate => 'Select a date';

  @override
  String get loansBorrowed => 'Borrowed';

  @override
  String get loansOverdue => 'Overdue';

  @override
  String get loansReturned => 'Completed';

  @override
  String get loansUnknown => 'Unknown';

  @override
  String get loansReturn => 'Confirm Return';

  @override
  String get loansReturnConfirmation =>
      'Do you want to confirm the return of this book?';

  @override
  String get loansRecentTitle => 'Recent Completed Loans';

  @override
  String get loansFullHistory => 'View full history';

  @override
  String get loansHistoryTitle => 'Loan History';

  @override
  String get loansEmptyHistory => 'No completed loans found.';

  @override
  String get loansEmpty => 'No active loans found.';

  @override
  String get loansOptionsLoadError => 'Could not load members and books.';

  @override
  String get loansInvalidDueDate =>
      'The expected return date must be in the future.';

  @override
  String get loansNotFound => 'Loan not found.';

  @override
  String get loansOperationError => 'Could not complete the operation.';

  @override
  String get loansCreatedSuccess => 'Loan registered successfully.';

  @override
  String get loansReturnedSuccess => 'Return confirmed successfully.';

  @override
  String loansShowing(int start, int end, int total) {
    return 'Showing $start to $end of $total loans';
  }

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileSaveChanges => 'Save Changes';

  @override
  String get profileLoadError => 'Unable to load your profile.';

  @override
  String get profileSaveSuccess => 'Changes saved successfully!';

  @override
  String get profilePasswordSuccess => 'Password changed successfully!';

  @override
  String get profileCurrentPassword => 'Current Password';

  @override
  String get profileNewPassword => 'New Password';

  @override
  String get profileConfirmPassword => 'Confirm Password';

  @override
  String get profileCurrentPasswordRequired => 'Enter your current password.';

  @override
  String get profileNewPasswordRequired => 'Enter a new password.';

  @override
  String get profileConfirmPasswordRequired => 'Confirm your new password.';

  @override
  String get profilePasswordLength =>
      'The new password must contain between 8 and 15 characters.';

  @override
  String get profilePasswordMustDiffer =>
      'The new password must differ from your current password.';

  @override
  String get profilePasswordMismatch => 'Passwords do not match.';

  @override
  String get profileShowPassword => 'Show password';

  @override
  String get profileHidePassword => 'Hide password';

  @override
  String get profilePhoneInvalid =>
      'The phone number must contain 10 or 11 digits.';

  @override
  String get profileUnauthorized => 'Your authentication was not authorized.';

  @override
  String get profileForbidden =>
      'You do not have permission to make this change.';

  @override
  String get profileInvalidData => 'Check the information entered.';

  @override
  String get profileConnectionError => 'Could not connect to the server.';

  @override
  String get profileSaveError => 'Unable to save the changes.';

  @override
  String get profilePasswordError =>
      'Unable to change the password. Check your current password and the information entered.';

  @override
  String get profilePartialSuccess =>
      'Your personal information was saved, but the password was not changed.';

  @override
  String get profileUnexpectedError =>
      'An error occurred while saving your changes.';

  @override
  String get dashboardRegisteredBooks => 'Registered books';

  @override
  String get dashboardMonthlyLoans => 'Loans this month';

  @override
  String get dashboardLastLoan => 'Most recent loan';

  @override
  String get dashboardNoLoansRecorded => 'No loans recorded';

  @override
  String get dashboardNoLoansYet => 'There are no loans yet.';

  @override
  String get dashboardMostBorrowedBook => 'Most borrowed book this month';

  @override
  String get dashboardNoBookFound => 'No book found';

  @override
  String get dashboardNoMonthlyLoans =>
      'No loans have been recorded this month.';

  @override
  String dashboardLoanCount(int count) {
    return '$count loans';
  }

  @override
  String get dashboardTopThree => 'Top 3 most borrowed books this month';

  @override
  String get dashboardLoanRanking => 'Loan ranking';

  @override
  String get dashboardNoMonthlyData => 'No data available for this month.';

  @override
  String get dashboardBorrowedBooks => 'Borrowed books';

  @override
  String get dashboardNextReturn => 'Next return';

  @override
  String get dashboardLastBorrowedBook => 'Last borrowed book';

  @override
  String get dashboardNoBooks => 'No books';

  @override
  String get dashboardMyLoans => 'My borrowed books';

  @override
  String get dashboardNoLoansFound => 'No loans found';

  @override
  String get dashboardLoansAppearHere => 'Your loans will appear here.';

  @override
  String get dashboardLoadError => 'Could not load the dashboard.';
}
