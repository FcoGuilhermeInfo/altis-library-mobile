
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:lokbooks_mobile/core/services/http/api_client.dart';
import 'package:lokbooks_mobile/core/services/storage/token_storage.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_model.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_page_result.dart';
import 'package:lokbooks_mobile/modules/publishers/models/publisher_request.dart';

enum PublisherError {
  unauthorized,
  forbidden,
  invalidData,
  conflict,
  notFound,
  connection,
  server,
}

class PublisherException implements Exception {
  final PublisherError error;

  const PublisherException(this.error);
}

class PublisherService {
  final TokenStorage _tokenStorage = const TokenStorage();

  Future<http.Response> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const PublisherException(PublisherError.unauthorized);
    }

    final request = http.Request(
      method,
      ApiClient.buildUri(endpoint),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    if (body != null) {
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await ApiClient.client
          .send(request)
          .timeout(const Duration(seconds: 10));

      final response = await http.Response.fromStream(
        streamedResponse,
      ).timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 401:
          throw const PublisherException(
            PublisherError.unauthorized,
          );
        case 403:
          throw const PublisherException(
            PublisherError.forbidden,
          );
        case 400:
        case 422:
          throw const PublisherException(
            PublisherError.invalidData,
          );
        case 404:
          throw const PublisherException(
            PublisherError.notFound,
          );
        case 409:
          throw const PublisherException(
            PublisherError.conflict,
          );
        default:
          if (response.statusCode >= 500) {
            throw const PublisherException(
              PublisherError.server,
            );
          }

          return response;
      }
    } on SocketException {
      throw const PublisherException(
        PublisherError.connection,
      );
    } on http.ClientException {
      throw const PublisherException(
        PublisherError.connection,
      );
    } on TimeoutException {
      throw const PublisherException(
        PublisherError.connection,
      );
    }
  }

  PublisherModel _parsePublisher(http.Response response) {
    try {
      final json = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return PublisherModel.fromJson(json);
    } on FormatException {
      throw const PublisherException(PublisherError.server);
    } on TypeError {
      throw const PublisherException(PublisherError.server);
    }
  }

  Future<PublisherPageResult> findAll({
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

    final response = await _request(
      'GET',
      '/publishers?$query',
    );

    if (response.statusCode != 200) {
      throw const PublisherException(PublisherError.server);
    }

    try {
      final json = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return PublisherPageResult.fromJson(json);
    } on FormatException {
      throw const PublisherException(PublisherError.server);
    } on TypeError {
      throw const PublisherException(PublisherError.server);
    }
  }

  Future<PublisherModel> create(
    PublisherRequest publisher,
  ) async {
    final response = await _request(
      'POST',
      '/publishers',
      body: publisher.toJson(),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw const PublisherException(PublisherError.server);
    }

    return _parsePublisher(response);
  }

  Future<PublisherModel> update(
    String id,
    PublisherRequest publisher,
  ) async {
    final response = await _request(
      'PATCH',
      '/publishers/$id',
      body: publisher.toJson(),
    );

    if (response.statusCode != 200) {
      throw const PublisherException(PublisherError.server);
    }

    return _parsePublisher(response);
  }

  Future<void> delete(String id) async {
    final response = await _request(
      'DELETE',
      '/publishers/$id',
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw const PublisherException(PublisherError.server);
    }
  }
}
