
import 'book_model.dart';

class BookPageResult {
  final List<BookModel> books;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  const BookPageResult({
    required this.books,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory BookPageResult.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as List<dynamic>;

    return BookPageResult(
      books: content
          .map(
            (item) => BookModel.fromJson(
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
