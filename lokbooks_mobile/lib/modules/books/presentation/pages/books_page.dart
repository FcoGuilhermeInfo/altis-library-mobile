
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/books/models/book_model.dart';
import 'package:lokbooks_mobile/modules/books/models/book_page_result.dart';
import 'package:lokbooks_mobile/modules/books/presentation/widgets/book_form_dialog.dart';
import 'package:lokbooks_mobile/modules/books/services/book_service.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  final _service = BookService();
  final _searchController = TextEditingController();

  Timer? _debounce;
  BookPageResult? _result;
  BookError? _error;

  int _currentPage = 1;
  int _requestId = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final requestId = ++_requestId;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _service.findAll(
        search: _searchController.text.trim(),
        page: _currentPage,
        size: 10,
      );

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } on BookException catch (error) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = error.error;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _error = BookError.server;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _currentPage = 1;
        _loadBooks();
      },
    );
  }

  void _changePage(int page) {
    final totalPages = _result?.totalPages ?? 0;

    if (_isLoading || page < 1 || page > totalPages) {
      return;
    }

    _currentPage = page;
    _loadBooks();
  }

  Future<void> _openForm([BookModel? book]) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => BookFormDialog(book: book),
    );

    if (!mounted || changed != true) return;

    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.booksSuccess)),
      );

    _loadBooks();
  }

  String _errorMessage(BookError error) {
    final l10n = AppLocalizations.of(context)!;

    return switch (error) {
      BookError.unauthorized => l10n.usersUnauthorized,
      BookError.forbidden => l10n.usersForbidden,
      BookError.invalidData => l10n.booksInvalidData,
      BookError.conflict => l10n.booksConflict,
      BookError.notFound => l10n.booksNotFound,
      BookError.connection => l10n.loginConnectionError,
      BookError.server => l10n.booksError,
    };
  }

  Widget _quantityItem(
    String label,
    int value,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 19,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _bookCard(BookModel book) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Color(0xFFE5E5E5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    book.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.booksEdit,
                  onPressed: () => _openForm(book),
                  icon: const Icon(
                    Icons.edit_square,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _infoRow(Icons.person_outline, book.author),
            const SizedBox(height: 8),
            _infoRow(
              Icons.calendar_today_outlined,
              book.releaseYear.toString(),
            ),
            const SizedBox(height: 8),
            _infoRow(
              Icons.business_outlined,
              book.publisherName,
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                _quantityItem(
                  l10n.booksTotalShort,
                  book.totalQuantity,
                ),
                _quantityItem(
                  l10n.booksAvailableShort,
                  book.availableQuantity,
                ),
                _quantityItem(
                  l10n.booksBorrowedShort,
                  book.borrowedQuantity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pagination(BookPageResult result) {
    final l10n = AppLocalizations.of(context)!;

    if (result.totalElements == 0) {
      return const SizedBox.shrink();
    }

    final start = (_currentPage - 1) * 10 + 1;
    final end = (_currentPage * 10).clamp(
      0,
      result.totalElements,
    );

    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          l10n.booksShowing(
            start,
            end,
            result.totalElements,
          ),
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: l10n.usersPrevious,
              onPressed: _currentPage > 1 && !_isLoading
                  ? () => _changePage(_currentPage - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              '${result.currentPage} / ${result.totalPages}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              tooltip: l10n.usersNext,
              onPressed: _currentPage < result.totalPages &&
                      !_isLoading
                  ? () => _changePage(_currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResults() {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          Text(
            _errorMessage(_error!),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: _loadBooks,
            child: Text(l10n.usersRetry),
          ),
        ],
      );
    }

    final result = _result;

    if (result == null || result.books.isEmpty) {
      return Center(
        child: Text(l10n.booksEmpty),
      );
    }

    return Column(
      children: [
        ...result.books.map(_bookCard),
        _pagination(result),
      ],
    );
  }

  @override
  void dispose() {
    _requestId++;
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadBooks,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          children: [
            Text(
              l10n.menuBooks,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _debounce?.cancel();
                      _currentPage = 1;
                      _loadBooks();
                    },
                    decoration: InputDecoration(
                      hintText: l10n.booksSearch,
                      suffixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFF1F1F1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openForm(),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.booksNew),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildResults(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
