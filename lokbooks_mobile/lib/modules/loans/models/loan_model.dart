
enum LoanStatus {
  borrowed,
  overdue,
  returned,
  unknown,
}

class LoanModel {
  final String id;
  final String bookTitle;
  final String userFullName;
  final DateTime borrowedAt;
  final DateTime dueDate;
  final DateTime? returnedAt;
  final LoanStatus status;

  const LoanModel({
    required this.id,
    required this.bookTitle,
    required this.userFullName,
    required this.borrowedAt,
    required this.dueDate,
    required this.returnedAt,
    required this.status,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    final statusName = json['status'] as String;

    final status = switch (statusName) {
      'BORROWED' => LoanStatus.borrowed,
      'OVERDUE' => LoanStatus.overdue,
      'RETURNED' => LoanStatus.returned,
      _ => LoanStatus.unknown,
    };

    return LoanModel(
      id: json['id'] as String,
      bookTitle: json['bookTitle'] as String,
      userFullName: json['userFullName'] as String,
      borrowedAt: DateTime.parse(json['borrowedAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      returnedAt: json['returnedAt'] == null
          ? null
          : DateTime.parse(json['returnedAt'] as String),
      status: status,
    );
  }

  bool get canReturn => returnedAt == null &&
      (status == LoanStatus.borrowed ||
          status == LoanStatus.overdue);
}
