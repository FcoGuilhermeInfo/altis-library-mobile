
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:lokbooks_mobile/core/services/http/api_client.dart';
import 'package:lokbooks_mobile/core/services/storage/token_storage.dart';
import 'package:lokbooks_mobile/modules/users/models/user_page_result.dart';

enum UserServiceError {
  unauthorized,
  forbidden,
  connection,
  server,
}

class UserServiceException implements Exception {
  final UserServiceError error;

  const UserServiceException(this.error);
}

class UserService {
  final TokenStorage _tokenStorage = const TokenStorage();

  Future<http.Response> _request(
    String endpoint, {
    String method = 'GET',
  }) async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const UserServiceException(
        UserServiceError.unauthorized,
      );
    }

    final uri = ApiClient.buildUri(endpoint);

    try {
      final response = method == 'PATCH'
          ? await ApiClient.client.patch(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            ).timeout(const Duration(seconds: 10))
          : await ApiClient.client.get(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
              },
            ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        throw const UserServiceException(
          UserServiceError.unauthorized,
        );
      }

      if (response.statusCode == 403) {
        throw const UserServiceException(
          UserServiceError.forbidden,
        );
      }

      return response;
    } on SocketException {
      throw const UserServiceException(
        UserServiceError.connection,
      );
    } on http.ClientException {
      throw const UserServiceException(
        UserServiceError.connection,
      );
    } on TimeoutException {
      throw const UserServiceException(
        UserServiceError.connection,
      );
    }
  }

  Future<UserPageResult> findAll({
    String search = '',
    int page = 1,
    int size = 10,
  }) async {
    final query = Uri(
      queryParameters: {
        'search': search,
        'page': page.toString(),
        'size': size.toString(),
      },
    ).query;

    final response = await _request('/users?$query');

    if (response.statusCode != 200) {
      throw const UserServiceException(
        UserServiceError.server,
      );
    }

    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return UserPageResult.fromJson(data);
    } on FormatException {
      throw const UserServiceException(
        UserServiceError.server,
      );
    } on TypeError {
      throw const UserServiceException(
        UserServiceError.server,
      );
    }
  }

  Future<void> activate(String id) async {
    final response = await _request(
      '/users/$id/activate',
      method: 'PATCH',
    );

    if (response.statusCode != 200) {
      throw const UserServiceException(
        UserServiceError.server,
      );
    }
  }

  Future<void> inactivate(String id) async {
    final response = await _request(
      '/users/$id/inactivate',
      method: 'PATCH',
    );

    if (response.statusCode != 200) {
      throw const UserServiceException(
        UserServiceError.server,
      );
    }
  }
}
