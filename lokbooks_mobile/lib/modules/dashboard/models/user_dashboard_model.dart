
class UserDashboardModel {
  final int borrowedBooks;
  final int borrowingLimit;
  final DateTime? nextReturnDate;
  final String? lastBorrowedBook;
  final DateTime? lastBorrowedAt;
  final List<UserLoanDashboardModel> loans;

  const UserDashboardModel({
    required this.borrowedBooks,
    required this.borrowingLimit,
    required this.nextReturnDate,
    required this.lastBorrowedBook,
    required this.lastBorrowedAt,
    required this.loans,
  });

  factory UserDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final loansJson = json['loans'];

    return UserDashboardModel(
      borrowedBooks: (json['borrowedBooks'] as num).toInt(),
      borrowingLimit: (json['borrowingLimit'] as num).toInt(),
      nextReturnDate: _parseDate(json['nextReturnDate']),
      lastBorrowedBook: json['lastBorrowedBook'] as String?,
      lastBorrowedAt: _parseDate(json['lastBorrowedAt']),
      loans: loansJson is List
          ? loansJson
              .map(
                (item) => UserLoanDashboardModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList()
          : [],
    );
  }
}

class UserLoanDashboardModel {
  final String tenant;
  final String book;
  final DateTime? borrowedAt;
  final DateTime? dueDate;
  final DateTime? returnedAt;
  final String status;

  const UserLoanDashboardModel({
    required this.tenant,
    required this.book,
    required this.borrowedAt,
    required this.dueDate,
    required this.returnedAt,
    required this.status,
  });

  factory UserLoanDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserLoanDashboardModel(
      tenant: json['tenant'] as String,
      book: json['book'] as String,
      borrowedAt: _parseDate(json['borrowedAt']),
      dueDate: _parseDate(json['dueDate']),
      returnedAt: _parseDate(json['returnedAt']),
      status: json['status'] as String,
    );
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;

  return DateTime.tryParse(value.toString());
}
