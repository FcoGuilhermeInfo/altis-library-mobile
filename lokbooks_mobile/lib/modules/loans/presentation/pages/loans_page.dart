
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lokbooks_mobile/core/l10n/app_localizations.dart';
import 'package:lokbooks_mobile/core/theme/app_colors.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_model.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_page_result.dart';
import 'package:lokbooks_mobile/modules/loans/presentation/widgets/loan_details_dialog.dart';
import 'package:lokbooks_mobile/modules/loans/presentation/widgets/loan_form_dialog.dart';
import 'package:lokbooks_mobile/modules/loans/presentation/widgets/loan_history_dialog.dart';
import 'package:lokbooks_mobile/modules/loans/services/loan_service.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {
  final _service = LoanService();
  final _searchController = TextEditingController();

  Timer? _debounce;
  LoanPageResult? _result;
  List<LoanModel> _recent = [];

  int _page = 1;
  int _requestId = 0;
  bool _loading = true;
  bool _error = false;
  bool _recentLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _loadRecent();
  }

  Future<void> _load() async {
    final requestId = ++_requestId;

    setState(() {
      _loading = true;
      _error = false;
    });

    try {
      final result = await _service.findAll(
        search: _searchController.text.trim(),
        page: _page,
        size: 10,
      );

      if (!mounted || requestId != _requestId) return;

      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadRecent() async {
    setState(() {
      _recentLoading = true;
    });

    try {
      final result = await _service.findHistory(
        page: 1,
        size: 2,
      );

      if (!mounted) return;

      setState(() {
        _recent = result.loans;
        _recentLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _recent = [];
        _recentLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await Future.wait([
      _load(),
      _loadRecent(),
    ]);
  }

  void _search(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 450),
      () {
        _page = 1;
        _load();
      },
    );
  }

  void _changePage(int page) {
    if (_loading ||
        page < 1 ||
        page > (_result?.totalPages ?? 0)) {
      return;
    }

    _page = page;
    _load();
  }

  Future<void> _openCreate() async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoanFormDialog(),
    );

    if (!mounted || changed != true) return;

    _page = 1;
    _refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.loansCreatedSuccess,
        ),
      ),
    );
  }

  Future<void> _openDetails(LoanModel loan) async {
    final changed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoanDetailsDialog(loan: loan),
    );

    if (!mounted || changed != true) return;

    _refresh();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.loansReturnedSuccess,
        ),
      ),
    );
  }

  String _date(DateTime? value) {
    if (value == null) return '-';

    final language =
        Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(value);
  }

  Color _statusColor(LoanStatus status) {
    return switch (status) {
      LoanStatus.borrowed => const Color(0xFF287CAC),
      LoanStatus.overdue => const Color(0xFFC40025),
      LoanStatus.returned => const Color(0xFF1DB74A),
      LoanStatus.unknown => Colors.grey,
    };
  }

  String _statusLabel(
    LoanStatus status,
    AppLocalizations l10n,
  ) {
    return switch (status) {
      LoanStatus.borrowed => l10n.loansBorrowed,
      LoanStatus.overdue => l10n.loansOverdue,
      LoanStatus.returned => l10n.loansReturned,
      LoanStatus.unknown => l10n.loansUnknown,
    };
  }

  Widget _loanCard(
    LoanModel loan,
    AppLocalizations l10n, {
    bool showDetails = true,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
        side: const BorderSide(
          color: Color(0xFFE4E4E4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    loan.userFullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (showDetails)
                  IconButton(
                    tooltip: l10n.loansViewDetails,
                    onPressed: () => _openDetails(loan),
                    icon: const Icon(
                      Icons.edit_square,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
            Text(
              loan.bookTitle,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 11),
            Text(
              '${l10n.loansBorrowedAt}: ${_date(loan.borrowedAt)}',
            ),
            Text(
              '${l10n.loansDueDate}: ${_date(loan.dueDate)}',
            ),
            if (loan.returnedAt != null)
              Text(
                '${l10n.loansReturnedAt}: ${_date(loan.returnedAt)}',
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _statusColor(loan.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _statusLabel(loan.status, l10n),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagination(
    LoanPageResult result,
    AppLocalizations l10n,
  ) {
    if (result.totalElements == 0) {
      return const SizedBox.shrink();
    }

    final start = (_page - 1) * 10 + 1;
    final end = (_page * 10).clamp(
      0,
      result.totalElements,
    );

    return Column(
      children: [
        Text(
          l10n.loansShowing(
            start,
            end,
            result.totalElements,
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _page > 1
                  ? () => _changePage(_page - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('$_page / ${result.totalPages}'),
            IconButton(
              onPressed: _page < result.totalPages
                  ? () => _changePage(_page + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }

  Widget _activeLoans(AppLocalizations l10n) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error) {
      return Center(
        child: TextButton(
          onPressed: _load,
          child: Text(l10n.usersRetry),
        ),
      );
    }

    final result = _result;

    if (result == null || result.loans.isEmpty) {
      return Center(child: Text(l10n.loansEmpty));
    }

    return Column(
      children: [
        ...result.loans.map(
          (loan) => _loanCard(loan, l10n),
        ),
        _pagination(result, l10n),
      ],
    );
  }

  Widget _recentLoans(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.loansRecentTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => const LoanHistoryDialog(),
                );
              },
              child: Text(l10n.loansFullHistory),
            ),
          ),
          if (_recentLoading)
            const Center(child: CircularProgressIndicator())
          else if (_recent.isEmpty)
            Text(l10n.loansEmptyHistory)
          else
            ..._recent.map(
              (loan) => _loanCard(
                loan,
                l10n,
                showDetails: false,
              ),
            ),
        ],
      ),
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
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          children: [
            Text(
              l10n.menuLoans,
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
                    onChanged: _search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _debounce?.cancel();
                      _page = 1;
                      _load();
                    },
                    decoration: InputDecoration(
                      hintText: l10n.loansSearch,
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
                      onPressed: _openCreate,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.loansNew),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _activeLoans(l10n),
                ],
              ),
            ),
            _recentLoans(l10n),
          ],
        ),
      ),
    );
  }
}
