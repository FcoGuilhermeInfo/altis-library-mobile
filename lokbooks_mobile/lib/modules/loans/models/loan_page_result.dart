
import 'loan_model.dart';

class LoanPageResult {
  final List<LoanModel> loans;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  const LoanPageResult({
    required this.loans,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory LoanPageResult.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as List<dynamic>;

    return LoanPageResult(
      loans: content
          .map(
            (item) => LoanModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: (json['number'] as int) + 1,
    );
  }
}
