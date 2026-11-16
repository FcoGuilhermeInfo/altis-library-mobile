
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:lokbooks_mobile/core/services/http/api_client.dart';
import 'package:lokbooks_mobile/modules/auth/models/forgot_password_request.dart';
import 'package:lokbooks_mobile/modules/auth/models/reset_password_request.dart';

enum PasswordResetError {
  invalidData,
  invalidCredentials,
  invalidToken,
  connection,
  tooManyRequests,
  server,
}

class PasswordResetException implements Exception {
  final PasswordResetError error;

  const PasswordResetException(this.error);
}

class PasswordResetService {
  Future<http.Response> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      return await ApiClient.client
          .post(
            ApiClient.buildUri(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const PasswordResetException(
        PasswordResetError.connection,
      );
    } on http.ClientException {
      throw const PasswordResetException(
        PasswordResetError.connection,
      );
    } on TimeoutException {
      throw const PasswordResetException(
        PasswordResetError.connection,
      );
    }
  }

  Future<String> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await _post(
      '/auth/forgot-password',
      request.toJson(),
    );

    switch (response.statusCode) {
      case 200:
        try {
          final data =
              jsonDecode(utf8.decode(response.bodyBytes));

          if (data is! Map<String, dynamic>) {
            throw const FormatException();
          }

          final token = data['token'];

          if (token is! String || token.isEmpty) {
            throw const FormatException();
          }

          return token;
        } on FormatException {
          throw const PasswordResetException(
            PasswordResetError.server,
          );
        }
      case 400:
      case 422:
        throw const PasswordResetException(
          PasswordResetError.invalidData,
        );
      case 401:
      case 404:
        throw const PasswordResetException(
          PasswordResetError.invalidCredentials,
        );
      case 429:
        throw const PasswordResetException(
          PasswordResetError.tooManyRequests,
        );
      default:
        throw const PasswordResetException(
          PasswordResetError.server,
        );
    }
  }

  Future<void> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final response = await _post(
      '/auth/reset-password',
      request.toJson(),
    );

    switch (response.statusCode) {
      case 204:
        return;
      case 400:
      case 422:
        throw const PasswordResetException(
          PasswordResetError.invalidData,
        );
      case 401:
      case 403:
        throw const PasswordResetException(
          PasswordResetError.invalidToken,
        );
      case 429:
        throw const PasswordResetException(
          PasswordResetError.tooManyRequests,
        );
      default:
        throw const PasswordResetException(
          PasswordResetError.server,
        );
    }
  }
}
