
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:lokbooks_mobile/core/services/http/api_client.dart';
import 'package:lokbooks_mobile/core/services/storage/token_storage.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_model.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_page_result.dart';
import 'package:lokbooks_mobile/modules/loans/models/loan_request.dart';

enum LoanError {
  unauthorized,
  forbidden,
  invalidData,
  notFound,
  conflict,
  connection,
  server,
}

class LoanException implements Exception {
  final LoanError error;
  final String? message;

  const LoanException(this.error, {this.message});
}

class LoanService {
  final TokenStorage _tokenStorage = const TokenStorage();

  Future<http.Response> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const LoanException(LoanError.unauthorized);
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

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return response;
      }

      final error = switch (response.statusCode) {
        400 || 422 => LoanError.invalidData,
        401 => LoanError.unauthorized,
        403 => LoanError.forbidden,
        404 => LoanError.notFound,
        409 => LoanError.conflict,
        _ => LoanError.server,
      };

      String? message;

      try {
        final data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (data is Map<String, dynamic> &&
            data['message'] is String) {
          message = data['message'] as String;
        }
      } catch (_) {}

      throw LoanException(error, message: message);
    } on SocketException {
      throw const LoanException(LoanError.connection);
    } on http.ClientException {
      throw const LoanException(LoanError.connection);
    } on TimeoutException {
      throw const LoanException(LoanError.connection);
    }
  }

  LoanModel _parseLoan(http.Response response) {
    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return LoanModel.fromJson(data);
    } catch (_) {
      throw const LoanException(LoanError.server);
    }
  }

  LoanPageResult _parsePage(http.Response response) {
    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return LoanPageResult.fromJson(data);
    } catch (_) {
      throw const LoanException(LoanError.server);
    }
  }

  Future<LoanPageResult> findAll({
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
      '/loans?$query',
    );

    return _parsePage(response);
  }

  Future<LoanPageResult> findHistory({
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
      '/loans/history?$query',
    );

    return _parsePage(response);
  }

  Future<LoanModel> findById(String id) async {
    final response = await _request(
      'GET',
      '/loans/$id',
    );

    return _parseLoan(response);
  }

  Future<LoanModel> create(LoanRequest loan) async {
    final response = await _request(
      'POST',
      '/loans',
      body: loan.toJson(),
    );

    return _parseLoan(response);
  }

  Future<LoanModel> returnLoan(String id) async {
    final response = await _request(
      'PATCH',
      '/loans/$id',
    );

    return _parseLoan(response);
  }
}
