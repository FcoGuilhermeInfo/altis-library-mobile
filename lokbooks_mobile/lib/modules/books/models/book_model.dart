
class BookModel {
  final String id;
  final String title;
  final String author;
  final int releaseYear;
  final String publisherName;
  final int totalQuantity;
  final int availableQuantity;
  final int borrowedQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.releaseYear,
    required this.publisherName,
    required this.totalQuantity,
    required this.availableQuantity,
    required this.borrowedQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      releaseYear: json['releaseYear'] as int,
      publisherName: json['publisherName'] as String,
      totalQuantity: json['totalQuantity'] as int,
      availableQuantity: json['availableQuantity'] as int,
      borrowedQuantity: json['borrowedQuantity'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
