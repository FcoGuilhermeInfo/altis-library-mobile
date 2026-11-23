
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:lokbooks_mobile/core/services/http/api_client.dart';
import 'package:lokbooks_mobile/core/services/storage/token_storage.dart';
import 'package:lokbooks_mobile/modules/books/models/book_model.dart';
import 'package:lokbooks_mobile/modules/books/models/book_page_result.dart';
import 'package:lokbooks_mobile/modules/books/models/book_request.dart';

enum BookError {
  unauthorized,
  forbidden,
  invalidData,
  conflict,
  notFound,
  connection,
  server,
}

class BookException implements Exception {
  final BookError error;

  const BookException(this.error);
}

class BookService {
  final TokenStorage _tokenStorage = const TokenStorage();

  Future<http.Response> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const BookException(BookError.unauthorized);
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
      final streamed = await ApiClient.client
          .send(request)
          .timeout(const Duration(seconds: 10));

      final response = await http.Response.fromStream(
        streamed,
      ).timeout(const Duration(seconds: 10));

      switch (response.statusCode) {
        case 400:
        case 422:
          throw const BookException(BookError.invalidData);
        case 401:
          throw const BookException(BookError.unauthorized);
        case 403:
          throw const BookException(BookError.forbidden);
        case 404:
          throw const BookException(BookError.notFound);
        case 409:
          throw const BookException(BookError.conflict);
        default:
          if (response.statusCode >= 500) {
            throw const BookException(BookError.server);
          }

          return response;
      }
    } on SocketException {
      throw const BookException(BookError.connection);
    } on http.ClientException {
      throw const BookException(BookError.connection);
    } on TimeoutException {
      throw const BookException(BookError.connection);
    }
  }

  BookModel _parseBook(http.Response response) {
    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return BookModel.fromJson(data);
    } on FormatException {
      throw const BookException(BookError.server);
    } on TypeError {
      throw const BookException(BookError.server);
    }
  }

  Future<BookPageResult> findAll({
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
      '/books?$query',
    );

    if (response.statusCode != 200) {
      throw const BookException(BookError.server);
    }

    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return BookPageResult.fromJson(data);
    } on FormatException {
      throw const BookException(BookError.server);
    } on TypeError {
      throw const BookException(BookError.server);
    }
  }

  Future<BookModel> create(BookRequest book) async {
    final response = await _request(
      'POST',
      '/books',
      body: book.toJson(),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {
      throw const BookException(BookError.server);
    }

    return _parseBook(response);
  }

  Future<BookModel> update(
    String id,
    BookRequest book,
  ) async {
    final response = await _request(
      'PATCH',
      '/books/$id',
      body: book.toJson(),
    );

    if (response.statusCode != 200) {
      throw const BookException(BookError.server);
    }

    return _parseBook(response);
  }

  Future<void> delete(String id) async {
    final response = await _request(
      'DELETE',
      '/books/$id',
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {
      throw const BookException(BookError.server);
    }
  }
}
