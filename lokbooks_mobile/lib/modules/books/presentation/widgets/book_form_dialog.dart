
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/books/models/book_model.dart';
import 'package:lokbooks_mobile/modules/books/models/book_request.dart';
import 'package:lokbooks_mobile/modules/books/services/book_service.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_model.dart';
import 'package:lokbooks_mobile/modules/publishers/services/publisher_service.dart';

class BookFormDialog extends StatefulWidget {
  final BookModel? book;

  const BookFormDialog({
    super.key,
    this.book,
  });

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _bookService = BookService();
  final _publisherService = PublisherService();

  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _yearController;
  late final TextEditingController _quantityController;

  List<PublisherModel> _publishers = [];
  String? _publisherName;
  bool _loadingPublishers = true;
  bool _isSaving = false;
  bool _publisherLoadFailed = false;

  bool get _isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();

    final book = widget.book;

    _titleController = TextEditingController(
      text: book?.title ?? '',
    );

    _authorController = TextEditingController(
      text: book?.author ?? '',
    );

    _yearController = TextEditingController(
      text: book?.releaseYear.toString() ?? '',
    );

    _quantityController = TextEditingController(
      text: book?.totalQuantity.toString() ?? '',
    );

    _publisherName = book?.publisherName;
    _loadPublishers();
  }

  Future<void> _loadPublishers() async {
    setState(() {
      _loadingPublishers = true;
      _publisherLoadFailed = false;
    });

    try {
      final publishers = <PublisherModel>[];
      var page = 1;
      var totalPages = 1;

      do {
        final result = await _publisherService.findAll(
          page: page,
          size: 100,
        );

        publishers.addAll(result.publishers);
        totalPages = result.totalPages;
        page++;
      } while (page <= totalPages);

      publishers.sort(
        (a, b) => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
      );

      if (!mounted) return;

      setState(() {
        _publishers = publishers;
        _loadingPublishers = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingPublishers = false;
        _publisherLoadFailed = true;
      });
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
      enabledBorder: InputBorder.none,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 13,
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.registerRequired;
    }

    return null;
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

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  Future<void> _save() async {
    if (_isSaving || _loadingPublishers ||
        _publisherLoadFailed ||
        !_formKey.currentState!.validate()) {
      return;
    }

    final year = int.parse(_yearController.text);
    final quantity = int.parse(_quantityController.text);

    if (_isEditing &&
        quantity < widget.book!.borrowedQuantity) {
      _showError(
        AppLocalizations.of(context)!.booksQuantityBelowBorrowed,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final request = BookRequest(
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        releaseYear: year,
        publisherName: _publisherName!,
        totalQuantity: quantity,
      );

      if (_isEditing) {
        await _bookService.update(widget.book!.id, request);
      } else {
        await _bookService.create(request);
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on BookException catch (error) {
      if (!mounted) return;
      _showError(_errorMessage(error.error));
    } catch (_) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.booksError);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _delete() async {
    if (!_isEditing || _isSaving) return;

    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.booksDelete),
        content: Text(l10n.booksDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.usersCancel),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
            child: Text(l10n.usersConfirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _bookService.delete(widget.book!.id);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on BookException catch (error) {
      if (!mounted) return;

      _showError(
        error.error == BookError.conflict
            ? l10n.booksDeleteConflict
            : _errorMessage(error.error),
      );
    } catch (_) {
      if (!mounted) return;
      _showError(l10n.booksError);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final language =
        Localizations.localeOf(context).languageCode;

    final pattern = language == 'en'
        ? 'MM/dd/yyyy, HH:mm'
        : 'dd/MM/yyyy, HH:mm';

    return DateFormat(pattern).format(date);
  }

  Widget _dateInfo(
    String label,
    DateTime date,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 18,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(date),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final book = widget.book;

    final publisherNames = _publishers
        .map((publisher) => publisher.name)
        .toSet()
        .toList();

    final selectedPublisher =
        publisherNames.contains(_publisherName)
            ? _publisherName
            : null;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      _isEditing
                          ? l10n.booksEditTitle
                          : l10n.booksCreateTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      enabled: !_isSaving,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(
                        l10n.booksTitle,
                        Icons.title,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _authorController,
                      enabled: !_isSaving,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: _decoration(
                        l10n.booksAuthor,
                        Icons.person_outline,
                      ),
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _yearController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      decoration: _decoration(
                        l10n.booksYear,
                        Icons.calendar_today_outlined,
                      ),
                      validator: (value) {
                        if (_required(value) != null) {
                          return l10n.registerRequired;
                        }

                        final year = int.tryParse(value!);

                        if (year == null ||
                            year < 1 ||
                            year > 32767) {
                          return l10n.booksInvalidYear;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_loadingPublishers)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      )
                    else if (_publisherLoadFailed)
                      Column(
                        children: [
                          Text(l10n.booksPublisherLoadError),
                          TextButton(
                            onPressed: _loadPublishers,
                            child: Text(l10n.usersRetry),
                          ),
                        ],
                      )
                    else
                      DropdownButtonFormField<String>(
                        initialValue: selectedPublisher,
                        isExpanded: true,
                        decoration: _decoration(
                          l10n.booksPublisher,
                          Icons.business_outlined,
                        ),
                        items: publisherNames
                            .map(
                              (name) => DropdownMenuItem(
                                value: name,
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: _isSaving
                            ? null
                            : (value) {
                                setState(() {
                                  _publisherName = value;
                                });
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.registerRequired;
                          }

                          return null;
                        },
                      ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _quantityController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: _decoration(
                        l10n.booksTotalQuantity,
                        Icons.inventory_2_outlined,
                      ),
                      validator: (value) {
                        if (_required(value) != null) {
                          return l10n.registerRequired;
                        }

                        final quantity = int.tryParse(value!);

                        if (quantity == null || quantity < 1) {
                          return l10n.booksInvalidQuantity;
                        }

                        if (_isEditing &&
                            quantity < book!.borrowedQuantity) {
                          return l10n.booksQuantityBelowBorrowed;
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              if (book != null) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _dateInfo(
                        l10n.usersCreatedAt,
                        book.createdAt,
                        Icons.calendar_today_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dateInfo(
                        l10n.usersUpdatedAt,
                        book.updatedAt,
                        Icons.update,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 30),
              if (_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _delete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: Text(
                          l10n.booksDelete,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _saveButton(l10n)),
                  ],
                )
              else
                SizedBox(
                  width: 170,
                  child: _saveButton(l10n),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _saveButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isSaving || _loadingPublishers ||
              _publisherLoadFailed || _publishers.isEmpty
          ? null
          : _save,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(),
      ),
      child: _isSaving
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              _isEditing
                  ? l10n.booksEdit
                  : l10n.booksCreate,
            ),
    );
  }
}
