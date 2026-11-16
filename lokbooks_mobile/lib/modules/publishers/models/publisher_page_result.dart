
import 'publisher_model.dart';

class PublisherPageResult {
  final List<PublisherModel> publishers;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  const PublisherPageResult({
    required this.publishers,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory PublisherPageResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final content = json['content'] as List<dynamic>;

    return PublisherPageResult(
      publishers: content
          .map(
            (item) => PublisherModel.fromJson(
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
