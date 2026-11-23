
class LoanRequest {
  final String bookId;
  final String userId;
  final DateTime dueDate;

  const LoanRequest({
    required this.bookId,
    required this.userId,
    required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    final date = dueDate;

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    final formattedDate =
        '${date.year.toString().padLeft(4, '0')}-'
        '${twoDigits(date.month)}-'
        '${twoDigits(date.day)}T'
        '${twoDigits(date.hour)}:'
        '${twoDigits(date.minute)}:'
        '${twoDigits(date.second)}';

    return {
      'bookId': bookId,
      'userId': userId,
      'dueDate': formattedDate,
    };
  }
}
