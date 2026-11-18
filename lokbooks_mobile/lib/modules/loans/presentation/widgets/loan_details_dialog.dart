
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_model.dart';
import 'package:lokbooks_mobile/modules/loans/services/loan_service.dart';

class LoanDetailsDialog extends StatefulWidget {
  final LoanModel loan;

  const LoanDetailsDialog({
    super.key,
    required this.loan,
  });

  @override
  State<LoanDetailsDialog> createState() =>
      _LoanDetailsDialogState();
}

class _LoanDetailsDialogState extends State<LoanDetailsDialog> {
  final _service = LoanService();

  bool _isReturning = false;
  String? _error;

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(date);
  }

  String _statusLabel(
    AppLocalizations l10n,
    LoanStatus status,
  ) {
    return switch (status) {
      LoanStatus.borrowed => l10n.loansBorrowed,
      LoanStatus.overdue => l10n.loansOverdue,
      LoanStatus.returned => l10n.loansReturned,
      LoanStatus.unknown => l10n.loansUnknown,
    };
  }

  Color _statusColor(LoanStatus status) {
    return switch (status) {
      LoanStatus.borrowed => const Color(0xFF237AB4),
      LoanStatus.overdue => const Color(0xFFC40025),
      LoanStatus.returned => const Color(0xFF1DB74A),
      LoanStatus.unknown => Colors.grey,
    };
  }

  Widget _field(IconData icon, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
      ),
      color: const Color(0xFFE0E0E0),
      child: Row(
        children: [
          Icon(icon, size: 21),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _returnLoan() async {
    if (_isReturning) return;

    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.loansReturn),
        content: Text(l10n.loansReturnConfirmation),
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
      _isReturning = true;
      _error = null;
    });

    try {
      await _service.returnLoan(widget.loan.id);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } on LoanException catch (exception) {
      if (!mounted) return;

      setState(() {
        _error = exception.message ?? l10n.loansOperationError;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = l10n.loansOperationError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isReturning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final loan = widget.loan;

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
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(
                      l10n.loansDetailsTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isReturning
                        ? null
                        : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _field(
                Icons.person_outline,
                loan.userFullName,
              ),
              _field(
                Icons.menu_book,
                loan.bookTitle,
              ),
              _field(
                Icons.calendar_today_outlined,
                _formatDate(loan.borrowedAt),
              ),
              _field(
                Icons.event_outlined,
                _formatDate(loan.dueDate),
              ),
              if (loan.returnedAt != null)
                _field(
                  Icons.assignment_turned_in_outlined,
                  _formatDate(loan.returnedAt),
                ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.usersStatus,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: _statusColor(loan.status),
                child: Text(
                  _statusLabel(l10n, loan.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 15),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 28),
              if (loan.canReturn)
                Center(
                  child: SizedBox(
                    width: 210,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isReturning ? null : _returnLoan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF19DE3B),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: _isReturning
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.loansReturn,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 13,
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
