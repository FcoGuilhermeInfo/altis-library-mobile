
class BookRequest {
  final String title;
  final String author;
  final int releaseYear;
  final String publisherName;
  final int totalQuantity;

  const BookRequest({
    required this.title,
    required this.author,
    required this.releaseYear,
    required this.publisherName,
    required this.totalQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'releaseYear': releaseYear,
      'publisherName': publisherName,
      'totalQuantity': totalQuantity,
    };
  }
}
