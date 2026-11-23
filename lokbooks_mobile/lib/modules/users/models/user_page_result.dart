
import 'user_model.dart';

class UserPageResult {
  final List<UserModel> users;
  final int totalElements;
  final int totalPages;
  final int currentPage;

  const UserPageResult({
    required this.users,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
  });

  factory UserPageResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final content = json['content'] as List<dynamic>;

    return UserPageResult(
      users: content
          .map(
            (item) => UserModel.fromJson(
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
