
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/core/widgets/searchable_select_field.dart';
import 'package:lokbooks_mobile/modules/books/models/book_model.dart';
import 'package:lokbooks_mobile/modules/books/services/book_service.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_request.dart';
import 'package:lokbooks_mobile/modules/loans/services/loan_service.dart';
import 'package:lokbooks_mobile/modules/users/models/user_model.dart';
import 'package:lokbooks_mobile/modules/users/services/user_service.dart';

class LoanFormDialog extends StatefulWidget {
  const LoanFormDialog({super.key});

  @override
  State<LoanFormDialog> createState() => _LoanFormDialogState();
}

class _LoanFormDialogState extends State<LoanFormDialog> {
  final _loanService = LoanService();
  final _userService = UserService();
  final _bookService = BookService();

  UserModel? _selectedUser;
  BookModel? _selectedBook;
  DateTime? _dueDate;

  bool _isSaving = false;
  bool _showValidation = false;
  String? _error;

  Future<SearchResultPage<UserModel>> _searchUsers(
    String search,
    int page,
  ) async {
    final result = await _userService.findAll(
      search: search,
      page: page,
      size: 10,
    );

    return SearchResultPage<UserModel>(
      items: result.users,
      totalPages: result.totalPages,
    );
  }

  Future<SearchResultPage<BookModel>> _searchBooks(
    String search,
    int page,
  ) async {
    final result = await _bookService.findAll(
      search: search,
      page: page,
      size: 10,
    );

    return SearchResultPage<BookModel>(
      items: result.books,
      totalPages: result.totalPages,
    );
  }

  String _formatDate(DateTime date) {
    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(date);
  }

  Future<void> _selectDueDate() async {
    if (_isSaving) return;

    final now = DateTime.now();

    final tomorrow = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );

    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(now.year + 5, 12, 31),
    );

    if (!mounted || selected == null) return;

    setState(() {
      _dueDate = DateTime(
        selected.year,
        selected.month,
        selected.day,
        23,
        59,
        59,
      );

      _error = null;
    });
  }

  String _errorMessage(
    LoanException exception,
    AppLocalizations l10n,
  ) {
    if (exception.message != null &&
        exception.message!.isNotEmpty &&
        (exception.error == LoanError.invalidData ||
            exception.error == LoanError.conflict)) {
      return exception.message!;
    }

    return switch (exception.error) {
      LoanError.unauthorized => l10n.usersUnauthorized,
      LoanError.forbidden => l10n.usersForbidden,
      LoanError.notFound => l10n.loansNotFound,
      LoanError.connection => l10n.loginConnectionError,
      _ => l10n.loansOperationError,
    };
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _showValidation = true;
      _error = null;
    });

    if (_selectedUser == null || _selectedBook == null) {
      return;
    }

    if (_dueDate == null ||
        !_dueDate!.isAfter(DateTime.now())) {
      setState(() {
        _error = l10n.loansInvalidDueDate;
      });

      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _loanService.create(
        LoanRequest(
          userId: _selectedUser!.id,
          bookId: _selectedBook!.id,
          dueDate: _dueDate!,
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on LoanException catch (exception) {
      if (!mounted) return;

      setState(() {
        _error = _errorMessage(exception, l10n);
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = l10n.loansOperationError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 21),
      filled: true,
      fillColor: const Color(0xFFE0E0E0),
      border: InputBorder.none,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            18,
            12,
            18,
            MediaQuery.viewInsetsOf(context).bottom > 0 ? 40 : 22,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      l10n.loansCreateTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SearchableSelectField<UserModel>(
                label: l10n.loansMember,
                icon: Icons.person_outline,
                enabled: !_isSaving,
                emptyMessage: l10n.usersEmpty,
                errorMessage: l10n.loansOptionsLoadError,
                retryLabel: l10n.usersRetry,
                previousLabel: l10n.usersPrevious,
                nextLabel: l10n.usersNext,
                search: _searchUsers,
                titleOf: (user) => user.name,
                subtitleOf: (user) {
                  final status = user.active
                      ? l10n.usersActive
                      : l10n.usersInactive;

                  return '${user.formattedCpf} • $status';
                },
                canSelect: (user) => user.active,
                onSelected: (user) {
                  setState(() {
                    _selectedUser = user;
                    _error = null;
                  });
                },
                validationError:
                    _showValidation && _selectedUser == null
                        ? l10n.registerRequired
                        : null,
              ),
              const SizedBox(height: 16),
              SearchableSelectField<BookModel>(
                label: l10n.loansBook,
                icon: Icons.menu_book,
                enabled: !_isSaving,
                emptyMessage: l10n.booksEmpty,
                errorMessage: l10n.loansOptionsLoadError,
                retryLabel: l10n.usersRetry,
                previousLabel: l10n.usersPrevious,
                nextLabel: l10n.usersNext,
                search: _searchBooks,
                titleOf: (book) => book.title,
                subtitleOf: (book) =>
                    '${l10n.booksAvailableShort}: ${book.availableQuantity}',
                canSelect: (book) => book.availableQuantity > 0,
                onSelected: (book) {
                  setState(() {
                    _selectedBook = book;
                    _error = null;
                  });
                },
                validationError:
                    _showValidation && _selectedBook == null
                        ? l10n.registerRequired
                        : null,
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: _decoration(
                  l10n.loansBorrowedAt,
                  Icons.calendar_today_outlined,
                ),
                child: Text(
                  _formatDate(DateTime.now()),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _isSaving ? null : _selectDueDate,
                child: InputDecorator(
                  decoration: _decoration(
                    l10n.loansDueDate,
                    Icons.event_outlined,
                  ).copyWith(
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  child: Text(
                    _dueDate == null
                        ? l10n.loansSelectDate
                        : _formatDate(_dueDate!),
                  ),
                ),
              ),
              if (_showValidation && _dueDate == null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.loansInvalidDueDate,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 28),
              Center(
                child: SizedBox(
                  width: 230,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      elevation: 0,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              l10n.loansCreate,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
