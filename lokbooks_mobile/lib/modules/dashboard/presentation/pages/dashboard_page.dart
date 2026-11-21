
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../auth/models/user_role.dart';
import '../../models/admin_dashboard_model.dart';
import '../../models/user_dashboard_model.dart';
import '../../services/dashboard_service.dart';

class DashboardPage extends StatefulWidget {
  final AuthController authController;

  const DashboardPage({
    super.key,
    required this.authController,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardService _dashboardService = DashboardService();

  late Future<Object> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  @override
  void didUpdateWidget(covariant DashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.authController != widget.authController) {
      _dashboardFuture = _loadDashboard();
    }
  }

  Future<Object> _loadDashboard() {
    return switch (widget.authController.role) {
      UserRole.admin => _dashboardService.getAdminDashboard(),
      UserRole.user => _dashboardService.getUserDashboard(),
      null => Future<Object>.error(
          const DashboardRequestException(statusCode: 401),
        ),
    };
  }

  Future<void> _refreshDashboard() async {
    final future = _loadDashboard();

    setState(() {
      _dashboardFuture = future;
    });

    try {
      await future;
    } catch (_) {}
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en' ? 'MM/dd/yyyy' : 'dd/MM/yyyy',
    ).format(date);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '-';

    final language = Localizations.localeOf(context).languageCode;

    return DateFormat(
      language == 'en'
          ? 'MM/dd/yyyy HH:mm'
          : 'dd/MM/yyyy HH:mm',
    ).format(date);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 23,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    String? subtitle,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: AppColors.primary,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF343434),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                color: AppColors.primary,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF171717),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _informationCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD5D5D5),
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _informationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF686868),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }

  Widget _adminDashboard(AdminDashboardModel dashboard) {
    final l10n = AppLocalizations.of(context)!;
    final lastLoan = dashboard.lastLoan;
    final mostBorrowed = dashboard.mostBorrowedBook;
    final topBooks = dashboard.topBorrowedBooks;

    final maxCount = topBooks.isEmpty
        ? 0
        : topBooks
            .map((book) => book.loanCount)
            .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _statCard(
                title: l10n.dashboardRegisteredBooks,
                value: dashboard.totalBooks.toString(),
                icon: Icons.menu_book_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: l10n.menuPublishers,
                value: dashboard.totalPublishers.toString(),
                icon: Icons.business_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _statCard(
                title: l10n.dashboardMonthlyLoans,
                value: dashboard.monthlyLoans.toString(),
                icon: Icons.handshake_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: l10n.menuUsers,
                value: dashboard.totalUsers.toString(),
                icon: Icons.people_outline,
              ),
            ),
          ],
        ),
        _sectionTitle(l10n.dashboardLastLoan),
        _informationCard(
          title: lastLoan?.bookTitle ??
              l10n.dashboardNoLoansRecorded,
          child: lastLoan == null
              ? Text(l10n.dashboardNoLoansYet)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _informationRow(
                      l10n.loansMember,
                      lastLoan.tenant,
                    ),
                    _informationRow(
                      l10n.loansBorrowedAt,
                      _formatDateTime(lastLoan.borrowedAt),
                    ),
                    _informationRow(
                      l10n.loansDueDate,
                      _formatDate(lastLoan.dueDate),
                    ),
                  ],
                ),
        ),
        _sectionTitle(l10n.dashboardMostBorrowedBook),
        _informationCard(
          title: mostBorrowed?.bookTitle ??
              l10n.dashboardNoBookFound,
          child: Text(
            mostBorrowed == null
                ? l10n.dashboardNoMonthlyLoans
                : l10n.dashboardLoanCount(
                    mostBorrowed.loanCount,
                  ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        _sectionTitle(l10n.dashboardTopThree),
        _informationCard(
          title: l10n.dashboardLoanRanking,
          child: topBooks.isEmpty
              ? Text(l10n.dashboardNoMonthlyData)
              : Column(
                  children: [
                    for (var i = 0; i < topBooks.length; i++) ...[
                      if (i > 0)
                        const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            '${i + 1}º',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              topBooks[i].bookTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            topBooks[i].loanCount.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: maxCount == 0
                            ? 0
                            : topBooks[i].loanCount / maxCount,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(3),
                        backgroundColor:
                            const Color(0xFFE3ECEE),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  String _statusLabel(String status) {
    final l10n = AppLocalizations.of(context)!;

    return switch (status) {
      'BORROWED' => l10n.loansBorrowed,
      'OVERDUE' => l10n.loansOverdue,
      'RETURNED' => l10n.loansReturned,
      _ => l10n.loansUnknown,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'BORROWED' => const Color(0xFF176A45),
      'OVERDUE' => const Color(0xFFB34325),
      'RETURNED' => const Color(0xFF446B80),
      _ => const Color(0xFF666666),
    };
  }

  Widget _loanCard(UserLoanDashboardModel loan) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFD5D5D5),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loan.book,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          _informationRow(
            l10n.loansBorrowedAt,
            _formatDate(loan.borrowedAt),
          ),
          _informationRow(
            l10n.loansDueDate,
            _formatDate(loan.dueDate),
          ),
          if (loan.returnedAt != null)
            _informationRow(
              l10n.loansReturnedAt,
              _formatDate(loan.returnedAt),
            ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _statusColor(loan.status).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              _statusLabel(loan.status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _statusColor(loan.status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userDashboard(UserDashboardModel dashboard) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _statCard(
                title: l10n.dashboardBorrowedBooks,
                value:
                    '${dashboard.borrowedBooks}/${dashboard.borrowingLimit}',
                icon: Icons.book_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                title: l10n.dashboardNextReturn,
                value: _formatDate(dashboard.nextReturnDate),
                icon: Icons.event_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _statCard(
          title: l10n.dashboardLastBorrowedBook,
          value: dashboard.lastBorrowedBook ??
              l10n.dashboardNoBooks,
          icon: Icons.auto_stories_outlined,
          subtitle: dashboard.lastBorrowedAt == null
              ? null
              : '${l10n.loansBorrowedAt}: ${_formatDate(dashboard.lastBorrowedAt)}',
        ),
        _sectionTitle(l10n.dashboardMyLoans),
        if (dashboard.loans.isEmpty)
          _informationCard(
            title: l10n.dashboardNoLoansFound,
            child: Text(l10n.dashboardLoansAppearHere),
          )
        else
          for (final loan in dashboard.loans)
            _loanCard(loan),
      ],
    );
  }

  Widget _errorContent(Object error) {
    final l10n = AppLocalizations.of(context)!;

    String message = l10n.dashboardLoadError;

    if (error is DashboardRequestException) {
      if (error.statusCode == 401) {
        message = l10n.usersUnauthorized;
      } else if (error.statusCode == 403) {
        message = l10n.usersForbidden;
      } else if (error.statusCode == null) {
        message = l10n.loginConnectionError;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 47,
            color: Color(0xFF777777),
          ),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: _refreshDashboard,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.usersRetry),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshDashboard,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            16,
            22,
            16,
            35,
          ),
          children: [
            Text(
              l10n.menuDashboard,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Object>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState !=
                    ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return _errorContent(snapshot.error!);
                }

                final data = snapshot.data;

                if (data is AdminDashboardModel) {
                  return _adminDashboard(data);
                }

                if (data is UserDashboardModel) {
                  return _userDashboard(data);
                }

                return _errorContent(
                  const DashboardRequestException(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
