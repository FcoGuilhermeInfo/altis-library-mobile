
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_model.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_page_result.dart';
import 'package:lokbooks_mobile/modules/loans/services/loan_service.dart';

class LoanHistoryDialog extends StatefulWidget {
  const LoanHistoryDialog({super.key});

  @override
  State<LoanHistoryDialog> createState() =>
      _LoanHistoryDialogState();
}

class _LoanHistoryDialogState extends State<LoanHistoryDialog> {
  final _service = LoanService();

  LoanPageResult? _result;
  int _page = 1;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final result = await _service.findHistory(
        page: _page,
        size: 10,
      );

      if (!mounted) return;

      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  String _date(DateTime? value) {
    if (value == null) return '-';

    final language =
        Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(value);
  }

  Widget _historyItem(
    LoanModel loan,
    AppLocalizations l10n,
  ) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Color(0xFFE0E0E0),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loan.userFullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(loan.bookTitle),
            const SizedBox(height: 10),
            Text(
              '${l10n.loansBorrowedAt}: ${_date(loan.borrowedAt)}',
            ),
            Text(
              '${l10n.loansDueDate}: ${_date(loan.dueDate)}',
            ),
            Text(
              '${l10n.loansReturnedAt}: ${_date(loan.returnedAt)}',
            ),
            const SizedBox(height: 8),
            const Chip(
              label: Text('✓'),
              backgroundColor: Color(0xFFB9F5C6),
              side: BorderSide.none,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = _result;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 550,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 5, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.loansHistoryTitle,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _error
                      ? Center(
                          child: TextButton(
                            onPressed: _load,
                            child: Text(l10n.usersRetry),
                          ),
                        )
                      : result == null || result.loans.isEmpty
                          ? Center(
                              child: Text(l10n.loansEmptyHistory),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: result.loans.length,
                              itemBuilder: (context, index) =>
                                  _historyItem(
                                    result.loans[index],
                                    l10n,
                                  ),
                            ),
            ),
            if (result != null && result.totalPages > 0)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: !_loading && _page > 1
                          ? () {
                              _page--;
                              _load();
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      '$_page / ${result.totalPages}',
                    ),
                    IconButton(
                      onPressed: !_loading &&
                              _page < result.totalPages
                          ? () {
                              _page++;
                              _load();
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
