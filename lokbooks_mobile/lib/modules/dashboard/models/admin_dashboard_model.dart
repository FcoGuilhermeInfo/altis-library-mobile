
class AdminDashboardModel {
  final int totalBooks;
  final int totalPublishers;
  final int monthlyLoans;
  final int totalUsers;
  final LastLoanDashboardModel? lastLoan;
  final MostBorrowedBookModel? mostBorrowedBook;
  final List<MostBorrowedBookModel> topBorrowedBooks;

  const AdminDashboardModel({
    required this.totalBooks,
    required this.totalPublishers,
    required this.monthlyLoans,
    required this.totalUsers,
    required this.lastLoan,
    required this.mostBorrowedBook,
    required this.topBorrowedBooks,
  });

  factory AdminDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final lastLoanJson = json['lastLoan'];
    final mostBorrowedBookJson = json['mostBorrowedBook'];
    final topBooksJson = json['topBorrowedBooks'];

    return AdminDashboardModel(
      totalBooks: (json['totalBooks'] as num).toInt(),
      totalPublishers: (json['totalPublishers'] as num).toInt(),
      monthlyLoans: (json['monthlyLoans'] as num).toInt(),
      totalUsers: (json['totalUsers'] as num).toInt(),
      lastLoan: lastLoanJson is Map<String, dynamic>
          ? LastLoanDashboardModel.fromJson(lastLoanJson)
          : null,
      mostBorrowedBook:
          mostBorrowedBookJson is Map<String, dynamic>
              ? MostBorrowedBookModel.fromJson(
                  mostBorrowedBookJson,
                )
              : null,
      topBorrowedBooks: topBooksJson is List
          ? topBooksJson
              .map(
                (item) => MostBorrowedBookModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList()
          : [],
    );
  }
}

class LastLoanDashboardModel {
  final String bookTitle;
  final String tenant;
  final DateTime? borrowedAt;
  final DateTime? dueDate;

  const LastLoanDashboardModel({
    required this.bookTitle,
    required this.tenant,
    required this.borrowedAt,
    required this.dueDate,
  });

  factory LastLoanDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return LastLoanDashboardModel(
      bookTitle: json['bookTitle'] as String,
      tenant: json['tenant'] as String,
      borrowedAt: _parseDate(json['borrowedAt']),
      dueDate: _parseDate(json['dueDate']),
    );
  }
}

class MostBorrowedBookModel {
  final String bookId;
  final String bookTitle;
  final int loanCount;

  const MostBorrowedBookModel({
    required this.bookId,
    required this.bookTitle,
    required this.loanCount,
  });

  factory MostBorrowedBookModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MostBorrowedBookModel(
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      loanCount: (json['loanCount'] as num).toInt(),
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}
